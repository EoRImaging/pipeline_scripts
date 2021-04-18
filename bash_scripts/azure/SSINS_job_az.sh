#!/bin/bash

echo JOBID ${SLURM_ARRAY_JOB_ID}
echo TASKID ${SLURM_ARRAY_TASK_ID}
echo "JOB START TIME" `date +"%Y-%m-%d_%H:%M:%S"`
myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo PUBLIC IP ${myip}

obs_id=$(cat ${obs_file_name} | sed -n ${SLURM_ARRAY_TASK_ID}p)

# az sed madness
if [ -z $obs_id ]; then
   echo OBSID is empty
   echo Trying again, slightly differently.
   obs_id=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${obs_file_name})
fi

if [ -z $obs_id ]; then
   echo OBSID is still empty
   echo obsfile name was $obs_file_name
   echo "contents of obsfile were $(cat ${obs_file_name})"
   echo first >> test_file.txt
   echo second >> second_file.txt
   testind=2
   testout=$(sed -n 2p)
   testout_sub=$(sed -n ${testind}p)
   echo test sed output no sub: $testout
   echo test sed output with variable sub $testout_sub

   echo Trying a different option using cat and array indexing
   obs=($(cat ${obs_file_name}))
   obs_id=(${obs[${SLURM_ARRAY_TASK_ID}]})
fi

if [ -z $obs_id ]; then
    echo "After much effort, obs_id is still empty. Exiting."
    >&2 "OBSID could not be identified. Check output log."
    exit 1
fi

echo OBSID $obs_id


# sign into azure
azcopy login --identity

# echo keywords
echo Using output directory: $outdir

echo Using ssins output az location: $ssins_output_az_path

echo Using input_az_loc: $input_az_loc

echo Using input_type: $input_type

echo Using correct: $correct

echo Using time_avg: $time_avg

echo Using freq_avg: $freq_avg


# create output directory with full permissions
if [ -d "$outdir" ]; then
    sudo chmod -R 777 $outdir
else
    sudo mkdir -m 777 $outdir
fi

# create input download location with full permissions
if [ -d ${input_type} ]; then
    sudo chmod -R 777 ${input_type}
else
    echo Making directory: ${input_type}
    sudo mkdir -m 777 ${input_type}
fi

# Check input type
# !uvfits input type has not been tested! March 2021
if [ $input_type == "uvfits" ]; then

  # Check if the uvfits file exists locally; if not, download it from az
  if [ ! -f "uvfits/${obs_id}.uvfits" ]; then
      # Download uvfits from az
      azcopy copy ${input_az_loc}/${obs_id}.uvfits uvfits/${obs_id}.uvfits

      # Verify that the uvfits downloaded correctly
      if [ ! -f "uvfits/${obs_id}.uvfits" ]; then
          >&2 echo "ERROR: downloading uvfits from az failed"
          echo $obs_id >> ~/logs/obs_fail_${SLURM_ARRAY_JOB_ID}.txt
          echo "Job Failed"
          exit 1
      fi
  fi
  input_files="uvfits/${obs_id}.uvfits"

  if [ ! -z $cal_az_path ]; then
    echo Using cal_az_path: $cal_az_path
    if [ -d cal_for_SSINS ]; then
      sudo chmod -R 777 cal_for_SSINS
    else
      sudo mkdir -m 777 cal_for_SSINS
    fi

    # Check if cal files exist locally. If not, download them from az.
    if [ ! -f cal_for_SSINS/${obs_id}_cal.sav ]; then
      azcopy copy ${cal_az_path}/calibration/${obs_id}_cal.sav cal_for_SSINS/${obs_id}_cal.sav
    fi
    cal_file=cal_for_SSINS/${obs_id}_cal.sav

    if [ ! -f cal_for_SSINS/${obs_id}_obs.sav ]; then
      azcopy copy ${cal_az_path}/metadata/${obs_id}_obs.sav cal_for_SSINS/${obs_id}_obs.sav
    fi
    cal_obs_file=cal_for_SSINS/${obs_id}_obs.sav

    if [ ! -f cal_for_SSINS/${obs_id}_settings.txt ]; then
      azcopy copy ${cal_az_path}/metadata/${obs_id}_settings.txt cal_for_SSINS/${obs_id}_settings.txt
    fi
    settings_file=cal_for_SSINS/${obs_id}_settings.txt

    # Verfiy that the files downloaded correctly.
    for file in $cal_file $cal_obs_file $settings_file; do
      if [ ! -f $file ];then
        >&2 echo "ERROR: downloading one of the calibration files failed."
        echo $obs_id >> ~/logs/obs_fail_${SLURM_ARRAY_JOB_ID}.txt
        echo "Job Failed"
        exit 1
      fi
    done
  fi

else
  # Check if the gpubox files exist locally; if not, download them from az
  file_num=$(ls gpubox/${obs_id}_vis/${obs_id}*.fits | wc -l)
  if [ $file_num -eq "0" ]; then

      # Download box files and metafits from az
      azcopy copy ${input_az_loc}/${obs_id}_vis gpubox --include-pattern "*fits" --recursive

      # Verify that the box files downloaded correctly
      file_num=$(ls gpubox/${obs_id}_vis/${obs_id}*.fits | wc -l)
      if [ $file_num -eq "0" ]; then
          >&2 echo "ERROR: downloading box files from az failed"
          echo $obs_id >> ~/logs/obs_fail_${SLURM_ARRAY_JOB_ID}.txt
          echo "Job Failed"
          exit 1
      fi

      # Verify that the metafits file downloaded correctly.
      if [ ! -f $(ls gpubox/${obs_id}_vis/${obs_id}.metafits) ]; then
          >&2 echo "ERROR: downloading metafits file from az failed"
          echo $obs_id >> ~/logs/obs_fail_${SLURM_ARRAY_JOB_ID}.txt
          echo "Job Failed"
          exit 1
      fi
  fi
  input_files=$(ls gpubox/${obs_id}_vis/${obs_id}*fits)
fi

echo "The input files for this run are: ${input_files}"

arg_string="-o ${obs_id} -u ${input_files} -d ${outdir}"
if [ ! -z $cal_az_path ]; then
  arg_string="${arg_string} -s -p ${cal_az_path}"
else
  arg_string="${arg_string} -t ${time_avg} -a ${freq_avg} -f -w"
  if [ $correct -eq 1 ]; then
    arg_string="${arg_string} -c"
  fi
fi

# Run python catalog script
python -u ~/repos/pipeline_scripts/SSINS_python_scripts/MWA_EoR_High_ssins_uvfits_write.py $arg_string

# Only case where you would not write a uvfits is if this string is nonempty. Might consider just having a flag for writing uvfits.
if [ -z $cal_az_path ]; then
  # Move uvfits to az
  i=1  # initialize counter
  azcopy copy ${outdir}/${obs_id}.uvfits ${uvfits_output_az_path}/${obs_id}.uvfits
  while [ $? -ne 0 ] && [ $i -lt 10 ]; do
      let "i += 1"  # increment counter
      >&2 echo "Moving uvfits to az failed. Retrying (attempt $i)."
      azcopy copy ${outdir}/${obs_id}.uvfits ${uvfits_output_az_path}/${obs_id}.uvfits
  done

  if [ $? -ne 0 ]; then
      >&2 echo "Transferring uvfits to az completely failed."
      echo $obs_id >> ~/logs/obs_fail_${SLURM_ARRAY_JOB_ID}.txt
  fi

  # Remove uvfits from instance because can't separate from other SSINS outputs due to buggy az
  sudo rm ${outdir}/${obs_id}.uvfits
fi

# Move SSINS outputs to az
i=1  # initialize counter
azcopy copy ${outdir} ${ssins_output_az_path} --include-pattern "*${obs_id}*" --recursive
while [ $? -ne 0 ] && [ $i -lt 10 ]; do
    let "i += 1"  # increment counter
    >&2 echo "Moving SSINS outputs to az failed. Retrying (attempt $i)."
    azcopy copy ${outdir} ${ssins_output_az_path} --include-pattern "*${obs_id}*" --recursive
done

if [ $? -ne 0 ]; then
    >&2 echo "Transferring SSINS outputs to az completely failed."
    echo $obs_id >> ~/logs/obs_fail_${SLURM_ARRAY_JOB_ID}.txt
fi

# Remove outputs from instance
sudo rm ${outdir}/*${obs_id}*

# Remove vis files and metafits from the instance
if [ $input_type == "uvfits" ]; then
  sudo rm uvfits/${obs_id}.uvfits
else
  sudo rm gpubox/${obs_id}_vis/${obs_id}*
fi

# Copy stdout to az
azcopy copy ~/logs/SSINS_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
${ssins_output_az_path}/logs/SSINS_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt

# Copy stderr to az
azcopy copy ~/logs/SSINS_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
${ssins_output_az_path}/logs/SSINS_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt

echo "JOB END TIME" `date +"%Y-%m-%d_%H:%M:%S"`

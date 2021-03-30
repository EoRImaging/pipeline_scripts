#!/bin/bash

echo JOBID ${SLURM_ARRAY_JOB_ID}
echo TASKID ${SLURM_ARRAY_TASK_ID}
echo "JOB START TIME" `date +"%Y-%m-%d_%H:%M:%S"`
myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo PUBLIC IP ${myip}

obs_id=$(cat ${obs_file_name} | sed -n ${SLURM_ARRAY_TASK_ID}p)
echo "Processing $obs_id"

# sign into azure
az login --identity

# set defaults
if [ -z ${outdir} ]; then
    outdir=SSINS_output/${obs_id}_SSINS
fi
if [ -z ${az_path} ]; then
    az_path=https://mwadata.blob.core.windows.net/ssins/2013
fi
if [ -z ${input_az_loc} ]; then
    input_az_loc=https://mwadata.blob.core.windows.net/gpubox/2013
fi

# strip the last / if present in output directory filepath
outdir=${outdir%/}
echo Using output directory: $outdir

az_path=${az_path%/}
echo Using output az location: $az_path

echo Using input_az_loc: $input_az_loc

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
      az storage copy -s ${input_az_loc}/${obs_id}.uvfits \
      -d uvfits/${obs_id}.uvfits
      fi

      # Verify that the uvfits downloaded correctly
      if [ ! -f "uvfits/${obs_id}.uvfits" ]; then
          >&2 echo "ERROR: downloading uvfits from az failed"
          echo $obs_id >> ~/logs/obs_fail_${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}.txt
          echo "Job Failed"
          exit 1
      fi
  fi
  input_files="uvfits/${obs_id}.uvfits"

else
  # Check if the gpubox files exist locally; if not, download them from az
  file_num=$(ls gpubox/${obs_id}_vis/${obs_id}*.fits | wc -l)
  if [ $file_num -eq "0" ]; then

      # Download box files and metafits from az
      az storage copy -s ${input_az_loc}/${obs_id}_vis --include-pattern "*fits" -d gpubox --recursive
      
      # Verify that the box files downloaded correctly
      file_num=$(ls gpubox/${obs_id}_vis/${obs_id}*.fits | wc -l)
      if [ $file_num -eq "0" ]; then
          >&2 echo "ERROR: downloading box files from az failed"
          echo $obs_id >> ~/logs/obs_fail_${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}.txt
          echo "Job Failed"
          exit 1
      fi

      # Verify that the metafits file downloaded correctly.
      if [ ! -f $(ls gpubox/${obs_id}_vis/${obs_id}.metafits) ]; then
          >&2 echo "ERROR: downloading metafits file from az failed"
          echo $obs_id >> ~/logs/obs_fail_${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}.txt
          echo "Job Failed"
          exit 1
      fi
  fi
  input_files=$(ls gpubox/${obs_id}_vis/${obs_id}*fits)
  echo $input_files
fi

# Run python catalog script
if [ $correct -eq 1 ]; then
  python -u ~/repos/SSINS/scripts/MWA_EoR_High_uvfits_write.py -o ${obs_id} -u ${input_files} -d $outdir -t ${time_avg} -a ${freq_avg} -f -c
else
  python -u ~/repos/SSINS/scripts/MWA_EoR_High_uvfits_write.py -o ${obs_id} -u ${input_files} -d $outdir -t ${time_avg} -a ${freq_avg} -f
fi

# Move SSINS outputs to az
i=1  # initialize counter
az storage copy -s ${outdir} -d ${az_path} --include-pattern "*${obs_id}*" --recursive
while [ $? -ne 0 ] && [ $i -lt 10 ]; do
    let "i += 1"  # increment counter
    >&2 echo "Moving SSINS outputs to az failed. Retrying (attempt $i)."
    az storage copy -s ${outdir} -d ${az_path} --include-pattern "*${obs_id}*" --recursive
# done

# Remove vis files and metafits from the instance
if [ $input_type == "uvfits" ]; then
  sudo rm uvfits/${obs_id}.uvfits
else
  sudo rm gpubox/${obs_id}_vis/${obs_id}*
fi

# Copy stdout to az
az storage copy -s ~/logs/SSINS_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
-d ${az_path}/logs/SSINS_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt

# Copy stderr to az
az storage copy -s ~/logs/SSINS_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
-d ${az_path}/logs/SSINS_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt

echo "JOB END TIME" `date +"%Y-%m-%d_%H:%M:%S"`

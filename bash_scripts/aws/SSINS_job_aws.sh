#!/bin/bash

echo JOBID ${JOB_ID}
echo TASKID ${SGE_TASK_ID}
echo "JOB START TIME" `date +"%Y-%m-%d_%H:%M:%S"`
myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo PUBLIC IP ${myip}

#set defaults
if [ -z ${nslots} ]; then
    nslots=10
fi
if [ -z ${outdir} ]; then
    outdir=/SSINS_output/${obs_id}_SSINS
fi
if [ -z ${s3_path} ]; then
    s3_path=s3://mw-mwa-ultra-faint-rfi
fi
if [ -z ${input_s3_loc} ]; then
    input_s3_loc=s3://mwapublic/uvfits/4.1
fi

obs_id=$(sed "${SGE_TASK_ID}q;d" ${obs_file_name})

echo "Processing $obs_id"

#strip the last / if present in output directory filepath
outdir=${outdir%/}
echo Using output directory: $outdir

s3_path=${s3_path%/}
echo Using output S3 location: $s3_path

echo Using input_s3_loc: $input_s3_loc

#create output directory with full permissions
if [ -d "$outdir" ]; then
    sudo chmod -R 777 $outdir
else
    sudo mkdir -m 777 $outdir
fi

#create input download location with full permissions
if [ -d /${input_type} ]; then
    sudo chmod -R 777 /${input_type}
else
    echo Making directory: /${input_type}
    sudo mkdir -m 777 /${input_type}
fi

# Check input type
if [ $input_type == "uvfits" ]; then

  # Check if the uvfits file exists locally; if not, download it from S3
  if [ ! -f "/uvfits/${obs_id}.uvfits" ]; then

      # Check that the uvfits file exists on S3
      uvfits_exists=$(aws s3 ls ${input_s3_loc}/${obs_id}.uvfits)
      if [ -z "$uvfits_exists" ]; then
          >&2 echo "ERROR: uvfits file not found"
          echo $obs_id >> /home/ubuntu/MWA/MJW-MWA/Obs_Lists/obs_fail.txt
          echo "Job Failed"
          exit 1
      fi

      # Download uvfits from S3
      sudo aws s3 cp ${input_s3_loc}/${obs_id}.uvfits \
      /uvfits/${obs_id}.uvfits --quiet

      # Verify that the uvfits downloaded correctly
      if [ ! -f "/uvfits/${obs_id}.uvfits" ]; then
          >&2 echo "ERROR: downloading uvfits from S3 failed"
          echo $obs_id >> /home/ubuntu/MWA/MJW-MWA/Obs_Lists/obs_fail.txt
          echo "Job Failed"
          exit 1
      fi
  fi
  input_files="/uvfits/${obs_id}.uvfits"
else
  # Check if the gpubox files exist locally; if not, download them from s3
  file_num=$(ls /gpubox/${obs_id}*.fits | wc -l)
  if [ $file_num -eq "0" ]; then

      # Check that the box files exist on S3
      gpubox_exists=$(aws s3 ls ${input_s3_loc}/${obs_id}_vis/ --recursive | grep /*_gpubox*)
      if [ -z "$gpubox_exists" ]; then
          >&2 echo "ERROR: gpubox files not found on s3"
          echo $obs_id >> /home/ubuntu/obs_fail_${JOB_ID}.${SGE_TASK_ID}.txt
          echo "Job Failed"
          exit 1
      fi

      # Check that the metafits file exists on s3
      metafits_exists=$(aws s3 ls ${input_s3_loc}/${obs_id}_vis/${obs_id}.metafits)
      if [ -z "$metafits_exists" ]; then
          >&2 echo "ERROR: metafits file not found on s3"
          echo $obs_id >> /home/ubuntu/obs_fail_${JOB_ID}.${SGE_TASK_ID}.txt
          echo "Job Failed"
          exit 1
      fi

      # Download box files and metafits from S3
      sudo aws s3 cp ${input_s3_loc}/${obs_id}_vis/ /gpubox/ --quiet --exclude "*" --include "*gpubox*" --recursive
      sudo aws s3 cp ${input_s3_loc}/${obs_id}_vis/${obs_id}.metafits \
      /gpubox/${obs_id}.metafits --quiet

      # Verify that the box files downloaded correctly
      file_num=$(ls /gpubox/${obs_id}*.fits | wc -l)
      if [ $file_num -eq "0" ]; then
          >&2 echo "ERROR: downloading box files from S3 failed"
          echo $obs_id >> /home/ubuntu/obs_fail_${JOB_ID}.${SGE_TASK_ID}.txt
          echo "Job Failed"
          exit 1
      fi

      # Verify that the metafits file downloaded correctly.
      if [ ! -f $(ls /gpubox/${obs_id}.metafits) ]; then
          >&2 echo "ERROR: downloading metafits file from S3 failed"
          echo $obs_id >> /home/ubuntu/obs_fail_${JOB_ID}.${SGE_TASK_ID}.txt
          echo "Job Failed"
          exit 1
      fi

  fi
  input_files=$(ls /gpubox/${obs_id}*fits)
  echo $input_files
fi

# Run python catalog script
if [ $correct -eq 1 ]; then
  python ~/MWA/SSINS/scripts/MWA_EoR_High_uvfits_write.py -o ${obs_id} -u ${input_files} -d $outdir -f -c
else
  python ~/MWA/SSINS/scripts/MWA_EoR_High_uvfits_write.py -o ${obs_id} -u ${input_files} -d $outdir -f
fi

# Move SSINS outputs to S3
i=1  #initialize counter
aws s3 mv ${outdir}/ ${s3_path}/ --recursive \
--exclude "*" --include "*${obs_id}*" --quiet
while [ $? -ne 0 ] && [ $i -lt 10 ]; do
    let "i += 1"  #increment counter
    >&2 echo "Moving SSINS outputs to S3 failed. Retrying (attempt $i)."
    aws s3 mv ${outdir}/ ${s3_path}/ \
    --recursive --exclude "*" --include "*${obs_id}*" --quiet
done

# Remove vis files and metafits from the instance
if [ $input_type == "uvfits" ]; then
  sudo rm /uvfits/${obs_id}.uvfits
else
  sudo rm /gpubox/${obs_id}*
fi

# Copy gridengine stdout to S3
aws s3 cp ~/grid_out/SSINS_job_aws.sh.o${JOB_ID}.${SGE_TASK_ID} \
${s3_path}/grid_out/SSINS_job_aws.sh.o${JOB_ID}.${SGE_TASK_ID}_${myip}.txt \
--quiet

# Copy gridengine stderr to S3
aws s3 cp ~/grid_out/SSINS_job_aws.sh.e${JOB_ID}.${SGE_TASK_ID} \
${s3_path}/grid_out/SSINS_job_aws.sh.e${JOB_ID}.${SGE_TASK_ID}_${myip}.txt \
--quiet

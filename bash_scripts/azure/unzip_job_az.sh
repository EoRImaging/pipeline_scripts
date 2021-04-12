#!/bin/bash

################################################################################
# Batch script for unzipping box files from ASVO. First level is run_unzip_az. #
################################################################################

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

echo OBSID "${obs_id}"

# sign into azure
az login --identity

# echo keywords
echo Using outdir: $outdir
echo Using az_path: $az_path
echo Using output directory: $outdir
echo Using zip_az_loc: $zip_az_loc

# create output directory with full permissions
if [ -d $outdir ]; then
    sudo chmod -R 777 $outdir
else
    sudo mkdir -m 777 $outdir
fi

# create zip download location with full permissions
if [ -d "box_zips" ]; then
    sudo chmod -R 777 box_zips
else
    sudo mkdir -m 777 box_zips
fi

# Check if the uvfits file exists locally; if not, download it from az
if [ ! -f "box_zips/${obs_id}_vis.zip" ]; then

    # Download uvfits from az
    az storage copy -s ${zip_az_loc}/${obs_id}_vis.zip \
    -d box_zips/${obs_id}_vis.zip

    # Verify that the uvfits downloaded correctly
    if [ ! -f "box_zips/${obs_id}_vis.zip" ]; then
        >&2 echo "ERROR: downloading zipped files from az failed"
        echo "Job Failed"
        exit 1
    fi
fi

# Run unzip
unzip box_zips/${obs_id}_vis.zip -d ${outdir}/${obs_id}_vis

if [ $? -eq 0 ]; then
    echo "unzip Job Finished"
    error_mode=0
else
    echo "unzip Job Failed"
    error_mode=1
fi

# Copy unzipped outputs to az
i=1  # initialize counter
az storage copy -s ${outdir}/${obs_id}_vis -d ${az_path} --recursive
while [ $? -ne 0 ] && [ $i -lt 10 ]; do
    let "i += 1"  # increment counter
    >&2 echo "Moving unzipped outputs to az failed. Retrying (attempt $i)."
    az storage copy -s ${outdir}/${obs_id}_vis -d ${az_path} --recursive
done

# Copy metafits to az
i=1  # initialize counter
az storage copy -s ${outdir}/${obs_id}_vis/${obs_id}.metafits -d ${metafits_az_path}/${obs_id}.metafits
while [ $? -ne 0 ] && [ $i -lt 10 ]; do
    let "i += 1"  # increment counter
    >&2 echo "Moving metafits to az failed. Retrying (attempt $i)."
    az storage copy -s ${outdir}/${obs_id}_vis/${obs_id}.metafits -d ${metafits_az_path}/${obs_id}.metafits
done

# Remove zip files from instance
sudo rm box_zips/${obs_id}_vis.zip

# Remove outputs from instance
sudo rm -r ${outdir}/${obs_id}_vis

# Copy stdout to az
az storage copy -s ~/logs/unzip_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
-d ${az_path}/unzip_${version}/logs/unzip_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt

# Copy stderr to az
az storage copy -s ~/logs/unzip_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
-d ${az_path}/unzip_${version}/logs/unzip_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt

echo "UNZIP JOB END TIME" `date +"%Y-%m-%d_%H:%M:%S"`

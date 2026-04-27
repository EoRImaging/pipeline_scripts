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

# create output directory with full permissions
if [ -d output_files ]; then
    sudo chmod -R 777 output_files
else
    sudo mkdir -m 777 output_files
fi

# create input download location with full permissions
if [ -d gpubox ]; then
    sudo chmod -R 777 gpubox
else
    echo "Making directory: gpubox"
    sudo mkdir -m 777 gpubox
fi

file_num=$(ls gpubox/${obs_id}*_vis/${obs_id}*.fits | wc -l)
if [ $file_num -eq "0" ]; then

    # Download box files and metafits from az
    azcopy copy ${data_dir}/* gpubox --include-pattern "${obs_id}*fits" --recursive
    # azcopy copy ${data_dir}/${obs_id}_vis gpubox --include-pattern "*fits" --recursive

    # Verify that the box files downloaded correctly
    file_num=$(ls gpubox/${obs_id}*_vis/${obs_id}*.fits | wc -l)
    # file_num=$(ls gpubox/${obs_id}_vis/${obs_id}*.fits | wc -l)
    if [ $file_num -eq "0" ]; then
        >&2 echo "ERROR: downloading box files from az failed"
        echo $obs_id >> ~/logs/obs_fail_${SLURM_ARRAY_JOB_ID}.txt
        echo "Job Failed"
        exit 1
    fi

    # Verify that the metafits file downloaded correctly.
    if [ ! -f $(ls gpubox/${obs_id}*_vis/${obs_id}*.metafits) ]; then
        >&2 echo "ERROR: downloading metafits file from az failed"
        echo $obs_id >> ~/logs/obs_fail_${SLURM_ARRAY_JOB_ID}.txt
        echo "Job Failed"
        exit 1
    fi
fi
input_files=$(ls gpubox/${obs_id}*_vis/${obs_id}*fits)
echo ${input_files}
arg_string="${arg_string} -u ${input_files} -o ${obs_id}"


# if using ssins, create directory and download
if [ ! -z $ssins_dir ]; then
    echo "using ssins_dir"
    echo ${ssins_dir}
    if [ -d ssins ]; then
	sudo chmod -R 777 ssins
    else
        sudo mkdir -m 777 ssins
    fi
    file_num=$(ls ssins/${obs_id}_SSINS_flags.h5 | wc -l)
    if [ $file_num -eq "0" ]; then
	azcopy copy ${ssins_dir}/${obs_id}_SSINS_flags.h5 ssins/${obs_id}_SSINS_flags.h5
	file_num=$(ls ssins/${obs_id}_SSINS_flags.h5 | wc -l)
	if [ $file_num -eq "0" ]; then
	    >&2 echo "ERROR: downloading ssins file from az failed"
            echo $obs_id >> ~/logs/obs_fail_${SLURM_ARRAY_JOB_ID}.txt
            echo "Job Failed"
            exit 1
        fi
    fi
fi

# run pyuvdata
python -u ~/repos/pipeline_scripts/pyuvdata_scripts/pyuvdata_gpubox_processing.py $arg_string

# pyuvdata creates a unique folder based on file properties
# find the name of that folder here
# create an array for the rare case that multiple files have been created
py_files=("$(ls -d output_files/*/${obs_id}.*)")

for p in "${py_files[@]}"; do
    filepath=${p#*/}
    # move output file to azure storage
    i=1  # initialize counter
    echo ${output_dir}/${filepath}
    azcopy copy output_files/${filepath} ${output_dir}/${filepath}
    while [ $? -ne 0 ] && [ $i -lt 10 ]; do
        let "i += 1"  # increment counter
        >&2 echo "Moving uvfits to az failed. Retrying (attempt $i)."
        azcopy copy output_files/${filepath} ${output_dir}/${filepath}
    done

    if [ $? -ne 0 ]; then
        >&2 echo "Transferring uvfits to az completely failed."
        echo $obs_id >> ~/logs/obs_fail_${SLURM_ARRAY_JOB_ID}.txt
    fi
done

# Remove files from the instance
sudo rm gpubox/${obs_id}_vis/${obs_id}*.fits
sudo rm gpubox/${obs_id}_vis/${obs_id}.metafits
sudo rm output_files/${filepath}
sudo rm ssins/${obs_id}_SSINS_flags.h5

# Copy stdout to az
azcopy copy ~/logs/${SLURM_JOB_NAME}.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
${output_dir}/logs/${SLURM_JOB_NAME}.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt

# Copy stderr to az
azcopy copy ~/logs/${SLURM_JOB_NAME}.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
${output_dir}/logs/${SLURM_JOB_NAME}.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt

echo "JOB END TIME" `date +"%Y-%m-%d_%H:%M:%S"`

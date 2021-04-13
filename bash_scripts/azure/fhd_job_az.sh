#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Batch script for slurm job. Second level program for
# running firstpass on azure machines. First level program is run_fhd_az.sh
# Adapted from fhd_job_aws.sh
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


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
echo Using outdir: $outdir
echo Using az_path: $az_path
echo Using version: $version
echo Using versions_script: $versions_script
echo Using output directory: $outdir
echo Using uvfits_az_loc: $uvfits_az_loc
echo Using metafits_az_loc: $metafits_az_loc
echo Using run_ps: $run_ps

# create output directory with full permissions
if [ -d $outdir ]; then
    sudo chmod -R 777 $outdir
else
    sudo mkdir -m 777 $outdir
fi

# Copy previous runs from az (allows FHD to not recalculate everything)
# Currently az storage copy used with --include-pattern moves folder as well as files - March 2021
# az storage copy -s ${az_path}/fhd_${version} -d ${outdir}/fhd_${version} \
# --include-pattern "*${obs_id}*" --recursive
azcopy copy ${az_path}/fhd_${version} ${outdir} --include-pattern "*${obs_id}*" --recursive

# Maybe add this later
# Run backup script in the background
# fhd_on_aws_backup.sh $outdir $az_path $version $SLURM_ARRAY_JOB_ID $myip &
# Run RAM use recording script in the background
# record_ram_use_az.sh $obs_id $outdir $version $SLURM_ARRAY_JOB_ID $myip &

# create uvfits download location with full permissions
if [ -d "uvfits" ]; then
    sudo chmod -R 777 uvfits
else
    sudo mkdir -m 777 uvfits
fi

# Check if the uvfits file exists locally; if not, download it from az
if [ ! -f "uvfits/${obs_id}.uvfits" ]; then

    # Download uvfits from az
    azcopy copy ${uvfits_az_loc}/${obs_id}.uvfits uvfits/${obs_id}.uvfits

    # Verify that the uvfits downloaded correctly
    if [ ! -f "uvfits/${obs_id}.uvfits" ]; then
        >&2 echo "ERROR: downloading uvfits from az failed"
        echo "Job Failed"
        exit 1
    fi
fi

# Check if the metafits file exists locally; if not, download it from az
if [ ! -f "uvfits/${obs_id}.metafits" ]; then

    # Download metafits from az
    azcopy copy ${metafits_az_loc}/${obs_id}.metafits uvfits/${obs_id}.metafits
    # Verify that the metafits downloaded correctly
    if [ ! -f "uvfits/${obs_id}.metafits" ]; then
        echo "WARNING: downloading metafits from az failed. Running without metafits."
    fi
fi

# !untested!
# Make directory for input_vis
if [ ! -z ${input_vis} ]; then
    if [ -d uvfits/input_vis ]; then
        sudo chmod -R 777 uvfits/input_vis
    else
        sudo mkdir -m 777 uvfits/input_vis
    fi
    # Download input_vis from az
    azcopy copy ${input_vis} uvfits/input_vis/vis_data --recursive --include-pattern "${obs_id}*"
    # Check download
    if [ ! -f "uvfits/input_vis/vis_data/${obs_id}_vis_model_XX.sav" ] || [ ! -f "uvfits/input_vis/vis_data/${obs_id}_vis_model_YY.sav" ]; then
        >&2 echo "ERROR: input_vis file not found"
        echo "Job Failed"
        exit 1
    fi
    echo Input visibilities from ${input_vis} copied to uvfits/input_vis/vis_data
fi

# !untested!
# Make input_eor directory
if [ ! -z ${input_eor} ]; then
    if [ -d uvfits/input_eor ]; then
        sudo chmod -R 777 uvfits/input_eor
    else
        sudo mkdir -m 777 uvfits/input_eor
    fi
    # Download input_eor from az
    azcopy copy ${input_eor} uvfits/input_eor/vis_data --recursive
    # Check download
    if [ -z $(ls uvfits/input_eor/vis_data/) ]; then
        >&2 echo "ERROR: input_eor file not found on filesystem"
        echo "Job Failed"
        exit 1
    fi
    echo Input EoR visibilities from ${input_eor} copied to uvfits/input_eor/vis_data
fi

# !untested!
# Make extra_vis directory
if [ ! -z ${extra_vis} ]; then
    if [ -d uvfits/extra_vis ]; then
        sudo chmod -R 777 uvfits/extra_vis
    else
        sudo mkdir -m 777 uvfits/extra_vis
    fi
    # Download extra_vis from az
    azcopy copy ${extra_vis} uvfits/extra_vis
    # Check the download
    if [ -z $(ls uvfits/extra_vis/) ]; then
        >&2 echo "ERROR: extra_vis file not found on filesystem"
        echo "Job Failed"
        exit 1
    fi
    echo Extra visibilities from ${extra_vis} copied to uvfits/extra_vis/
fi

# Get calibration transfer files
if [ ! -z ${cal_transfer} ]; then
    # Check that the cal_transfer file exists on az
    cal_transfer_az_path="${cal_transfer}/calibration/${obs_id}_cal.sav"
    transfer_dir=uvfits/transfer
    if [ -d $transfer_dir ]; then
        sudo chmod -R 777 $transfer_dir
    else
        sudo mkdir -m 777 $transfer_dir
    fi
    # Download the cal_transfer file
    azcopy copy $cal_transfer_az_path $transfer_dir/${obs_id}_cal.sav
    # Check the download
    if [ ! -f "${transfer_dir}/${obs_id}_cal.sav" ]; then
    >&2 echo "ERROR: cal_transfer file not found on filesystem"
        echo "Job Failed"
        exit 1
    fi
    echo Calibration transferred from $cal_transfer
fi

# Get model_uv transfer files
if [ ! -z ${model_uv_transfer} ]; then
    model_uv_transfer_az_path="${model_uv_transfer}/cal_prerun/${obs_id}_model_uv_arr.sav"

    transfer_dir=uvfits/transfer
    if [ -d $transfer_dir ]; then
        sudo chmod -R 777 $transfer_dir
    else
        sudo mkdir -m 777 $transfer_dir
    fi
    # Download the model_uv_transfer file
    azcopy copy $model_uv_transfer_az_path $transfer_dir/${obs_id}_model_uv_arr.sav
    # Check the download
    if [ ! -f "${transfer_dir}/${obs_id}_model_uv_arr.sav" ]; then
    >&2 echo "ERROR: model_uv_transfer file not found on filesystem"
        echo "Job Failed"
        exit 1
    fi
    echo Model_uv transferred from $model_uv_transfer
fi

# Run FHD
idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS $nslots -e $versions_script -args \
$obs_id $outdir $version azure || :

if [ $? -eq 0 ]; then
    echo "FHD Job Finished"
    error_mode=0
else
    echo "FHD Job Failed"
    error_mode=1
fi

# sign into azure again
az login --identity

# Copy FHD outputs to az
i=1  # initialize counter
# az storage copy -s ${outdir}/fhd_${version} -d ${az_path}/fhd_${version} --recursive --include-pattern "*${obs_id}*"
# az storage copy currently moves source directory when calling --recursive and --include-pattern 3/2021
azcopy copy ${outdir}/fhd_${version} ${az_path} --recursive --include-pattern "*${obs_id}*"
while [ $? -ne 0 ] && [ $i -lt 10 ]; do
    let "i += 1"  # increment counter
    >&2 echo "Moving FHD outputs to az failed. Retrying (attempt $i)."
    # az storage copy -s ${outdir}/fhd_${version} -d ${az_path}/fhd_${version} --recursive --include-pattern "*${obs_id}*"
    azcopy copy ${outdir}/fhd_${version} ${az_path} --recursive --include-pattern "*${obs_id}*"
done

# Remove uvfits and metafits from the instance
sudo rm uvfits/${obs_id}.uvfits
sudo rm uvfits/${obs_id}.metafits
if [ ! -z ${input_vis} ]; then
    sudo rm -r uvfits/input_vis
fi
if [ ! -z ${input_eor} ]; then
    sudo rm -r uvfits/input_eor
fi

echo "FHD JOB END TIME" `date +"%Y-%m-%d_%H:%M:%S"`

# !untested!
# Start PS
if [ "$run_ps" -eq 1 ]; then
    echo Running power spectrum
    refresh_ps=0
    ps_wt_cutoffs=1
    echo Using ps_uvf_input: $ps_uvf_input
    echo Using refresh_ps: $refresh_ps
    echo Using ps_wt_cutoffs: $ps_wt_cutoffs
    # Create ps directory with full permissions if it doesn't exist
    if [ -d "${outdir}/fhd_${version}/ps" ]; then
        sudo chmod -R 777 ${outdir}/fhd_${version}/ps
    else
        sudo mkdir -m 777 ${outdir}/fhd_${version}/ps
    fi

    # Run eppsilon
    idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS $nslots -e az_ps_single_obs_job -args \
    $obs_id $outdir $version $refresh_ps $ps_uvf_input $ps_wt_cutoffs || :

    if [ $? -eq 0 ]; then
        echo "Eppsilon Job Finished"
        error_mode=0
    else
        echo "Eppsilon Job Failed"
        error_mode=1
    fi

    # Move outputs to az
    i=1  # initialize counter
    azcopy copy ${outdir}/fhd_${version}/ps ${az_path}/fhd_${version} \
    --recursive --include-pattern "*${obs_id}*"
    while [ $? -ne 0 ] && [ $i -lt 10 ]; do
        let "i += 1"  # increment counter
        >&2 echo "Moving eppsilon outputs to az failed. Retrying (attempt $i)."
        azcopy copy ${outdir}/fhd_${version}/ps ${az_path}/fhd_${version} \
        --recursive --include-pattern "*${obs_id}*"
    done

fi

# Remove outputs from the instance
sudo rm -r ${outdir}/fhd_${version}/*/*${obs_id}*

# Maybe add this later
# kill $(jobs -p)  # Kill fhd_on_aws_backup.sh

# Copy stdout to az
azcopy copy ~/logs/fhd_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
${az_path}/fhd_${version}/logs/fhd_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt

# Copy stderr to az
azcopy copy ~/logs/fhd_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
${az_path}/fhd_${version}/logs/fhd_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt

echo "JOB END TIME" `date +"%Y-%m-%d_%H:%M:%S"`

exit $error_mode

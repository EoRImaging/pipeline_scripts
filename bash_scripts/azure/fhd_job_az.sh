#!/bin/bash

#############################################################################
# Batch script for slurm job. Second level program for
# running firstpass on azure machines. First level program is run_fhd_az.sh
#############################################################################


echo JOBID ${SLURM_ARRAY_JOB_ID}
echo TASKID ${SLURM_ARRAY_TASK_ID}
echo "JOB START TIME" `date +"%Y-%m-%d_%H:%M:%S"`
myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo PUBLIC IP ${myip}

obs_id=$(cat ${obs_file_name} | sed -n ${SLURM_ARRAY_TASK_ID}p)
echo "OBSID $obs_id"

# sign into azure
az login --identity

# set defaults
if [ -z ${nslots} ]; then
    nslots=10
fi
if [ -z ${outdir} ]; then
    outdir=FHD_output
fi
if [ -z ${az_path} ]; then
    az_path=https://mwadata.blob.core.windows.net/fhd
fi
if [ -z ${versions_script} ]; then
    versions_script='fhd_versions_rlb'
fi
if [ -z ${uvfits_az_loc} ]; then
    uvfits_az_loc=https://mwadata.blob.core.windows.net/uvfits/2013
fi
if [ -z ${metafits_az_loc} ]; then
    metafits_az_loc=https://mwadata.blob.core.windows.net/metafits/2013
fi
if [ -z ${version} ]; then
    >&2 echo "ERROR: no version provided"
    exit 1
fi
if [ -z ${run_fhd} ]; then
    run_fhd=1
fi
if [ -z ${run_ps} ]; then
    run_ps=0
fi
if [ -z ${refresh_ps} ]; then
    refresh_ps=0
fi
if [ -z ${ps_uvf_input} ]; then
    ps_uvf_input=0
fi
if [ -z ${ps_wt_cutoffs} ]; then
    ps_wt_cutoffs=1
fi

#strip the last / if present in output directory filepath
outdir=${outdir%/}
echo Using output directory: $outdir

az_path=${az_path%/}
echo Using output az location: $az_path

#create output directory with full permissions
if [ -d "$outdir" ]; then
    sudo chmod -R 777 ${outdir}
else
    sudo mkdir -m 777 ${outdir}
fi

# Make directory if it doesn't already exist
if [ -d "${outdir}/fhd_${version}/logs" ]; then
    sudo mkdir -p -m 777 ${outdir}/fhd_${version}/logs
    echo Output located at ${outdir}/fhd_${version}
fi

# Copy previous runs from az (allows FHD to not recalculate everything)
# Currently az storage copy used with --include-pattern moves folder as well as files; needs testing
az storage copy -s ${az_path}/fhd_${version} -d ${outdir}/fhd_${version} \
--include-pattern "*${obs_id}*" --recursive

# Run backup script in the background
# fhd_on_aws_backup.sh $outdir $az_path $version $SLURM_ARRAY_JOB_ID $myip &

# Run RAM use recording script in the background
record_ram_use_az.sh $obs_id $outdir $version $SLURM_ARRAY_JOB_ID $myip &

if [ "$run_fhd" -eq 1 ]; then  # Start FHD

    #create uvfits download location with full permissions
    if [ -d "uvfits" ]; then
        sudo chmod -R 777 uvfits
    else
        sudo mkdir -m 777 uvfits
    fi

    # Check if the uvfits file exists locally; if not, download it from az
    if [ ! -f "uvfits/${obs_id}.uvfits" ]; then

        # Check that the uvfits file exists on az
        # uvfits_exists=$(aws az ls ${uvfits_az_loc}/${obs_id}.uvfits)
        # if [ -z "$uvfits_exists" ]; then
            # >&2 echo "ERROR: uvfits file not found"
            # echo "Job Failed"
            # exit 1
        # fi

        # Download uvfits from az
        az storage copy -s ${uvfits_az_loc}/${obs_id}.uvfits \
        -d uvfits/${obs_id}.uvfits 

        # Verify that the uvfits downloaded correctly
        if [ ! -f "uvfits/${obs_id}.uvfits" ]; then
            >&2 echo "ERROR: downloading uvfits from az failed"
            echo "Job Failed"
            exit 1
        fi
    fi

    # Check if the metafits file exists locally; if not, download it from az
    if [ ! -f "uvfits/${obs_id}.metafits" ]; then

        # Check that the metafits file exists on az
        # metafits_exists=$(aws az ls ${metafits_az_loc}/${obs_id}.metafits)
        metafits_exists=1
        if [ -z ${metafits_exists} ]; then
            >&2 echo "WARNING: metafits file not found. Running without metafits."
        else
            # Download metafits from az
            az storage copy -s ${metafits_az_loc}/${obs_id}.metafits \
            -d uvfits/${obs_id}.metafits

            # Verify that the metafits downloaded correctly
            if [ ! -f "uvfits/${obs_id}.metafits" ]; then
                >&2 echo "ERROR: downloading metafits from az failed"
                echo "Job Failed"
                exit 1
            fi
        fi
    fi

    #Get input_vis files
    if [ ! -z ${input_vis} ]; then
        # Check that the input_vis file/loc exists on az
        # input_vis_exists=$(aws az ls ${input_vis})
        # if [ -z "$input_vis_exists" ]; then
            # >&2 echo "ERROR: input_vis file not found"
            # echo "Job Failed"
            # exit 1
        # fi
        if [ -d uvfits/input_vis ]; then
            sudo chmod -R 777 uvfits/input_vis
        else
            sudo mkdir -m 777 uvfits/input_vis
        fi
        # Download input_vis from az
        az storage copy -s ${input_vis} \
        -d uvfits/input_vis/vis_data --recursive --include-pattern "${obs_id}*"
        echo Input visibilities from ${input_vis} copied to uvfits/input_vis/vis_data
        if [ ! -f "uvfits/input_vis/vis_data/${obs_id}_vis_model_XX.sav" ] || [ ! -f "uvfits/input_vis/vis_data/${obs_id}_vis_model_YY.sav" ]; then
            >&2 echo "ERROR: input_vis file not found"
            echo "Job Failed"
            exit 1
        fi
    fi

    #Get input_eor files
    if [ ! -z ${input_eor} ]; then
        # Check that the input_eor file/loc exists on az
        # input_eor_exists=$(aws az ls ${input_eor})
        # if [ -z "$input_eor_exists" ]; then
            # >&2 echo "ERROR: input_eor file not found"
            # echo "Job Failed"
            # exit 1
        # fi
        if [ -d uvfits/input_eor ]; then
            sudo chmod -R 777 uvfits/input_eor
        else
            sudo mkdir -m 777 uvfits/input_eor
        fi
        # Download input_eor from az
        az storage copy -s ${input_eor} \
        -d uvfits/input_eor/vis_data/ --recursive
        echo Input EoR visibilities from ${input_eor} copied to uvfits/input_eor/vis_data
        if [ -z $(ls uvfits/input_eor/vis_data/) ]; then
            >&2 echo "ERROR: input_eor file not found on filesystem"
            echo "Job Failed"
            exit 1
        fi
     fi

    #Get extra_vis files
    if [ ! -z ${extra_vis} ]; then
        # Check that the extra_vis file/loc exists on az
        # extra_vis_exists=$(aws az ls ${extra_vis})
        # if [ -z "$extra_vis_exists" ]; then
            # >&2 echo "ERROR: extra_vis file not found on az"
            # echo "Job Failed"
            # exit 1
        # fi
        # Make the appropriate
        # Download extra_vis from az
        az storage copy -s ${extra_vis} -d uvfits/extra_vis
        # Check the download...
        if [ -z $(ls uvfits/extra_vis/) ]; then
            >&2 echo "ERROR: extra_vis file not found on filesystem"
            echo "Job Failed"
            exit 1
        fi
        echo Extra visibilities from ${extra_vis} copied to uvfits/extra_vis/
    fi

    #Get calibration transfer files
    if [ ! -z ${cal_transfer} ]; then
        # Check that the cal_transfer file exists on az
        cal_transfer_az_path="${cal_transfer}/calibration/${obs_id}_cal.sav"
        # echo "Searching for ${cal_transfer_az_path}"
        # cal_transfer_exists=$(aws az ls ${cal_transfer_az_path})
        # echo $cal_transfer_exists
        # if [ -z "$cal_transfer_exists" ]; then
            # >&2 echo "ERROR: cal_transfer file not found on az"
            # echo "Job Failed"
            # exit 1
        # fi
        transfer_dir="uvfits/transfer"
        if [ -d "$transfer_dir" ]; then
            sudo chmod -R 777 $transfer_dir
        else
            sudo mkdir -m 777 $transfer_dir
        fi
        #Download the cal_transfer file
        az storage copy -s $cal_transfer_az_path -d $transfer_dir
        #Check the download
        if [ ! -f ${transfer_dir}/${obs_id}_cal.sav ]; then
        >&2 echo "ERROR: cal_transfer file not found on filesystem"
            echo "Job Failed"
            exit 1
        fi
    fi

    #Get model_uv transfer files
    if [ ! -z ${model_uv_transfer} ]; then
        # Check that the model_uv_transfer file exists on az
        model_uv_transfer_az_path="${model_uv_transfer}/cal_prerun/${obs_id}_model_uv_arr.sav"
        # echo Searching for $model_uv_transfer_az_path
        # model_uv_transfer_exists=$(aws az ls ${model_uv_transfer_az_path})
        # echo $model_uv_transfer_exists
        # if [ -z "$model_uv_transfer_exists" ]; then
            # >&2 echo "ERROR: model_uv_transfer file not found on az"
            # echo "Job Failed"
            # exit 1
        # fi
        transfer_dir="uvfits/transfer"
        if [ -d "$transfer_dir" ]; then
            sudo chmod -R 777 $transfer_dir
        else
            sudo mkdir -m 777 $transfer_dir
        fi
        #Download the model_uv_transfer file
        az storage copy -s $model_uv_transfer_az_path -d $transfer_dir
        #Check the download
        if [ ! -f ${transfer_dir}/${obs_id}_model_uv_arr.sav ]; then
        >&2 echo "ERROR: model_uv_transfer file not found on filesystem"
            echo "Job Failed"
            exit 1
        fi
    fi

    # Run FHD
    idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS $nslots -e $versions_script -args \
    $obs_id $outdir $version azure || :

    if [ $? -eq 0 ]
    then
        echo "FHD Job Finished"
        error_mode=0
    else
        echo "FHD Job Failed"
        error_mode=1
    fi

    # Move FHD outputs to az
    # Right now az storage has a copy function but not a move function 3/2021
    # if [ "$run_ps" -eq 1 ]; then  # Keep outputs on instance
        # transfer_operation=cp
    # else  # Remove outputs from instance
        # transfer_operation=mv
    # fi
    i=1  #initialize counter
    # az storage copy -s ${outdir}/fhd_${version} -d ${az_path}/fhd_${version} --recursive --include-pattern "*${obs_id}*"
    # az storage copy currently moves source directory when calling --recursive and --include-pattern 3/2021
    az storage copy -s ${outdir}/fhd_${version} -d ${az_path} --recursive --include-pattern "*${obs_id}*"
    while [ $? -ne 0 ] && [ $i -lt 10 ]; do
        let "i += 1"  #increment counter
        >&2 echo "Moving FHD outputs to az failed. Retrying (attempt $i)."
        # az storage copy -s ${outdir}/fhd_${version} -d ${az_path}/fhd_${version} --recursive --include-pattern "*${obs_id}*"
        az storage copy -s ${outdir}/fhd_${version} -d ${az_path} --recursive --include-pattern "*${obs_id}*"
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

fi  # End FHD

if [ "$run_ps" -eq 1 ]; then  # Start PS

    # Create ps directory with full permissions if it doesn't exist
    if [ -d "${outdir}/fhd_${version}/ps" ]; then
        sudo chmod -R 777 ${outdir}/fhd_${version}/ps
    else
        sudo mkdir -m 777 ${outdir}/fhd_${version}/ps
    fi

    # Run eppsilon
    idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS $nslots -e aws_ps_single_obs_job -args \
    $obs_id $outdir $version $refresh_ps $ps_uvf_input $ps_wt_cutoffs || :

    if [ $? -eq 0 ]
    then
        echo "Eppsilon Job Finished"
        error_mode=0
    else
        echo "Eppsilon Job Failed"
        error_mode=1
    fi

    # Move outputs to az
    i=1  #initialize counter
    az storage copy -s ${outdir}/fhd_${version}/ps -d ${az_path}/fhd_${version}/ps \
    --recursive --include-pattern "*${obs_id}*"
    while [ $? -ne 0 ] && [ $i -lt 10 ]; do
        let "i += 1"  #increment counter
        >&2 echo "Moving eppsilon outputs to az failed. Retrying (attempt $i)."
        az storage copy -s ${outdir}/fhd_${version}/ps -d ${az_path}/fhd_${version}/ps \
        --recursive --include-pattern "*${obs_id}*"
    done

    # Remove outputs from the instance
    sudo rm -r ${outdir}/fhd_${version}

fi  # End PS

kill $(jobs -p)  # Kill fhd_on_aws_backup.sh

echo "JOB END TIME" `date +"%Y-%m-%d_%H:%M:%S"`

# Copy gridengine stdout to az
az storage copy -s ~/logs/fhd_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
-d ${az_path}/logs/fhd_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt

# Copy gridengine stderr to S3
az storage copy -s ~/logs/fhd_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
-d ${az_path}/logs/fhd_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt

exit $error_mode

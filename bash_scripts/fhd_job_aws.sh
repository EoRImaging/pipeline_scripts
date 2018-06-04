#! /bin/bash

#############################################################################
# Runs one observation at a time in grid engine.  Second level program for
# running firstpass on AWS machines. First level program is run_fhd_aws.sh
#############################################################################


echo JOBID ${JOB_ID}
echo TASKID ${SGE_TASK_ID}
echo OBSID ${obs_id}
echo "JOB START TIME" `date +"%Y-%m-%d_%H:%M:%S"`
myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo PUBLIC IP ${myip}

#set defaults
if [ -z ${nslots} ]; then
    nslots=10
fi
if [ -z ${outdir} ]; then
    outdir=/FHD_output
fi
if [ -z ${s3_path} ]; then
    s3_path=s3://mwatest/diffuse_survey
fi
if [ -z ${versions_script} ]; then
    versions_script='fhd_versions_rlb'
fi
if [ -z ${uvfits_s3_loc} ]; then
    uvfits_s3_loc=s3://mwapublic/uvfits/4.1
fi
if [ -z ${metafits_s3_loc} ]; then
    metafits_s3_loc=s3://mwatest/metafits/4.1
fi
if [ -z ${version} ]; then
    >&2 echo "ERROR: no version provided"
    exit 1
fi
if [ -z ${obs_id} ]; then
    >&2 echo "ERROR: no obs ID provided"
    exit 1
fi

#strip the last / if present in output directory filepath
outdir=${outdir%/}
echo Using output directory: $outdir

s3_path=${s3_path%/}
echo Using output S3 location: $s3_path

#create output directory with full permissions
if [ -d "$outdir" ]; then
    sudo chmod -R 777 $outdir
else
    sudo mkdir -m 777 $outdir
fi

#create uvfits download location with full permissions
if [ -d /uvfits ]; then
    sudo chmod -R 777 /uvfits
else
    sudo mkdir -m 777 /uvfits
fi

# Check if the uvfits file exists locally; if not, download it from S3
if [ ! -f "/uvfits/${obs_id}.uvfits" ]; then

    # Check that the uvfits file exists on S3
    uvfits_exists=$(aws s3 ls ${uvfits_s3_loc}/${obs_id}.uvfits)
    if [ -z "$uvfits_exists" ]; then
        >&2 echo "ERROR: uvfits file not found"
        echo "Job Failed"
        exit 1
    fi

    # Download uvfits from S3
    sudo aws s3 cp ${uvfits_s3_loc}/${obs_id}.uvfits \
    /uvfits/${obs_id}.uvfits --quiet

    # Verify that the uvfits downloaded correctly
    if [ ! -f "/uvfits/${obs_id}.uvfits" ]; then
        >&2 echo "ERROR: downloading uvfits from S3 failed"
        echo "Job Failed"
        exit 1
    fi
fi

# Check if the metafits file exists locally; if not, download it from S3
if [ ! -f "/uvfits/${obs_id}.metafits" ]; then

    # Check that the metafits file exists on S3
    metafits_exists=$(aws s3 ls ${metafits_s3_loc}/${obs_id}.metafits)
    if [ -z "$metafits_exists" ]; then
        >&2 echo "ERROR: metafits file not found"
        echo "Job Failed"
        exit 1
    fi

    # Download metafits from S3
    sudo aws s3 cp ${metafits_s3_loc}/${obs_id}.metafits \
    /uvfits/${obs_id}.metafits --quiet

    # Verify that the metafits downloaded correctly
    if [ ! -f "/uvfits/${obs_id}.metafits" ]; then
        >&2 echo "ERROR: downloading metafits from S3 failed"
        echo "Job Failed"
        exit 1
    fi
fi

#Get input_vis files
if [ ! -z ${input_vis} ]; then

    # Check that the input_vis file/loc exists on S3
    input_vis_exists=$(aws s3 ls ${input_vis})
    if [ -z "$input_vis_exists" ]; then
        >&2 echo "ERROR: input_vis file not found"
        echo "Job Failed"
        exit 1
    fi

    # Download input_vis from S3
    sudo aws s3 cp ${input_vis} \
    /uvfits/input_vis/vis_data/ --recursive --quiet

    echo Input visibilities from ${input_vis} copied to /uvfits/input_vis/vis_data

    if [ ! -f "/uvfits/input_vis/vis_data/${obs_id}_vis_model_XX.sav" ] || [ ! -f "/uvfits/input_vis/vis_data/${obs_id}_vis_model_YY.sav" ]; then
        >&2 echo "ERROR: input_vis file not found"
        echo "Job Failed"
        exit 1
    fi

fi

#Get input_eor files
if [ ! -z ${input_eor} ]; then

    # Check that the input_eor file/loc exists on S3
    input_eor_exists=$(aws s3 ls ${input_eor})
    if [ -z "$input_eor_exists" ]; then
        >&2 echo "ERROR: input_eor file not found"
        echo "Job Failed"
        exit 1
    fi

    # Download input_eor from S3
    sudo aws s3 cp ${input_eor} \
    /uvfits/input_eor/vis_data/ --recursive --quiet

    echo Input EoR visibilities from ${input_eor} copied to /uvfits/input_eor/vis_data

fi

# Copy previous runs from S3 (allows FHD to not recalculate everything)
aws s3 cp ${s3_path}/fhd_${version}/ ${outdir}/fhd_${version}/ --recursive \
--exclude "*" --include "*${obs_id}*" --quiet

# Run backup script in the background
fhd_on_aws_backup.sh $outdir $s3_path $version $JOB_ID $myip &

# Run FHD
idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS $nslots -e $versions_script -args \
$obs_id $outdir $version aws || :

if [ $? -eq 0 ]
then
    echo "FHD Job Finished"
    error_mode=0
else
    echo "Job Failed"
    error_mode=1
fi

kill $(jobs -p) #kill fhd_on_aws_backup.sh

# Move FHD outputs to S3
i=1  #initialize counter
aws s3 mv ${outdir}/fhd_${version}/ ${s3_path}/fhd_${version}/ --recursive \
--exclude "*" --include "*${obs_id}*" --quiet
while [ $? -ne 0 ] && [ $i -lt 10 ]; do
    let "i += 1"  #increment counter
    >&2 echo "Moving FHD outputs to S3 failed. Retrying (attempt $i)."
    aws s3 mv ${outdir}/fhd_${version}/ ${s3_path}/fhd_${version}/ \
    --recursive --exclude "*" --include "*${obs_id}*" --quiet
done

# Remove uvfits and metafits from the instance
sudo rm /uvfits/${obs_id}.uvfits
sudo rm /uvfits/${obs_id}.metafits

echo "JOB END TIME" `date +"%Y-%m-%d_%H:%M:%S"`

# Copy gridengine stdout to S3
aws s3 cp ~/grid_out/fhd_job_aws.sh.o${JOB_ID} \
${s3_path}/fhd_${version}/grid_out/fhd_job_aws.sh.o${JOB_ID}_${myip}.txt \
--quiet

# Copy gridengine stderr to S3
aws s3 cp ~/grid_out/fhd_job_aws.sh.e${JOB_ID} \
${s3_path}/fhd_${version}/grid_out/fhd_job_aws.sh.e${JOB_ID}_${myip}.txt \
--quiet

exit $error_mode

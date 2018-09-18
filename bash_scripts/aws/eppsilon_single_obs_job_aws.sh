#! /bin/bash

#############################################################################
# Runs one eppsilon on observation at a time in grid engine on AWS
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
if [ -z ${version} ]; then
    >&2 echo "ERROR: no version provided"
    exit 1
fi
if [ -z ${obs_id} ]; then
    >&2 echo "ERROR: no obs ID provided"
    exit 1
fi
if [ -z ${image_window_name} ]; then
    image_window_name=0
fi
if [ -z ${refresh_ps} ]; then
    refresh_ps=0
fi
if [ -z ${uvf_input} ]; then
    uvf_input=0
fi

#strip the last / if present in output directory filepath
outdir=${outdir%/}
s3_path=${s3_path%/}

#create output directory with full permissions
if [ -d "$outdir" ]; then
    sudo chmod -R 777 $outdir
else
    sudo mkdir -m 777 $outdir
fi

# Check that the FHD outputs exist on S3
fhd_exists=$(aws s3 ls ${s3_path}/fhd_${version})
if [ -z "$fhd_exists" ]; then
    >&2 echo "ERROR: FHD outputs not found"
    echo "Job Failed"
    exit 1
fi

# Copy FHD job from S3
aws s3 cp ${s3_path}/fhd_${version}/ ${outdir}/fhd_${version}/ --recursive \
--exclude "*" --include "*${obs_id}*" --quiet

# Create ps directory with full permissions if it doesn't exist
if [ -d "${outdir}/fhd_${version}/ps" ]; then
    sudo chmod -R 777 ${outdir}/fhd_${version}/ps
else
    sudo mkdir -m 777 ${outdir}/fhd_${version}/ps
fi

# Run backup script in the background
eppsilon_on_aws_backup.sh $outdir $s3_path $version $JOB_ID $myip &

# Run eppsilon
idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS $nslots -e aws_ps_single_obs_job -args \
$obs_id $outdir $version $image_window_name $refresh_ps $uvf_input || :

if [ $? -eq 0 ]
then
    echo "Eppsilon Job Finished"
    error_mode=0
else
    echo "Job Failed"
    error_mode=1
fi

kill $(jobs -p) #kill epps_on_aws_backup.sh

# Move outputs to S3
i=1  #initialize counter
aws s3 mv ${outdir}/fhd_${version}/ps/ ${s3_path}/fhd_${version}/ps/ \
--recursive --exclude "*" --include "*${obs_id}*" --quiet
while [ $? -ne 0 ] && [ $i -lt 10 ]; do
    let "i += 1"  #increment counter
    >&2 echo "Moving eppsilon outputs to S3 failed. Retrying (attempt $i)."
    aws s3 mv ${outdir}/fhd_${version}/ps/ ${s3_path}/fhd_${version}/ps/ \
    --recursive --exclude "*" --include "*${obs_id}*" --quiet
done

# Remove outputs from the instance
sudo rm -r ${outdir}/fhd_${version}

echo "JOB END TIME" `date +"%Y-%m-%d_%H:%M:%S"`

# Copy gridengine stdout to S3
aws s3 cp ~/grid_out/eppsilon_single_obs_job_aws.sh.o${JOB_ID} \
${s3_path}/fhd_${version}/grid_out/eppsilon_single_obs_job_aws.sh.o${JOB_ID}_${myip}.txt \
--quiet

# Copy gridengine stderr to S3
aws s3 cp ~/grid_out/eppsilon_single_obs_job_aws.sh.e${JOB_ID} \
${s3_path}/fhd_${version}/grid_out/eppsilon_single_obs_job_aws.sh.e${JOB_ID}_${myip}.txt \
--quiet

exit $error_mode

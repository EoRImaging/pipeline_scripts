#! /bin/bash

# Parse arguments
outdir=$1
s3_path=$2
version=$3
JOB_ID=$4
myip=$5

i=0
while true; do

    if [ -z $(curl -Is http://169.254.169.254/latest/meta-data/spot/termination-time | head -1 | grep 404 | cut -d \  -f 2) ]; then
        echo "Spot instance termination notice sent. Preparing to shut down."
        >&2 echo "Spot instance termination. Shutting down."

        # Copy gridengine stdout to S3
        aws s3 cp ~/grid_out/fhd_job_aws.sh.o${JOB_ID} \
        ${s3_path}/fhd_${version}/grid_out/\
        fhd_job_aws.sh.o${JOB_ID}_${myip}.txt --quiet

        # Copy gridengine stderr to S3
        aws s3 cp ~/grid_out/fhd_job_aws.sh.e${JOB_ID} \
        ${s3_path}/fhd_${version}/grid_out/\
        fhd_job_aws.sh.e${JOB_ID}_${myip}.txt --quiet

        # Copy FHD outputs to S3
        j=1  #initialize counter
        aws s3 sync ${outdir}/fhd_${version}/ \
        ${s3_path}/fhd_${version}/ --exclude "*" --include "*${obs_id}*" \
        --quiet
        while [ $? -ne 0 ] && [ $j -lt 10 ]; do
            let "j += 1"  #increment counter
            >&2 echo "Moving FHD outputs to S3 failed. Retrying (attempt $j)."
            aws s3 sync ${outdir}/fhd_${version}/ \
            ${s3_path}/fhd_${version}/ --exclude "*" --include "*${obs_id}*" \
            --quiet
        done

        exit 0
    fi

    if [ $i -eq 720 ]; then # Back up every hour
        echo "Backup to S3: " `date +"%Y-%m-%d_%H:%M:%S"`

        j=1  #initialize counter
        aws s3 sync ${outdir}/fhd_${version}/ \
        ${s3_path}/fhd_${version}/ --exclude "*" --include "*${obs_id}*" \
        --quiet
        while [ $? -ne 0 ] && [ $j -lt 6 ]; do
            let "j += 1"  #increment counter
            >&2 echo "Backing up FHD outputs to S3 failed. Retrying (attempt $j). Timestamp " `date +"%Y-%m-%d_%H:%M:%S"`
            aws s3 sync ${outdir}/fhd_${version}/ \
            ${s3_path}/fhd_${version}/ --exclude "*" --include "*${obs_id}*" \
            --quiet
        done

        i=0
    fi

    i=$((i+1))
    sleep 5 # Check instance termination status every 5 seconds
done

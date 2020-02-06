#! /bin/bash

# Parse arguments
obs_id=$1
outdir=$2
version=$3
JOB_ID=$4
myip=$5

echo 'RAM usage (MB):' > ${outdir}/fhd_${version}/metadata/${obs_id}_ram_usage_${JOB_ID}_${myip}.txt
while true; do
    date >> ${outdir}/fhd_${version}/metadata/${obs_id}_ram_usage_${JOB_ID}_${myip}.txt
    awk '/Mem:/ {print $3}' <(free -m) >> ${outdir}/fhd_${version}/metadata/${obs_id}_ram_usage_${JOB_ID}_${myip}.txt
    sleep 60 # Record RAM usage every 60 seconds
done

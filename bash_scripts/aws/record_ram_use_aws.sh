#! /bin/bash

# Parse arguments
outdir=$1
version=$2
JOB_ID=$3
myip=$4

while true; do
    date >> ${outdir}/fhd_${version}/metadata/ram_usage_${JOB_ID}_${myip}.txt
    awk '/Mem:/ {print $3}' <(free -m) >> ${outdir}/fhd_${version}/metadata/ram_usage_${JOB_ID}_${myip}.txt
    sleep 60 # Record RAM usage every 60 seconds
done

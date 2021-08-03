#!/bin/sh
#PBS -t 0-10%2

echo "JOB START TIME" `date +"%Y-%m-%d_%H:%M:%S"`

echo "Processing"

echo $IDL_PATH
source ~/.bashrc
echo $IDL_PATH
echo "Array ID:"
echo ${PBS_ARRAYID}

echo "------ ARGS ------"
echo "obs_file: ${obs_file_name}"
echo "outdir: ${outdir}"
echo "version_str: ${version_str}"
echo "band: ${band}"
echo "exants file: ${exants}"

python /lustre/aoc/projects/hera/dstorer/Projects/scripts/IDLscripts/sampleFHDscripts/run_fhd_h4c_arrayJob.py ${obs_file_name} ${outdir} ${version_str} ${PBS_ARRAYID} ${band} ${exants}

echo "JOB END TIME" `date +"%Y-%m-%d_%H:%M:%S"`

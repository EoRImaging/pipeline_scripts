#!/bin/bash

while getopts ":f:o:v:b:a:" option
do
  case $option in
    # A text file where each line is an obsid
    f) obs_file_name="$OPTARG";;
    # The output directory for the error log
    o) outdir="$OPTARG";;
    # The run version
    v) version_str=$OPTARG;;
    # The frequency band to run on - can be: 'low','mid','high', or 'full'
    b) band=$OPTARG;;
    # A yml file containing a list of flagged antennas
    a) exants=$OPTARG;;
    \?) echo "Unknown option: Accepted flags are -f (obs_file_name),"
        exit 1;;
    :) echo "Missing option argument for input flag"
       exit 1;;
  esac
done
#t=${obs_file_name:54:-4}

qsub -v obs_file_name=${obs_file_name},outdir=${outdir},version_str=${version_str},band=${band},exants=${exants} -j oe -o ${outdir}/FHD_${band}.out -l nodes=1:ppn=1 -l mem=64G -l vmem=64G -N FHD_cal_${band} -q hera /lustre/aoc/projects/hera/dstorer/Projects/scripts/IDLscripts/sampleFHDscripts/wrapper2_arrayJob.sh 

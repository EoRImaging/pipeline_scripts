#!/bin/bash

while getopts ":f:o:b:v:n:q:p:t:c:a:m:" option
do
  case $option in
    f) export obs_file_name="$OPTARG";;
    o) export outdir=$OPTARG;;
    b) export ssins_output_az_path=$OPTARG;;
    v) export uvfits_output_az_path=$OPTARG;;
    n) nslots=$OPTARG;;
    q) partition=$OPTARG;;
    p) export input_az_loc=$OPTARG;;
    t) export input_type=$OPTARG;;
    c) export correct=$OPTARG;;
    a) export freq_avg=$OPTARG;;
    m) export time_avg=$OPTARG;;
    \?) echo "Unknown option: Accepted flags are -f (obs_file_name), -o (output directory), "
        echo "-b (ssins output container on az), -v (uvfits output container on az), "
        echo "-n (number of nodes to use), -q (slurm partition: hpc or htc)"
        echo "-p (path to input files on az), -t (type of input file), -c (whether to correct digital things)"
        echo "-a (number of frequency channels to average) -m (number of times to average)"
        exit 1;;
    :) echo "Missing option argument for input flag"
       exit 1;;
  esac
done

# Manual shift to the next flag.
shift $(($OPTIND - 1))

# Throw error if no obs_id file.
if [ -z ${obs_file_name} ]; then
   echo "Need to specify a full filepath to a list of viable observation ids."
   exit 1
fi

# Set default output directory if one is not supplied and update user
if [ -z ${outdir} ];
then
    export outdir=SSINS_output
    echo Using default output directory: $outdir
else
    # strip the last / if present in output directory filepath
    export outdir=${outdir%/}
    echo Using output directory: $outdir
fi

if [ -z ${input_type} ]; then
  export input_type=uvfits
elif [[ ${input_type} != "uvfits" && ${input_type} != "gpubox" ]]; then
  echo "${input_type} is not a valid input type. Valid options are 'uvfits' or 'gpubox'"
  exit 1
fi

if [ -z ${input_az_loc} ]; then
  if [ ${input_type} == "uvfits" ]; then
    export input_az_loc=https://mwadata.blob.core.windows.net/uvfits/2013
    echo Using default input_az_loc: $input_az_loc
  else
    export input_az_loc=https://mwadata.blob.core.windows.net/gpubox/2013
    echo Using default input_az_loc: $input_az_loc
  fi
else
    # strip the last / if present in uvfits filepath
    export input_az_loc=${input_az_loc%/}
    echo Using input_az_loc: $input_az_loc
fi

if [ -z ${ssins_output_az_path} ]
then
    export ssins_output_az_path=https://mwadata.blob.core.windows.net/ssins/2013
    echo Using default az location: $ssins_output_az_path
else
    # strip the last / if present in output directory filepath
    export ssins_output_az_path=${ssins_output_az_path%/}
    echo Using az bucket: $ssins_output_az_path
fi

if [ -z ${uvfits_output_az_path} ]
then
    export uvfits_output_az_path=https://mwadata.blob.core.windows.net/uvfits/2013
    echo Using default az location: $uvfits_output_az_path
else
    # strip the last / if present in output directory filepath
    export uvfits_output_az_path=${uvfits_output_az_path%/}
    echo Using az bucket: $uvfits_output_az_path
fi

if [ -z $correct ]; then
  export correct=0
  echo Using default correct: $correct
else
  export correct=1
  echo Using correct: $correct
fi

if [ -z $freq_avg ]; then
  export freq_avg=0
  echo Using default freq_avg: $freq_avg
else
  echo Using freq_avg: $freq_avg
fi

if [ -z $time_avg ]; then
  export time_avg=0
  echo Using default time_avg: $time_avg
else
  echo Using time_avg: $time_avg
fi

# Make log directory if it doesn't already exist
if [ ! -d ~/logs ]; then
    sudo mkdir -m 777 ~/logs
fi
logdir=~/logs

# Set number of CPUs per job. nslots per node is half the number of vCPUs per node.
# That is, to use a full 32 vCPU node, set nslots=16
if [ -z ${nslots} ]; then
    nslots=16
fi

# Set default partition
if [ -z ${partition} ]; then
    partition=hpc
elif [[ ${partition} != "hpc" && ${input_type} != "htc" ]]; then
  echo "${partition} is not a valid input type. Valid options are 'hpc' or 'htc'"
  exit 1
fi

N_obs=$(wc -l < $obs_file_name)
echo "processing ${N_obs} observations"

sbatch -D /mnt/scratch -c ${nslots} -p ${partition} -e ${logdir}/SSINS_job_az.sh.e%A.%a -o ${logdir}/SSINS_job_az.sh.o%A.%a -a 1-${N_obs} SSINS_job_az.sh

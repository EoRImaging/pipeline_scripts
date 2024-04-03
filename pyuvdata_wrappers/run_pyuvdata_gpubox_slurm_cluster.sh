#!/bin/bash

while getopts ":f:o:d:s:pgbvcxe:a:t:u:k:z:w:n:q:" option
do
  case $option in
    f) export obs_file_name="$OPTARG";;
    o) export output_dir=$OPTARG;;
    d) export data_dir=$OPTARG;;
    s) export ssins_dir=$OPTARG;;
    p) export phase='true';;
    g) export gains='true';;
    b) export bandpass='true';;
    v) export vanvleck='true';;
    c) export dc_flags='true';;
    x) export edge_flags='true';;
    e) export edge_flags=$OPTARG;;
    a) export freq_avg=$OPTARG;;
    t) export time_avg=$OPTARG;;
    u) export output_format=$OPTARG;;
    k) export select=$OPTARG;;
    z) job_script=$OPTARG;;
    w) working_dir=$OPTARG;;
    n) nslots=$OPTARG;;
    q) partition=$OPTARG;;
    \?) echo "Unknown option: Accepted flags are -f (obs_file_name), -o (output directory), "
        echo "-d (directory for input files), -s (directory for ssins file),  "
        echo "-p (option to phase to pointing center), -g (option to remove digital gains), "
        echo "-b (option to remove pfb bandpass shape), -v (option to apply van vleck corrections), "
	echo "-c (option to flag dc channels), -e (number of hz to flag at the edge of each coarse channel), "
	echo "-a (number of frequency channels to average), -t (number of times to average), "
        echo "-u (format of output file (must be 'uvfits', 'uvh5', 'ms', 'mir')), "
	echo "-k (visibilities to select (must be 'autos' or 'crosses'), "
	echo "-z (job script to run), -w (compute working directory),  -n (number of cpus to use), "
	echo "-q (slurm partition to use), -x (option to flag zeroeth fine channel of each coarse channel)"
	exit 1;;
    :) echo "Missing option argument for input flag"
       exit 1;;
  esac
done

# Manual shift to the next flag.
shift $(($OPTIND - 1))

# Throw errors if no obs_id file, output directory, input directory, output format, or job script.
if [ -z ${obs_file_name} ]; then
   echo "Need to specify a full filepath to a list of viable observation ids."
   exit 1
else
    echo ${obs_file_name}
fi

if [ -z ${output_dir} ]; then
   echo "Need to specify a directory to move outputs to"
   exit 1
else
  export output_dir=${output_dir%/}
fi

if [ -z ${data_dir} ]; then
   echo "Need to specify a path to input data files"
   exit 1
else
   export data_dir=${data_dir%/}
fi

if [ -z ${output_format} ]; then
   echo "Need to specify an output file format"
   exit 1
elif [[ ${output_format} != "uvfits" && ${output_format} != "h5py" && ${output_format} != "ms" && ${output_format} != "mir" ]]; then
   echo "output file format must be 'uvfits', 'uvh5', 'ms', or 'mir'"
   exit 1
fi

if [ -z ${job_script} ]; then
   echo "Need to specify a slurm job script to run"
   exit 1
fi

arg_string="-d output_files -f ${output_format}"

if [ ! -z ${ssins_dir} ]; then
    arg_string="${arg_string} -s ssins"
    export ssins_dir=${ssins_dir%/}
    echo "applying ssins flags"
fi

if [ ! -z ${phase} ]; then
    arg_string="${arg_string} -p"
    echo "phasing data"
fi

if [ ! -z ${edge_flags} ]; then
    arg_string="${arg_string} -e ${edge_flags}"
    echo "flagging ${edge_flags} Hz at coarse channel edges"
fi

if [ ! -z ${time_avg} ]; then
    arg_string="${arg_string} -t ${time_avg}"
    echo "avereging in time by ${time_avg}"
fi

if [ ! -z ${freq_avg} ]; then
    arg_string="${arg_string} -a ${freq_avg}"
    echo "averaging in frequency by ${freq_avg}"
fi

if [ ! -z $gains ]; then
    arg_string="${arg_string} -g"
    echo "removing digital gains"
fi

if [ ! -z $bandpass ]; then
    arg_string="${arg_string} -b"
    echo "removing polyphase filter bank bandpass"
fi

if [ ! -z $dc_flags ]; then
    arg_string="${arg_string} -c"
    echo "flagging dc channels"
fi

if [ ! -z $flag_zero ]; then
    arg_string="${arg_string} -x"
    echo "flagging zeroeth fine channels"
fi

if [ ! -z $vanvleck ]; then
    arg_string="${arg_string} -v"
    echo "applying van vleck correction"
fi

if [ ! -z ${select} ]; then
    if [[ ${select} != "autos" && ${select} != "crosses" ]]; then
        echo "select must be 'autos' or 'crosses'"
        exit 1
    fi
    arg_string="${arg_string} -k ${select}"
    echo "selecting ${select}"
fi

echo "running pyuvdata with arg string ${arg_string}"
export arg_string=${arg_string}

# Make log directory if it doesn't already exist
if [ ! -d ~/logs ]; then
    sudo mkdir -m 777 ~/logs
fi
logdir=~/logs

# Set default number of CPUs per job
if [ -z ${nslots} ]; then
    nslots=16
fi

slurm_string=""
if [ ! -z ${partition} ]; then
    slurm_string="${slurm_string} -p ${partition}"
fi

if [ ! -z ${working_dir} ]; then
    slurm_string="${slurm_string} -D ${working_dir}"
fi

echo "running with slurm string ${slurm_string}"

N_obs=$(wc -l < $obs_file_name)
echo "processing ${N_obs} observations"

sbatch ${slurm_string} -c ${nslots} -e ${logdir}/%x.e%A.%a -o ${logdir}/%x.o%A.%a -a 1-${N_obs} ${job_script}

#!/bin/bash

################################################################################
# This wrapper submits some jobs on azure that download some zipped box files  #
# as would be obtained from ASVO, unzips them, and sends them back to storage. #
################################################################################

# Clear input parameters
unset obs_file_name
unset starting_obs
unset ending_obs
unset outdir

# # # # # # # Gathering the input arguments and applying defaults if necessary

# Parse flags for inputs
while getopts ":f:s:e:o:b:m:n:p:q:w:" option
do
  case $option in
    f) export obs_file_name="$OPTARG";; # text file of observation id's
    s) starting_obs=$OPTARG;; # starting observation in text file for choosing a range
    e) ending_obs=$OPTARG;; # ending observation in text file for choosing a range
    o) export outdir=$OPTARG;; # output directory for unzipping
    b) export az_path=$OPTARG;; # output bucket on azure
    m) export metafits_az_path=$OPTARG;; # output bucket for metafits files
    n) export nslots=$OPTARG;; # Number of slots for slurm
    p) export zip_az_loc=$OPTARG;; # Path to zipped files on azure
    q) partition=$OPTARG;; # Compute node partition
    w) export temp_obs_file=$OPTARG;; # Temporary obs_id file used if starting_obs or ending_obs is set
    \?) echo "Unknown option: Accepted flags are -f (obs_file_name), -s (starting_obs), -e (ending obs),"
        echo "-o (output directory), -b (output bucket on azure),  -n (number of slots to use), "
        echo "-p (path to zip files on azure), -q (compute partition), -w (temporary obs_id file)"
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

# Throw error if no az_path set
if [ -z ${az_path} ]; then
    echo "Need to specify an az storage url for outputs."
    exit 1
else
    # strip the last / if present in output directory filepath
    export az_path=${az_path%/}
    echo Using azure container: $az_path
fi

# Throw error if no metafits_az_path set
if [ -z ${metafits_az_path} ]; then
    echo "Need to specify an az storage url for metafits outputs."
    exit 1
else
    # strip the last / if present in output directory filepath
    export metafits_az_path=${metafits_az_path%/}
    echo Using metafits azure container: $metafits_az_path
fi

# Set default output directory if one is not supplied and update user
if [ -z ${outdir} ]
then
    export outdir=vis_output
    echo Using default output directory: $outdir
else
    # strip the last / if present in output directory filepath
    export outdir=${outdir%/}
    echo Using output directory: $outdir
fi

if [ -z ${zip_az_loc} ]; then
  echo "Need to specify an az storage url for inputs."
  exit 1
else
    # strip the last / if present in zip filepath
    export zip_az_loc=${zip_az_loc%/}
    echo Using zip_az_loc: $zip_az_loc
fi

# Use enough slots that it isn't dreadfully slow.
if [ -z ${nslots} ]; then
    export nslots=4
fi

# Set default partition
if [ -z ${partition} ]; then
    partition=htc
elif [[ ${partition} != "hpc" && ${partition} != "htc" ]]; then
  echo "${partition} is not a valid input type. Valid options are 'hpc' or 'htc'"
  exit 1
fi

# If starting_obs or ending_obs is set, write out subset of obs_ids into temp_obs_file
if [[ ! -z ${starting_obs} || ! -z ${ending_obs} ]]; then
    if [ ! -z $non_integer_obs ]; then
        echo "unable to process subset of obs_ids with non-integer obs"
        exit 1
    fi
    if [ -z ${temp_obs_file} ]; then
        export temp_obs_file=~/temp_obs_file.txt
        echo Using default temp_obs_file: $temp_obs_file
    else
        echo Using temp_obs_file: $temp_obs_file
    fi
    # Read the obs file and put into an array, skipping blank lines if they exist
    i=0
    while read line
    do
       if [ ! -z "$line" ]; then
          obs_id_array[$i]=$line
          i=$((i + 1))
       fi
    done < "$obs_file_name"

    # Find the max and min of the obs id array
    max=${obs_id_array[0]}
    min=${obs_id_array[0]}

    for obs_id in "${obs_id_array[@]}"
    do
       # Update max if applicable
       if [[ "$obs_id" -gt "$max" ]]
       then
    	    max="$obs_id"
       fi

       # Update min if applicable
       if [[ "$obs_id" -lt "$min" ]]
       then
 	    min="$obs_id"
       fi
    done

    # If minimum not specified, start at minimum of obs_file
    if [ -z ${starting_obs} ]
    then
        starting_obs=$min
        echo "Starting observation not specified. Starting at minimum of $obs_file_name: $starting_obs"
    else
        echo Starting on observation: $starting_obs
    fi

    # If maximum not specified, end at maximum of obs_file
    if [ -z ${ending_obs} ]
    then
        ending_obs=$max
        echo "Ending observation not specified. Ending at maximum of $obs_file_name: $ending_obs"
    else
        echo Ending on observation: $ending_obs
    fi

    # Create a list of observations using the specified range
    unset good_obs_list
    for obs_id in "${obs_id_array[@]}"; do
        if [ $obs_id -ge $starting_obs ] && [ $obs_id -le $ending_obs ]; then
        echo $obs_id
	    good_obs_list+=($obs_id)
        fi
    done
    # Write list to temp_obs_file
    printf "%s\n" "${good_obs_list[@]}" > ${temp_obs_file}
    unset obs_file_name
    export obs_file_name=${temp_obs_file}
else
    echo Starting at observation at beginning of file $obs_file_name
    echo Ending at observation at end of file $obs_file_name
fi

# Make log directory if it doesn't already exist
if [ ! -d ~/logs ]; then
    sudo mkdir -m 777 ~/logs
fi
logdir=~/logs

N_obs=$(wc -l < $obs_file_name)
echo "processing ${N_obs} observations"

# # # # # # # End of gathering the input arguments and applying defaults if necessary

# # # # # # # Submit the unzip jobs and wait for output

sbatch -D /mnt/scratch -c ${nslots} -p ${partition} -e ${logdir}/unzip_job_az.sh.e%A.%a -o ${logdir}/unzip_job_az.sh.o%A.%a -a 1-${N_obs} unzip_job_az.sh

#!/bin/bash

# Clear input parameters
unset obs_file_name
unset starting_obs
unset ending_obs
unset outdir
unset version

# # # # # # # Gathering the input arguments and applying defaults if necessary

# Parse flags for inputs
while getopts ":f:s:e:o:b:v:n:r:d:u:p:m:i:j:k:c:t:a:q:w:" option
do
   case $option in
    f) obs_file_name="$OPTARG";; # text file of observation id's
    s) starting_obs=$OPTARG;; # starting observation in text file for choosing a range
    e) ending_obs=$OPTARG;; # ending observation in text file for choosing a range
    o) export outdir=$OPTARG;; # output directory for FHD
    b) export az_path=$OPTARG;; # output bucket on azure
    v) export version=$OPTARG;; # FHD folder name and case
		# Example: nb_foo creates folder named fhd_nb_foo
    n) export nslots=$OPTARG;; # Number of slots for grid engine
    u) export versions_script=$OPTARG;; # Versions script: default fhd_versions_rlb
    p) export uvfits_az_loc=$OPTARG;; # Path to uvfits files on azure
    m) export metafits_az_loc=$OPTARG;; # Path to metafits files on azure
    r) export run_ps=$OPTARG;; # Run eppsilon PS code (on individual obs)
    d) export ps_uvf_input=$OPTARG;; # Use UVF input for PS (only used if run_ps=1)
    i) export input_vis=$OPTARG;; # Optional input visibilities for in situ sim
    j) export input_eor=$OPTARG;; # Optional input eor sim for in situ sim
    k) export extra_vis=$OPTARG;; # Optional additional visibilities for in situ sim (e.g. RFI visibilities)
    c) export cal_transfer=$OPTARG;; # Option to transfer calibration solutions from another run
    t) export model_uv_transfer=$OPTARG;; # Option to transfer model_uv_arr.sav from a calibration pre-run
    a) non_integer_obs=$OPTARG;; # Specify that obsids are not integers - cannot sort.
    q) partition=$OPTARG;; # Compute partition
    w) export temp_obs_file=$OPTARG;; # Temporary obs_id file
    \?) echo "Unknown option: Accepted flags are -f (obs_file_name), -s (starting_obs), -e (ending obs), -o (output directory), "
        echo "-b (output bucket on azure), -v (version input for FHD),  -n (number of slots to use), "
        echo "-u (versions script), -p (path to uvfits files on azure), -m (path to metafits files on azure), "
        echo "-r (option to run eppsilon on each obs), -d (option to use UVF input for eppsilon run), "
        echo "-i (visibilities for in situ sim), -j (EoR sim), "
        echo "-k (extra visibilities to add to simulation visibilities), -c (calibration save files to transfer), "
        echo "-t (model_uv_arr.sav files to transfer from precalibration run), -a (indicate that obsids are not integers), "
        echo "-q (compute partition), -w (temporary obs_id file)"
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

# Update the user on which obsids will run given the inputs
if [ -z ${starting_obs} ]
then
    echo Starting at observation at beginning of file $obs_file_name
else
    echo Starting on observation $starting_obs
fi

if [ -z ${ending_obs} ]
then
    echo Ending at observation at end of file $obs_file_name
else
    echo Ending on observation $ending_obs
fi

# Set default output directory if one is not supplied and update user
if [ -z ${outdir} ]
then
    export outdir=/FHD_output
    echo Using default output directory: $outdir
else
    # strip the last / if present in output directory filepath
    export outdir=${outdir%/}
    echo Using output directory: $outdir
fi

if [ -z ${uvfits_az_loc} ]; then
    export uvfits_az_loc=https://mwadata.blob.core.windows.net/uvfits/2013
else
    # strip the last / if present in uvfits filepath
    export uvfits_az_loc=${uvfits_az_loc%/}
fi

if [ -z ${metafits_az_loc} ]; then
    export metafits_az_loc=https://mwadata.blob.core.windows.net/metafits/2013
else
    # strip the last / if present in metafits filepath
    export metafits_az_loc=${metafits_az_loc%/}
fi

if [ -z ${az_path} ]
then
    export az_path=https://mwadata.blob.core.windows.net/fhd_outputs/2013
    echo Using default azure location: $az_path
else
    # strip the last / if present in output directory filepath
    export az_path=${az_path%/}
    echo Using azure container: $az_path
fi

if [ ! -z ${cal_transfer} ]; then
    # strip the last / if present in cal transfer filepath
    export cal_transfer=${cal_transfer%/}
    echo Transferring calibration from $cal_transfer
fi

if [ ! -z ${model_uv_transfer} ]; then
    # strip the last / if present in cal transfer filepath
    export model_uv_transfer=${model_uv_transfer%/}
    echo Transferring calibration from $model_uv_transfer
fi

# Make log directory if it doesn't already exist
if [ ! -d ~/logs ]; then
    sudo mkdir -m 777 ~/logs
fi
logdir=~/logs

if [ -z ${version} ]; then
   echo Please specify a version, e.g, yourinitials_test
   exit 1
fi

if [ -z ${versions_script} ]; then
    export versions_script='fhd_versions_rlb'
fi

# Set typical slots needed for standard FHD firstpass if not set.
if [ -z ${nslots} ]; then
    export nslots=10
fi

if [ -z ${run_ps} ]; then
    export run_ps=0
fi

if [ -z ${ps_uvf_input} ]; then
    export ps_uvf_input=0
fi

if [ -z $non_integer_obs ]; then
    non_integer_obs=0
fi

if [ -z ${partition} ]; then
    partition=hpc
elif [[ ${partition} != "hpc" && ${partition} != "htc" ]]; then
  echo "${partition} is not a valid input type. Valid options are 'hpc' or 'htc'"
  exit 1
fi

if [ -z ${temp_obs_file} ]; then
    export temp_obs_file=~/temp_obs_file.txt
    echo "Using temp obs file ${temp_obs_file}"
fi
# Make directory if it doesn't already exist
sudo mkdir -p -m 777 ${outdir}/fhd_${version}/logs
echo Output located at ${outdir}/fhd_${version}

# If starting_obs or ending_obs is set, write out subset of obs_ids into temp_obs_file
if [[ ! -z ${starting_obs} || ! -z ${ending_obs} ]]; then
    if [ $non_integer_obs -eq 1 ]; then
        echo "unable to process subset of obs_ids with non-integer obs"
        exit 1
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
       echo "Starting observation not specified: Starting at minimum of $obs_file_name"
       starting_obs=$min
    fi

    # If maximum not specified, end at maximum of obs_file
    if [ -z ${ending_obs} ]
    then
       echo "Ending observation not specified: Ending at maximum of $obs_file_name"
       ending_obs=$max
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
fi

N_obs=$(wc -l < $obs_file_name)
echo "processing ${N_obs} observations"

# # # # # # # End of gathering the input arguments and applying defaults if necessary

# # # # # # # Submit the firstpass jobs and wait for output

sbatch -D /mnt/scratch -c ${nslots} -p ${partition} -e ${logdir}/fhd_job_az.sh.e%A.%a -o ${logdir}/fhd_job_az.sh.o%A.%a -a 1-${N_obs} fhd_job_az.sh

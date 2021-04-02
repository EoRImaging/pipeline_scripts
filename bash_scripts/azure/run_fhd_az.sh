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
    f) export obs_file_name="$OPTARG";; # text file of observation id's
    s) starting_obs=$OPTARG;; # starting observation in text file for choosing a range
    e) ending_obs=$OPTARG;; # ending observation in text file for choosing a range
    o) export outdir=$OPTARG;; # output directory for FHD
    b) export az_path=$OPTARG;; # output bucket on azure
    v) export version=$OPTARG;; # FHD folder name and case
		# Example: nb_foo creates folder named fhd_nb_foo
    n) export nslots=$OPTARG;; # Number of slots for slurm
    u) export versions_script=$OPTARG;; # Versions script: default fhd_versions_rlb
    p) export uvfits_az_loc=$OPTARG;; # Path to uvfits files on azure
    m) export metafits_az_loc=$OPTARG;; # Path to metafits files on azure
    r) export run_ps=$OPTARG;; # Flag to run eppsilon PS code (on individual obs)
    d) export ps_uvf_input=$OPTARG;; # Flag to use UVF input for PS (only used if run_ps=1)
    i) export input_vis=$OPTARG;; # Path to optional input visibilities for in situ sim
    j) export input_eor=$OPTARG;; # Path to optional input eor sim for in situ sim
    k) export extra_vis=$OPTARG;; # Path to optional additional visibilities for in situ sim (e.g. RFI visibilities)
    c) export cal_transfer=$OPTARG;; # Path to transfer calibration solutions from another run
    t) export model_uv_transfer=$OPTARG;; # Path to transfer model_uv_arr.sav from a calibration pre-run
    a) non_integer_obs=$OPTARG;; # Flag to specify that obsids are not integers - cannot sort.
    q) partition=$OPTARG;; # Compute node partition
    w) export temp_obs_file=$OPTARG;; # Temporary obs_id file used if starting_obs or ending_obs is set
    \?) echo "Unknown option: Accepted flags are -f (obs_file_name), -s (starting_obs), -e (ending obs), -o (output directory), "
        echo "-b (output bucket on azure), -v (version input for FHD),  -n (number of slots to use), "
        echo "-u (versions script), -p (path to uvfits files on azure), -m (path to metafits files on azure), "
        echo "-r (flag to run eppsilon on each obs), -d (flag to use UVF input for eppsilon run), "
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

# Throw error if no az_path set
if [ -z ${az_path} ]; then
    echo "Need to specify an az storage url for outputs."
    exit 1
else
    # strip the last / if present in output directory filepath
    export az_path=${az_path%/}
    echo Using azure container: $az_path
fi

# Throw error if no version set
if [ -z ${version} ]; then
    echo Please specify a version, e.g, yourinitials_test
    exit 1
else
    echo Using version: $version
fi

# Set default versions script
if [ -z ${versions_script} ]; then
    echo Need to specify a versions script.
    exit 1
else
    echo Using versions_script: $versions_script
fi

# Set default output directory if one is not supplied and update user
if [ -z ${outdir} ]
then
    export outdir=FHD_output
    echo Using default output directory: $outdir
else
    # strip the last / if present in output directory filepath
    export outdir=${outdir%/}
    echo Using output directory: $outdir
fi

if [ -z ${uvfits_az_loc} ]; then
    export uvfits_az_loc=https://mwadata.blob.core.windows.net/uvfits/2013
    echo Using default uvfits_az_loc: $uvfits_az_loc
else
    # strip the last / if present in uvfits filepath
    export uvfits_az_loc=${uvfits_az_loc%/}
    echo Using uvfits_az_loc: $uvfits_az_loc
fi

if [ -z ${metafits_az_loc} ]; then
    export metafits_az_loc=https://mwadata.blob.core.windows.net/metafits/2013
    echo Using default metafits_az_loc: $metafits_az_loc
else
    # strip the last / if present in metafits filepath
    export metafits_az_loc=${metafits_az_loc%/}
    echo Using metafits_az_loc: $metafits_az_loc
fi

if [ ! -z ${cal_transfer} ]; then
    # strip the last / if present in cal transfer filepath
    export cal_transfer=${cal_transfer%/}
    echo Transferring calibration from $cal_transfer
fi

if [ ! -z ${model_uv_transfer} ]; then
    # strip the last / if present in model uv transfer filepath
    export model_uv_transfer=${model_uv_transfer%/}
    echo Transferring model_uv from $model_uv_transfer
fi

if [ ! -z ${input_vis} ]; then
    # strip the last / if present in input vis filepath
    export input_vis=$input_vis%/}
    echo Using input_vis: $input_vis
fi

if [ ! -z ${input_eor} ]; then
    # strip the last / if present in input eor filepath
    export input_eor=$input_eor%/}
    echo Using input_eor: $input_eor
fi

if [ ! -z ${extra_vis} ]; then
    # strip the last / if present in extra vis filepath
    export extra_vis=$extra_vis%/}
    echo Using extra_vis: $extra_vis
fi

if [ -z ${run_ps} ]; then
    export run_ps=0
else
    export run_ps=1
    echo Eppsilon power spectrum job will run after FHD
fi

if [ -z ${ps_uvf_input} ]; then
    export ps_uvf_input=0
elif [ $run_ps -eq 0 ]; then
    echo Cannot use ps_uvf_input unless run_ps is set
    exit 1
else
    export ps_uvf_input=1
fi
echo Using ps_uvf_input: $ps_uvf_input

# Set typical slots needed for standard FHD firstpass if not set.
if [ -z ${nslots} ]; then
    export nslots=8
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

# # # # # # # Submit the firstpass jobs and wait for output

sbatch -D /mnt/scratch -c ${nslots} -p ${partition} -e ${logdir}/fhd_job_az.sh.e%A.%a -o ${logdir}/fhd_job_az.sh.o%A.%a -a 1-${N_obs} fhd_job_az.sh

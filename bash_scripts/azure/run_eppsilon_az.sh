#!/bin/bash

######################################################################################
# Adapted from run_eppsilon_aws.sh
######################################################################################

#Parse flags for inputs
while getopts ":u:d:f:v:b:n:i:c:p:h:s:x:t:q:o:" option
do
   case $option in
        u) export versions_script=$OPTARG;;     # optional versions script; if not submitted az_ps_job will be used
        d) export file_path_cubes=$OPTARG;;			#file path to fhd directory on azure storage
        f) export integrate_list="$OPTARG";;		#txt file of obs ids or subcubes or a single obsid
        v) export cube_prefix=$OPTARG;;  # Name associated with resulting integration/eppsilon outputs. Not the FHD version.
        b) export version=$OPTARG;; # version from script
        n) export nslots=$OPTARG;;             	#Number of slots for grid engine
        i) int=$OPTARG;;           # Run FHD integration job
        c) cubes=$OPTARG;;         # Run eppsilon cube job
        p) ps=$OPTARG;;			# Run eppsilon power spectra job
        h) hold_job_id=$OPTARG;;             #Job_id for a job to finish before running. Useful when running immediately after firstpass
        s) export single_obs=$OPTARG;; # Working on a single obsid that has never seen integration.
        x) export pols=$OPTARG;; # String of space-separated pols
	t) export cube_types=$OPTARG;; # String of space-separated cube types
        q) partition=$OPTARG;; # Compute node partition
	o) force_single_obs=$OPTARG;; # Force single obs when doing integration
	\?) echo "Unknown option: Accepted flags are -d (file path to fhd directory on azure storage), -f (obs list or subcube path or single obsid), "
	          echo "-v (version), -n (number of slots), -i (integrate) -c (make 'weights', 'dirty', 'model' cubes) -p (make ps), "
		  echo "-h (job id to hold int/ps script for), -s (single obsid), -x (string of pols), -t (string of cube types), and -q (partition)"
		  echo "-o (force single obs integration)"
            exit 1;;
        :) echo "Missing option argument for input flag"
           exit 1;;
   esac
done

#Manual shift to the next flag
shift $(($OPTIND - 1))

#Error if no file path to FHD directory
if [ -z ${file_path_cubes} ]; then
   echo "Need to specify a file path to fhd directory on azure storage with cubes: Example /nfs/complicated_path/fhd_mine"
   exit 1
else
    # strip the last / if present in FHD directory path
    export file_path_cubes=${file_path_cubes%/}
    echo Using file_path_cubes: ${file_path_cubes}
fi

# Error if cube_prefix is not set
if [ -z ${cube_prefix} ]; then
    >&2 echo "Need to specify cube_prefix to associate with resulting integration/eppsilon outputs."
    exit 1
else
    echo Using cube_prefix: $cube_prefix
fi

# set default versions_script
if [ ! -z ${versions_script} ]; then
    if [ -z ${version} ]; then
        >&2 echo "Need to specify version if using versions_script."
        exit 1
    else
        echo Using version: $version
    fi
else
    versions_script=az_ps_job
fi
export versions_script=$versions_script
echo Using versions_script: $versions_script

# export versions_script=${versions_script}
# Set default single_obs
if [ -z ${single_obs} ]; then
    export single_obs=0
else
    export single_obs=1
fi
echo Using single_obs: $single_obs

# Set default to not force single obs integration
if [ -z ${force_single_obs} ]; then
    force_single_obs=0
elif [ ${force_single_obs} -ne 0 ]; then
    force_single_obs=1
fi

#Set default to do integration
if [ -z ${int} ]; then
    int=1
fi
# Run checks if doing an integration job.
if [ ${int} -eq 1 ]; then
    #Error if integrate_list is not set
    if [ -z ${integrate_list} ]; then
        echo "Need to specify obs list file path or preintegrated subcubes list file path with option -f"
        exit 1
    fi
    # Error if single_obs==1
    if [ ${single_obs} -eq 1 ] && [ $force_single_obs -eq 0 ]; then
        >&2 echo "It does not make sense to integrate a single observation. Run without integration or without single_obs"
        exit 1
    fi
    #Error if integrate list filename does not exist
    if [ ! -e "$integrate_list" ]; then
        >&2 echo "Integrate list file does not exist!"
        exit 1
    else
        export n_obs=$(wc -l < ${integrate_list})
        # Error if > 20 cubes are submitted
        if [ $n_obs -gt 20 ]; then
            >&2 echo "Integration list list must contain 20 or fewer cube prefixes. Resubmit with a shorter list."
            exit 1
        fi
        # Error if a single cube is submitted
        if [ $n_obs -eq 1 ] && [ $force_single_obs -eq 0  ]; then
            >&2 echo "It does not make sense to integrate a single cube. Submit a longer text file."
            exit 1
        fi
        export int_list_path=${integrate_list}
        echo "Number of cubes to integrate: ${n_obs}"
    fi
fi

#Set default to make cubes with eppsilon
if [ -z ${cubes} ]; then
    cubes=1
fi

#Set default to make power spectrum with eppsilon
if [ -z ${ps} ]; then
    ps=1
fi

# Set default pols to XX and YY
if [ -z ${pols} ]; then
    export pols="XX YY"
    pol_arr=($pols)
else
    # Check that inputs are actually pols
    pol_arr=($pols)
    for i in ${pol_arr[@]}; do
        if [[ ${i^^} != XX && ${i^^} != YY ]]; then
            if [[ ${i^^} != XY && ${i^^} != YX ]]; then
                echo "pol string must have form 'xx xy' or 'XX XY' "
                exit 1
            fi
        fi
    done
fi
# Get number of pols for job array
export n_pol=${#pol_arr[@]}

#Set typical slots needed for standard PS with obs ids if not set.
if [ -z ${nslots} ]; then
    export nslots=2
fi

# Set default partition to htc
if [ -z ${partition} ]; then
    partition=htc
elif [[ ${partition} != "hpc" && ${partition} != "htc" ]]; then
  echo "${partition} is not a valid input type. Valid options are 'hpc' or 'htc'"
  exit 1
fi

# Make log directory if it doesn't already exist
if [ ! -d ~/logs ]; then
    sudo mkdir -m 777 ~/logs
fi
logdir=~/logs

# Number of tasks for array job is n_pols*2 (each pol for each even and odd)
n_arr=$(($n_pol*2))

# Run integration job
if [ $int -eq 1 ]; then
    # create hold string
    if [ -z ${hold_job_id} ]; then
        hold_str=""
    else
        hold_str="-d afterok:${hold_job_id}"
        echo "Hold string is ${hold_str}"
    fi
    # Get job_id
    jid_int=$(sbatch ${hold_str} -D /mnt/scratch -c ${nslots} -p ${partition} -e ${logdir}/${cube_prefix}_integration_job_az.sh.e%A.%a -o ${logdir}/${cube_prefix}_integration_job_az.sh.o%A.%a -a 1-${n_arr} integration_job_az.sh)
    echo ${jid_int}
    echo "Submitting integration job"
    # Update hold string so that cube tasks wait on corresponding integration tasks
    # Currently, a single cube job in eppsilon requires that all evenodd/pol combos be present
    # If this is changed so that a cube job only needs the corresponding cube,
    # then can use 'hold_str="-d aftercorr:${jid_int##* }"'
    hold_str="-d afterok:${jid_int##* }"
    echo "String for holding until integration job tasks finish is '${hold_str}'"
fi

# Cube definitions
if [ -z ${cube_types} ]; then
	cube_type_arr=('weights' 'dirty' 'model')
else
	cube_type_arr=($cube_types)
fi

export n_cubes=${#cube_type_arr[@]}

# Run eppsilon cube job
if [ $cubes -eq 1 ]; then
    # create hold string
    if [ $int -eq 0 ]; then
        if [ -z ${hold_job_id} ]; then
            hold_str=""
        else
            hold_str="-d afterok:${hold_job_id}"
            echo "Hold string is ${hold_str}"
        fi
    fi
    cube_jobs=""
    for cube_type in "${cube_type_arr[@]}"; do
        echo "Submitting eppsilon ${cube_type} cube job"
        export cube_type=${cube_type}
        jid_cube=$(sbatch ${hold_str} -D /mnt/scratch -c ${nslots} -p ${partition} -e ${logdir}/${cube_prefix}_eppsilon_cube_job_az.sh.e%A.%a -o ${logdir}/${cube_prefix}_eppsilon_cube_job_az.sh.o%A.%a -a 1-${n_arr} eppsilon_job_az.sh)
        echo ${jid_cube}
        cube_jobs+=":${jid_cube##* }"
    done
    # Update hold string so that power spectrum job waits on all cube jobs
    hold_str="-d afterok${cube_jobs}"
    echo "String for holding until eppsilon cube jobs finish is '${hold_str}'"
fi

# Run eppsilon power spectrum job
if [ $ps -eq 1 ]; then
    # create hold string
    if [[ $int -eq 0 ]] && [[ $cubes -eq 0 ]]; then
        if [ -z ${hold_job_id} ]; then
            hold_str=""
        else
            hold_str="-d afterok:${hold_job_id}"
            echo "Hold string is ${hold_str}"
        fi
    fi
    echo "Submitting eppsilon ps job"
    unset cube_type
    sbatch ${hold_str} -D /mnt/scratch -c ${nslots} -p ${partition} -e ${logdir}/${cube_prefix}_eppsilon_ps_job_az.sh.e%A -o ${logdir}/${cube_prefix}_eppsilon_ps_job_az.sh.o%A eppsilon_job_az.sh
fi

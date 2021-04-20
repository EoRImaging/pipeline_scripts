#! /bin/bash

# Batch script for slurm job. Second level program for
# running integration on azure machines. First level program is run_eppsilon_az.sh
# Adapted from eppsilon_job_aws.sh

#inputs needed: file_path_cubes, obs_list_path, obs_list_array, version, nslots
#inputs optional: cube_type, pol, evenodd

# If cube_type is unset, do a power spectrum job. Otherwise, do a cube job.

echo JOBID ${SLURM_ARRAY_JOB_ID}
if [ ! -z ${cube_type} ]; then
    echo TASKID ${SLURM_ARRAY_TASK_ID}
fi
echo VERSION ${version}
echo "JOB START TIME" `date +"%Y-%m-%d_%H:%M:%S"`
myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo PUBLIC IP ${myip}

# If doing cube job, use task id to get index for even/odd and pol arrays
# These tasks might wait on corresponding tasks in integration_job_az.sh
# This code must be the same in both scripts for the tasks to correspond correctly
if [ ! -z ${cube_type} ]; then
    evenodd_arr=('even' 'odd')
    pol_arr=($pols)
    n_pols=${#pol_arr[@]}
    evenodd_ind=$(((${SLURM_ARRAY_TASK_ID}-1)/${n_pols}))
    pol_ind=$(((${SLURM_ARRAY_TASK_ID}-1)%${n_pols}))
    pol=(${pol_arr[$pol_ind]})
    evenodd=(${evenodd_arr[$evenodd_ind]})
    echo Processing cube: ${pol} ${evenodd} ${cube_type}
fi

# echo keywords
echo Using file_path_cubes: $file_path_cubes
echo Using version: $version
echo Using single_obs: $single_obs

# log into azcopy
azcopy login --identity

# get unique directory
FHD_version=$(basename ${file_path_cubes})

# Create a string of arguements to pass into az_ps_job given the input
#   into this script
input_folder=/mnt/scratch/$FHD_version/
if [[ -z ${cube_type} ]] && [[ -z ${pol} ]] && [[ -z ${evenodd} ]]; then
    # create arg string for ps job
	arg_string="${input_folder} ${version}"
else
    if [[ ! -z ${cube_type} ]] && [[ ! -z ${pol} ]] && [[ ! -z ${evenodd} ]]; then
        # create arg string for cube job
	    arg_string="${input_folder} ${version} ${cube_type} ${pol,,} ${evenodd}"
    else
        echo "Need to specify cube_type, pol, and evenodd altogether"
        exit 1
    fi
fi

#create Healpix download location with full permissions
if [ -d ${FHD_version}/Healpix ]; then
    sudo chmod -R 777 ${FHD_version}/Healpix
else
    sudo mkdir -m 777 ${FHD_version}
    sudo mkdir -m 777 ${FHD_version}/Healpix
fi
#create PS download location with full permissions
if [ -d ${FHD_version}/ps ]; then
    sudo chmod -R 777 ${FHD_version}/ps
    if [ -d ${FHD_version}/ps/data ]; then
        sudo chmod -R 777 ${FHD_version}/ps/data
    else
        sudo mkdir -m 777 ${FHD_version}/ps/data
    fi
    if [ -d ps/data/uvf_cubes ]; then
        sudo chmod -R 777 ${FHD_version}/ps/data/uvf_cubes
    else
        sudo mkdir -m 777 ${FHD_version}/ps/data/uvf_cubes
    fi
else
    sudo mkdir -m 777 ${FHD_version}
    sudo mkdir -m 777 ${FHD_version}/ps
    sudo mkdir -m 777 ${FHD_version}/ps/data
    sudo mkdir -m 777 ${FHD_version}/ps/data/uvf_cubes
fi

if [ $single_obs -eq 1 ]; then
    cube_prefix=${version}
	echo Working on a single obsid. Using cube prefix ${cube_prefix}.
else
	cube_prefix="Combined_obs_${version}"
	echo Working on combined obsids. Using cube prefix ${cube_prefix}.
fi 

# If doing a cube job, look for integration cube locally.
# If not found, download from azure
if [ ! -z ${cube_type} ]; then
    if [ ! -f "${FHD_version}/Healpix/${cube_prefix}_${evenodd}_cube${pol^^}.sav" ]; then
        azcopy copy ${file_path_cubes}/Healpix/${cube_prefix}_${evenodd}_cube${pol^^}.sav \
        ${FHD_version}/Healpix/${cube_prefix}_${evenodd}_cube${pol^^}.sav
    fi
    # Check that file downloaded
    if [ ! -f "${FHD_version}/Healpix/${cube_prefix}_${evenodd}_cube${pol^^}.sav" ]; then
        >&2 echo "Integration cube ${cube_prefix}_${evenodd}_cube${pol^^}.sav not found"
        exit 1
    fi
# If doing a power spectra job, need all the weights, model, and dirty cubes.
# If not found locally, download from azure
else
    # should have n_cubes * n_pols * n_evenodd cubes
    n_epps_cubes = $((n_cubes*n_pol*2))
    file_num=$(ls ${FHD_version}/ps/data/uvf_cubes/${cube_prefix}* | wc -li)
    echo "file_num is $file_num"
    if [ $file_num -ne $n_epps_cubes ]; then
        # Download from azure
        azcopy copy ${file_path_cubes}/ps/data/uvf_cubes ${FHD_version}/ps/data --recursive
    fi
    # Check download
    file_num=$(ls ${FHD_version}/ps/data/uvf_cubes/${cube_prefix}* | wc -li)
    if [ $file_num -ne $n_epps_cubes ]; then
        >&2 echo "Unable to make power spectra. Missing uvf cubes."
        echo "Job Failed"
        exit 1
    fi
fi

# Run eppsilon
echo "arg_string is $arg_string"
idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS $nslots -e az_ps_job -args $arg_string || :

if [ $? -eq 0 ]
then
    echo "Eppsilon Job Finished"
    error_mode=0
else
    echo "Eppsilon Job Failed"
    error_mode=1
fi

# Move eppsilon outputs to az
if [ -z ${cube_type} ]; then
    i=1  #initialize counter
    azcopy copy ${FHD_version}/ps ${file_path_cubes} --recursive
    while [ $? -ne 0 ] && [ $i -lt 10 ]; do
        let "i += 1"  #increment counter
        >&2 echo "Moving eppsilon outputs to az failed. Retrying (attempt $i)."
        azcopy copy ${FHD_version}/ps ${file_path_cubes} --recursive
    done
else
    i=1  #initialize counter
    azcopy copy ${FHD_version}/ps/data/uvf_cubes ${file_path_cubes}/ps/data --recursive
    while [ $? -ne 0 ] && [ $i -lt 10 ]; do
        let "i += 1"  #increment counter
        >&2 echo "Moving eppsilon outputs to az failed. Retrying (attempt $i)."
        azcopy copy ${FHD_version}/ps/data/uvf_cubes ${file_path_cubes}/ps/data --recursive
    done
fi

echo "JOB END TIME" `date +"%Y-%m-%d_%H:%M:%S"`

# Move logs to az
if [ ! -z ${cube_type} ]; then
    # Copy stdout to S3
    azcopy copy ~/logs/${version}_eppsilon_cube_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
    ${file_path_cubes}/ps/logs/${version}_eppsilon_cube_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt
    # Copy stderr to S3
    azcopy copy ~/logs/${version}_eppsilon_cube_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
    ${file_path_cubes}/ps/logs/${version}_eppsilon_cube_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt
else
    # Copy stdout to S3
    azcopy copy ~/logs/${version}_eppsilon_ps_job_az.sh.o${SLURM_ARRAY_JOB_ID} \
    ${file_path_cubes}/ps/logs/${version}_eppsilon_ps_job_az.sh.o${SLURM_ARRAY_JOB_ID}_${myip}.txt
    # Copy stderr to S3
    azcopy copy ~/logs/${version}_eppsilon_ps_job_az.sh.e${SLURM_ARRAY_JOB_ID} \
    ${file_path_cubes}/ps/logs/${version}_eppsilon_ps_job_az.sh.e${SLURM_ARRAY_JOB_ID}_${myip}.txt
fi

exit $error_mode

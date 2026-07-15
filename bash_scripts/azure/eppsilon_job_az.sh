#! /bin/bash

# Batch script for slurm job. Second level program for
# running integration on azure machines. First level program is run_eppsilon_az.sh
# Adapted from eppsilon_job_aws.sh

#inputs needed: file_path_cubes, obs_list_path, obs_list_array, cube_prefix, nslots, scratch_dir
#inputs optional: cube_type, pol, evenodd

# If cube_type is unset, do a power spectrum job. Otherwise, do a cube job.

echo JOBID ${SLURM_ARRAY_JOB_ID}
if [ ! -z ${cube_type} ]; then
    echo TASKID ${SLURM_ARRAY_TASK_ID}
fi
echo CUBE_PREFIX ${cube_prefix}
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
echo Using cube_prefix: $cube_prefix
echo Using single_obs: $single_obs
echo Using versions_script: $versions_script
echo Using scratch_dir: $scratch_dir

# /mnt/scratch is node-local (not shared between the scheduler or other
# compute nodes), so scratch_dir can't be created ahead of time by the
# launcher script -- it has to be created here, on whichever node this task
# actually landed on. -D (from the launcher's sbatch call) points at the
# plain /mnt/scratch, which does exist on every node; everything below then
# runs inside the unique scratch_dir subdirectory of that.
mkdir -p ${scratch_dir}
cd ${scratch_dir} || { >&2 echo "ERROR: could not create/enter scratch_dir: ${scratch_dir}"; exit 1; }

# NOTE: shouldn't be necessary with new idl license server
# Set up per-job isolated license cache on local /tmp to avoid shared-filesystem race conditions
#JOB_LICENSE_DIR=/tmp/harris_license_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}
#mkdir -p ${JOB_LICENSE_DIR}/flexera
#mkdir -p ${JOB_LICENSE_DIR}/flexera-sv
#cp /shared/idl_stuff/harris/license/o_licenseserverurl.txt ${JOB_LICENSE_DIR}/
#cp /shared/idl_stuff/harris/license/device.id0 ${JOB_LICENSE_DIR}/
#export EXELIS_DIR=${JOB_LICENSE_DIR}
#trap "rm -rf ${JOB_LICENSE_DIR}" EXIT
#echo "Using per-job license cache at ${JOB_LICENSE_DIR}"

# log into azcopy
azcopy login --identity

# FHD_version names the subfolder for this FHD directory's data; true run-to-run
# isolation comes from scratch_dir (created and cd'd into above), which the
# launcher script (run_eppsilon_az.sh) generates uniquely per run.
FHD_version=$(basename ${file_path_cubes})

# Create a string of arguements to pass into az_ps_job given the input
#   into this script
input_folder=${scratch_dir}/$FHD_version/
if [[ -z ${cube_type} ]] && [[ -z ${pol} ]] && [[ -z ${evenodd} ]]; then
        arg_string="${input_folder} ${cube_prefix}"
else
    if [[ ! -z ${cube_type} ]] && [[ ! -z ${pol} ]] && [[ ! -z ${evenodd} ]]; then
        # create arg string for cube job
            arg_string="${input_folder} ${cube_prefix} ${cube_type} ${pol,,} ${evenodd}"
    else
        echo "Need to specify cube_type, pol, and evenodd altogether"
        exit 1
    fi
fi

if [ ! -z ${version} ]; then
    arg_string="$arg_string ${version}"
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
    cube_prefix=${cube_prefix}
        echo Working on a single obsid. Using cube prefix ${cube_prefix}.
else
        cube_prefix="Combined_obs_${cube_prefix}"
        echo Working on combined obsids. Using cube prefix ${cube_prefix}.
fi

# if running a power spectrum job, pull the uvf cubes and info cube
if [ -z ${cube_type} ]; then
    echo ps job, pulling all uvf files
    azcopy copy ${file_path_cubes}/ps ${FHD_version} --recursive --include-pattern="*${cube_prefix}*info.idlsave"
    # check that all uvf cubes were downloaded
    for ps_pol in ${pols}; do
        for ps_evenodd in even odd; do
            for ps_cube_type in weights dirty model; do
                cube_name="${cube_prefix}_${ps_evenodd}_cube${ps_pol^^}_noimgclip_${ps_cube_type}_uvf.idlsave"
                azcopy copy ${file_path_cubes}/ps/data/uvf_cubes/${cube_name} ${FHD_version}/ps/data/uvf_cubes/${cube_name}
                if [ ! -f "${FHD_version}/ps/data/uvf_cubes/${cube_name}" ]; then
                >&2 echo "uvf cube ${cube_name} not found"
                exit 1
                fi
            done
        done
    done
fi
# if running a dft job, pull the Healpix cubes
for ps_pol in ${pols}; do
    for ps_evenodd in even odd; do
        if [ ! -f "${FHD_version}/Healpix/${cube_prefix}_${ps_evenodd}_cube${ps_pol^^}.sav" ]; then
                echo "Using file_path_cubes for Healpix download: ${file_path_cubes}"
            echo "Attempting to download ${cube_prefix}_${ps_evenodd}_cube${ps_pol^^}.sav"
                azcopy copy ${file_path_cubes}/Healpix/${cube_prefix}_${ps_evenodd}_cube${ps_pol^^}.sav \
            ${FHD_version}/Healpix/${cube_prefix}_${ps_evenodd}_cube${ps_pol^^}.sav
        fi
        # Check that file downloaded
        if [ ! -f "${FHD_version}/Healpix/${cube_prefix}_${ps_evenodd}_cube${ps_pol^^}.sav" ]; then
            >&2 echo "Integration cube ${cube_prefix}_${ps_evenodd}_cube${ps_pol^^}.sav not found"
            exit 1
        fi
    done
done

echo $(ls ${scratch_dir}/${FHD_version}/ps/data/uvf_cubes)

echo "arg_string is $arg_string"

# Run eppsilon
/shared/idl_stuff/nv5/idl91/bin/idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS $nslots -e ${versions_script} -args $arg_string || :

if [ $? -eq 0 ]
then
    echo "Eppsilon Job Finished"
    error_mode=0
else
    echo "Eppsilon Job Failed"
    error_mode=1
fi
echo $(ls ${scratch_dir}/${FHD_version}/ps/data/uvf_cubes)

i=1  #initialize counter
azcopy copy ${FHD_version}/ps ${file_path_cubes} --recursive
while [ $? -ne 0 ] && [ $i -lt 10 ]; do
    let "i += 1"  #increment counter
    >&2 echo "Moving eppsilon outputs to az failed. Retrying (attempt $i)."
    azcopy copy ${FHD_version}/ps ${file_path_cubes} --recursive
done

echo "JOB END TIME" `date +"%Y-%m-%d_%H:%M:%S"`

# Move logs to az
if [ ! -z ${cube_type} ]; then
    # Copy stdout to az
    azcopy copy ~/logs/${cube_prefix}_eppsilon_cube_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
    ${file_path_cubes}/ps/logs/${cube_prefix}_eppsilon_cube_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt
    # Copy stderr to az
    azcopy copy ~/logs/${cube_prefix}_eppsilon_cube_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
    ${file_path_cubes}/ps/logs/${cube_prefix}_eppsilon_cube_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt
else
    # Copy stdout to az
    azcopy copy ~/logs/${cube_prefix}_eppsilon_ps_job_az.sh.o${SLURM_ARRAY_JOB_ID} \
    ${file_path_cubes}/ps/logs/${cube_prefix}_eppsilon_ps_job_az.sh.o${SLURM_ARRAY_JOB_ID}_${myip}.txt
    # Copy stderr to az
    azcopy copy ~/logs/${cube_prefix}_eppsilon_ps_job_az.sh.e${SLURM_ARRAY_JOB_ID} \
    ${file_path_cubes}/ps/logs/${cube_prefix}_eppsilon_ps_job_az.sh.e${SLURM_ARRAY_JOB_ID}_${myip}.txt
fi

# Go ahead and delete output directory on instance since they are not currently sharing jobs
#sudo rm -r ${FHD_version}

exit $error_mode

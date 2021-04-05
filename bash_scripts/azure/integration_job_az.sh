#!/bin/bash

# Batch script for slurm job. Second level program for
# running integration on azure machines. First level program is run_eppsilon_az.sh
# Adapted from integration_job_aws.sh

echo JOBID ${SLURM_ARRAY_JOB_ID}
echo TASKID ${SLURM_ARRAY_TASK_ID}
echo "JOB START TIME" `date +"%Y-%m-%d_%H:%M:%S"`
myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo PUBLIC IP ${myip}

# Use task id to get index for even/odd and pol arrays
# Corresponding tasks in eppsilon_job_az.sh might wait on these tasks
# This code must be the same in both scripts for the tasks to correspond correctly
evenodd_arr=('even' 'odd')
pol_arr=($pols)
n_pols=${#pol_arr[@]}
evenodd_ind=$(((${SLURM_ARRAY_TASK_ID}-1)/${n_pols}))
pol_ind=$(((${SLURM_ARRAY_TASK_ID}-1)%${n_pols}))
pol=(${pol_arr[$pol_ind]})
evenodd=(${evenodd_arr[$evenodd_ind]})
echo Processing cube: ${pol} ${evenodd}

# echo keywords
echo Using file_path_cubes: $file_path_cubes
echo Using version: $version

#create Healpix download location with full permissions
if [ -d ${version}/Healpix ]; then
    sudo chmod -R 777 ${version}/Healpix
else
    sudo mkdir -m 777 ${version}
    sudo mkdir -m 777 ${version}/Healpix
fi

# set integrated cube file name
save_file_evenoddpol=${version}/Healpix/Combined_obs_${version}_${evenodd}_cube${pol^^}.sav

# check if Healpix cubes exist locally; if not, try to download
unset exit_flag
for int_cube in $(cat $int_list_path); do
    if [ ! -f "${version}/Healpix/${int_cube}_${evenodd}_cube${pol^^}.sav" ]; then
        az storage copy -s ${file_path_cubes}/Healpix/${int_cube}_${evenodd}_cube${pol^^}.sav \
        -d ${version}/Healpix/${int_cube}_${evenodd}_cube${pol^^}.sav
    fi
    # check if cube downloaded
    if [ ! -f "${version}/Healpix/${int_cube}_${evenodd}_cube${pol^^}.sav" ]; then
        >&2 echo "ERROR: HEALPix file not downloaded: ${int_cube}_${evenodd}_cube${pol^^}.sav"
        exit_flag=1
    else
        echo Downloaded ${int_cube}_${evenodd}_cube${pol^^}.sav
    fi
done

# Error if any cubes did not download
if [ ! -z ${exit_flag} ]; then
    exit 1
fi
echo All cubes on instance

#Create a name for the downloaded cube file based off of inputs
evenoddpol_file_paths=${version}/Healpix/${version}_${evenodd}${pol^^}_list.txt

# Fill the downloaded cube file with paths to cubes to integrate
for int_cube in $(cat $int_list_path); do
    cube_path=${version}/Healpix/${int_cube}_${evenodd}_cube${pol^^}.sav
    echo $cube_path >> $evenoddpol_file_paths
done

# Run the integration IDL script
idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS $nslots -e integrate_healpix_cubes -args "$evenoddpol_file_paths" "$save_file_evenoddpol" || :

if [ $? -eq 0 ]
then
    echo "Integration Job Finished"
    error_mode=0
else
    echo "Integration Job Failed"
    error_mode=1
fi

# Move integration output file to az
i=1  #initialize counter
az storage copy -s ${save_file_evenoddpol} -d ${file_path_cubes}/${save_file_evenoddpol}
while [ $? -ne 0 ] && [ $i -lt 10 ]; do
    let "i += 1"  #increment counter
    >&2 echo "Moving FHD outputs to az failed. Retrying (attempt $i)."
    az storage copy -s ${save_file_evenoddpol} -d ${file_path_cubes}/${save_file_evenoddpol}
done

echo "JOB END TIME" `date +"%Y-%m-%d_%H:%M:%S"`

# Copy stdout to S3
az storage copy -s ~/logs/${version}_integration_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
-d ${file_path_cubes}/Healpix/logs/${version}_integration_job_az.sh.o${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt

# Copy stderr to S3
az storage copy -s ~/logs/${version}_integration_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID} \
-d ${file_path_cubes}/Healpix/logs/${version}_integration_job_az.sh.e${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}_${myip}.txt

# Remove integration cubes from the instance
for int_cube in $(cat $int_list_path); do
    sudo rm ${version}/Healpix/${int_cube}_${evenodd}_cube${pol^^}.sav
done

exit $error_mode
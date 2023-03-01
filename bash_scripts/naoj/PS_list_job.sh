#! /bin/bash
#run Bryna's PS code on cubes that have already been integrated (in Slurm)

#PBS -V
#PBS -m n


#inputs needed: file_path_cubes, nobs, version, ncores

echo "Job ID: " ${PBS_JOBID}

#***Get the obsid file paths
nobs=0
while read line
do
  ((nobs++))
done < $obs_list_path

input_file=${file_path_cubes}/
#***

#***Create a string of arguements to pass into mit_ps_job given the input
#   into this script
if [[ -z ${cube_type} ]] && [[ -z ${pol} ]] && [[ -z ${evenodd} ]]; then
    if [[ -z ${image_filter_name} ]]; then
	arg_string="${input_file} ${version}"
    else
	arg_string="${input_file} ${version} ${image_filter_name}"
    fi
else
    if [[ ! -z ${cube_type} ]] && [[ ! -z ${pol} ]] && [[ ! -z ${evenodd} ]]; then
	if [[ -z ${image_filter_name} ]]; then
	    arg_string="${input_file} ${version} ${cube_type} ${pol} ${evenodd}"
	else
	    arg_string="${input_file} ${version} ${cube_type} ${pol} ${evenodd} ${image_filter_name}"
	fi
    else
        echo "Need to specify cube_type, pol, and evenodd altogether"
        exit 1
    fi
fi
#***

/usr/local/harris/idl88/bin/idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS $ncores -e ozstar_ps_job -args $arg_string

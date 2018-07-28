#! /bin/bash
#$ -V
#$ -S /bin/bash

#This script is an extra layer between Grid Engine and IDL commands because
#Grid Engine runs best on bash scripts.

#inputs needed: file_path_cubes, obs_list_path, obs_list_array, version, nslots
#inputs optional: cube_type, pol, evenodd, image_filter_name, image_letters

echo JOBID ${JOB_ID}
echo VERSION ${version}
echo "JOB START TIME" `date +"%Y-%m-%d_%H:%M:%S"`
myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo PUBLIC IP ${myip}


input_file=/

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

#create Healpix download location with full permissions
if [ -d /Healpix ]; then
    sudo chmod -R 777 /Healpix
else
    sudo mkdir -m 777 /Healpix
fi
#create PS download location with full permissions
if [ -d /ps ]; then
    sudo chmod -R 777 /ps
    if [ -d /ps/data ]; then
        sudo chmod -R 777 /ps/data
    else 
        sudo mkdir -m 777 /ps/data
    fi
    if [ -d /ps/data/uvf_cubes ]; then
        sudo chmod -R 777 /ps/data/uvf_cubes
    else
        sudo mkdir -m 777 /ps/data/uvf_cubes
    fi
else
    sudo mkdir -m 777 /ps
    sudo mkdir -m 777 /ps/data
    sudo mkdir -m 777 /ps/data/uvf_cubes
fi

obs_list_array=($(echo $obs_list_array|sed 's/:/ /g'))
printf "%s\n" "${obs_list_array[@]}" > $obs_list_path

unset exit_flag

#####Check for data cubes if DFTing individually
if [ ! -z ${cube_type} ]; then
    cube_exists=$(aws s3 ls ${file_path_cubes}/ps/data/uvf_cubes/Combined_obs_${version}_${evenodd}_cube${pol^^}_${image_letters}${cube_type}_uvf.idlsave)
    if [ ! -z "$cube_exists" ]; then
        echo Cube already exists. Exiting
        exit 1
    fi
fi

####Check for all integrated Healpix cubes
# Check if the Healpix cubes exist locally; if not, check S3
###TEMP solution until eppsilon can take individual cubes
#if [ ! -f "/Healpix/Combined_obs_${version}_${evenodd}_cube${pol^^}.sav" ]; then
if [ "$(ls /Healpix/Combined_obs_${version}_*.sav | wc -l)" -ne "4" ]; then
    for evenodd_i in even odd; do
        for pol_i in XX YY; do
            # Check that the Healpix file exists on S3
            healpix_exists=$(aws s3 ls ${file_path_cubes}/Healpix/Combined_obs_${version}_${evenodd_i}_cube${pol_i^^}.sav)
            if [ -z "$healpix_exists" ]; then
                >&2 echo "ERROR: HEALPix file not found Combined_obs_${version}_${evenodd}_cube${pol^^}.sav"
                exit_flag=1
            fi
	done
    done
fi

if [ ! -z ${exit_flag} ]; then exit 1;fi 
####

####Download Healpix cubes
# Check if the Healpix exists locally; if not, download it from S3
#if [ ! -f "/Healpix/Combined_obs_${version}_${evenodd}_cube${pol^^}.sav" ]; then
if [ "$(ls /Healpix/Combined_obs_${version}_*.sav | wc -l)" -ne "4" ]; then

    # Download Healpix from S3
    #sudo aws s3 cp ${file_path_cubes}/Healpix/Combined_obs_${version}_${evenodd}_cube${pol^^}.sav \
    #/Healpix/Combined_obs_${version}_${evenodd}_cube${pol^^}.sav --quiet
    for evenodd_i in even odd; do
        for pol_i in XX YY; do
            sudo aws s3 cp ${file_path_cubes}/Healpix/Combined_obs_${version}_${evenodd_i}_cube${pol_i^^}.sav \
             /Healpix/Combined_obs_${version}_${evenodd_i}_cube${pol_i^^}.sav --quiet
	     
	    # Verify that the cubes downloaded correctly
            if [ ! -f "/Healpix/Combined_obs_${version}_${evenodd_i}_cube${pol_i^^}.sav" ]; then
                >&2 echo "ERROR: downloading cubes from S3 failed"
                echo "Job Failed"
                exit 1
            fi
        done
    done
fi
####

####Check for weights cube if DFTing separate cubes
if [ ! -z ${cube_type} ]; then
    if [ ${cube_type} != "weights" ]; then
        ##Needs weights cube
	# Check if it exists locally; if not, download it from S3
        if [ ! -f "/ps/data/uvf_cubes/Combined_obs_${version}_${evenodd}_cube${pol^^}_${image_letters}weights_uvf.idlsave" ]; then

            # Download Healpix from S3
            sudo aws s3 cp ${file_path_cubes}/ps/data/uvf_cubes/Combined_obs_${version}_${evenodd}_cube${pol^^}_${image_letters}weights_uvf.idlsave \
            /ps/data/uvf_cubes/Combined_obs_${version}_${evenodd}_cube${pol^^}_${image_letters}weights_uvf.idlsave --quiet

            # Verify that the cubes downloaded correctly
            if [ ! -f "/ps/data/uvf_cubes/Combined_obs_${version}_${evenodd}_cube${pol^^}_${image_letters}weights_uvf.idlsave" ]; then
                >&2 echo "ERROR: downloading weights cube from S3 failed"
                echo "Job Failed"
                exit 1
            fi
        fi
    fi
fi
####

####Get uvf_cubes folder if not DFTing separate cubes
if [ -z ${cube_type} ]; then
    sudo aws s3 cp ${file_path_cubes}/ps/data/uvf_cubes/ /ps/data/uvf_cubes --recursive --quiet \
     --exclude "*" --include "Combined_obs_${version}*" --force-glacier-transfer
fi
####

idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS $nslots -e aws_ps_job -args $arg_string || :

if [ $? -eq 0 ]
then
    echo "Eppsilon Cube Job Finished"
    error_mode=0
else
    echo "Job Failed"
    error_mode=1
fi

# Move eppsilon outputs to S3
if [ -z ${cube_type} ]; then
    i=1  #initialize counter
    aws s3 mv /ps/ ${file_path_cubes}/ps/ --recursive --quiet
    while [ $? -ne 0 ] && [ $i -lt 10 ]; do
        let "i += 1"  #increment counter
        >&2 echo "Moving FHD outputs to S3 failed. Retrying (attempt $i)."
        aws s3 mv /ps/ ${file_path_cubes}/ps/ --recursive --quiet
    done
else
    i=1  #initialize counter
    aws s3 mv /ps/data/uvf_cubes/ ${file_path_cubes}/ps/data/uvf_cubes/ --recursive --quiet
    while [ $? -ne 0 ] && [ $i -lt 10 ]; do
        let "i += 1"  #increment counter
        >&2 echo "Moving FHD outputs to S3 failed. Retrying (attempt $i)."
        aws s3 mv /ps/data/uvf_cubes/ ${file_path_cubes}/ps/data/uvf_cubes/ --recursive --quiet
    done
fi

echo "JOB END TIME" `date +"%Y-%m-%d_%H:%M:%S"`

# Move integration logs to S3
i=1  #initialize counter
aws s3 cp ~/grid_out/ ${file_path_cubes}/ps/logs --recursive \
--exclude "*" --include "*_xx_*" --quiet
aws s3 cp ~/grid_out ${file_path_cubes}/ps/logs --recursive \
--exclude "*" --include "*_yy_*" --quiet
aws s3 cp ~/grid_out ${file_path_cubes}/ps/logs --recursive \
--exclude "*" --include "*_plots*" --quiet
while [ $? -ne 0 ] && [ $i -lt 10 ]; do
    let "i += 1"  #increment counter
    >&2 echo "Moving eppsilon logs to S3 failed. Retrying (attempt $i)."
    aws s3 cp ~/grid_out ${file_path_cubes}/ps/logs --recursive \
     --exclude "*" --include "*_xx_*" --quiet
    aws s3 cp ~/grid_out ${file_path_cubes}/ps/logs --recursive \
     --exclude "*" --include "*_yy_*" --quiet
    aws s3 cp ~/grid_out ${file_path_cubes}/ps/logs --recursive \
     --exclude "*" --include "*_plots*" --quiet
done

#! /bin/bash
#$ -V
#$ -N Cube_int
#$ -S /bin/bash

#This script is an extra layer between Grid Engine and IDL commands because
#Grid Engine runs best on bash scripts.

#inputs needed: file_path_cubes, obs_list_path, obs_list_array, version, chunk, nslots, 
#evenodd, pol
#chunk is the chunk number when the list was broken up. 0 for "master" or only chunk

echo JOBID ${JOB_ID}
echo VERSION ${version}
echo ${pol} ${evenodd}
echo "JOB START TIME" `date +"%Y-%m-%d_%H:%M:%S"`
myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo PUBLIC IP ${myip}

#create Healpix download location with full permissions
if [ -d /Healpix ]; then
    sudo chmod -R 777 /Healpix
    rm -f /Healpix/${version}_int_chunk*.txt # remove any old chunk files lying around
else
    sudo mkdir -m 777 /Healpix
fi

#***If the integration has been split up into chunks, name the save file specifically off of that.
if [ "$chunk" -gt "0" ]; then
    int_filename=Combined_obs_${version}_int_chunk${chunk}_${evenodd}_cube${pol^^}.sav
    save_file_evenoddpol=/Healpix/${int_filename}
else
    int_filename=Combined_obs_${version}_${evenodd}_cube${pol^^}.sav
    save_file_evenoddpol=/Healpix/${int_filename}
fi
#***

unset healpix_found

# Check if the Healpix integration exists locally; if not, check S3
if [ ! -f "${save_file_evenoddpol}" ]; then

    # Check if Healpix integration file exists on S3
    healpix_exists=$(aws s3 ls ${file_path_cubes}/Healpix/${int_filename})
    if [ ! -z "$healpix_exists" ]; then
        >&2 echo "HEALPix integration file found ${file_path_cubes}/Healpix/${int_filename}"
        
        sudo aws s3 cp ${file_path_cubes}/Healpix/${int_filename} \
         /Healpix/${int_filename} --quiet

        if [ ! -f "/Healpix/${int_filename}" ]; then
            >&2 echo "ERROR: downloading HEALPix integration from S3 failed"
            echo "Job Failed"
            exit 1
        fi
        healpix_found=1
    fi
else
    >&2 echo "HEALPix integration file found in /HEALPix"
    healpix_found=1
fi

#print array into file on the specific instance
obs_list_array=($(echo $obs_list_array|sed 's/:/ /g'))
printf "%s\n" "${obs_list_array[@]}" > $obs_list_path

if [ -z ${healpix_found} ]
then

    unset exit_flag

    ####Check for all Healpix cubes
    while read obs_id
    do
        # Check if the Healpix exists locally; if not, check S3
        if [ ! -f "/Healpix/${obs_id}_${evenodd}_cube${pol^^}.sav" ]; then

            # Check that the Healpix file exists on S3
            healpix_exists=$(aws s3 ls ${file_path_cubes}/Healpix/${obs_id}_${evenodd}_cube${pol^^}.sav)
            if [ -z "$healpix_exists" ]; then
                >&2 echo "ERROR: HEALPix file not found ${obs_id}_${evenodd}_cube${pol^^}.sav"
                exit_flag=1
            fi
        fi
    done < $obs_list_path

    if [ ! -z ${exit_flag} ]; then exit 1;fi 
    ####

    ####Download Healpix cubes
    while read obs_id
    do
        # Check if the Healpix exists locally; if not, download it from S3
        if [ ! -f "/Healpix/${obs_id}_${evenodd}_cube${pol^^}.sav" ]; then

            # Download Healpix from S3
            sudo aws s3 cp ${file_path_cubes}/Healpix/${obs_id}_${evenodd}_cube${pol^^}.sav \
            /Healpix/${obs_id}_${evenodd}_cube${pol^^}.sav --quiet

            # Verify that the cubes downloaded correctly
            if [ ! -f "/Healpix/${obs_id}_${evenodd}_cube${pol^^}.sav" ]; then
                >&2 echo "ERROR: downloading cubes from S3 failed"
                echo "Job Failed"
                exit 1
            else
                echo Downloaded ${obs_id}_${evenodd}_cube${pol^^}.sav
            fi
        fi
    done < $obs_list_path
    ####

    echo All cubes on instance

    #Create a name for the obs txt file based off of inputs
    evenoddpol_file_paths=/Healpix/${version}_int_chunk${chunk}_${evenodd}${pol^^}_list.txt
    #clear old file paths
    rm $evenoddpol_file_paths

    #***Fill the obs text file with the obsids to integrate
    nobs=0
    while read line
    do
        evenoddpol_file=/Healpix/${line}_${evenodd}_cube${pol^^}.sav
        echo $evenoddpol_file >> $evenoddpol_file_paths
        ((nobs++))
    done < "$obs_list_path"
    #***

    ####Run the integration IDL script
    idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS $nslots -e integrate_healpix_cubes -args "$evenoddpol_file_paths" "$save_file_evenoddpol" || :
    #***

    if [ $? -eq 0 ]
    then
        echo "Integration Job Finished"
        error_mode=0
    else
        echo "Job Failed"
        error_mode=1
    fi

    # Move integration outputs to S3
    i=1  #initialize counter
    aws s3 mv ${save_file_evenoddpol} \
    ${file_path_cubes}${save_file_evenoddpol} --quiet
    while [ $? -ne 0 ] && [ $i -lt 10 ]; do
        let "i += 1"  #increment counter
        >&2 echo "Moving FHD outputs to S3 failed. Retrying (attempt $i)."
        aws s3 mv ${save_file_evenoddpol} \
        ${file_path_cubes}${save_file_evenoddpol} --quiet
    done

    echo "JOB END TIME" `date +"%Y-%m-%d_%H:%M:%S"`

    # Move integration logs to S3
    i=1  #initialize counter
    aws s3 cp ~/grid_out/ ${file_path_cubes}/Healpix/ --recursive \
     --exclude "*" --include "*int_*" --quiet
    while [ $? -ne 0 ] && [ $i -lt 10 ]; do
        let "i += 1"  #increment counter
        >&2 echo "Moving FHD outputs to S3 failed. Retrying (attempt $i)."
        aws s3 cp ~/grid_out/ ${file_path_cubes}/Healpix/ --recursive \
         --exclude "*" --include "*int_*" --quiet
    done

    # Remove obsid cubes from the instance
    while read obs_id
    do
        sudo rm /Healpix/${obs_id}_${evenodd}_cube${pol^^}.sav
    done < $obs_list_path

fi

#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <output_folder> <obs_id_list.txt> <skip_point>"
    exit 1
fi


# Assign command line arguments to variables

output_folder="$1"
if [ -n "$3" ]; then
	skip_point="$3"
else
	skip_point=0
fi

skip_counter=0

version_tag="eli_testing_updated"

echo "Output folder: $output_folder"
echo "Skip point: $skip_point"
obs_id_list="$2"
while IFS= read -r obs_id; do
        
	((skip_counter++))
	
    if [ "$skip_counter" -gt "$skip_point" ]; then
        echo "Running calibration on: ${obs_id}"
        yes 'yes' | rm /Users/elillesk/idl_stuff/flexera/a*
        yes 'yes' | rm /Users/elillesk/idl_stuff/flexera-sv/a*
            //Applications/harris/idl88/bin/idl -e "enl_fhd_versions, '$obs_id', '$output_folder', '${version_tag}_cal'">& idl_stuff/idl_${obs_id}_eli_testing_cal.out
    fi


	((skip_counter++))
	if [ "$skip_counter" -gt "$skip_point" ]; then
        echo "Running imaging on: ${obs_id}"
		yes 'yes' | rm /Users/elillesk/idl_stuff/flexera/a*
		yes 'yes' | rm /Users/elillesk/idl_stuff/flexera-sv/a*
	        //Applications/harris/idl88/bin/idl -e "enl_fhd_versions, '$obs_id', '$output_folder', '${version_tag}_image'">& idl_stuff/idl_${obs_id}_eli_testing_image.out
	fi

done < "$obs_id_list"



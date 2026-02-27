#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <obs_id_list.txt> <skip_point>"
    exit 1
fi


# Assign command line arguments to variables


if [ -n "$2" ]; then
	skip_point="$2"
else
	skip_point=0
fi

skip_counter=0

version_tag="eli_testing_updated"

echo "Output folder: $output_folder"
echo "Skip point: $skip_point"
echo "$version_tag"

obs_id_list="$1"
while IFS= read -r obs_id; do
        
	((skip_counter++))
	
    if [ "$skip_counter" -gt "$skip_point" ]; then
        echo "Running eppsilon on: ${obs_id}"
        yes 'yes' | rm /Users/elillesk/idl_stuff/flexera/a*
        yes 'yes' | rm /Users/elillesk/idl_stuff/flexera-sv/a*
            //Applications/harris/idl88/bin/idl -e "ps_wrapper, '/Volumes/Data3/elillesk/data_and_analysis/fhd/fhd_${version_tag}_image', '$obs_id', /png">& idl_stuff/idl_${obs_id}_epp.out
            //Applications/harris/idl88/bin/idl -e "ps_wrapper, '/Volumes/Data3/elillesk/data_and_analysis/fhd/fhd_${version_tag}_image', '$obs_id', /png, /plot_slices, slice_type = 'sumdiff'">& idl_stuff/idl_${obs_id}_epp.out
            //Applications/harris/idl88/bin/idl -e "ps_wrapper, '/Volumes/Data3/elillesk/data_and_analysis/fhd/fhd_${version_tag}_image', '$obs_id', /png, /plot_slices, slice_type = 'weights'">& idl_stuff/idl_${obs_id}_epp.out
    fi



done < "$obs_id_list"



    #!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <output_folder> [<obs_id_list.txt> | <obs_id>] <skip_point> <skip_cal>"
    exit 1
fi



# Assign command line arguments to variables

output_folder="$1"
if [ -n "$3" ]; then
	skip_point="$3"
else
	skip_point=0
fi

if [ -n "$4" ]; then
	skip_cal="$4"
else
	skip_cal=0
fi
skip_counter=0

echo "Output folder: $output_folder"
echo "Skip point: $skip_point"
# Check if a obs_id list or single obs_id is provided as input
if [ -f "$2" ]; then
    obs_id_list="$2"
    while IFS= read -r obs_id; do
        
	((skip_counter++))
	if [ "$skip_cal" -eq 0 ]; then
		if [ "$skip_counter" -gt "$skip_point" ]; then
			echo "Running calibration on: ${obs_id}"
			yes 'yes' | rm /Users/elillesk/idl_stuff/flexera/a*
			yes 'yes' | rm /Users/elillesk/idl_stuff/flexera-sv/a*
        		//Applications/harris/idl88/bin/idl -e "save_image_cube_rfi_versions, $obs_id, '$output_folder', 'save_image_cube_rfi_cal_fix1'">& idl_stuff/idl_${obs_id}_cal_fix1.out
		fi
	fi

	((skip_counter++))
	if [ "$skip_counter" -gt "$skip_point" ]; then
        	echo "Running imaging on: ${obs_id}"
		yes 'yes' | rm /Users/elillesk/idl_stuff/flexera/a*
		yes 'yes' | rm /Users/elillesk/idl_stuff/flexera-sv/a*
	        //Applications/harris/idl88/bin/idl -e "save_image_cube_rfi_versions, $obs_id, '$output_folder', 'save_image_cube_rfi_grid_unflagged6'">& idl_stuff/idl_${obs_id}_unflagged6.out
	fi

    done < "$obs_id_list"
    
    
elif [ -n "$2" ]; then
    obs_id="$2"

    ((skip_counter++))
    
    if [ "$skip_cal" -eq 0 ]; then
    	if [ "$skip_counter" -gt "$skip_point" ]; then
		echo "Running calibration on: ${obs_id}"
		yes 'yes' | rm /Users/elillesk/idl_stuff/flexera/a*
		yes 'yes' | rm /Users/elillesk/idl_stuff/flexera-sv/a*
       		//Applications/harris/idl88/bin/idl -e "save_image_cube_rfi_versions, $obs_id, '$output_folder', 'save_image_cube_rfi_cal_fix1'">& idl_stuff/idl_${obs_id}_cal_fix1.out
        fi
    fi

    ((skip_counter++))
    if [ "$skip_counter" -gt "$skip_point" ]; then
       	echo "Running imaging on: ${obs_id}"
	yes 'yes' | rm /Users/elillesk/idl_stuff/flexera/a*
	yes 'yes' | rm /Users/elillesk/idl_stuff/flexera-sv/a*
        //Applications/harris/idl88/bin/idl -e "save_image_cube_rfi_versions, $obs_id, '$output_folder', 'save_image_cube_rfi_grid_unflagged6'">& idl_stuff/idl_${obs_id}_unflagged6.out
    fi

else
    echo "Error: Please provide either an obs_id list or a single obs_id."
    exit 1
fi

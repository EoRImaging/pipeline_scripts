#! /bin/bash
#$ -V
#$ -N Cube_integrator
#$ -S /bin/bash

#This script is an extra layer between Grid Engine and IDL commands because
#Grid Engine runs best on bash scripts.

#inputs needed: file_path_cubes, obs_list_path, version, chunk, nslots, evenodd, pol
#chunk is the chunk number when the list was broken up. 0 for "master" or only chunk

file_path_cubes=$1
obs_list_path=$2
version=$3
chunk=$4
#nslots=$5
#evenodd=$6
#pol=$7

parity_list=("even" "odd")
pol_list=("XX" "YY")

for evenodd in "${parity_list[@]}"; do
    for pol in "${pol_list[@]}"; do
        #Create a name for the obs txt file based off of inputs
        evenoddpol_file_paths=${file_path_cubes}/Healpix/${version}_int_chunk${chunk}_${evenodd}${pol}_list.txt
        #clear old file paths
        rm $evenoddpol_file_paths
        #***Fill the obs text file with the obsids to integrate
        nobs=0
        while read line
        do
        evenoddpol_file=${file_path_cubes}/Healpix/${line}_${evenodd}_cube${pol}.sav
        echo $evenoddpol_file >> $evenoddpol_file_paths
        ((nobs++))
        done < "$obs_list_path"
        #***
        
        unset int_pids
        
        #***If the integration has been split up into chunks, name the save file specifically off of that.
        if [ "$chunk" -gt "0" ]; then
        save_file_evenoddpol="$file_path_cubes"/Healpix/Combined_obs_${version}_int_chunk${chunk}_${evenodd}_cube${pol}.sav
        else
        save_file_evenoddpol="$file_path_cubes"/Healpix/Combined_obs_${version}_${evenodd}_cube${pol}.sav
        fi
        #***
        
        #***Run the integration IDL script
        //Applications/harris/idl88/bin/idl  -e integrate_healpix_cubes -args "$evenoddpol_file_paths" "$save_file_evenoddpol" &
        int_pids+=( $! )
        #***
        
        wait ${int_pids[@]} # Wait for integration to finish before making PS
    done
done

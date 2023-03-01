#! /bin/bash
#############################################################################
#Integrates healpix cubes in PBS scheduler.  Second level program for 
#running eppsilon on the NAOJ cluster. First level program is 
#ps_queue.sh
#############################################################################

#PBS -V
#PBS -N cube_int
#PBS -m n

#inputs needed: file_path_cubes, obs_list_path, version, chunk, ncores
# chunk is the chunk number when the list was broken up. 0 for "master" or only chunk

echo ${PBS_JOBID}

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
/usr/local/harris/idl88/bin/idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS $ncores -e integrate_healpix_cubes -args "$evenoddpol_file_paths" "$save_file_evenoddpol" &
int_pids+=( $! )
#***

wait ${int_pids[@]} # Wait for integration to finish before making PS

/usr/local/harris/idl88/bin/idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS $ncores -e integrate_healpix_cubes -args "$even_file_paths" "$save_file_even" &
int_pids+=( $! )
/usr/local/harris/idl88/bin/idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS $ncores -e integrate_healpix_cubes -args "$odd_file_paths" "$save_file_odd" &
int_pids+=( $! )
wait ${int_pids[@]} # Wait for integration to finish before making PS


#!/bin/bash

######################################################################################
# Top level script to integrate healpix cubes and run power spectrum code.
#
# A file path to the fhd directory is needed.
# 
# A file path to a text file listing observation ids OR preintegrated subcubes is
# needed.
# 
# If a text file of observation ids to be used in integration is specified, the obs 
# ids are assumed to be seperated by newlines.
#
# If a text file of preintegrated subcubes is specified, the format should be
# the name of the save file seperated by newlines.  "even_cube.sav" and "odd_cube.sav"
# is not necessary to include, as both will be used anyways.  The subcubes are
# assumed to be in <fhd_directory>/Healpix/. If elsewhere in the FHD directory, the 
# name of the subcubes must specify this in the text file as Other_than_Healpix/<name>.
#
# Set -ps to 1 to skip integration and make cubes only.
# 
# NOTE: print statements must be turned off in idl_startup file (e.g. healpix check)
######################################################################################

#Parse flags for inputs
while getopts ":d:f:p:w:n:m:o:l:h:t:" option
do
   case $option in
        d) FHDdir="$OPTARG";;			#file path to fhd directory with cubes
        f) integrate_list="$OPTARG";;		#txt file of obs ids or subcubes or a single obsid
        p) priority=$OPTARG;;           	#priority level for grid engine qsub
        w) wallclock_time=$OPTARG;;     	#Time for execution in grid engine
        n) ncores=$OPTARG;;             	#Number of slots for grid engine
        m) mem=$OPTARG;;                	#Memory per core for grid engine
	o) ps_only=$OPTARG;;			#Flag for skipping integration to make PS only
        l) legacy=$OPTARG;;                     #Use legacy directory structure. hacky solution to a silly problem.
        h) hold=$OPTARG;;                       #Hold for a job to finish before running. Useful when running immediately after firstpass
	t) tukey_filter=$OPTARG;;               #Apply a Tukey image window filter during eppsilon
        \?) echo "Unknown option: Accepted flags are -d (file path to fhd directory with cubes), -f (obs list or subcube path or single obsid), "
	    echo "-p (priority for grid engine), -w (wallclock time), -n (number of slots), -m (memory allocation), "
	    echo "-o (make ps only without integration), and -l (legacy flag for old file structure),"
	    echo "-h (hold int/ps script on a running job id), and -t (apply a tukey window filter during ps),"
            exit 1;;
        :) echo "Missing option argument for input flag"
           exit 1;;
   esac
done

#Manual shift to the next flag
shift $(($OPTIND - 1))

#Throw error if no file path to FHD directory
if [ -z ${FHDdir} ]
then
   echo "Need to specify a file path to a FHD directory with cubes: Example /nfs/complicated_path/fhd_mine/"
   exit 1
fi

#Throw error if file path does not exist
if [ ! -d "$FHDdir" ]
then
   echo "Argument after flag -d is not a real directory. Argument should be the file path to the location of cubes to integrate."
   exit 1
fi

#Remove extraneous / on FHD directory if present
if [[ $FHDdir == */ ]]; then FHDdir=${FHDdir%?}; fi

#Error if integrate_list is not set
if [ -z ${integrate_list} ]
then
    echo "Need to specify obs list file path or preintegrated subcubes list file path with option -f"
    exit 1
fi

#Warning if integrate list filename does not exist
if [ ! -e "$integrate_list" ]
then
    echo "Integrate list is either not a file or the file does not exist!"
    echo "Assuming the integrate list is a single observation id."

    if [ -z ${ps_only} ]
    then
        echo "ps_only flag must be set if integrate list is a single observation id. Set -o 1 if desired function"
        exit 1
    fi 
    version=$integrate_list  #Currently assuming that the integrate list is a single obsid
else
    version=$(basename $integrate_list) # get filename
    version="${version%.*}" # strip extension
fi

#Default priority if not set.
if [ -z ${priority} ]; then priority=0; fi

#Set typical wallclock_time for standard PS with obs ids if not set.
if [ -z ${wallclock_time} ]; then wallclock_time=10:00:00; fi

#Set typical slots needed for standard PS with obs ids if not set.
if [ -z ${ncores} ]; then ncores=1; fi

#Set typical memory needed for standard PS with obs ids if not set.
if [ -z ${mem} ]; then mem=25G; fi

#Set default to do integration
if [ -z ${ps_only} ]; then ps_only=0; fi

#Set default to use current file structure
if [ -z ${legacy} ]; then legacy=0; fi

# create hold string
if [ -z ${hold} ]; then hold_str=""; else hold_str="--dependency=afterok:${hold}"; fi

# create hold string
if [[ -n ${tukey_filter} ]]; then tukey_filter="Blackman-Harris"; fi

### NOTE this only works if idlstartup doesn't have any print statements (e.g. healpix check)
PSpath=$(idl -e 'print,rootdir("eppsilon")')

#Versions made during integrate list logic check above
echo Version is $version

if [ ! -e "$integrate_list" ]
then
    first_line=$integrate_list
else
    first_line=$(head -n 1 $integrate_list)
fi

first_line_len=$(echo ${#first_line})

rm -f ${FHDdir}/Healpix/${version}_int_chunk*.txt # remove any old chunk files lying around

exit_flag=0

#Check that cubes or integrated cubes are present, print and error if they are not
if [ "$ps_only" -ne "1" ]; then 	#only if we're integrating
while read line
do
   if [ "$first_line_len" == 10 ]; then
      if [ "$legacy" -ne "1" ]; then
	  if ! ls $FHDdir/Healpix/$line*cube*.sav &> /dev/null; then
              echo Missing cube for obs $line
	      if [ -z "$hold" ]; then
		  exit_flag=1
	      fi
	  fi
      pol_files=$(($(ls $FHDdir/Healpix/$line*cube*.sav | wc -l) / 2))
      if [[ "$pol_files" -eq 2 ]]; then 
          n_pol=2; else
              if [[ "$pol_files" -eq 4 ]]; then
                  n_pol=4; else 
                      echo Non-standard amount of cubes per obs $line
                      exit_flag=1
              fi
      fi 
      else
	  if ! ls $FHDdir/$line*cube*.sav &> /dev/null; then
	      echo Missing cube for obs $line
	      exit_flag=1
	  fi
      fi
   else
      if [[ "$first_line" != */* ]]; then
	 check=$FHDdir/Healpix/$line*.sav
      else
	 check=$FHDdir/$line*.sav
      fi
      if ! ls $check &> /dev/null; then
	    echo Missing save file for $line
	    exit_flag=1
      fi
   fi
done < $integrate_list
fi

if [ "$exit_flag" -eq 1 ]; then exit 1; fi

if [ "$first_line_len" == 10 ]; then
    
    # read in obs ids 100 at a time and divide into chunks to integrate in parallel mode
    obs=0   

    while read line
    do
        ((chunk=obs/100+1))		#integer division results in chunks labeled 0 (first 100), 1 (second 100), etc
        echo $line >> ${FHDdir}/Healpix/${version}_int_chunk${chunk}.txt	#put that obs id into the right txt file
        ((obs++))			#increment obs for the next run through
    done < $integrate_list
    nchunk=$chunk 			#number of chunks we ended up with

else

    if [[ "$first_line" != */* ]]; then
   
        chunk=0 
        while read line
        do
            echo $line >> ${FHDdir}/Healpix/${version}_int_chunk${chunk}.txt        #put that obs id into the right txt file
        done < $integrate_list
        nchunk=$chunk                       #number of chunks we ended up with
    
    else

        chunk=0 
        while read line
        do
            echo $line >> ${FHDdir}/Healpix/${version}_int_chunk${chunk}.txt        #put that obs id into the right txt file
        done < $integrate_list
        nchunk=$chunk                       #number of chunks we ended up with

    fi

fi

if [[ "$n_pol" -eq 2 ]]; then pol_list=( XX YY );fi
if [[ "$n_pol" -eq 4 ]]; then pol_list=( XX YY XY YX );fi

unset idlist
if [ "$ps_only" -ne "1" ]; then   
    if [ "$nchunk" -gt "1" ]; then

        # set up files for master integration
        sub_cubes_list=${FHDdir}/Healpix/${version}_sub_cubes.txt
        rm $sub_cubes_list # remove any old lists

        # launch separate chunks
        for chunk in $(seq 1 $nchunk); do
	    chunk_obs_list=${FHDdir}/Healpix/${version}_int_chunk${chunk}.txt
	    outfile=${FHDdir}/Healpix/${version}_int_chunk${chunk}_out.log
	    errfile=${FHDdir}/Healpix/${version}_int_chunk${chunk}_err.log
	    for evenodd in even odd; do
		for pol in ${pol_list[@]}; do 
		    message=$(sbatch ${hold_str} --mem=$mem -t ${wallclock_time} -n ${ncores} --export=file_path_cubes=$FHDdir,obs_list_path=$chunk_obs_list,version=$version,chunk=$chunk,ncores=$ncores,legacy=$legacy,evenodd=$evenodd,pol=$pol -e $errfile -o $outfile ${PSpath}../pipeline_scripts/bash_scripts/ozstar/integrate_slurm_job.sh)
	    	    message=($message)
	    	    if [ "$chunk" -eq 1 ] && [[ "$evenodd" = "even" ]] && [[ "$pol" = "XX" ]]; then idlist=${message[3]}; else idlist=${idlist}:${message[3]}; fi
		done
	    done
	    echo Combined_obs_${version}_int_chunk${chunk} >> $sub_cubes_list # trick it into finding our sub cubes
        done

        # master integrator
        chunk=0
        outfile=${FHDdir}/Healpix/${version}_int_chunk${chunk}_out.log
        errfile=${FHDdir}/Healpix/${version}_int_chunk${chunk}_err.log
	for evenodd in even odd; do
	    for pol in ${pol_list[@]}; do
                message=$(sbatch --dependency=afterok:$idlist --mem=$mem -t $wallclock_time -n $ncores --export=file_path_cubes=$FHDdir,obs_list_path=$sub_cubes_list,version=$version,chunk=$chunk,ncores=$ncores,legacy=$legacy,evenodd=$evenodd,pol=$pol -e $errfile -o $outfile ${PSpath}../pipeline_scripts/bash_scripts/ozstar/integrate_slurm_job.sh)
        	message=($message)
		if [[ "$evenodd" = "even" ]] && [[ "$pol" = "XX" ]]; then idlist_master=${message[3]}; else idlist_master=${idlist_master}:${message[3]}; fi
	    done
	done
	hold_str="--dependency=afterok:${idlist_master}"

    else

        # Just one integrator
        mv ${FHDdir}/Healpix/${version}_int_chunk1.txt ${FHDdir}/Healpix/${version}_int_chunk0.txt
        chunk=0
        chunk_obs_list=${FHDdir}/Healpix/${version}_int_chunk${chunk}.txt
        outfile=${FHDdir}/Healpix/${version}_int_chunk${chunk}_out.log
        errfile=${FHDdir}/Healpix/${version}_int_chunk${chunk}_err.log
	for evenodd in even odd; do
	    for pol in ${pol_list[@]}; do
                message=$(sbatch ${hold_str} --mem=$mem -t ${wallclock_time} -n ${ncores} --export=file_path_cubes=$FHDdir,obs_list_path=$chunk_obs_list,version=$version,chunk=$chunk,ncores=$ncores,legacy=$legacy,evenodd=$evenodd,pol=$pol -e $errfile -o $outfile ${PSpath}../pipeline_scripts/bash_scripts/ozstar/integrate_slurm_job.sh)
       		message=($message)
		if [[ "$evenodd" = "even" ]] && [[ "$pol" = "XX" ]]; then idlist_int=${message[3]}; else idlist_int=${idlist_int}:${message[3]}; fi
	    done
	done
        hold_str="--dependency=afterok:${idlist_int}"
    fi
else
    echo "Running only ps code" # Just PS if flag has been set
fi

outfile=${FHDdir}/ps/logs/${version}_ps_out
errfile=${FHDdir}/ps/logs/${version}_ps_err


mkdir -p ${FHDdir}/ps/logs
mkdir -p ${FHDdir}/ps/data/uvf_cubes
mkdir -p ${FHDdir}/ps/data/kspace_cubes
mkdir -p ${FHDdir}/ps/data/2d_binning
mkdir -p ${FHDdir}/ps/data/1d_binning

mkdir -p ${FHDdir}/ps/plots/slices
mkdir -p ${FHDdir}/ps/plots/2d_binning
mkdir -p ${FHDdir}/ps/plots/1d_binning

if [[ "$n_pol" -eq 2 ]]; then pol_list=( xx yy );fi
if [[ "$n_pol" -eq 4 ]]; then pol_list=( xx yy xy yx );fi

evenodd_list=( even odd )
cube_type_list=( weights dirty model res )

pipe_path='../pipeline_scripts/bash_scripts/ozstar/'
hold_str_cubes=$hold_str

for pol in ${pol_list[@]}; do
    for evenodd in ${evenodd_list[@]}; do
        evenodd_initial="$(echo $evenodd | head -c 1)"
        for cube_type in ${cube_type_list[@]}; do
	    if [ "$cube_type" == "weights" ]; then hold_str_cubes=$hold_str; fi
            message=$(sbatch ${hold_str_cubes} --mem=$mem -t ${wallclock_time} -n ${ncores} --export=file_path_cubes=$FHDdir,obs_list_path=$integrate_list,version=$version,ncores=$ncores,cube_type=$cube_type,pol=$pol,evenodd=$evenodd,image_filter_name=$tukey_filter -e ${errfile}_${pol}_${evenodd}_${cube_type}.log -o ${outfile}_${pol}_${evenodd}_${cube_type}.log -J PS_${pol}${evenodd_initial}_${cube_type} ${PSpath}${pipe_path}PS_list_slurm_job.sh)
            message=($message)
            if [ "$cube_type" == "weights" ]; then hold_str_cubes="--dependency=afterok:${message[3]}"; fi
                if [ "$cube_type" == "weights" ]; then
                    if [ "$evenodd" == "even" ]; then
                        if [ "$pol" == "XX" ]; then
                            id_list=${message[3]}
                            else id_list=${id_list}:${message[3]}
                        fi
                        else id_list=${id_list}:${message[3]}
                    fi
                    else id_list=${id_list}:${message[3]}
                fi
        done
    done
done

#final plots
if [[ -n ${tukey_filter} ]]; then plot_walltime=1:00:00; else plot_walltime=00:20:00; fi
sbatch --dependency=afterok:$id_list --mem=$mem -t ${wallclock_time} -n ${ncores} --export=file_path_cubes=$FHDdir,obs_list_path=$integrate_list,version=$version,ncores=$ncores,image_filter_name=$tukey_filter -e ${errfile}_plots.log -o ${outfile}_plots.log -J PS_plots ${PSpath}${pipe_path}PS_list_slurm_job.sh

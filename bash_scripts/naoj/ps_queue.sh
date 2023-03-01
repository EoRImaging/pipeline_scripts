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



Help()
{
   # Display Help
   echo "Script to submit eppsilon integration and image dft + power spectrum analysis into the NAOJ queue"
   echo "All binary options require a 1 to be passed to be activated, i.e. -o 1"
   echo
   echo "Syntax: nohup ./ps_slurm.sh [-d -f -p -w -n -m -s -o -i -l -p -H] >> ~/log.txt &"
   echo "options:"
   echo "-d (file path to fhd directory which contains a Healpix directory with cubes, required),"
   echo "-f (text file with observation list or subcube path or single obsid, required), "
   echo "-p (number of instrumental polarizations (2 for XX,YY, 4 for XX,YY,XY,YX), default:2), "
   echo "-w (wallclock time, default:10:00:00), "
   echo "-n (number of slots, default:1), "
   echo "-m (memory allocation, default:15gb), "
   echo "-o (skip integration and run image dft with power spectrum analysis, optional), " 
   echo "-i (run integration only and skip image dft with power spectrum analysis, optional),"
   echo "-s (skip integration and image dft and only run with power spectrum analysis, optional),"
   echo "-q (queue, default:q4)." 
   echo "-H (hold int/ps script on a running job id, optional)"
   echo
}


#Parse flags for inputs
while getopts ":d:f:p:w:n:m:s:o:i:l:q:H:h" option
do
   case $option in
        d) FHDdir="$OPTARG";;			#file path to fhd directory with cubes
        f) integrate_list="$OPTARG";;		#txt file of obs ids or subcubes or a single obsid
        p) n_pol=$OPTARG;;           	#number of polarizations to process
        w) wallclock_time=$OPTARG;;     	#Time for execution in grid engine
        n) ncores=$OPTARG;;             	#Number of slots for grid engine
        m) mem=$OPTARG;;                	#Memory per core for grid engine
        s) wrapper_only=$OPTARG;;               #Flag for skipping integration and DFT's to the ps_wrapper step
	o) ps_only=$OPTARG;;			#Flag for skipping integration to make PS only
        i) int_only=$OPTARG;;                   #Flag for skipping PS to make integration only
        l) legacy=$OPTARG;;                     #Use legacy directory structure. hacky solution to a silly problem.
        q) queue=$OPTARG;;                      #Queue to run on 
        H) hold=$OPTARG;;                       #Hold for a job to finish before running. Useful when running immediately after firstpass
        h) Help
           exit 1;;
        \?) echo "Unknown option. Please review accepted flags."
            Help
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
if [ -z ${n_pol} ]; then n_pol=2; fi

#Set typical wallclock_time for standard PS weights cubes
if [ -z ${wallclock_time} ]; then wallclock_time=10:00:00; fi

#Set typical wallclock time for dirty,model,residual cubes
IFS=':' #delimeter
read -ra hms <<< "$wallclock_time" #split wallclock time
hms[0]=$(($hms / 2)) #divide just the hours (first dim) in half to get estimate
IFS=' ' #reset delimeter
wallclock_time_half=$(printf ":%s" "${hms[@]}") #concatonate string
wallclock_time_half="${wallclock_time_half:1}"

#Set typical slots needed for standard PS with obs ids if not set.
if [ -z ${ncores} ]; then ncores=1; fi

#Set typical memory needed for standard PS with obs ids if not set.
if [ -z ${mem} ]; then mem=15G; fi

#Set queue for NAOJ
if [ -z ${queue} ]; then
    queue=q4
fi

#Set default to do integration
if [ -z ${ps_only} ]; then ps_only=0; fi

#Set default to do integration
if [ -z ${int_only} ]; then int_only=0; fi

#Set default to do integration
if [ -z ${wrapper_only} ]; then wrapper_only=0; fi

#Set default to use current file structure
if [ -z ${legacy} ]; then legacy=0; fi

# create hold string
if [ -z ${hold} ]; then hold_str=""; else hold_str="-W depend=afterok:${hold}"; fi

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
if [ "$ps_only" -ne "1" ] && [ "$wrapper_only" -ne "1" ]; then 	#only if we're integrating
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
		      if  [ -z ${hold} ]; then 
                           exit_flag=1; else
                                n_pol=2
                      fi
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
if [ "$ps_only" -ne "1" ] && [ "$wrapper_only" -ne "1" ]; then   
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
		    message=$(qsub ${hold_str} -q $queue -l ncpus=${ncores},mem=$mem,walltime=${wallclock_time} -V -v file_path_cubes=$FHDdir,obs_list_path=$chunk_obs_list,version=$version,chunk=$chunk,ncores=$ncores,evenodd=$evenodd,pol=$pol -e $errfile -o $outfile ./integrate_job.sh)
	    	    message=($message)
	    	    if [ "$chunk" -eq 1 ] && [[ "$evenodd" = "even" ]] && [[ "$pol" = "XX" ]]; then idlist=${message[0]}; else idlist=${idlist}:${message[0]}; fi
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
		message=$(qsub -W depend=afterok:${id_list} -q $queue -l ncpus=${ncores},mem=$mem,walltime=${wallclock_time} -V -v file_path_cubes=$FHDdir,obs_list_path=$sub_cubes_list,version=$version,chunk=$chunk,ncores=$ncores,evenodd=$evenodd,pol=$pol -e $errfile -o $outfile ./integrate_job.sh)
        	message=($message)
		if [[ "$evenodd" = "even" ]] && [[ "$pol" = "XX" ]]; then idlist_master=${message[0]}; else idlist_master=${idlist_master}:${message[0]}; fi
	    done
	done
	hold_str="-W depend=afterok:${idlist_master}"

    else

        # Just one integrator
        mv ${FHDdir}/Healpix/${version}_int_chunk1.txt ${FHDdir}/Healpix/${version}_int_chunk0.txt
        chunk=0
        chunk_obs_list=${FHDdir}/Healpix/${version}_int_chunk${chunk}.txt
        outfile=${FHDdir}/Healpix/${version}_int_chunk${chunk}_out.log
        errfile=${FHDdir}/Healpix/${version}_int_chunk${chunk}_err.log
	for evenodd in even odd; do
	    for pol in ${pol_list[@]}; do
                message=$(qsub ${hold_str} -q $queue -l ncpus=${ncores},mem=$mem,walltime=${wallclock_time} -V -v file_path_cubes=$FHDdir,obs_list_path=$chunk_obs_list,version=$version,chunk=$chunk,ncores=$ncores,evenodd=$evenodd,pol=$pol -e $errfile -o $outfile ./integrate_job.sh)
       		message=($message)
		if [[ "$evenodd" = "even" ]] && [[ "$pol" = "XX" ]]; then idlist_int=${message[0]}; else idlist_int=${idlist_int}:${message[0]}; fi
	    done
	done
        hold_str="-W depend=afterok:${idlist_int}"
    fi
else
    echo "Running only ps code" # Just PS if flag has been set
fi

if [ "$int_only" -eq "1" ]; then
    echo "Running only int code" 
    exit 1
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

if [ "$wrapper_only" -ne "1" ]; then
hold_str_cubes=$hold_str
echo $hold_str_cubes
for pol in ${pol_list[@]}; do
    for evenodd in ${evenodd_list[@]}; do
        evenodd_initial="$(echo $evenodd | head -c 1)"
        for cube_type in ${cube_type_list[@]}; do
	    if [ "$cube_type" == "weights" ]; then hold_str_cubes=$hold_str; fi
            if [ "$cube_type" != "weights" ]; then wallclock_time_use=$wallclock_time_half; else wallclock_time_use=$wallclock_time; fi
            message=$(qsub ${hold_str_cubes} -q $queue -l ncpus=${ncores},mem=$mem,walltime=${wallclock_time_use} -V -v file_path_cubes=$FHDdir,obs_list_path=$integrate_list,version=$version,ncores=$ncores,cube_type=$cube_type,pol=$pol,evenodd=$evenodd -e $errfile_${pol}_${evenodd}_${cube_type}.log -o $outfile_${pol}_${evenodd}_${cube_type}.log -N PS_${pol}${evenodd_initial}_${cube_type} ./PS_list_job.sh)
            message=($message)
            if [ "$cube_type" == "weights" ]; then hold_str_cubes="-W depend=afterok:${message[0]}"; fi
                if [ "$cube_type" == "weights" ]; then
                    if [ "$evenodd" == "even" ]; then
                        if [ "$pol" == "xx" ]; then
                            id_list=${message[0]}
                            else id_list=${id_list}:${message[0]}
                        fi
                        else id_list=${id_list}:${message[0]}
                    fi
                    else id_list=${id_list}:${message[0]}
                fi
        done
    done
done
hold_str="-W depend=afterok:$id_list"
else
    hold_str=""
fi

#final plots
plot_walltime=00:30:00
if [[ -n ${wrapper_only} ]]; then plot_walltime=$wallclock_time; fi
qsub $hold_str -q $queue -l mem=$mem,walltime=${plot_walltime},ncpus=1 -V -v file_path_cubes=$FHDdir,obs_list_path=$integrate_list,version=$version,ncores=1 -e ${errfile}_plots.log -o ${outfile}_plots.log -N PS_plots ./PS_list_job.sh

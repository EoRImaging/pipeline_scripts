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
# Written by N. Barry 
#
######################################################################################

#Parse flags for inputs
while getopts ":d:f:n:p:h:i:q:" option
do
   case $option in
        d) FHDdir="$OPTARG";;			#file path to fhd directory with cubes
        f) integrate_list="$OPTARG";;		#txt file of obs ids or subcubes or a single obsid
        n) nslots=$OPTARG;;             	#Number of slots for grid engine
	p) ps_only=$OPTARG;;			#Flag for skipping integration to make PS only
        h) hold=$OPTARG;;                       #Hold for a job to finish before running. Useful when running immediately after firstpass
	i) image_filter=$OPTARG;;               #Apply an image window filter during eppsilon
	q) ps_plots_only=$OPTARG;;		#Submit only a PS_plots job with no individual cube DFTs
        \?) echo "Unknown option: Accepted flags are -d (file path to fhd directory with cubes), -f (obs list or subcube path or single obsid), "
	    echo "-n (number of slots), -p (make ps only), -q (submit PS_plots only)"
	    echo "-h (hold int/ps script on a running job id), and -i (apply a window filter during ps),"
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

#Remove extraneous / on FHD directory if present
if [[ $FHDdir == */ ]]; then FHDdir=${FHDdir%?}; fi

aws s3 ls ${FHDdir}
if [[ $? -ne 0 ]]; then
  echo "FHDdir does not exist"
  exit 1
fi

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

#Set typical slots needed for standard PS with obs ids if not set.
if [ -z ${nslots} ]; then nslots=10; fi

#Set default to do integration
if [ -z ${ps_only} ]; then ps_only=0; fi

# create hold string
if [ -z ${hold} ]; then hold_str=""; else hold_str="-hold_jid ${hold}"; fi

# image filter
if [[ -n ${image_filter} ]]; then 
    case $image_filter in
        "Blackman-Harris") image_letters="bh_" ;;
        "Blackman-Harris^2") image_letters="bh2_" ;;
        "Blackman-Nutall") image_letters="bn_" ;;
        "Blackman") image_letters="blm_" ;;
        "Hann") image_letters="han_" ;;
        "Hamming") image_letters="ham_" ;;
        "Nutall") image_letters="ntl_" ;;
        "Tukey") image_letters="tk_" ;;
	"None") image_letters="" ;;
        *) image_filter="Blackman-Harris"; image_letters="bh_" ;;
    esac
fi

PSpath='~/MWA/eppsilon/'

#Versions made during integrate list logic check above
echo Version is $version

if [ ! -e "$integrate_list" ]
then
    first_line=$integrate_list
else
    first_line=$(head -n 1 $integrate_list)
fi

first_line_len=$(echo ${#first_line})

#create Healpix download location with full permissions
if [ -d /Healpix ]; then
    sudo chmod -R 777 /Healpix
    rm -f /Healpix/${version}_int_chunk*.txt # remove any old chunk files lying around
else
    sudo mkdir -m 777 /Healpix
fi

if [ "$first_line_len" == 10 ]; then
    
    obs=0   

    while read line
    do
        ((chunk=obs/20+1))		#integer division results in chunks labeled 0 (first 100), 1 (second 100), etc
        echo $line >> /Healpix/${version}_int_chunk${chunk}.txt	#put that obs id into the right txt file
        ((obs++))			#increment obs for the next run through
    done < $integrate_list
    nchunk=$chunk 			#number of chunks we ended up with

else

    if [[ "$first_line" != */* ]]; then
   
        chunk=0 
        while read line
        do
            echo $line >> /Healpix/${version}_int_chunk${chunk}.txt        #put that obs id into the right txt file
        done < $integrate_list
        nchunk=$chunk                       #number of chunks we ended up with
    
    else

        chunk=0 
        while read line
        do
            echo $line >> /Healpix/${version}_int_chunk${chunk}.txt        #put that obs id into the right txt file
        done < $integrate_list
        nchunk=$chunk                       #number of chunks we ended up with

    fi

fi

outfile=~/grid_out
errfile=~/grid_out

unset idlist
if [ "$ps_only" -ne "1" ]; then   
    if [ "$nchunk" -gt "1" ]; then

        # set up files for master integration
        sub_cubes_list=/Healpix/${version}_sub_cubes.txt
        rm $sub_cubes_list # remove any old lists

        # launch separate chunks
        for chunk in $(seq 1 $nchunk); do
	    chunk_obs_list=/Healpix/${version}_int_chunk${chunk}.txt
            readarray chunk_obs_array < $chunk_obs_list
	    chunk_obs_array=$( IFS=$':'; echo "${chunk_obs_array[*]}" ) #qsub can't take arrays
	    
            for evenodd in even odd; do
		for pol in XX YY; do 
	    	    message=$(qsub ${hold_str} -V -b y -v file_path_cubes=$FHDdir,obs_list_array="$chunk_obs_array",obs_list_path=$chunk_obs_list,version=$version,chunk=$chunk,nslots=$nslots,legacy=$legacy,evenodd=$evenodd,pol=$pol -e $errfile -o $outfile -N int_c_${version} -pe smp $nslots -sync y integration_job_aws.sh)
	    	    message=($message)
		done
	    done
	    echo Combined_obs_${version}_int_chunk${chunk} >> $sub_cubes_list # trick it into finding our sub cubes
        done

        idlist_int_chunks=(`qstat | grep "int_c_" | cut -b -7`)
	idlist_int_chunks=$( IFS=$','; echo "${idlist_int_chunks[*]}" )
	hold_str="-hold_jid ${idlist_int_chunks}"

        # master integrator
        chunk=0
        readarray chunk_obs_array < $sub_cubes_list
	chunk_obs_array=$( IFS=$':'; echo "${chunk_obs_array[*]}" ) #qsub can't take arrays
	
        for evenodd in even odd; do
	    for pol in XX YY; do 
	    	message=$(qsub ${hold_str} -V -b y -v file_path_cubes=$FHDdir,obs_list_array="$chunk_obs_array",obs_list_path=$sub_cubes_list,version=$version,chunk=$chunk,nslots=$nslots,legacy=$legacy,evenodd=$evenodd,pol=$pol -e $errfile -o $outfile -N int_m_${version} -pe smp $nslots -sync y integration_job_aws.sh)
        	message=($message)
	    done
	done

        idlist_int_master=(`qstat | grep "int_m_" | cut -b -7`)
	idlist_int_master=$( IFS=$','; echo "${idlist_int_master[*]}" )
	hold_str="-hold_jid ${idlist_int_master}"


    else

        # Just one integrator
        mv /Healpix/${version}_int_chunk1.txt /Healpix/${version}_int_chunk0.txt
        chunk=0
        chunk_obs_list=/Healpix/${version}_int_chunk${chunk}.txt
        readarray chunk_obs_array < $chunk_obs_list
	chunk_obs_array=$( IFS=$':'; echo "${chunk_obs_array[*]}" ) #qsub can't take arrays
	
        for evenodd in even odd; do
	    for pol in XX YY; do
        	message=$(qsub ${hold_str} -V -b y -v file_path_cubes=$FHDdir,obs_list_array="$chunk_obs_array",obs_list_path=$chunk_obs_list,version=$version,chunk=$chunk,nslots=$nslots,legacy=$legacy,evenodd=$evenodd,pol=$pol -e $errfile -o $outfile -N int_${version} -pe smp $nslots -sync y integration_job_aws.sh)
       		message=($message)
	    done
	done

        idlist_int=(`qstat | grep "int_" | cut -b -7`)
        hold_str="-hold_jid ${idlist_int}"

    fi
else
    echo "Running only ps code" # Just PS if flag has been set
fi


if [ ! -d /ps ]; then
    sudo mkdir /ps
fi
if [ ! -d /ps/logs ]; then
    sudo mkdir /ps/logs
fi

#outfile=/ps/logs/${version}_ps_out
#errfile=/ps/logs/${version}_ps_err
outfile=~/grid_out
errfile=~/grid_out

###Polarization definitions
pol_arr=('xx' 'yy')
n_pol=${#pol_arr[@]}

###Evenodd definitions
evenodd_arr=('even' 'odd')
n_evenodd=${#evenodd_arr[@]}

###Cube definitions
cube_type_arr=('weights' 'dirty' 'model')
n_cube=${#cube_type_arr[@]}

readarray integrate_array < $integrate_list
integrate_array=$( IFS=$':'; echo "${integrate_array[*]}" ) #qsub can't take arrays

hold_str_int=$hold_str
unset id_list
unset pids

if [ -z ${ps_plots_only} ]; then

    for pol in "${pol_arr[@]}"
    do
        for evenodd in "${evenodd_arr[@]}"
        do
            for cube_type in "${cube_type_arr[@]}"
            do
                if [ $cube_type = "weights" ]
                then
                    hold_str_temp=$hold_str_int
                else
                    hold_str_temp="-hold_jid ${weights_id}"
                fi

                cube_type_letter=${cube_type:0:1}

                message=$(qsub ${hold_str_temp} -V -b y -cwd -v file_path_cubes=$FHDdir,obs_list_path=$integrate_list,obs_list_array="$integrate_array",version=$version,nslots=$nslots,cube_type=$cube_type,pol=$pol,evenodd=$evenodd,image_filter_name=$image_filter,image_letters=$image_letters -e ${errfile} -o ${outfile} -N ${cube_type_letter}_${pol}_${evenodd} -pe smp $nslots -sync y eppsilon_job_aws.sh)
                message=($message)

                if [ ! -z "$pids" ]; then pids="$!"; else pids=($pids "$!"); fi
                job_id=(`qstat | grep "${cube_type_letter}_${pol}_${evenodd}" | cut -b -7`)
                if [ -z "$id_list" ]; then id_list=${job_id};else id_list=${id_list},${job_id};fi

                if [ $cube_type = "weights" ]
                then
                    weights_id=$job_id
                fi
            done
        done
    done

fi

#final plots
qsub -hold_jid $id_list -V -v file_path_cubes=$FHDdir,obs_list_path=$integrate_list,obs_list_array="$integrate_array",version=$version,nslots=$nslots,image_filter_name=$image_filter,image_letters=$image_letters -e ${errfile} -o ${outfile} -N PS_plots -pe smp $nslots -sync y eppsilon_job_aws.sh



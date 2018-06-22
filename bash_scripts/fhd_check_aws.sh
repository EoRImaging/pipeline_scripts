#!/bin/bash

######################################################################################
# Top level script to check end-product outputs from FHD run.
#
# A file path to the fhd directory is needed.
# 
# A file path to a text file listing observation ids is needed. Obs ids are
# assumed to be seperated by newlines.
# 
# Written by Nichole Barry
#
# NOTE 
# print statements must be turned off in idl_startup file (e.g. healpix check)
######################################################################################

#Parse flags for inputs
while getopts ":d:f:e:p:m:" option
do
   case $option in
        d) FHDdir="$OPTARG";;			      #file path to fhd directory with cubes
        f) check_list="$OPTARG";;		#txt file of obs ids or subcubes or a single obsid
        e) evenodd="$OPTARG";;          #OPTIONAL: array of even-odd names
        p) pol="$OPTARG";;              #OPTIONAL: array of pol names
	m) min_size="$OPTARG";;         #OPTIONAL: min size of HEALPix cubes, in B
        \?) echo "Unknown option: Accepted flags are -d (file path to fhd directory with cubes), "
            echo "-f (obs list), -e (array of even-odd), -p (array of pol)"
            exit 1;;
        :) echo "Missing option argument for input flag"
           exit 1;;
   esac
done

#Manual shift to the next flag
shift $(($OPTIND - 1))

###########Check inputs
#Throw error if no file path to FHD directory
if [ -z ${FHDdir} ]
then
   echo "Need to specify a file path to a FHD directory with cubes: Example /nfs/complicated_path/fhd_mine/"
   exit 1
fi

#Remove extraneous / on FHD dir if present
if [[ $FHDdir == */ ]]
then 
   FHDdir=${FHDdir%?}
fi

#Error if check_list is not set
if [ -z ${check_list} ]
then
    echo "Need to specify obs list file path with option -f"
    exit 1
fi

#Default evenodd if not set.
if [ -z ${evenodd} ]
then
    evenodd=(even odd)
fi

#Default evenodd if not set.
if [ -z ${pol} ]
then
    pol=(XX YY)
fi

#Default evenodd if not set.
if [ -z ${min_size} ]
then 
    min_size=4500000000
fi
############End of check inputs

n_evenodd=${#evenodd[@]}
n_pol=${#pol[@]}
num_files=$(($n_evenodd * $n_pol))

#aws s3 ls command cannot use wildcards, hence this workaround  - 3/2018
ls_output_size=( $(aws s3 ls ${FHDdir}/Healpix/ | tr -s ' ' | cut -d' ' -f3) )
ls_output_filename=( $(aws s3 ls ${FHDdir}/Healpix/ | tr -s ' ' | cut -d' ' -f4) )

#Check that the size of the Healpix cubes are greater than the min
i=0
unset miss_flag
for file_size in "${ls_output_size[@]}"
do
    if [[ $file_size -lt "$min_size" ]]
    then
        if [ -z ${miss_flag} ]
        then
            echo HEALPix cubes smaller than specified min_size:
            miss_flag=1
        fi
        echo ${ls_output_filename[$i]}
    fi
    (( ++i ))
done

#Check that all Healpix cubes are present, print if they are not
unset miss_flag
while read line
do
    if [[ "$(grep -o $line <<< ${ls_output_filename[*]} | wc -l)" -ne "$num_files" ]]
    then
        if [ -z ${miss_flag} ]
        then
            echo Some HEALPix cubes are missing:
            miss_flag=1
        fi
        echo $line
    fi
done < $check_list

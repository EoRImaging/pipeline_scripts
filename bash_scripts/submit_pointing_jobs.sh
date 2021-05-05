#!/bin/bash

while getopts ":v:i:c:p:n:" option
do
   case $option in
           v) version=$OPTARG;;
           i) indir=$OPTARG;;
	   c) clean=$OPTARG;;
	   p) pointings=$OPTARG;;
	   n) integrate=$OPTARG;;
           :) echo "Missing option for input flag"
              exit 1
   esac
done

shift $(($OPTIND - 1))

if [ -z $pointings ]; then
    pointings="minus_two minus_one zenith plus_one plus_two"
fi

if [ -z $integrate ]; then
    integrate=1
fi

echo "clean is $clean"

for pointing in $pointings
do
    if [ $clean -eq 1 ]; then
        obsfile=${indir}/${version}_${pointing}_clean.txt
    else
        obsfile=${indir}/${version}_${pointing}.txt
    fi
    if [ -f $obsfile ]; then
        num_obs=$(wc -l ${obsfile} | tr -s ' ' | cut -f 1 -d ' ')
	nslots=$((${num_obs} / 4 + 1))
	bash run_eppsilon_az.sh -d https://mwadata.blob.core.windows.net/fhd/mike_thesis/thesis_run/fhd_Wilensky_thesis_image -f ${obsfile} -v ${version}_${pointing} -n 8 -i $integrate -c 1 -p 1 -q htc -o 1 
    fi
done

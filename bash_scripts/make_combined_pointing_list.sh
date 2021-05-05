#!/bin/bash

while getopts ":v:i:o::" option
do
   case $option in
	   v) version=$OPTARG;;
	   i) indir=$OPTARG;;
	   o) outdir=$OPTARG;;
	   :) echo "Missing option for input flag"
	      exit 1
   esac
done

shift $(($OPTIND - 1))

pointings="minus_two minus_one zenith plus_one plus_two"

if [ -z $outdir ]; then
    outdir=${indir}
fi

outfile=${outdir}/${version}_all_pointings_submit.txt
clean_outfile=${outdir}/${version}_all_pointings_clean_submit.txt

for pointing in $pointings
do
    obsfile=${indir}/${version}_${pointing}.txt
    clean_obsfile=${indir}/${version}_${pointing}_clean.txt
    if [ -f $obsfile ]; then 
	healpix_name="Combined_obs_${version}_${pointing}"
	clean_healpix_name="Combined_obs_${version}_${pointing}_clean"
	echo $healpix_name >> $outfile
	echo $clean_healpix_name >> $clean_outfile
    fi
done

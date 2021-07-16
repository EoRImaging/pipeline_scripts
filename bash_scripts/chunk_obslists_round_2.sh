#!/bin/bash

indir="/shared/home/mwilensky/obslists/thesis_jackknife/final_jackknife"
file_path_cubes="https://mwadata.blob.core.windows.net/fhd/mike_thesis/thesis_run/fhd_Wilensky_thesis_image"

cd $indir

for pointing in minus_two minus_one zenith plus_one plus_two
do
  for clean in 0 1
  do
    if [ $clean -eq 1 ]; then
      clean_tag="_clean"
    else
      clean_tag=""
    fi
    for z_band in 3_5 5_10 10_100
    do
      for shape in narrow all_TV all_RFI_types streak
      do
        filename="2014_iono_cut_z_band_${z_band}_${shape}_${pointing}${clean_tag}_chunk_list.txt"
        version="2014_iono_cut_z_band_${z_band}_${shape}_${pointing}${clean_tag}"
        bash run_eppsilon_az.sh -d ${file_path_cubes} -f ${indir}/${filename} -v ${version} -n 8 -i 1 -c 1 -p 1 -q htc -o 1
      done
    done
  done
done

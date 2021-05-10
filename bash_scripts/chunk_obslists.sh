#!/bin/bash

cd /shared/home/mwilensky/obslists/thesis_jackknife/final_jackknife
file_path_cubes="https://mwadata.blob.core.windows.net/fhd/mike_thesis/thesis_run/fhd_Wilensky_thesis_image"

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
        filename="2014_iono_cut_z_band_${z_band}_${shape}_${pointing}${clean_tag}.txt"
      	num_lines=$(wc -l $filename | cut -f 1 -d ' ')
      	echo $num_lines
      	if [ -f $filename ]; then
          if [ $num_lines -gt 20 ]; then
            bn=$(basename -s .txt ${filename})
            chunk_pre="${bn}_chunk_"
            split -l 20 -a 1 $filename "${chunk_pre}"
            chunks="$(ls ${chunk_pre}?)"
            for obsfile in $chunks
              do
                bash run_eppsilon_az.sh -d ${file_path_cubes} -f ${obsfile} -v ${obsfile} -n 8 -i 1 -q htc -o 1 -c 0 -p 0
              done
              echo $chunks >> ${bn}_chunk_list.txt
          else
            version="2014_iono_cut_z_band_${z_band}_${shape}_${pointing}${clean_tag}"
            bash run_eppsilon_az.sh -d ${file_path_cubes} -f ${filename} -v ${version} -n 8 -i 1 -q htc -o 1
          fi
        fi
      done
    done
  done
done

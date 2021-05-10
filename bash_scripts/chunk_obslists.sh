#!/bin/bash

cd /shared/home/mwilensky/obslists/thesis_jackknife/final_jackknife

for pointing in minus_two minus_one zenith plus_one plus_two
do
  for clean in 0 1
  do
    for z_band in 3_5 5_10 10_100
    do
      if [ $clean -eq 1 ]; then
        clean_tag="_clean"
      else
        clean_tag=""
      fi
      filename="2014_iono_cut_z_band_${z_band}_${pointing}${clean_tag}.txt"
      if [ -f $filename ] && [ $(wc -l ${filename}) -gt 20 ]; then
        bn=$(basename -s .txt ${filename})
        split -l 20 -a $filename "${bn}_chunk_"
      fi
    done
  done
done

#!/bin/bash

azcopy list https://june22mwax.blob.core.windows.net/ssins/2021/SSINS_output/ > ssins_files_list.txt
awk -F';' '{print $1}' ssins_files_list.txt > all_filenames.txt
awk -F': ' '/_SSINS.pdf$/ {print $2}' all_filenames.txt>filenames.txt


# Set the source and destination URLs
source_container_url="https://june22mwax.blob.core.windows.net/ssins/2021/SSINS_output"
destination_directory="/Volumes/Data2/elillesk/interference/"

# Loop through each filename in the list

while IFS= read line; do
	lines+=($line)
done < filenames.txt


for filename in "${lines[@]}"; do
    # Copy the file using AzCopy
    echo "$source_container_url/$filename"
    azcopy copy "$source_container_url/$filename" "$destination_directory$filename"
    wait
done

#while IFS= read -r filename; do
    # Copy the file using AzCopy
    # 
#    echo "$source_container_url/$filename"
    #azcopy copy "$source_container_url/$filename" "$destination_directory$filename" --recursive=false
#done < filenames.txt

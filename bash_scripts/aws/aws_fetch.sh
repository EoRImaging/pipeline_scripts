#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <bucket> <input_folder> <output_folder> [<file_list.txt> | <file>] [<suffix>]"
    exit 1
fi

# Assign command line arguments to variables
bucket="$1"
input_folder="$2"
output_folder="$3"
suffix="$5"

echo "Bucket: $bucket"
echo "Input folder: $input_folder"
echo "Output folder: $output_folder"
# Check if a file list or single file is provided as input
if [ -f "$4" ]; then
    file_list="$4"
    while IFS= read -r file; do
        if [ -n "$suffix" ]; then
	    echo "Fetching file: ${file}${suffix}"
            aws s3api get-object --bucket "$bucket" --key "$input_folder/${file}${suffix}" "$output_folder/${file}${suffix}"
        else
	    echo "Fetching file: $file"
            aws s3api get-object --bucket "$bucket" --key "$input_folder/$file" "$output_folder/$file"
        fi
    done < "$file_list"
elif [ -n "$4" ]; then
    file="$4"
    if [ -n "$suffix" ]; then
	echo "Fetching file: ${file}${suffix}"
        aws s3api get-object --bucket "$bucket" --key "$input_folder/${file}${suffix}" "$output_folder/${file}${suffix}"
    else
	echo "Fetching file: $file"
        aws s3api get-object --bucket "$bucket" --key "$input_folder/$file" "$output_folder/$file"
    fi
else
    echo "Error: Please provide either a file list or a single file."
    exit 1
fi

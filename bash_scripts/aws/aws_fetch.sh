#!/bin/bash

# Function to display help
function show_help() {
    echo "Usage: $0 <bucket> <input_folder> <output_folder> [--sync] [--force] [<item_list.txt> | <item>] [<suffix>]"
    echo
    echo "Options:"
    echo "  <bucket>           S3 bucket name."
    echo "  <input_folder>     Folder in the S3 bucket."
    echo "  <output_folder>    Local folder to save downloaded files."
    echo "  --sync             Use this option to sync directories instead of downloading individual files."
    echo "  --force            Download even if the file already exists locally."
    echo "  <item_list.txt>    Optional: A text file containing a list of items (files or directories) to download or sync."
    echo "  <item>             Optional: A single item (file or directory) to download or sync."
    echo "  <suffix>           Optional: Suffix to append to each item name."
    echo
    echo "Note: If neither <item_list.txt> nor <item> is provided, the entire folder will be synced."
}

# Check if the correct number of arguments is provided
if [ "$#" -lt 3 ]; then
    echo "Error: Incorrect number of arguments."
    show_help
    exit 1
fi

# Assign command line arguments to variables
bucket="$1"
input_folder="$2"
output_folder="$3"
use_sync=false
shift 3
force_download=false

# Parse optional flags
while [[ "$1" == --* ]]; do
    case "$1" in
        --sync)
            use_sync=true
            ;;
        --force)
            force_download=true
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

item_input="$1"
suffix="$2"

# Remove dots from the suffix if provided
clean_suffix="${suffix//./}"

# Define the log file with the suffix
log_file="${clean_suffix}_obs_ids.txt"

echo "Bucket: $bucket"
echo "Input folder: $input_folder"
echo "Output folder: $output_folder"
echo "Use sync: $use_sync"

# Make output directory if it doesn't exist already
mkdir -p $output_folder

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install it and try again."
    exit 1
fi

# Define a function to perform syncing or downloading
function sync_or_download() {
    local item="$1"
    if [ -n "$suffix" ]; then
        item="${item}${suffix}"
    fi

    local target="$output_folder/$item"

    # Skip existing files unless --force was specified
    if [ "$use_sync" = false ] && \
	[ "$force_download" = false ] && \
	[ -e "$target" ]; then
	echo "Skipping existing file: $target"
        return 0
    fi

    if [ "$use_sync" = true ]; then
        echo "Syncing item: $item"
	echo aws s3 sync "s3://$bucket/$input_folder/$item" "$output_folder/$item"
        aws s3 sync "s3://$bucket/$input_folder/$item" "$output_folder/$item"
    else
        echo "Fetching item: $item"
        aws s3api get-object --bucket "$bucket" --key "$input_folder/$item" "$output_folder/$item"
    fi

    if [ $? -ne 0 ]; then
        echo "Error: Failed to process item $item"
    else
        # Append the item to obs_ids.txt if download or sync is successful
        echo "$item" >> "$output_folder/$log_file"
        echo "Logged obs_id: $item"
    fi
}

# Check if a file list or single item is provided as input
if [ -f "$item_input" ]; then
    echo "Using item list: $item_input"
    while IFS= read -r item; do
        sync_or_download "$item"
    done < "$item_input"
elif [ -n "$item_input" ]; then
    sync_or_download "$item_input"
else
    # Sync the entire folder if no specific items are provided
    echo "Syncing entire folder: $input_folder"
    aws s3 sync "s3://$bucket/$input_folder" "$output_folder"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to sync folder $input_folder"
    else
        # Log the folder sync as an obs_id
        echo "$input_folder" >> "$output_folder/$log_file"
        echo "Logged folder as obs_id: $input_folder"
    fi
fi

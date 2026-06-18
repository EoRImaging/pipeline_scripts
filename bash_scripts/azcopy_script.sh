#!/bin/bash

set -uo pipefail
# Note: 'set -e' is intentionally omitted. We want the script to keep going
# even if an individual azcopy call fails; failures are tracked manually below.

############################################
# Usage:
# ./azcopy_upload_from_list.sh \
#   -l file_list.txt \
#   -s /local/source/dir \
#   -d "https://account.blob.core.windows.net/container[/optional/path][SAS]" \
#   -x "_suffix.ext"
############################################

# Parse arguments
while getopts ":l:s:d:x:" opt; do
  case $opt in
    l) file_list="$OPTARG" ;;   # text file with list of IDs
    s) src_dir="$OPTARG" ;;     # source directory
    d) dest_url="$OPTARG" ;;    # destination Azure container URL
    x) suffix="$OPTARG" ;;      # suffix to append to each ID
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
    :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
  esac
done

# Default suffix to empty if not provided
suffix="${suffix:-}"

# Validate inputs
if [[ -z "${file_list:-}" || -z "${src_dir:-}" || -z "${dest_url:-}" ]]; then
  echo "Error: Missing required arguments."
  echo "Usage: $0 -l file_list.txt -s /source/dir -d <destination_url> [-x suffix]"
  exit 1
fi

if [[ ! -f "$file_list" ]]; then
  echo "Error: File list not found: $file_list"
  exit 1
fi

if [[ ! -d "$src_dir" ]]; then
  echo "Error: Source directory not found: $src_dir"
  exit 1
fi

############################################
# Upload loop
############################################

echo "Starting uploads..."

success_count=0
fail_count=0
skip_count=0
failed_files=()

while IFS= read -r id || [[ -n "$id" ]]; do
  # Skip empty lines or comments
  [[ -z "$id" || "$id" =~ ^# ]] && continue

  filename="${id}${suffix}"
  src_file="${src_dir}/${filename}"
  dest_file="${dest_url}/${filename}"

  if [[ ! -f "$src_file" ]]; then
    echo "WARNING: File not found, skipping: $src_file"
    skip_count=$((skip_count + 1))
    continue
  fi

  echo "Uploading: $filename"

  # The 'if' here is what protects us: testing a command's exit status
  # (even without set -e) means a failure won't kill the script.
  if azcopy copy "$src_file" "$dest_file" --overwrite=ifSourceNewer < /dev/null; then
    success_count=$((success_count + 1))
  else
    echo "ERROR: azcopy failed for $filename (continuing with next file)"
    fail_count=$((fail_count + 1))
    failed_files+=("$filename")
  fi

done < "$file_list"

############################################
# Summary
############################################

echo ""
echo "Upload complete."
echo "  Succeeded: $success_count"
echo "  Failed:    $fail_count"
echo "  Skipped:   $skip_count"

if [[ ${#failed_files[@]} -gt 0 ]]; then
  echo ""
  echo "Failed files:"
  printf '  %s\n' "${failed_files[@]}"
fi

# Exit non-zero overall if anything failed, so callers/CI can detect it,
# while still having attempted every file in the list.
if [[ $fail_count -gt 0 ]]; then
  exit 1
fi

#!/bin/bash

######################################################################################
# run_eppsilon_sequence.sh
#
# Submits run_eppsilon_az.sh once per title in a list, sequentially, so that each
# run's eppsilon power-spectrum + cleanup jobs finish (and free /mnt/scratch) before
# the next run's integration job starts.
#
# Usage:
#   ./run_eppsilon_sequence.sh -l titles.txt -d <azure_path> [other run_eppsilon_az.sh flags...]
#
# Required:
#   -l   path to a text file with one title per line, e.g.:
#          2014-09-14_lim
#          2014-09-12_lim,COW
#        Each title is used both as:
#          -v L<title>           (cube_prefix)
#          -f <obs_list_dir>/<title>.txt   (integrate_list)
#
#        If a title's obs-list file has exactly 1 line, run_eppsilon_az.sh's normal
#        guard ("does not make sense to integrate a single cube") would refuse it.
#        For these titles the wrapper passes -o 1 (force_single_obs) so the full
#        pipeline (integration -> cubes -> ps) still runs on that one observation.
#   -d   azure file_path_cubes (passed through to run_eppsilon_az.sh)
#
# Optional:
#   -p   path to run_eppsilon_az.sh (default: ./run_eppsilon_az.sh)
#   -e   directory containing the per-title obs list .txt files
#        (default: /shared/home/elillesk/repos/pipeline_scripts/fhd_obsid_lists/2014_lists)
#
# Any additional flags accepted by run_eppsilon_az.sh (-n, -q, -r, -x, -t, -m, -s, -o,
# -i, -c, -p [ps flag], -u, -b) can be passed through after a literal '--', and will be
# forwarded to every call unchanged. Do NOT pass -v, -f, -d, or -h here; this wrapper
# sets those itself for each title.
#
# Example:
#   ./run_eppsilon_sequence.sh -l titles.txt \
#       -d https://mwadatastore.blob.core.windows.net/fhd/initial_run/fhd_eli_azure_image \
#       -- -n 2 -q hpc
######################################################################################

set -euo pipefail

script_path="./run_eppsilon_az.sh"
obs_list_dir="/shared/home/elillesk/repos/pipeline_scripts/fhd_obsid_lists/2014_lists"
titles_file=""
file_path_cubes=""

# Parse our own flags up to '--', then keep everything after as passthrough args
passthrough_args=()
while [ $# -gt 0 ]; do
    case "$1" in
        -l) titles_file="$2"; shift 2;;
        -d) file_path_cubes="$2"; shift 2;;
        -p) script_path="$2"; shift 2;;
        -e) obs_list_dir="$2"; shift 2;;
        --) shift; passthrough_args=("$@"); break;;
        *) echo "Unknown option: $1" >&2; exit 1;;
    esac
done

if [ -z "$titles_file" ]; then
    echo "Need to specify -l <titles_file>" >&2
    exit 1
fi
if [ ! -e "$titles_file" ]; then
    echo "Titles file does not exist: $titles_file" >&2
    exit 1
fi
if [ -z "$file_path_cubes" ]; then
    echo "Need to specify -d <file_path_cubes>" >&2
    exit 1
fi
if [ ! -e "$script_path" ]; then
    echo "Cannot find run_eppsilon_az.sh at: $script_path (use -p to point at it)" >&2
    exit 1
fi

echo "Using run_eppsilon_az.sh at: $script_path"
echo "Using obs list directory: $obs_list_dir"
echo "Using file_path_cubes: $file_path_cubes"
echo "Passthrough args to every run: ${passthrough_args[*]:-(none)}"
echo "----------------------------------------"

hold_arg=""   # colon-separated job id list to pass as -h for the NEXT run

run_num=0
while IFS= read -r title || [ -n "$title" ]; do
    # skip blank lines
    [ -z "$title" ] && continue

    run_num=$((run_num + 1))
    cube_prefix="L${title}"
    obs_list_path="${obs_list_dir}/${title}.txt"

    echo ""
    echo "=== [$run_num] Submitting for title: ${title} ==="
    echo "    cube_prefix (-v): ${cube_prefix}"
    echo "    integrate_list (-f): ${obs_list_path}"

    if [ ! -e "$obs_list_path" ]; then
        echo "    WARNING: obs list file not found, skipping this title: ${obs_list_path}" >&2
        continue
    fi

    cmd=("$script_path" -v "$cube_prefix" -f "$obs_list_path" -d "$file_path_cubes")

    # If this title's obs list has only a single observation, run_eppsilon_az.sh's
    # normal guard will refuse to integrate it ("does not make sense to integrate
    # a single cube"). Pass -o 1 (force_single_obs) for just this title so it's
    # processed instead of erroring out.
    n_obs_this_title=$(wc -l < "$obs_list_path")
    if [ "$n_obs_this_title" -eq 1 ]; then
        echo "    Note: obs list has only 1 line; passing -o 1 to bypass single-cube guard"
        cmd+=(-o 1)
    fi

    if [ -n "$hold_arg" ]; then
        cmd+=(-h "$hold_arg")
        echo "    Holding for previous run's cleanup job(s): ${hold_arg}"
    fi
    cmd+=("${passthrough_args[@]}")

    echo "    Running: ${cmd[*]}"
    output=$("${cmd[@]}")
    echo "$output"

    # Pull out all numeric Slurm job IDs that were echoed (in submission order).
    # The (modified) script echoes jid_int, jid_cube (x N cube types), jid_ps, then
    # the two cleanup job ids, each looking like "Submitted batch job 12345". This
    # holds whether or not -o 1 (force_single_obs) was used, since that flag still
    # runs the full integration -> cubes -> ps -> cleanup pipeline.
    mapfile -t job_ids < <(echo "$output" | grep -oE '[0-9]+$')

    n_jobs=${#job_ids[@]}
    if [ "$n_jobs" -lt 2 ]; then
        echo "    WARNING: could not find two cleanup job IDs in output for ${title}." >&2
        echo "    Found job ids: ${job_ids[*]:-none}" >&2
        echo "    The next run will NOT be held on this run's cleanup; check manually." >&2
        hold_arg=""
    else
        # Last two echoed job ids are the cleanup jobs (int-partition, epp-partition)
        cleanup_int_id="${job_ids[$((n_jobs-2))]}"
        cleanup_epp_id="${job_ids[$((n_jobs-1))]}"
        hold_arg="${cleanup_int_id}:${cleanup_epp_id}"
        echo "    Cleanup job IDs for this run: ${hold_arg}"
    fi

done < "$titles_file"

echo ""
echo "=== Done submitting ${run_num} run(s). ==="

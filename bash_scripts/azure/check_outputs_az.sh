#!/bin/bash

################################################################################
# This script checks whether certain outputs exist on azure storage. It does   #
# not need to be run from azure, but does require azure-cli.                   #
################################################################################

while getopts ":u:s:f:v:c:m:h:p:x:" option
do
  case $option in
    u) uvfits_az_path=$OPTARG;; # Path to uvfits files on azure
    s) ssins_az_path=$OPTARG;; # Path to SSINS outputs on azure
    f) fhd_az_path=$OPTARG;; # Path to FHD directory on azure
    v) check_cal_vis=$OPTARG;; # Whether to check for the calibrated visibilities
    c) check_cal=$OPTARG;; # If set to 1, check for cal solns, plots, vis
    m) check_model_uv_arr=$OPTARG;; # If set to 1, check for model_uv_arr in fhd outputs
    h) check_healpix=$OPTARG;; # If set to 1, for healpix outputs
    p) prefix=$OPTARG;; # The output prefix
    x) compare_list=$OPTARG;; # An obslist to compare against. Will return all obsids on this list without outputs.
    \?) echo "Unknown option: accepted options are -u (uvfits_az_path), "
        echo "-s (ssins_az_path), -f (fhd_az_path) -v (check_cal_vis), -c (check_cal), "
        echo "-m (check_model_uv_arr), -h (check_healpix), -o (outdir, required)"
        exit 1;;
    :)  echo "Missing argument option for input flag"
        exit 1;;
  esac
done

# Define some functions
check_empty_flag (){
  if [ -z $1 ]; then
    return 0
  else
    return 1
  fi
}

compare_to_list(){
  if [ ! -z $compare_list ]; then
    local not_txt_out="${prefix}_${1}_not_on_az.txt"
    comm -23 $compare_list $2 >> $not_txt_out
  fi
}

# Feeling particularly evil today.
# arg 1 - filesystem
# arg 2 - path on filesystem
# arg 3 - name on output files after prefix
# arg 4 - file extension
check_path (){
  local yml_out="${prefix}_${3}_on_az.yml"
  local txt_out="${prefix}_${3}_on_az.txt"
  echo "Executing az storage fs file list --account-name mwadata -f $1 --path $2 -o yaml >> $yml_out"
  az storage fs file list --account-name mwadata -f $1 --path $2 -o yaml --recursive false --exclude-dir >> $yml_out
  # Extract the obs by deleting the "name" prefix from the yml file input to sed
  # and then finding all files with appropriate prefix.
  basename -a -s $4 $(sed -n 's/name\: //p' ${yml_out} | grep "/.*${4}") >> $txt_out
  compare_to_list $3 $txt_out
  if [ ! -z $compare_list ]; then
    local not_txt_out="${prefix}_${3}_not_on_az.txt"
    comm -23 $compare_list $txt_out >> $not_txt_out
  fi
}

check_cal_vis=$(check_empty_flag $check_cal_vis)
check_cal=$(check_empty_flag $check_cal)
check_model_uv_arr=$(check_empty_flag $check_model_uv_arr)
check_healpix=$(check_empty_flag $check_healpix)

if [ -z $prefix ]; then
  echo "-o unique must be supplied"
  exit 1
fi

if [ ! -z $uvfits_az_path ]; then
  check_path uvfits $uvfits_az_path "uvfits" ".uvfits"
fi

if [ ! -z $ssins_az_path ]; then
  check_path ssins $ssins_az_path "SSINS_data" "_SSINS_data.h5"
  check_path ssins $ssins_az_path "SSINS_match_events" "_SSINS_match_events.yml"
  comm -12 "${prefix}_SSINS_data_on_az.txt" "${prefix}_SSINS_match_events_on_az.txt" >> "${prefix}_SSINS_data_events_on_az.txt"
  compare_to_list "SSINS_data_events" "${prefix}_SSINS_data_events_on_az.txt"

  check_path ssins $ssins_az_path "SSINS_mask" "_SSINS_mask.h5"
  check_path ssins $ssins_az_path "SSINS_flags" "_SSINS_flags.h5"
  comm -12 "${prefix}_SSINS_mask_on_az.txt" "${prefix}_SSINS_flags_on_az.txt" >> "${prefix}_SSINS_mask_flags_on_az.txt"

  comm -12 "${prefix}_SSINS_data_events_on_az.txt" "${prefix}_SSINS_mask_flags_on_az.txt" >> "${prefix}_SSINS_all_outputs_on_az.txt"
  compare_to_list "SSINS_all_outputs" "${prefix}_SSINS_all_outputs_on_az.txt"
 fi

if [ ! -z $fhd_az_path ]; then
  if [ $check_cal -eq 1 ]; then
    check_path fhd ${fhd_az_path}/calibration "cal_soln" "_cal.sav"
    check_path fhd ${fhd_az_path}/output_images "cal_amp_plot" "_cal_amp.png"
    check_path fhd ${fhd_az_path}/output_images "cal_phase_plot" "_cal_phase.png"
    comm -12 "${prefix}_cal_amp_plot_on_az.txt" "${prefix}_cal_phase_plot_on_az.txt" >>  "${prefix}_all_cal_plots_on_az.txt"
    compare_to_list "all_cal_plots" "${prefix}_all_cal_plots_on_az.txt"
  fi

  if [ $check_cal_vis -eq 1 ]; then
    check_path fhd ${fhd_az_path}/vis_data "cal_vis_XX" "_vix_XX.sav"
    check_path fhd ${fhd_az_path}/vis_data "cal_vis_YY" "_vix_YY.sav"
    comm -12 "${prefix}_cal_vis_XX_on_az.txt" "${prefix}_cal_vis_YY_on_az.txt" >> "${prefix}_all_cal_vis_on_az.txt"
    compare_to_list "all_cal_vis" "${prefix}_all_cal_vis_on_az.txt"
  fi

  if [ $check_healpix -eq 1 ]; then
    check_path fhd ${fhd_az_path}/Healpix "even_XX_healpix" "_even_cubeXX.sav"
    check_path fhd ${fhd_az_path}/Healpix "even_YY_healpix" "_even_cubeYY.sav"
    comm -12 "${prefix}_even_XX_healpix_on_az.txt" "${prefix}_even_YY_healpix_on_az.txt" >> "${prefix}_even_healpix_on_az.txt"
    check_path fhd ${fhd_az_path}/Healpix "odd_XX_healpix" "_odd_cubeXX.sav"
    check_path fhd ${fhd_az_path}/Healpix "odd_YY_healpix" "_odd_cubeYY.sav"
    comm -12 "${prefix}_odd_XX_healpix_on_az.txt" "${prefix}_odd_YY_healpix_on_az.txt" >> "${prefix}_odd_healpix_on_az.txt"
    comm -12 "${prefix}_even_XX_healpix_on_az.txt" "${prefix}_odd_XX_healpix_on_az.txt" >> "${prefix}_all_healpix_on_az.txt"
    compare_to_list "all_healpix" "${prefix}_all_healpix_on_az.txt"
  fi

  if [ $check_model_uv_arr -eq 1 ]; then
    check_path fhd ${fhd_az_path}/cal_prerun "model_uv_arr" "_model_uv_arr.sav"
  fi
fi

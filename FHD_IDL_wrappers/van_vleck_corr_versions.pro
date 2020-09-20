pro van_vleck_corr_versions

  ; Keywords
  obs_id = '1061315448_vv_cable_phase_gains_cb_flagged_80kHz_2s'
  output_directory = '/data3/users/bryna/fhd_outs/'
  version = 'van_vleck_corr_ver6'
  vis_file_list = '/data3/users/bryna/van_vleck_corrected/' + string(obs_id) +'.uvfits'

  ; Directory setup
  fhd_file_list=fhd_path_setup(vis_file_list,version=version,output_directory=output_directory)
  healpix_path=fhd_path_setup(output_dir=output_directory,subdir='Healpix',output_filename='Combined_obs',version=version)

  ; Set global defaults and bundle all the variables into a structure.
  ; Any keywords set on the command line or in the top-level wrapper will supercede these defaults

  ; do not apply bandpass or cable dependent bandpass:
  cable_bandpass_fit=0
  bandpass_calibrate=0

  ; try using the auto calibration
  calibration_auto_fit=1

  ; digital_gain_jump_polyfit=1
  cal_reflection_mode_theory=1
  cal_mode_fit=[90,150,230,320,400,524]

  model_delay_filter=1
  cal_time_average=0
  cal_gain_init=1/64d
  max_cal_iter=100L

  eor_wrapper_defaults,extra
  fhd_depreciation_test, _Extra=extra

  print,""
  print,"Keywords set in wrapper:"
  print,structure_to_text(extra)
  print,""

  general_obs,_Extra=extra
  
end

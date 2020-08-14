pro van_vleck_corr_versions

  ; Keywords
  obs_id = '1061315448_vv_cable_phase_gains_cb'
  output_directory = '/Volumes/Data1/fhd_eppsilon_test_data/'
  version = 'van_vleck_corr_initial'
  vis_file_list = '/Volumes/Data1/mwa_uvfits/' + string(obs_id) +'.uvfits'

  ; Directory setup
  fhd_file_list=fhd_path_setup(vis_file_list,version=version,output_directory=output_directory)
  healpix_path=fhd_path_setup(output_dir=output_directory,subdir='Healpix',output_filename='Combined_obs',version=version)

  ; Set global defaults and bundle all the variables into a structure.
  ; Any keywords set on the command line or in the top-level wrapper will supercede these defaults
  cable_bandpass_fit=0
  digital_gain_jump_polyfit=1
  cal_reflection_mode_theory=[90,150,230,320,400,524]
  model_delay_filter=1
  cal_time_average=0

  eor_wrapper_defaults,extra
  fhd_depreciation_test, _Extra=extra

  print,""
  print,"Keywords set in wrapper:"
  print,structure_to_text(extra)
  print,""

  general_obs,_Extra=extra
  
end
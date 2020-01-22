pro lmb_versions
  except=!except
  !except=0
  heap_gc

  ; parse command line args
  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  PRINT, args
  ;obs_id = args[0]
  obs_id = '1061312640'
  ;output_directory = args[1]
  output_directory = '/home/lmberkhout/data/MWA/data/golden_day'
  ;version = args[2]
  version = 'vanilla_test_2'
  ;vis_file_list = args[1]

  ;if nargs gt 3 then platform = args[3] else platform = '' ;indicates if running on AWS
  ;if nargs gt 4 then cal_obs_id = args[4] else cal_obs_id = '' ;let it run calibration on my funky obs names...

  cmd_args={version:version}
  
   case version of
    'vanilla_test': begin
      uvfits_version = 4
      uvfits_subversion = 1
      calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      filter_background = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      recalculate_all = 1
      cal_bp_transfer = 0
      vis_file_list = vis_file_list
    end  

    'vanilla_test_2': begin
      uvfits_version = 4
      uvfits_subversion = 1
      calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      diffuse_calibrate = 0
      diffuse_model = 0
      subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      recalculate_all = 1
      cal_bp_transfer = 0
      vis_file_list = '/home/lmberkhout/data/MWA/data/golden_day/1061312640.uvfits'
    end

    'vanilla_test_w_modified_kernel_calibration': begin
      model_uv_transfer='/home/lmberkhout/data/MWA/data/golden_day/fhd_vanilla_test_w_modified_kernel_calibration/cal_prerun/1061312640_model_uv_arr.sav'
      model_transfer = '/home/lmberkhout/data/MWA/data/golden_day/fhd_vanilla_test_w_modified_kernel_calibration/cal_prerun/vis_data'
      kernel_window='Blackman-Harris'
      debug_dim=1
      beam_mask_threshold=1e3
      ;print,"Please"
      filter_name='weighted'
      transfer_weights = '/home/lmberkhout/data/MWA/data/golden_day/fhd_vanilla_test_w_modified_kernel_calibration/vis_data/1061312640_flags.sav'
      ;uvfits_version = 4
      ;uvfits_subversion = 1
      ;calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      filter_background=1
      digital_gain_jump_polyfit=1
      diffuse_calibrate=0
      diffuse_model=0
      ;subtract_sidelobe_catalog=filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      dft_threshold=0
      ring_radius=0
      debug_region_grow=0
      recalculate_all = 1
      ;snapshot_recalculate=1
      cal_bp_transfer=0
      vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061312640.uvfits'
      transfer_calibration='/home/lmberkhout/data/MWA/data/golden_day/fhd_vanilla_test_w_modified_kernel_calibration/1061312640'
      beam_clip_floor=1
      cal_bp_transfer=0
      ;image_filter_fn='filter_uv_natural'
      ;transfer_calibration = '/home/lmberkhout/data/MWA/data/golden_day/vanilla_test_w_modified_kernel_calibration/calibration/' + obs_id + '_cal.sav'
     end

  
  endcase 
 
;if cal_obs_id ne '' then begin
;    transfer_calibration = '/cal/' + cal_obs_id + '_cal.sav'
;    cal_bp_transfer = '/cal/' + cal_obs_id + '_bandpass.txt'
;  endif

  undefine, uvfits_subversion, uvfits_version

  fhd_file_list=fhd_path_setup(vis_file_list,version=version,output_directory=output_directory)
  healpix_path=fhd_path_setup(output_dir=output_directory,subdir='Healpix',output_filename='Combined_obs',version=version)


  ; Set global defaults and bundle all the variables into a structure.
  ; Any keywords set on the command line or in the top-level wrapper will supercede these defaults
  eor_wrapper_defaults,extra
  fhd_depreciation_test, _Extra=extra

  print,""
  print,"Keywords set in wrapper:"
  print,structure_to_text(extra)
  print,""
  ;print,extra.filter_name
  general_obs,_Extra=extra

end

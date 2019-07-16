pro fhd_versions_djs_shrivelfigIdlCrash
  except=!except
  !except=0
  heap_gc

  ; parse command line args
  ;compile_opt strictarr
  ;args = Command_Line_Args(count=nargs)
  ;obs_id = args[0]
  ;output_directory = args[1]
  ;version = args[2]
  ;if nargs gt 3 then platform = args[3] else platform = '' ;indicates if running on AWS

  ;cmd_args={version:version}
  
  obs_id = "ref_1.1_uniform"
  output_directory = "/Volumes/Bilbo/djs_outputs"
  version = "djs_shrivelfigIdlCrash_test_Feb2019"
  vis_file_list = "/Users/dstorer/Desktop/ref_1.1_uniform.uvfits"

  case version of

    'djs_shrivelfigIdlCrash_test_Feb2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      calibration_catalog_file_path=filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      rephase_weights = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      instrument = 'hera'
      min_cal_baseline = 0
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      cal_bp_transfer = 0
      sim_over_calibrate = 1
      remove_sim_flags = 1
      unflag_all = 1
      flag_calibration = 0
      bandpass_calibrate = 0
    end
    
  endcase

  if ~keyword_set(vis_file_list) then begin
    if platform eq 'aws' then begin
      vis_file_list = '/uvfits/' + STRING(obs_id) + '.uvfits'
    endif else begin
      SPAWN, 'read_uvfits_loc.py -v ' + STRING(uvfits_version) + ' -s ' + $
        STRING(uvfits_subversion) + ' -o ' + STRING(obs_id), vis_file_list
    endelse
  endif

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


  general_obs,_Extra=extra

end

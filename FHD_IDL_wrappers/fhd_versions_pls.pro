pro fhd_versions_pls
  except=!except
  !except=0
  heap_gc

  ; parse command line args
  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  obs_id = args[0]
  output_directory = args[1]
  version = args[2]
  if nargs gt 3 then platform = args[3] else platform = '' ;indicates if running on AWS

  cmd_args={version:version}

  case version of

    'example_run_Feb2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      debug_beam_clip_floor = 1
      bandpass_calibrate = 0
    end


'trial_run_0307': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      debug_beam_clip_floor = 1
      bandpass_calibrate = 0
      cable_bandpass_fit = 0
      cal_mode_fit = 0
    end

'test_reader': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      bandpass_calibrate = 0
      cable_bandpass_fit = 0
      cal_mode_fit = 0
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


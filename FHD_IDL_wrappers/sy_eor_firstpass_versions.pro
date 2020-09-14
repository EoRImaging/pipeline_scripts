pro sy_eor_firstpass_versions
  except=!except
  !except=0
  heap_gc

  ; wrapper to contain all the parameters for various runs we might do
  ; using firstpass.

  ; parse command line args
  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  IF keyword_set(args) then begin
    obs_id = args[0]
    output_directory = args[1]
    version = args[2]
    if nargs gt 3 then platform = args[3] else platform = '' ;indicates if running on AWS
  endif

  cmd_args={version:version}

  uvfits_version=5
  uvfits_subversion=1

  ;******FHD versions and keywords******
  case version of

    'sy_calibration': begin
      calibration_catalog_file_path=filepath('GLEAM_EGC_v2_84MHz_FornaxWSClean.sav',root=rootdir('FHD'),subdir='catalog_data')
      save_beam_metadata_only=1
      FoV=0
      cal_stop=1
      conserve_memory=1.0e8
      time_cut=-2
      interpolate_kernel=1
      beam_nfreq_avg=1.
      calibration_flux_threshold=0.1
      cal_time_average=0
      ALLOW_SIDELOBE_MODEL_SOURCES =0
      ALLOW_SIDELOBE_CAL_SOURCES =0
      ps_kspan=200.
      calibration_auto_fit=1
      antenna_mod_index=256.
      cal_bp_transfer=0
      beam_threshold=0.1
      gaussian_source_models=1
      psf_dim=14
      beam_mask_threshold=10000.
      dft_threshold=1
    end
   
    'sy_limit': begin
      calibration_catalog_file_path=filepath('GLEAM_EGC_v2_84MHz_FornaxWSClean.sav.sav',root=rootdir('FHD'),subdir='catalog_data')
      gaussian_source_models=1
      restrict_hpx_inds=0
      time_cut=-2
      save_beam_metadata_only=1
      beam_nfreq_avg=1
      ps_kspan=200.
      save_uvf=1
      antenna_mod_index=256.
      cal_bp_transfer=0
      kernel_window=1
      debug_dim=1
      dft_threshold=1.
      beam_mask_threshold = 1e3
      model_visibilities=1
      model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_sy_calibration/cal_prerun/' + obs_id + '_model_uv_arr.sav'
      transfer_calibration = '/fred/oz048/MWA/CODE/FHD/fhd_sy_calibration/calibration/' + obs_id + '_cal.sav'
    end

  endcase
  ;******

  ;Location of uvfits
  vis_file_list = '/fred/oz048/MWA/data/2014/v5_1/' + string(obs_id) +'.uvfits'
  print, vis_file_list

  ;vis_file_list=vis_file_list ; this is silly, but it's so var_bundle sees it.
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

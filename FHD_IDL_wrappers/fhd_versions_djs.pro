pro fhd_versions_djs
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
  
  ;obs_id = "ref_1.1_gauss"
  ;output_directory = "/Volumes/Bilbo/djs_outputs/ref_1_1_gauss"
  ;version = "djs_simComp_heratext_gaussian_beam_adjustedWidthHWHM_incSources_July2019"
  ;vis_file_list = "/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/uvfitsFiles/ref_1.1_gauss.uvfits"

  obs_id = '2458098.52817.HH'
  output_directory = "/Volumes/Bilbo/djs_outputs/heraTest"
  version = "djs_HERA_testRun_July2019"
  vis_file_list = "/Users/dstorer/Files/hera_FHD_Run/zen.2458098.52817.HH.uvfits"

  case version of

    'djs_simComp_heratext_mwa_beam_multFreqs_May2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/mock_catalog_heratext_test_multiple_freqs.sav'
      calibration_catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/mock_catalog_heratext_test_multiple_freqs.sav'
      rephase_weights = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      instrument = 'mwa'
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
      split_ps_export = 0
      n_avg = 1
    end
    
    'djs_simComp_heratext_mwa_beam_noCal_model_May2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/mock_catalog_heratext_2458098.38824015.sav'
      calibration_catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/mock_catalog_heratext_2458098.38824015.sav'
      model_catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/mock_catalog_heratext_2458098.38824015.sav'
      rephase_weights = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      instrument = 'mwa'
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
      split_ps_export = 0
      n_avg = 1
      calibrate_visibilities = 0
      model_visibilities = 1
      return_cal_visibilities = 0
      ;calibration_visibilities_subtract = 0
    end
    
    'djs_simComp_heratext_gaussian_beam_noCal_model_July2019': begin
      ;FHD-Pyuvsim Comparison Version
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/mock_catalog_heratext_2458098_38824015_test.sav'
      calibration_catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/mock_catalog_heratext_2458098_38824015_test.sav'
      model_catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/mock_catalog_heratext_2458098_38824015_test.sav'
      rephase_weights = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      instrument = 'gaussian'
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
      split_ps_export = 0
      n_avg = 1
      calibrate_visibilities = 0
      model_visibilities = 1
      return_cal_visibilities = 0
    end
    
    'djs_simComp_ref1_2_gaussian_beam_noCal_model_July2019': begin
      ;FHD-Pyuvsim Comparison Version
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/catalogs/two_distant_points_2458098.38824015.sav'
      calibration_catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/catalogs/two_distant_points_2458098.38824015.sav'
      model_catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/catalogs/two_distant_points_2458098.38824015.sav'
      rephase_weights = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      instrument = 'gaussian'
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
      split_ps_export = 0
      n_avg = 1
      calibrate_visibilities = 0
      model_visibilities = 1
      return_cal_visibilities = 0
    end
    
    'djs_simComp_ref1_3_gaussian_beam_noCal_model_July2019': begin
      ;FHD-Pyuvsim Comparison Version
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/catalogs/letter_R_12pt_2458098.38824015.sav'
      calibration_catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/catalogs/letter_R_12pt_2458098.38824015.sav'
      model_catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/catalogs/letter_R_12pt_2458098.38824015.sav'
      rephase_weights = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      instrument = 'gaussian'
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
      split_ps_export = 0
      n_avg = 1
      calibrate_visibilities = 0
      model_visibilities = 1
      return_cal_visibilities = 0
    end
    
    'djs_simComp_ref1_1_gaussian_beam_noCal_model_adjustedAmplitude_July2019' : begin
      ;FHD-Pyuvsim Comparison Version
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/catalogs/mock_catalog_heratext_2458098_38824015_test.sav'
      calibration_catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/catalogs/mock_catalog_heratext_2458098_38824015_test.sav'
      model_catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/catalogs/mock_catalog_heratext_2458098_38824015_test.sav'
      rephase_weights = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      instrument = 'gaussian'
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
      split_ps_export = 0
      n_avg = 1
      calibrate_visibilities = 0
      model_visibilities = 0
      return_cal_visibilities = 0
     end
     
     'djs_simComp_heratext_gaussian_beam_adjustedWidthHWHM_incSources_July2019': begin
       ;FHD-Pyuvsim Comparison Version. Manually set sigma=4.84 in gaussian beam setup to match FWHM=11.4 in pyuvsim run
       recalculate_all = 1
       uvfits_version = 5
       uvfits_subversion = 1
       catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/mock_catalog_heratext_2458098_38824015_test.sav'
       calibration_catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/mock_catalog_heratext_2458098_38824015_test.sav'
       model_catalog_file_path='/Users/dstorer/Files/FHD_Pyuvsim_ComparisonSimulation/mock_catalog_heratext_2458098_38824015_test.sav'
       rephase_weights = 0
       diffuse_calibrate = 0
       diffuse_model = 0
       instrument = 'gaussian'
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
       split_ps_export = 0
       n_avg = 1
       calibrate_visibilities = 0
       model_visibilities = 1
       return_cal_visibilities = 0
       save_uvf=1
       include_catalog_sources=1
     end
     
     'djs_HERA_testRun_July2019': begin
       ;Testing hera data on FHD
       recalculate_all = 1
       instrument = 'hera'
       calibrate_visibilities=1
       export_images=1
       combine_obs = 0
       min_baseline=5
       min_cal_baseline=5
       no_fits=1
       bandpass_calibrate=1
       calibration_polyfit=1
       cal_amp_degree_fit=2
       cal_phase_degree_fit=1
       mark_zenith=1
       beam_diff_image=1
       beam_residual_threshold=0.1
       output_residual_histogram=1
       show_beam_contour=1
       contour_level=[0,0.01,0.05,0.1,0.2,0.5,0.67,0.9]
       contour_color='blue'
       max_cal_iter=1000L
       beam_model_version=1
       ;uvfits_version = 5
       ;uvfits_subversion = 1
       catalog_file_path='/Users/dstorer/repositories/FHD/catalog_data/GLEAM_v2_plus_rlb2019.sav'
       ;calibration_catalog_file_path='/Users/dstorer/repositories/FHD/catalog_data/GLEAM_v2_plus_rlb2019.sav'
       ;model_catalog_file_path='/Users/dstorer/repositories/FHD/catalog_data/GLEAM_v2_plus_rlb2019.sav'
       save_uvf=1
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

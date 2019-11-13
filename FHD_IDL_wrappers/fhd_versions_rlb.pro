pro fhd_versions_rlb
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

    'rlb_master_catalog_cal_Sept2016': begin
      recalculate_all = 1
      mapfn_recalculate = 0
      uvfits_version = 5
      uvfits_subversion = 1
      calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
      rephase_weights = 0
      diffuse_calibrate = 0
      diffuse_model = 0
    end

    'rlb_GLEAM_cal_Sept2016': begin
      recalculate_all = 1
      mapfn_recalculate = 1
      uvfits_version = 5
      uvfits_subversion = 1
      calibration_catalog_file_path=filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      diffuse_calibrate = 0
      diffuse_model = 0
      ring_radius = 0
    end

    'rlb_GLEAM_cal_decon_Nov2016': begin
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      gain_factor = 0.1
      deconvolve = 1
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 0
      snapshot_recalculate = 1
      recalculate_all = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
    end

    'rlb_GLEAM_cal_decon_4pol_Apr2017': begin
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      gain_factor = 0.1
      deconvolve = 1
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 0
      snapshot_recalculate = 1
      recalculate_all = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      n_pol = 4
    end

    'rlb_GLEAM+Fornax_cal_Sept2017': begin
      recalculate_all = 1
      mapfn_recalculate = 1
      uvfits_version = 5
      uvfits_subversion = 1
      calibration_catalog_file_path=filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      diffuse_calibrate = 0
      diffuse_model = 0
      ring_radius = 0
    end

    'rlb_4pol_firstpass_Nov2017': begin
      recalculate_all = 0
      mapfn_recalculate = 0
      uvfits_version = 4
      uvfits_subversion = 1
      calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
      rephase_weights = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      n_pol = 4
    end

    'rlb_phaseI_Barry_effect_sim_max_bl_100_Apr2018': begin
      recalculate_all = 1
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 4000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      max_cal_baseline = 100.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_phaseII_Barry_effect_sim_max_bl_100_Apr2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 4000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      max_cal_baseline = 100.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_phaseI_ref_for_sim_Apr2018': begin
      recalculate_all = 1
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      calibrate_visibilities = 0
      model_visibilities = 1
      unflag_all = 1
      return_cal_visibilities = 0
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_phaseII_ref_for_sim_Apr2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      calibrate_visibilities = 0
      model_visibilities = 1
      unflag_all = 1
      return_cal_visibilities = 0
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_phaseI_Barry_effect_sim_Apr2018': begin
      recalculate_all = 1
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 4000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_phaseII_Barry_effect_sim_Apr2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 4000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_phaseI_Barry_effect_sim_nocal_Apr2018': begin
      recalculate_all = 1
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_model_sources = 4000 ;does this apply to the model? check this keyword
      smooth_width = 32
      filter_background = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      calibrate_visibilities = 0 ;turn off calibration
      model_visibilities = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_phaseII_Barry_effect_sim_nocal_Apr2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      max_model_sources = 4000
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      calibrate_visibilities = 0 ;turn off calibration
      model_visibilities = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_phaseI_4pol_ref_for_sim_Apr2018': begin
      recalculate_all = 1
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 4
      calibrate_visibilities = 0
      model_visibilities = 1
      unflag_all = 1
      return_cal_visibilities = 0
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_4pol_sim_decon_Apr2018': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 400000
      calibrate_visibilities = 0 ;turn off calibration
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      gain_factor = 0.1
      deconvolve = 1
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 1  ; Fixed this
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_4pol_sim_decon_nocal_Apr2018': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      gain_factor = 0.1
      deconvolve = 1
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 1  ; Fixed this
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_diffuse_survey_decon_4pol_May2018': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      gain_factor = 0.1
      deconvolve = 1
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 1  ; Fixed this
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_diffuse_survey_decon_2pol_May2018': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      gain_factor = 0.1
      deconvolve = 1
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 1  ; Fixed this
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 2
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_hex_array_sim_reference_May2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      calibrate_visibilities = 0
      model_visibilities = 1
      unflag_all = 1
      return_cal_visibilities = 0
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      ;vis_file_list = '/Users/rubybyrne/array_simulation/'+string(obs_id)+'.uvfits'
    end

    'rlb_hex_array_Barry_effect_sim_May2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 4000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      ;in_situ_sim_input = '/Users/rubybyrne/array_simulation/fhd_rlb_array_sim_reference_May2018'
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
      ;vis_file_list = '/Users/rubybyrne/array_simulation/'+string(obs_id)+'.uvfits'
    end

    'rlb_random_array_sim_reference_May2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      calibrate_visibilities = 0
      model_visibilities = 1
      unflag_all = 1
      return_cal_visibilities = 0
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      ;vis_file_list = '/Users/rubybyrne/array_simulation/'+string(obs_id)+'.uvfits'
    end

    'rlb_random_array_Barry_effect_sim_May2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 4000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      ;in_situ_sim_input = '/Users/rubybyrne/array_simulation/fhd_rlb_random_array_sim_reference_May2018'
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
      ;vis_file_list = '/Users/rubybyrne/array_simulation/'+string(obs_id)+'.uvfits'
    end

    'rlb_self_cal_firstpass_4pol_Jun2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = '/home/ubuntu/'+string(obs_id)+'_decon_catalog.sav'
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_self_cal_firstpass_4pol_leakage_corrected_Jun2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = '/home/ubuntu/'+string(obs_id)+'_decon_catalog_pol_leakage_corrected.sav'
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_leakage_correction_4pol_Jun2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/'+string(obs_id)+'_decon_catalog_pol_leakage_corrected.sav'
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/'+string(obs_id)+'_cal.sav'
      transfer_weights = '/home/ubuntu/'+string(obs_id)+'_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_self_cal_firstpass_4pol_subtract_leakage_corrected_Jun2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = '/home/ubuntu/'+string(obs_id)+'_decon_catalog.sav'
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 0  ; must be unset if model_visibilities is set
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/'+string(obs_id)+'_decon_catalog_pol_leakage_corrected.sav'
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_leakage_correction_4pol_debug_Jun2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/'+string(obs_id)+'_decon_catalog_pol_leakage_corrected.sav'
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/'+string(obs_id)+'_cal_transferred.sav'
      transfer_weights = '/home/ubuntu/'+string(obs_id)+'_flags_transferred.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_diffuse_survey_decon_2pol_master_Jun2018': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      gain_factor = 0.1
      deconvolve = 1
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 1  ; Fixed this
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 2
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_transfer_cal_test_4pol_Jun2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/'+string(obs_id)+'_cal_4pol.sav'
      transfer_weights = '/home/ubuntu/'+string(obs_id)+'_flags_4pol.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_transfer_cal_test_2pol_fullpol_Jun2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/'+string(obs_id)+'_cal_2pol_fullpol.sav'
      transfer_weights = '/home/ubuntu/'+string(obs_id)+'_flags_2pol_fullpol.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 2
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_transfer_cal_test_2pol_master_Jun2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/'+string(obs_id)+'_cal_2pol_master.sav'
      transfer_weights = '/home/ubuntu/'+string(obs_id)+'_flags_2pol_master.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 2
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_diffuse_survey_decon_2pol_May2018_debug': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      gain_factor = 0.1
      deconvolve = 1
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 1  ; Fixed this
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 2
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      vis_file_list = '/Users/Shared/uvfits/5.1/'+string(obs_id)+'.uvfits'
    end

    'rlb_array_sim_reference_Jun2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      calibrate_visibilities = 0
      model_visibilities = 1
      unflag_all = 1
      return_cal_visibilities = 0
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_array_sim_Barry_effect_Jun2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 4000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      ;in_situ_sim_input = '/Users/rubybyrne/array_simulation/fhd_rlb_random_array_sim_reference_May2018'
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_transfer_cal_test_2pol_master_Jun2018_debug': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/Users/rubybyrne/transfer_cal_testing/fhd_rlb_diffuse_survey_decon_2pol_master_Jun2018/calibration/1131478776_cal.sav'
      transfer_weights = '/Users/rubybyrne/transfer_cal_testing/fhd_rlb_diffuse_survey_decon_2pol_master_Jun2018/vis_data/1131478776_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 2
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      vis_file_list = '/Users/Shared/uvfits/5.1/'+string(obs_id)+'.uvfits'
    end

    'rlb_firstpass_2pol_master_Jul2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      gain_factor = 0.1
      deconvolve = 0
      return_decon_visibilities = 0
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 1  ; Fixed this
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 2
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      vis_file_list = '/Users/Shared/uvfits/5.1/'+string(obs_id)+'.uvfits'
    end

    'rlb_transfer_cal_firstpass_2pol_master_Jul2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/Users/rubybyrne/transfer_cal_testing/fhd_rlb_firstpass_2pol_master_Jul2018/calibration/1131478776_cal.sav'
      transfer_weights = '/Users/rubybyrne/transfer_cal_testing/fhd_rlb_firstpass_2pol_master_Jul2018/vis_data/1131478776_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 2
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      vis_file_list = '/Users/Shared/uvfits/5.1/'+string(obs_id)+'.uvfits'
    end

    'rlb_decon_2pol_master_Jul2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      gain_factor = 0.1
      deconvolve = 1
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 1  ; Fixed this
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 2
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      vis_file_list = '/Users/Shared/uvfits/5.1/'+string(obs_id)+'.uvfits'
    end

    'rlb_array_sim_Barry_effect_perfect_cal_Jul2018': begin
      recalculate_all = 1
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_model_sources = 4000
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities = 1
      calibrate_visibilities = 0 ;do not calibrate (perfect calibration)
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 0 ;turn off when not calibrating
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_array_sim_Barry_effect_amp_errors_only_Jul2018': begin
      recalculate_all = 1
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_model_sources = 4000
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities = 1
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 0  ; don't combine calibration visibilities with model visibilities (must be 0 for tranferred cal)
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      transfer_calibration = '/home/ubuntu/cal_files/'+obs_id+'_cal_amp_errors_only.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_array_sim_Barry_effect_abs_errors_only_Jul2018': begin
      recalculate_all = 1
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_model_sources = 4000
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities = 1
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 0  ; don't combine calibration visibilities with model visibilities (must be 0 for tranferred cal)
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      transfer_calibration = '/home/ubuntu/cal_files/'+obs_id+'_cal_abs_errors_only.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_array_sim_Barry_effect_phase_errors_only_Jul2018': begin
      recalculate_all = 1
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_model_sources = 4000
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities = 1
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 0  ; don't combine calibration visibilities with model visibilities (must be 0 for tranferred cal)
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      transfer_calibration = '/home/ubuntu/cal_files/'+obs_id+'_cal_phase_errors_only.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_array_sim_Barry_effect_perfect_cal_large_window_Jul2018': begin
      recalculate_all = 1
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_model_sources = 4000
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities = 1
      calibrate_visibilities = 0 ;do not calibrate (perfect calibration)
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 0 ;turn off when not calibrating
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave' ; triple the window size
      ps_kspan=200 ; only include modes out to 100 lambda (speeds up eppsilon computation)
      save_uvf = 1
    end

    'rlb_array_sim_Barry_effect_amp_errors_only_large_window_Jul2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_model_sources = 4000
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities = 1
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 0  ; don't combine calibration visibilities with model visibilities (must be 0 for tranferred cal)
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      transfer_calibration = '/home/ubuntu/cal_files/'+obs_id+'_cal_amp_errors_only.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave' ; triple the window size
      ps_kspan=200 ; only include modes out to 100 lambda (speeds up eppsilon computation)
    end

    'rlb_array_sim_Barry_effect_abs_errors_only_large_window_Jul2018': begin
      recalculate_all = 1
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_model_sources = 4000
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities = 1
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 0  ; don't combine calibration visibilities with model visibilities (must be 0 for tranferred cal)
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      transfer_calibration = '/home/ubuntu/cal_files/'+obs_id+'_cal_abs_errors_only.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave' ; triple the window size
      ps_kspan=200 ; only include modes out to 100 lambda (speeds up eppsilon computation)
      save_uvf = 1
    end

    'rlb_array_sim_Barry_effect_phase_errors_only_large_window_Jul2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_model_sources = 4000
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities = 1
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 0  ; don't combine calibration visibilities with model visibilities (must be 0 for tranferred cal)
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      transfer_calibration = '/home/ubuntu/cal_files/'+obs_id+'_cal_phase_errors_only.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave' ; triple the window size
      ps_kspan=200 ; only include modes out to 100 lambda (speeds up eppsilon computation)
    end

    'rlb_array_sim_Barry_effect_traditional_cal_large_window_Jul2018': begin
      recalculate_all = 1
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 4000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      ;in_situ_sim_input = '/Users/rubybyrne/array_simulation/fhd_rlb_random_array_sim_reference_May2018'
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave' ; triple the window size
      ps_kspan=200 ; only include modes out to 100 lambda (speeds up eppsilon computation)
      save_uvf = 1
    end

    'rlb_single_source_sim_Oct2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      model_catalog_file_path = '/home/ubuntu/single_source.sav'
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      calibrate_visibilities = 0
      model_visibilities = 1
      unflag_all = 1
      return_cal_visibilities = 0
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_array_sim_Barry_effect_6k_sources_Oct2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 6000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      ;in_situ_sim_input = '/Users/rubybyrne/array_simulation/fhd_rlb_random_array_sim_reference_May2018'
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_array_sim_Barry_effect_1k_sources_Oct2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 1000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      ;in_situ_sim_input = '/Users/rubybyrne/array_simulation/fhd_rlb_random_array_sim_reference_May2018'
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_array_sim_Barry_effect_50k_sources_Oct2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 50000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      ;in_situ_sim_input = '/Users/rubybyrne/array_simulation/fhd_rlb_random_array_sim_reference_May2018'
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_array_sim_transfer_calfits_Oct2018': begin
      recalculate_all = 1
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_model_sources = 4000
      model_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities = 1
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 0  ; don't combine calibration visibilities with model visibilities (must be 0 for tranferred cal)
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      transfer_calibration = '/home/ubuntu/cal_files/'+obs_id+'_cal.calfits'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_array_sim_Barry_effect_no_delay_filter_Oct2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 4000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      ;in_situ_sim_input = '/Users/rubybyrne/array_simulation/fhd_rlb_random_array_sim_reference_May2018'
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 0 ;try turning this off
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_array_sim_Barry_effect_model_fake_sources_Oct2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 50000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      ;in_situ_sim_input = '/Users/rubybyrne/array_simulation/fhd_rlb_random_array_sim_reference_May2018'
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 0
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_catalog_testing_reference_Oct2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      model_catalog_file_path = '/home/ubuntu/test_catalogs/test_catalog_4k_sources.sav'
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      calibrate_visibilities = 0
      model_visibilities = 1
      unflag_all = 1
      return_cal_visibilities = 0
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_catalog_testing_extra_sources_Oct2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 50000
      calibration_catalog_file_path = '/home/ubuntu/test_catalogs/test_catalog_20k_sources.sav'
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 0
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_catalog_testing_extra_negative_sources_Oct2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 50000
      calibration_catalog_file_path = '/home/ubuntu/test_catalogs/test_catalog_20k_sources_negative.sav'
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 0
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_catalog_testing_barry_effect_Oct2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 50000
      calibration_catalog_file_path = '/home/ubuntu/test_catalogs/test_catalog_4k_sources.sav'
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 0
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_catalog_testing_reference_Nov2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      model_catalog_file_path = '/home/ubuntu/test_catalogs/test_catalog_2k_sources.sav'
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      calibrate_visibilities = 0
      model_visibilities = 1
      unflag_all = 1
      return_cal_visibilities = 0
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_catalog_testing_extra_sources_Nov2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 50000
      calibration_catalog_file_path = '/home/ubuntu/test_catalogs/test_catalog_2p5k_sources.sav'
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 0
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_catalog_testing_extra_negative_sources_Nov2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 50000
      calibration_catalog_file_path = '/home/ubuntu/test_catalogs/test_catalog_2p5k_neg_sources.sav'
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 0
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_catalog_testing_missing_sources_Nov2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 50000
      calibration_catalog_file_path = '/home/ubuntu/test_catalogs/test_catalog_1p5k_sources.sav'
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 0
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_GLEAM_catalog_testing_reference_Nov2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      model_catalog_file_path = '/home/ubuntu/test_catalogs/GLEAM_three_quarters.sav'
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      calibrate_visibilities = 0
      model_visibilities = 1
      unflag_all = 1
      return_cal_visibilities = 0
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_GLEAM_catalog_testing_missing_sources_Nov2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 50000
      calibration_catalog_file_path = '/home/ubuntu/test_catalogs/GLEAM_half.sav'
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 0
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_GLEAM_catalog_testing_extra_sources_Nov2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 50000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 0
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_GLEAM_catalog_testing_negative_sources_Nov2018': begin
      recalculate_all = 0
      uvfits_version = 4
      uvfits_subversion = 1
      max_sources = 200000
      max_calibration_sources = 50000
      calibration_catalog_file_path = '/home/ubuntu/test_catalogs/GLEAM_negative.sav'
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      min_cal_baseline = 0.
      cal_mode_fit = 0
      calibration_polyfit = 0
      digital_gain_jump_polyfit = 0
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      in_situ_sim_input = '/uvfits/input_vis'
      remove_sim_flags = 1 ;turn off flagging for simulation
      sim_over_calibrate = 1 ;calibrate each fine frequency independently
      unflag_all = 1
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 0
      cal_time_average = 0 ;don't average over time before calibrating
    end

    'rlb_test_Fornax_gaussian_model_2pol_Dec2018': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = '/home/ubuntu/GLEAM_v2_plus_FornaxA_gaussian_model.sav'
      filter_background = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 2
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      gaussian_source_models = 1
    end

    'rlb_test_Fornax_FHD_model_2pol_Dec2018': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = '/home/ubuntu/GLEAM_v2_plus_FornaxA_from_FHD.sav'
      filter_background = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 2
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      gaussian_source_models = 0
    end

    'rlb_test_Fornax_gaussian_model_without_gaussians_2pol_Dec2018': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = '/home/ubuntu/GLEAM_v2_plus_FornaxA_gaussian_model.sav'
      filter_background = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      subtract_sidelobe_catalog = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 2
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      gaussian_source_models = 0
    end

    'rlb_gleam_v1_catalog_testing_Jan2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_plus_rlb2017.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_gleam_v2_catalog_testing_Jan2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_gaussian_source_test_Jan2018': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      model_catalog_file_path = '/home/ubuntu/single_gaussian_source_catalog.sav'
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      calibrate_visibilities = 0
      model_visibilities = 1
      unflag_all = 1
      return_cal_visibilities = 0
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_diffuse_survey_pol_leakage_correction_4pol_Jan2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/decon_catalogs/'+string(obs_id)+'_decon_catalog_pol_leakage_corrected.sav'
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_cal.sav'
      transfer_weights = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_testing_pre_merge_Feb2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_testing_post_merge_Feb2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_testing_jones_norm_bug_fix_Feb2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_diffuse_survey_pol_leakage_correction_4pol_Mar2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/decon_catalogs/'+string(obs_id)+'_decon_catalog_pol_leakage_corrected.sav'
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_cal.sav'
      transfer_weights = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      baseline_threshold = -50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_diffuse_survey_pol_leakage_correction_4pol_natural_weighting_Mar2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/decon_catalogs/'+string(obs_id)+'_decon_catalog_pol_leakage_corrected.sav'
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_cal.sav'
      transfer_weights = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      baseline_threshold = -50  ; use only baselines shorter than 50 wavelength
      image_filter_fn = 'filter_uv_natural' ; use natural weighting
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_diffuse_survey_test_baseline_restriction_Mar2019': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      max_cal_iter = 1000L ;increase max calibration iterations to ensure convergence
      min_cal_baseline = 0.
      max_baseline = 50.
      filter_background = 1
      return_cal_visibilities = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_test_max_baseline_keyword_Mar2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/decon_catalogs/'+string(obs_id)+'_decon_catalog_pol_leakage_corrected.sav'
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_cal.sav'
      transfer_weights = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelengths
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_test_max_baseline_keyword_2pol_Mar2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/decon_catalogs/'+string(obs_id)+'_decon_catalog_pol_leakage_corrected.sav'
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_cal.sav'
      transfer_weights = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelengths
      debug_region_grow = 0
      n_pol = 2
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_simulated_polarized_sources_May2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      model_catalog_file_path = '/home/ubuntu/polarization_test_catalog.sav'
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 4
      max_baseline = 50  ; use only baselines shorter than 50 wavelengths
      calibrate_visibilities = 0
      model_visibilities = 1
      unflag_all = 1
      return_cal_visibilities = 0
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_test_max_baseline_baseline_threshold_together_Mar2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      gain_factor = 0.1
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/decon_catalogs/'+string(obs_id)+'_decon_catalog_pol_leakage_corrected.sav'
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_cal.sav'
      transfer_weights = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelengths
      baseline_threshold = -50
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_simulated_polarized_signal_baseline_cut_Mar2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      smooth_width = 32
      filter_background = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 4
      max_baseline = 50  ; use only baselines shorter than 50 wavelengths
      calibrate_visibilities = 0
      model_visibilities = 0
      unflag_all = 1
      return_cal_visibilities = 0
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
    end

    'rlb_simulated_polarized_signal_no_baseline_cut_Mar2018': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      smooth_width = 32
      filter_background = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 10
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 4
      calibrate_visibilities = 0
      model_visibilities = 0
      unflag_all = 1
      return_cal_visibilities = 0
      nfreq_avg = 384 ; speed things up by using one beam for all frequencies
    end

    'rlb_test_beam_power_polarized_calculation_branch_Jun2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_test_master_branch_May2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_test_beam_power_polarized_calculation_branch_no_delay_filter_Jun2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      model_delay_filter = 0 ; turn this off for testing
    end

    'rlb_test_master_branch_no_delay_filter_Jun2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      model_delay_filter = 0 ; turn this off for testing
    end

    'rlb_diffuse_survey_decon_4pol_Jun2019': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      max_cal_iter = 1000L ;increase max calibration iterations to ensure convergence
      gain_factor = 0.1
      deconvolve = 1
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_diffuse_survey_decon_master_4pol_Jun2019': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      max_cal_iter = 1000L ;increase max calibration iterations to ensure convergence
      gain_factor = 0.1
      deconvolve = 1
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_test_Stokes_V_fix_branch_Jun2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_test_master_branch_Jun2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
      model_delay_filter = 1 ; delay filter the model visibilities to get rid of the cyclic beam errors
    end

    'rlb_diffuse_survey_decon_4pol_Jul2019': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      max_cal_iter = 1000L ;increase max calibration iterations to ensure convergence
      gain_factor = 0.1
      deconvolve = 0 ;changed for baseline cut
      export_images = 1
      max_baseline = 50 ;changed for baseline cut
      grid_recalculate = 1 ;changed for baseline cut
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_diffuse_survey_pol_leakage_correction_Jul2019': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/decon_catalogs/'+string(obs_id)+'_decon_catalog_pol_leakage_corrected.sav'
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_cal.sav'
      transfer_weights = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end

    'rlb_diffuse_survey_pol_leakage_correction_bug_hunting_Jul2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/decon_catalogs/'+string(obs_id)+'_decon_catalog_pol_leakage_corrected.sav'
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_cal.sav'
      transfer_weights = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end
    
    'rlb_fix_polarized_source_modeling_single_source_test_Jul2019': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_cal.sav'
      transfer_weights = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      stokes_low = -5
      stokes_high = 5
    end
    
    'rlb_fix_polarized_source_modeling_make_fits_Jul2019': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      model_visibilities = 0
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      dft_threshold = 0
      ring_radius = 0
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      in_situ_sim_input = '/uvfits/input_vis'
    end
    
    'rlb_single_extended_source_test_Jul2019': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_extended_source_test.sav'
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_cal.sav'
      transfer_weights = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      stokes_low = -5
      stokes_high = 5
    end
    
    'rlb_expanded_extended_source_test_Jul2019': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/expanded_extended_source_test.sav'
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_cal.sav'
      transfer_weights = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      stokes_low = -5
      stokes_high = 5
    end
    
    'rlb_single_extended_source_noextend_test_Jul2019': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_extended_source_test.sav'
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_cal.sav'
      transfer_weights = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      stokes_low = -5
      stokes_high = 5
      no_extend = 1
    end
    
    'rlb_single_source_identical_beams_test_Jul2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      stokes_low = -5
      stokes_high = 5
    end
    
    'rlb_single_source_debug_flip_Jul2019': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      stokes_low = -5
      stokes_high = 5
      debug_flip = 1
    end
    
    'rlb_diffuse_survey_decon_4pol_Jul2019_2': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      max_cal_iter = 1000L ;increase max calibration iterations to ensure convergence
      gain_factor = 0.1
      deconvolve = 1
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end
    
    'rlb_single_source_identical_beams_test_Aug2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      stokes_low = -5
      stokes_high = 5
    end
    
    'rlb_single_source_identical_beams_test_Aug2019_2': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      stokes_low = -5
      stokes_high = 5
      debug_equal_beams = 1
    end
    
    'rlb_single_source_identical_beams_test_Aug2019_3': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      debug_equal_beams = 1
    end
    
    'rlb_single_source_flip_beams_test_Aug2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      debug_flip = 1
    end
    
    'rlb_single_source_test_Aug2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
    end
    
    'rlb_diffuse_survey_decon_4pol_Aug2019': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      max_cal_iter = 1000L ;increase max calibration iterations to ensure convergence
      gain_factor = 0.1
      deconvolve = 1
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end
    
    'rlb_diffuse_survey_baseline_cut_Aug2019': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0  ; changed this for calibration transfer
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/decon_catalogs/'+string(obs_id)+'_decon_catalog.sav'
      cal_bp_transfer = 0  ; changed this for calibration transfer
      transfer_calibration = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_cal.sav'
      transfer_weights = '/home/ubuntu/calibration_transferred/'+string(obs_id)+'_flags.sav'
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
    end
    
    'rlb_single_source_test_new_beam_calc_Sept2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
    end
    
    'rlb_single_source_test_single_beam_Sept2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      remove_sim_flags = 1 ;turn off flagging
      unflag_all = 1 ;turn off flagging
    end
    
    'rlb_single_source_test_zenith_Sept2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_zenith.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      remove_sim_flags = 1 ;turn off flagging
      unflag_all = 1 ;turn off flagging
    end
    
    'rlb_single_source_test_pointing_center_Sept2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_ptcenter.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      remove_sim_flags = 1 ;turn off flagging
      unflag_all = 1 ;turn off flagging
    end
    
    'rlb_single_source_test_pointing_center_uvres_p75_Sept2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_ptcenter.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      remove_sim_flags = 1 ;turn off flagging
      unflag_all = 1 ;turn off flagging
      kbinsize = .75 ;go to a coarser UV resolution
    end
    
    'rlb_single_source_test_pointing_center_uvres_1_Sept2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_ptcenter.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      remove_sim_flags = 1 ;turn off flagging
      unflag_all = 1 ;turn off flagging
      kbinsize = 1. ;go to a coarser UV resolution
    end
    
    'rlb_single_source_test_natural_weighting_Oct2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_ptcenter.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      image_filter_fn = 'filter_uv_natural'
    end
    
    'rlb_single_source_test_natural_weighting_no_beam_clip_Oct2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_ptcenter.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      image_filter_fn = 'filter_uv_natural'
      beam_clip_floor = 0
    end
    
    'rlb_single_source_test_no_beam_clip_Oct2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_ptcenter.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      beam_clip_floor = 0
    end
    
    'rlb_single_source_test_one_freq_Oct2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_ptcenter.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 0  ; allow flagging this time (necessary for inplementing the frequency cut)
      stokes_low = -5
      stokes_high = 5
      ; try using only one frequency
      freq_start = 167.5-.08
      freq_end = 167.5+.08
      nfreq_avg = 384
    end
    
    'rlb_single_source_test_natural_weighting_flipped_beam_norm_Oct2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_ptcenter.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      image_filter_fn = 'filter_uv_natural'
    end
    
    'rlb_single_source_test_uniform_weighting_flipped_beam_norm_Oct2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_ptcenter.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      image_filter_fn = 'filter_uv_uniform'
    end
    
    'rlb_single_source_ofcent_uniform_weighting_flipped_beam_norm_Oct2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      image_filter_fn = 'filter_uv_uniform'
    end
    
    'rlb_single_source_ofcent_natural_weighting_flipped_beam_norm_Oct2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      image_filter_fn = 'filter_uv_natural'
    end
    
    'rlb_single_source_ofcent_flipped_beam_branch_Oct2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
    end
    
    'rlb_single_source_ptcent_flipped_beam_branch_Oct2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_ptcenter.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
    end
    
    'rlb_single_source_zenith_flipped_beam_branch_Oct2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_zenith.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
    end
    
    'rlb_master_reference_Oct2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
    end
    
    'rlb_beam_power_polarized_calculation_branch_Oct2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
    end
    
    'rlb_diffuse_subtract_Nov2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      diffuse_model = '/home/ubuntu/nearest_short_baselines_Aug2019.sav'
      diffuse_calibrate = 0
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
    end
    
    'rlb_master_reference_Nov2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
      smooth_width = 32
      filter_background = 1
      return_cal_visibilities = 1
      pad_uv_image = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      n_pol = 2
    end
    
    'rlb_diffuse_survey_decon_4pol_master_Nov2019': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      max_cal_iter = 1000L ;increase max calibration iterations to ensure convergence
      gain_factor = 0.1
      deconvolve = 1
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      stokes_low = -5
      stokes_high = 5
    end
    
    'rlb_diffuse_survey_decon_4pol_new_beam_calc_Nov2019': begin
      recalculate_all = 0
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      max_cal_iter = 1000L ;increase max calibration iterations to ensure convergence
      gain_factor = 0.1
      deconvolve = 1
      return_decon_visibilities = 1
      deconvolution_filter = 'filter_uv_uniform'
      filter_background = 1
      return_cal_visibilities = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      cal_bp_transfer = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019',root=rootdir('FHD'),subdir='catalog_data')
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      debug_region_grow = 0
      n_pol = 4
      time_cut = -4 ;flag an extra 4 seconds from the end of each obs
      stokes_low = -5
      stokes_high = 5
    end
    
    'rlb_single_source_test_master_Nov2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      image_filter_fn = 'filter_uv_natural'
    end
    
    'rlb_single_source_test_master_onefreq_Nov2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      image_filter_fn = 'filter_uv_natural'
      ; use just one frequency:
      unflag_all = 0
      freq_start = 167.555-.04
      freq_end = 167.555+.04
    end
    
    'rlb_single_source_test_branch_Nov2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      unflag_all = 1  ; unflag for simulation
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      image_filter_fn = 'filter_uv_natural'
    end
    
    'rlb_single_source_test_branch_onefreq_Nov2019': begin
      recalculate_all = 1
      uvfits_version = 5
      uvfits_subversion = 1
      max_sources = 200000
      filter_background = 1
      return_cal_visibilities = 0
      catalog_file_path = 0
      diffuse_calibrate = 0
      diffuse_model = 0
      model_visibilities = 1
      model_catalog_file_path = '/home/ubuntu/single_source_test.sav'
      calibrate_visibilities = 0
      rephase_weights = 0
      restrict_hpx_inds = 0
      hpx_radius = 15
      return_sidelobe_catalog = 1
      dft_threshold = 0
      ring_radius = 0
      write_healpix_fits = 1
      max_baseline = 50  ; use only baselines shorter than 50 wavelength
      debug_region_grow = 0
      n_pol = 4
      stokes_low = -5
      stokes_high = 5
      nfreq_avg = 384 ; use one beam for all frequencies
      image_filter_fn = 'filter_uv_natural'
      ; use just one frequency:
      unflag_all = 0
      freq_start = 167.555-.04
      freq_end = 167.555+.04
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

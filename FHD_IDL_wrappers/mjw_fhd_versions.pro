pro mjw_fhd_versions
  except=!except
  !except=0
  heap_gc

  ; parse command line args
  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  obs_id = args[0]
  ;obs_id = '1061312640'
  output_directory = args[1]
  ;output_directory = '/Users/mikewilensky/RFI_Catalog_Sim'
  version = args[2]
  ;version = 'plaw_catalog_sim_plus_gleam_nocal_widefield'

  if nargs gt 3 then platform = args[3] else platform = '' ;indicates if running on AWS
  if nargs gt 4 then cal_obs_id = args[4] else cal_obs_id = '' ;let it run calibration on my funky obs names...

  cmd_args={version:version}

  case version of

    'mjw_no_transfer': begin
    cal_bp_transfer=0
    end

    'mjw_tv_cal': begin
    cal_bp_transfer=0
    bandpass_calibrate=1
    vis_file_list = '/Volumes/Faramir/uvfits/1061313128_short_cal.uvfits'
    end

    'mjw_tv_transfer': begin
    cal_bp_transfer = '/Users/mikewilensky/TV_cal/fhd_mjw_tv_cal/calibration/1061313128_short_clean_bandpass.txt'
    transfer_calibration = '/Users/mikewilensky/TV_cal/fhd_mjw_tv_cal/calibration/1061313128_short_clean_cal.sav'
    bandpass_calibrate = 1
    model_visibilities = 1
    vis_file_list = '/Volumes/Faramir/uvfits/1061313128_chunk/1061313128_t21.uvfits'
    end

    'catalog_sim': begin
    calibrate_visibilities=0
    vis_file_list = '/Volumes/Faramir/uvfits/1061312640.uvfits'
    model_catalog_file_path = '/Users/mikewilensky/test_RFI_source_newpos.sav'
    model_visibilities=1
    save_visibilities=1
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    end

    'kernel_window_control_run': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    end

    'kernel_window_control_run_zenith': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    end

    'kernel_window_control_run_zenith_navg1': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=1
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    end

    'kernel_window_control_run_zenith_single_source_navg1': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=1
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('test_RFI_source_1061315448_zenith.sav',root=rootdir('FHD'),subdir='catalog_data')
    end

    'kernel_window_rfi_sim_1x_run': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061312640_nsamplemax_RFI_plaw_1x.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    end

    'kernel_window_rfi_sim_run': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061312640_nsamplemax_RFI_plaw_10x.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    end

    'kernel_window_rfi_sim_100x_run': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061312640_nsamplemax_RFI_plaw_100x.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    end

    'kernel_window_rfi_sim_1000x_run': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061312640_nsamplemax_RFI_plaw_1000x.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    end

    'kernel_window_rfi_sim_single_source_run': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061315448_NB_RFI_nsamplemax.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    eor_vis_filepath='/uvfits/input_eor/vis_data'
    remove_sim_flags=1
    end

    'kernel_window_rfi_sim_single_source_run_no_bubbles': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061315448_NB_RFI_nsamplemax.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    remove_sim_flags=1
    end

    'kernel_window_rfi_sim_single_source_run_no_bubbles_MB_100x': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061315448_NB_midband_100x_RFI_nsamplemax.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    remove_sim_flags=1
    end

    'kernel_window_rfi_sim_single_source_run_no_bubbles_MB': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061315448_NB_midband_RFI_nsamplemax.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    remove_sim_flags=1
    end

    'kernel_window_rfi_sim_single_source_run_no_bubbles_MBZ7': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061315448_NB_RFI_MBZ7_nsamplemax.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    remove_sim_flags=1
    end

    'kernel_window_rfi_sim_single_source_run_no_bubbles_MBZ7_mJy': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061315448_NB_RFI_MBZ7_mJy_nsamplemax.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    remove_sim_flags=1
    end

    'kernel_window_rfi_sim_single_source_run_no_bubbles_MB_single_model': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061315448_NB_midband_RFI_nsamplemax.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    remove_sim_flags=1
    model_catalog_file_path = filepath('test_RFI_source_1061315448_zenith.sav',root=rootdir('FHD'),subdir='catalog_data')
    end

    'kernel_window_rfi_sim_single_source_run_no_bubbles_DTV_single_model': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061315448_DTV_RFI_nsamplemax.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    remove_sim_flags=1
    model_catalog_file_path = filepath('test_RFI_source_1061315448_zenith.sav',root=rootdir('FHD'),subdir='catalog_data')
    end

    'kernel_window_rfi_sim_single_source_run_no_bubbles_DTV6_single_model': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061315448_DTV6_RFI_nsamplemax.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    remove_sim_flags=1
    model_catalog_file_path = filepath('test_RFI_source_1061315448_zenith.sav',root=rootdir('FHD'),subdir='catalog_data')
    end

    'kernel_window_rfi_sim_single_source_run_no_bubbles_Double_DTV_single_model': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061315448_Double_DTV_RFI_nsamplemax.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    remove_sim_flags=1
    model_catalog_file_path = filepath('test_RFI_source_1061315448_zenith.sav',root=rootdir('FHD'),subdir='catalog_data')
    end

    'kernel_window_rfi_sim_single_source_run_no_bubbles_Double_DTV_single_model_mJy': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061315448_Double_DTV_mJy_RFI_nsamplemax.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    remove_sim_flags=1
    model_catalog_file_path = filepath('test_RFI_source_1061315448_zenith.sav',root=rootdir('FHD'),subdir='catalog_data')
    end

    'kernel_window_rfi_sim_1000s_run': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/uvfits/extra_vis/1061312640_nsamplemax_RFI_plaw_1000s.uvfits'
    in_situ_sim_input='/uvfits/input_vis/vis_data'
    end

    'kernel_window_rfi_run': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    snapshot_healpix_export = 0
    model_catalog_file_path = filepath('RFI_PLAW_Cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    end
    
    'kernel_window_rfi_run_single_source': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    snapshot_healpix_export = 0
    model_catalog_file_path = filepath('test_RFI_source_1061315448_zenith.sav',root=rootdir('FHD'),subdir='catalog_data')
    end

    'kernel_window_rfi_10x_run': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    snapshot_healpix_export = 0
    model_catalog_file_path = filepath('RFI_PLAW_10x_Cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    end

    'kernel_window_rfi_100x_run': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    snapshot_healpix_export = 0
    model_catalog_file_path = filepath('RFI_PLAW_100x_Cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    end

    'kernel_window_rfi_1000x_run': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    snapshot_healpix_export = 0
    model_catalog_file_path = filepath('RFI_PLAW_1000x_Cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    end

    'kernel_window_rfi_1000s_run': begin
    kernel_window=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ps_kspan=200.
    interpolate_kernel=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    snapshot_healpix_export = 0
    model_catalog_file_path = filepath('RFI_PLAW_1000s_Cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    end

    'plaw_catalog_sim_widefield': begin
      calibrate_visibilities=0
      ;vis_file_list = '/Volumes/Faramir/uvfits/1061312640.uvfits'
      model_catalog_file_path = '/RFI_Catalogs/RFI_PLAW_Cat.sav'
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    end

    'plaw_10x_catalog_sim_widefield': begin
      calibrate_visibilities=0
      ;vis_file_list = '/Volumes/Faramir/uvfits/1061312640.uvfits'
      model_catalog_file_path = '/RFI_Catalogs/RFI_PLAW_10x_Cat.sav'
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    end

    'plaw_100x_catalog_sim_widefield': begin
      calibrate_visibilities=0
      ;vis_file_list = '/Volumes/Faramir/uvfits/1061312640.uvfits'
      model_catalog_file_path = '/RFI_Catalogs/RFI_PLAW_100x_Cat.sav'
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    end

    'plaw_1000x_catalog_sim_widefield': begin
      calibrate_visibilities=0
      ;vis_file_list = '/Volumes/Faramir/uvfits/1061312640.uvfits'
      model_catalog_file_path = '/RFI_Catalogs/RFI_PLAW_1000x_Cat.sav'
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    end

    'plaw_1000s_catalog_sim_widefield': begin
      calibrate_visibilities=0
      ;vis_file_list = '/Volumes/Faramir/uvfits/1061312640.uvfits'
      model_catalog_file_path = '/RFI_Catalogs/RFI_PLAW_1000s_Cat.sav'
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    end

    'plaw_catalog_sim_plus_gleam_nocal_widefield': begin
      calibrate_visibilities=0
      vis_file_list = '/Users/mikewilensky/RFI_catalog_sim/1061312640_nsamplemax_RFI_plus_gleam_plaw_widefield.uvfits'
      model_catalog_file_path = filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    end

    'plaw_10x_catalog_sim_plus_gleam_nocal_widefield': begin
      calibrate_visibilities=0
      vis_file_list = '/Users/mikewilensky/RFI_catalog_sim/1061312640_nsamplemax_RFI_plus_gleam_plaw_10x_widefield.uvfits'
      model_catalog_file_path = filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    end

    'plaw_100x_catalog_sim_plus_gleam_nocal_widefield': begin
      calibrate_visibilities=0
      vis_file_list = '/Users/mikewilensky/RFI_catalog_sim/1061312640_nsamplemax_RFI_plus_gleam_plaw_100x_widefield.uvfits'
      model_catalog_file_path = filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    end

    'plaw_1000x_catalog_sim_plus_gleam_nocal_widefield': begin
      calibrate_visibilities=0
      vis_file_list = '/Users/mikewilensky/RFI_catalog_sim/1061312640_nsamplemax_RFI_plus_gleam_plaw_1000x_widefield.uvfits'
      model_catalog_file_path = filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    end

    'plaw_1000s_catalog_sim_plus_gleam_nocal_widefield': begin
      calibrate_visibilities=0
      vis_file_list = '/Users/mikewilensky/RFI_catalog_sim/1061312640_nsamplemax_RFI_plus_gleam_plaw_1000s_widefield.uvfits'
      model_catalog_file_path = filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    end

    'catalog_sim_half_flux': begin
      calibrate_visibilities=0
      vis_file_list = '/Volumes/Faramir/uvfits/1061312640.uvfits'
      model_catalog_file_path = '/Users/mikewilensky/test_RFI_source_newpos_half_flux.sav'
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
    end

    'catalog_sim_double_flux_newpos': begin
      calibrate_visibilities=0
      vis_file_list = '/Volumes/Faramir/uvfits/1061312640.uvfits'
      model_catalog_file_path = '/Users/mikewilensky/test_RFI_source_newpos_double_flux.sav'
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
    end

    'catalog_sim_plus_gleam_half_flux_nocal': begin
      calibrate_visibilities=0
      vis_file_list = '/Users/mikewilensky/RFI_catalog_sim/1061312640_nsamplemax_RFI_plus_gleam_half_flux_same_pos.uvfits'
      model_catalog_file_path = filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
    end

    'catalog_sim_plus_gleam_double_flux_nocal': begin
      calibrate_visibilities=0
      vis_file_list = '/Users/mikewilensky/RFI_catalog_sim/1061312640_nsamplemax_RFI_plus_gleam_double_flux_newpos.uvfits'
      model_catalog_file_path = filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
    end

    'catalog_sim_plus_gleam_double_flux_nocal_widefield': begin
      calibrate_visibilities=0
      vis_file_list = '/Users/mikewilensky/RFI_catalog_sim/1061312640_nsamplemax_RFI_plus_gleam_double_flux_newpos.uvfits'
      model_catalog_file_path = filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    end

    'catalog_sim_plus_gleam_nocal_widefield': begin
      calibrate_visibilities=0
      vis_file_list = '/Users/mikewilensky/RFI_catalog_sim/1061312640_nsamplemax_gleam.uvfits'
      model_catalog_file_path = filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    end

    'catalog_sim_fill': begin
      calibrate_visibilities=0
      vis_file_list = '/Volumes/Faramir/uvfits/1061312640.uvfits'
      model_catalog_file_path = '/Users/mikewilensky/test_RFI_source_newpos.sav'
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
    end


    'catalog_sim_gleamonly': begin
      calibrate_visibilities=0
      vis_file_list = '/Volumes/Faramir/uvfits/1061312640.uvfits'
      model_catalog_file_path = filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities=1
      save_visibilities=1
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      fill_model_visibilities=1
    end

    'RFI_sim_first_go': begin
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
      vis_file_list = '/Users/mikewilensky/RFI_catalog_sim/fhd_catalog_sim_fill/vis_data/1061312640_nsamplemax.uvfits'
      ps_kspan=200.
      diffuse_model=0
      diffuse_calibrate=0
      remove_sim_flags=1
      interpolate_kernel=1
      calibration_catalog_filepath=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
     end

    'mjw_default': begin

    end

    'mjw_NB_transfer_1': begin
    uvfits_version = 4
    uvfits_subversion = 1
    transfer_calibration = '/cal/1061318616_cal.sav'
    cal_bp_transfer = '1061318616_bandpass.txt'
    bandpass_calibrate = 1
    ;calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    filter_background = 1
    diffuse_calibrate = 0
    diffuse_model = 0
    subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    dft_threshold = 0
    ring_radius = 0
    debug_region_grow = 0
    recalculate_all = 1
    vis_file_list = '/uvfits/1061318616.uvfits'
    model_visibilities = 1

    end

    'mjw_NB_transfer_2': begin
    uvfits_version = 4
    uvfits_subversion = 1
    transfer_calibration = '/cal/1061318736_cal.sav'
    cal_bp_transfer = '/cal/1061318736_bandpass.txt'
    bandpass_calibrate = 1
    ;calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    filter_background = 1
    diffuse_calibrate = 0
    diffuse_model = 0
    subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    dft_threshold = 0
    ring_radius = 0
    debug_region_grow = 0
    recalculate_all = 1
    vis_file_list = '/uvfits/1061318736.uvfits'
    model_visibilities = 1

    end

    'mjw_NB_transfer_3': begin
    uvfits_version = 4
    uvfits_subversion = 1
    transfer_calibration = '/cal/1061318864_cal.sav'
    cal_bp_transfer = '/cal/1061318864_bandpass.txt'
    bandpass_calibrate = 1
    ;calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    filter_background = 1
    diffuse_calibrate = 0
    diffuse_model = 0
    subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    dft_threshold = 0
    ring_radius = 0
    debug_region_grow = 0
    recalculate_all = 1
    vis_file_list = '/uvfits/1061318864.uvfits'
    model_visibilities = 1

    end

    'mjw_NB_transfer_4': begin
    uvfits_version = 4
    uvfits_subversion = 1
    transfer_calibration = '/cal/1061319224_cal.sav'
    cal_bp_transfer = '/cal/1061319224_bandpass.txt'
    bandpass_calibrate = 1
    ;calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    filter_background = 1
    diffuse_calibrate = 0
    diffuse_model = 0
    subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    dft_threshold = 0
    ring_radius = 0
    debug_region_grow = 0
    recalculate_all = 1
    vis_file_list = '/uvfits/1061319224.uvfits'
    model_visibilities = 1

    end

    'mjw_NB_transfer_5': begin
    uvfits_version = 4
    uvfits_subversion = 1
    transfer_calibration = '/cal/1061319352_cal.sav'
    cal_bp_transfer = '/cal/1061319352_bandpass.txt'
    bandpass_calibrate = 1
    ;calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    filter_background = 1
    diffuse_calibrate = 0
    diffuse_model = 0
    subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    dft_threshold = 0
    ring_radius = 0
    debug_region_grow = 0
    recalculate_all = 1
    vis_file_list = '/uvfits/1061319352.uvfits'
    model_visibilities = 1

    end

    'mjw_NB_transfer_6': begin
    uvfits_version = 4
    uvfits_subversion = 1
    transfer_calibration = '/cal/1061319472_cal.sav'
    cal_bp_transfer = '/cal/1061319472_bandpass.txt'
    bandpass_calibrate = 1
    ;calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    filter_background = 1
    diffuse_calibrate = 0
    diffuse_model = 0
    subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    dft_threshold = 0
    ring_radius = 0
    debug_region_grow = 0
    recalculate_all = 1
    vis_file_list = '/uvfits/1061319472.uvfits'
    model_visibilities = 1

    end

    'mjw_vanilla_test': begin
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
      platform = 'aws'

     end

     'mjw_vanilla_test_transfer': begin
       uvfits_version = 4
       uvfits_subversion = 1
       bandpass_calibrate = 1
       ;calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
       calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
       filter_background = 1
       diffuse_calibrate = 0
       diffuse_model = 0
       subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
       dft_threshold = 0
       ring_radius = 0
       debug_region_grow = 0
       recalculate_all = 1
       model_visibilities = 1

      end

  endcase

  if ~keyword_set(vis_file_list) and keyword_set(instrument) then begin
    if instrument eq 'hera' then begin
      vis_file_list = '/nfs/eor-00/h1/rbyrne/HERA_analysis/zen.2458042.'+obs_id+'.xx.HH.uvR.uvfits'
      if obs_id eq '38650' then begin
        vis_file_list = '/nfs/eor-00/h1/rbyrne/HERA_analysis/zen.2458042.'+obs_id+'.yy.HH.uvR.uvfits'
      endif
    endif
  endif

  if ~keyword_set(vis_file_list) then begin
    if platform eq 'aws' then begin
      vis_file_list = '/uvfits/' + STRING(obs_id) + '.uvfits'
    endif else begin
      SPAWN, 'read_uvfits_loc.py -v ' + STRING(uvfits_version) + ' -s ' + $
        STRING(uvfits_subversion) + ' -o ' + STRING(obs_id), vis_file_list
    endelse
  endif

  if cal_obs_id ne '' then begin
    transfer_calibration = '/cal/' + cal_obs_id + '_cal.sav'
    cal_bp_transfer = '/cal/' + cal_obs_id + '_bandpass.txt'
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

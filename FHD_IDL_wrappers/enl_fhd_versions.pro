pro enl_fhd_versions, obs_id, output_directory, version, platform
  except=!except
  !except=0
  heap_gc

  ; parse command line args
  compile_opt strictarr

 cm_args = command_line_args(count = nargs)
  if nargs gt 0l then begin
    args = cm_args
    obs_id = args[0]
    output_directory = args[1]
    version = args[2]
    if nargs gt 3 then begin
      ; will be "aws" if running on AWS
      platform = args[3]
    endif else begin
      platform = ''
      spawn, 'hostname', hostname
    endelse
  endif else begin
    if n_elements(obs_id) eq 0 then message, 'obs_id must be provided.'
    if n_elements(output_directory) eq 0 then message, 'output_directory must be provided.'
    if n_elements(version) eq 0 then message, 'version must be provided.'
    if n_elements(platform) eq 0 then begin
      platform = ''
      spawn, 'hostname', hostname
    endif
  endelse






  
  ;args = Command_Line_Args(count=nargs)
  ;obs_id = args[0]
  ;obs_id = '1061312640'
  ;output_directory = args[1]
  ;output_directory = '/Users/mikewilensky/RFI_Catalog_Sim'
  ;version = args[2]
  ;version = 'plaw_catalog_sim_plus_gleam_nocal_widefield'

  ;if nargs gt 3 then platform = args[3] else platform = '' ;indicates if running on AWS
  ;if nargs gt 4 then cal_obs_id = args[4] else cal_obs_id = '' ;let it run calibration on my funky obs names...
  ;platform = ''
  cal_obs_id = ''
  ;cmd_args={version:version}

  case version of

    'eli_testing_cal': begin
    calibration_catalog_file_path=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    beam_clip_floor=1
    model_delay_filter=1
    FoV=0
    snapshot_recalculate=1
    interpolate_kernel=1
    beam_nfreq_avg=1
    recalculate_all=1
    mapfn_recalculate=0
    calibration_flux_threshold=0.1
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    diffuse_calibrate=0
    diffuse_model=0
    ps_kspan=200.
    cal_stop=1
    cal_bp_transfer=0
    max_cal_iter=1000L
    cal_reflection_mode_theory=1
    cal_mode_fit=[90,150,230,320]
    use_adaptive_calibration_gain=1
    calibration_base_gain=0.5
    auto_ratio_calibration=1
    calibration_auto_fit=0
    digital_gain_jump_polyfit=0

    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_from_box/'+obs_id+'.uvfits'
    end

    'eli_testing_image': begin
    fhd_cal_folder = '/Volumes/Data3/elillesk/data_and_analysis/fhd/fhd_eli_testing_cal/'
    model_uv_transfer = fhd_cal_folder + 'cal_prerun/' + obs_id + '_model_uv_arr.sav'
    transfer_calibration = fhd_cal_folder + 'calibration/' + obs_id + '_cal.sav'
    kernel_window=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_nfreq_avg=1
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    interpolate_kernel=1
    cal_time_average=0
    model_visibilities=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=0
    ps_kspan=200.
    calibration_auto_fit=0
    auto_ratio_calibration=1
    cal_bp_transfer=0
    beam_clip_floor=1
    tile_flag_list=['44']

    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_from_box/'+obs_id+'.uvfits'
    end


    'eli_testing_fromAWS_cal': begin
    calibration_catalog_file_path=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    beam_clip_floor=1
    model_delay_filter=1
    FoV=0
    snapshot_recalculate=1
    interpolate_kernel=1
    beam_nfreq_avg=1
    recalculate_all=1
    mapfn_recalculate=0
    calibration_flux_threshold=0.1
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    diffuse_calibrate=0
    diffuse_model=0
    ps_kspan=200.
    cal_stop=1
    cal_bp_transfer=0
    max_cal_iter=1000L
    cal_reflection_mode_theory=1
    cal_mode_fit=[90,150,230,320]
    use_adaptive_calibration_gain=1
    calibration_base_gain=0.5
    auto_ratio_calibration=1
    calibration_auto_fit=0
    digital_gain_jump_polyfit=0

    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_aws/'+obs_id+'.uvfits'
    end

    'eli_testing_fromAWS_image': begin
    fhd_cal_folder = '/Volumes/Data3/elillesk/data_and_analysis/fhd/fhd_eli_testing_fromAWS_cal/'
    model_uv_transfer = fhd_cal_folder + 'cal_prerun/' + obs_id + '_model_uv_arr.sav'
    transfer_calibration = fhd_cal_folder + 'calibration/' + obs_id + '_cal.sav'
    kernel_window=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_nfreq_avg=1
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    interpolate_kernel=1
    cal_time_average=0
    model_visibilities=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=0
    ps_kspan=200.
    calibration_auto_fit=0
    auto_ratio_calibration=1
    cal_bp_transfer=0
    beam_clip_floor=1
    tile_flag_list=['44']
    
    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_aws/'+obs_id+'.uvfits'
    end
   
    'eli_testing_flag_init_on_cal': begin
    calibration_catalog_file_path=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    beam_clip_floor=1
    model_delay_filter=1
    FoV=0
    snapshot_recalculate=1
    interpolate_kernel=1
    beam_nfreq_avg=1
    recalculate_all=1
    mapfn_recalculate=0
    calibration_flux_threshold=0.1
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    diffuse_calibrate=0
    diffuse_model=0
    ps_kspan=200.
    cal_stop=1
    cal_bp_transfer=0
    max_cal_iter=1000L
    cal_reflection_mode_theory=1
    cal_mode_fit=[90,150,230,320]
    use_adaptive_calibration_gain=1
    calibration_base_gain=0.5
    auto_ratio_calibration=1
    calibration_auto_fit=0
    digital_gain_jump_polyfit=0

    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_from_box_new/'+obs_id+'.uvfits'
    end

    'eli_testing_flag_init_on_image': begin
    fhd_cal_folder = '/Volumes/Data3/elillesk/data_and_analysis/fhd/fhd_eli_testing_flag_init_on_cal/'
    model_uv_transfer = fhd_cal_folder + 'cal_prerun/' + obs_id + '_model_uv_arr.sav'
    transfer_calibration = fhd_cal_folder + 'calibration/' + obs_id + '_cal.sav'
    kernel_window=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_nfreq_avg=1
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    interpolate_kernel=1
    cal_time_average=0
    model_visibilities=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=0
    ps_kspan=200.
    calibration_auto_fit=0
    auto_ratio_calibration=1
    cal_bp_transfer=0
    beam_clip_floor=1
    tile_flag_list=['44']
    
    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_from_box_new/'+obs_id+'.uvfits'
    end


    'eli_testing_FHDreset_cal': begin
    calibration_catalog_file_path=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    beam_clip_floor=1
    model_delay_filter=1
    FoV=0
    snapshot_recalculate=1
    interpolate_kernel=1
    beam_nfreq_avg=1
    recalculate_all=1
    mapfn_recalculate=0
    calibration_flux_threshold=0.1
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    diffuse_calibrate=0
    diffuse_model=0
    ps_kspan=200.
    cal_stop=1
    cal_bp_transfer=0
    max_cal_iter=1000L
    cal_reflection_mode_theory=1
    cal_mode_fit=[90,150,230,320]
    use_adaptive_calibration_gain=1
    calibration_base_gain=0.5
    auto_ratio_calibration=1
    calibration_auto_fit=0
    digital_gain_jump_polyfit=0

    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_aws/'+obs_id+'.uvfits'
    end

    'eli_testing_FHDreset_image': begin
    fhd_cal_folder = '/Volumes/Data3/elillesk/data_and_analysis/fhd/fhd_eli_testing_FHDreset_cal/'
    model_uv_transfer = fhd_cal_folder + 'cal_prerun/' + obs_id + '_model_uv_arr.sav'
    transfer_calibration = fhd_cal_folder + 'calibration/' + obs_id + '_cal.sav'
    kernel_window=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_nfreq_avg=1
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    interpolate_kernel=1
    cal_time_average=0
    model_visibilities=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=0
    ps_kspan=200.
    calibration_auto_fit=0
    auto_ratio_calibration=1
    cal_bp_transfer=0
    beam_clip_floor=1
    tile_flag_list=['44']
    
    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_aws/'+obs_id+'.uvfits'
    end


    'eli_testing_FHD_old_cal': begin
    calibration_catalog_file_path=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    beam_clip_floor=1
    model_delay_filter=1
    FoV=0
    snapshot_recalculate=1
    interpolate_kernel=1
    beam_nfreq_avg=1
    recalculate_all=1
    mapfn_recalculate=0
    calibration_flux_threshold=0.1
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    diffuse_calibrate=0
    diffuse_model=0
    ps_kspan=200.
    cal_stop=1
    cal_bp_transfer=0
    max_cal_iter=1000L
    cal_reflection_mode_theory=1
    cal_mode_fit=[90,150,230,320]
    use_adaptive_calibration_gain=1
    calibration_base_gain=0.5
    auto_ratio_calibration=1
    calibration_auto_fit=0
    digital_gain_jump_polyfit=0

    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_aws/'+obs_id+'.uvfits'
    end

    'eli_testing_FHD_old_image': begin
    fhd_cal_folder = '/Volumes/Data3/elillesk/data_and_analysis/fhd/fhd_eli_testing_FHD_old_cal/'
    model_uv_transfer = fhd_cal_folder + 'cal_prerun/' + obs_id + '_model_uv_arr.sav'
    transfer_calibration = fhd_cal_folder + 'calibration/' + obs_id + '_cal.sav'
    kernel_window=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_nfreq_avg=1
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    interpolate_kernel=1
    cal_time_average=0
    model_visibilities=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=0
    ps_kspan=200.
    calibration_auto_fit=0
    auto_ratio_calibration=1
    cal_bp_transfer=0
    beam_clip_floor=1
    tile_flag_list=['44']
    
    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_aws/'+obs_id+'.uvfits'
    end



    'eli_testing_FHD_clean_old_cal': begin
    calibration_catalog_file_path=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    beam_clip_floor=1
    model_delay_filter=1
    FoV=0
    snapshot_recalculate=1
    interpolate_kernel=1
    beam_nfreq_avg=1
    recalculate_all=1
    mapfn_recalculate=0
    calibration_flux_threshold=0.1
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    diffuse_calibrate=0
    diffuse_model=0
    ps_kspan=200.
    cal_stop=1
    cal_bp_transfer=0
    max_cal_iter=1000L
    cal_reflection_mode_theory=1
    cal_mode_fit=[90,150,230,320]
    use_adaptive_calibration_gain=1
    calibration_base_gain=0.5
    auto_ratio_calibration=1
    calibration_auto_fit=0
    digital_gain_jump_polyfit=0

    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_aws/'+obs_id+'.uvfits'
    end

    'eli_testing_FHD_clean_old_image': begin
    fhd_cal_folder = '/Volumes/Data3/elillesk/data_and_analysis/fhd/fhd_eli_testing_FHD_clean_old_cal/'
    model_uv_transfer = fhd_cal_folder + 'cal_prerun/' + obs_id + '_model_uv_arr.sav'
    transfer_calibration = fhd_cal_folder + 'calibration/' + obs_id + '_cal.sav'
    kernel_window=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_nfreq_avg=1
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    interpolate_kernel=1
    cal_time_average=0
    model_visibilities=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=0
    ps_kspan=200.
    calibration_auto_fit=0
    auto_ratio_calibration=1
    cal_bp_transfer=0
    beam_clip_floor=1
    tile_flag_list=['44']
    
    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_aws/'+obs_id+'.uvfits'
    end


    'eli_testing_meta_cal': begin
    calibration_catalog_file_path=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    beam_clip_floor=1
    model_delay_filter=1
    FoV=0
    snapshot_recalculate=1
    interpolate_kernel=1
    beam_nfreq_avg=1
    recalculate_all=1
    mapfn_recalculate=0
    calibration_flux_threshold=0.1
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    diffuse_calibrate=0
    diffuse_model=0
    ps_kspan=200.
    cal_stop=1
    cal_bp_transfer=0
    max_cal_iter=1000L
    cal_reflection_mode_theory=1
    cal_mode_fit=[90,150,230,320]
    use_adaptive_calibration_gain=1
    calibration_base_gain=0.5
    auto_ratio_calibration=1
    calibration_auto_fit=0
    digital_gain_jump_polyfit=0

    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_aws/'+obs_id+'.uvfits'
    end

    'eli_testing_meta_image': begin
    fhd_cal_folder = '/Volumes/Data3/elillesk/data_and_analysis/fhd/fhd_eli_testing_meta_cal/'
    model_uv_transfer = fhd_cal_folder + 'cal_prerun/' + obs_id + '_model_uv_arr.sav'
    transfer_calibration = fhd_cal_folder + 'calibration/' + obs_id + '_cal.sav'
    kernel_window=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_nfreq_avg=1
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    interpolate_kernel=1
    cal_time_average=0
    model_visibilities=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=0
    ps_kspan=200.
    calibration_auto_fit=0
    auto_ratio_calibration=1
    cal_bp_transfer=0
    beam_clip_floor=1
    tile_flag_list=['44']
    
    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_aws/'+obs_id+'.uvfits'
    end



    'eli_testing_updated_cal': begin
    calibration_catalog_file_path=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    beam_clip_floor=1
    model_delay_filter=1
    FoV=0
    snapshot_recalculate=1
    interpolate_kernel=1
    beam_nfreq_avg=1
    recalculate_all=1
    mapfn_recalculate=0
    calibration_flux_threshold=0.1
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    diffuse_calibrate=0
    diffuse_model=0
    ps_kspan=200.
    cal_stop=1
    cal_bp_transfer=0
    max_cal_iter=1000L
    cal_reflection_mode_theory=1
    cal_mode_fit=[90,150,230,320]
    use_adaptive_calibration_gain=1
    calibration_base_gain=0.5
    auto_ratio_calibration=1
    calibration_auto_fit=0
    digital_gain_jump_polyfit=0

    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_aws/'+obs_id+'.uvfits'
    end

    'eli_testing_updated_image': begin
    fhd_cal_folder = '/Volumes/Data3/elillesk/data_and_analysis/fhd/fhd_eli_testing_updated_cal/'
    model_uv_transfer = fhd_cal_folder + 'cal_prerun/' + obs_id + '_model_uv_arr.sav'
    transfer_calibration = fhd_cal_folder + 'calibration/' + obs_id + '_cal.sav'
    kernel_window=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_nfreq_avg=1
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    interpolate_kernel=1
    cal_time_average=0
    model_visibilities=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=0
    ps_kspan=200.
    calibration_auto_fit=0
    auto_ratio_calibration=1
    cal_bp_transfer=0
    beam_clip_floor=1
    tile_flag_list=['44']
    
    vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_aws/'+obs_id+'.uvfits'
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


   

  ;vis_file_list = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_from_box/1091130480.uvfits'
    print, vis_file_list
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

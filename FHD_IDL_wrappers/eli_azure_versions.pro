pro eli_azure_versions
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

    'eli_azure_cal': begin
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
    end

    'eli_azure_image': begin
    model_uv_transfer='uvfits/transfer/' + obs_id + '_model_uv_arr.sav'
    transfer_calibration = 'uvfits/transfer/' + obs_id + '_cal.sav'
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
    endif else if platform eq 'azure' then begin
      vis_file_list = 'uvfits/' + STRING(obs_id) + '.uvfits'
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

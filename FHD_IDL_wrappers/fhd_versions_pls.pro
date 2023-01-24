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

    'eor_latest_greatest_cal_phase2_no_freq_av_no_freq_flag': begin
    instrument='mwa2'
    calibration_catalog_file_path=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'

    ; for phase 2, larger default dimension is not necessary
    dimension = 1024

    ; these keywords are not in the dictionary
    max_cal_iter=1000L
    model_delay_filter=1 ;removes any higher k_tau power from the model

    ; turn off beam averaging (this is set as 16 in eor_defaults)
    beam_nfreq_avg=1

    ; recalculate all products except mapping function. I'm not sure why this is set
    recalculate_all=1
    mapfn_recalculate=0

    ; set flux cutoff for calibration sources
    calibration_flux_threshold=0.1

    ; turn off time averaging
    cal_time_average=0
    ; turn off frequency averaging
    n_avg=1

    ; sidelobe subtraction
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')

    ; prevent power leakage by not gridding longer baselines (this is set as 600 in eor_defaults)
    ps_kspan=200.

    ; this is only a cal run so stop before gridding
    cal_stop=1

    ; use Ian's speedup
    use_adaptive_calibration_gain=1
    calibration_base_gain=0.5

    ; other calibration settings
    no_frequency_flagging=1 ;turn of coarse edge flagging
    cal_reflection_mode_theory=1
    cal_mode_fit=[90,150,230,320]
    auto_ratio_calibration=1 ; use wengyang's auto calibration
    calibration_auto_fit=0 ; this is default
    digital_gain_jump_polyfit=0 ; this is default
    end

    'eor_latest_greatest_cal_phase2_no_freq_av_no_freq_flag_gaussbeam_instrum': begin
    instrument='mwa2'
    calibration_catalog_file_path=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'

    ; for phase 2, larger default dimension is not necessary
    dimension = 1024

    ; these keywords are not in the dictionary
    max_cal_iter=1000L
    model_delay_filter=1 ;removes any higher k_tau power from the model

    ; turn off beam averaging (this is set as 16 in eor_defaults)
    beam_nfreq_avg=1

    ; use gaussian beam
    beam_gaussian_decomp=1
    beam_gauss_param_transfer = 1
    psf_image_resolution=10.
    beam_mask_threshold=1e6
    save_beam_metadata_only=1
    beam_clip_floor=0 ; this is set as 1 in eor_defaults
    conserve_memory=1e9

    ; recalculate all products except mapping function. I'm not sure why this is set
    recalculate_all=1
    mapfn_recalculate=0

    ; set flux cutoff for calibration sources
    calibration_flux_threshold=0.1

    ; turn off time averaging
    cal_time_average=0
    ; turn off frequency averaging
    n_avg=1

    ; sidelobe subtraction
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')

    ; prevent power leakage by not gridding longer baselines (this is set as 600 in eor_defaults)
    ps_kspan=200.

    ; this is only a cal run so stop before gridding
    cal_stop=1

    ; use Ian's speedup
    use_adaptive_calibration_gain=1
    calibration_base_gain=0.5

    ; other calibration settings
    no_frequency_flagging=1 ;turn of coarse edge flagging
    cal_reflection_mode_theory=1
    cal_mode_fit=[90,150,230,320]
    auto_ratio_calibration=1 ; use wengyang's auto calibration
    calibration_auto_fit=0 ; this is default
    digital_gain_jump_polyfit=0 ; this is default
    end

    'eor_latest_greatest_cal_phase2_no_freq_av_no_freq_flag_big_dim': begin
    instrument='mwa2'
    calibration_catalog_file_path=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'

    ; for phase 2, test using larger dimension
    dimension = 2048

    ; these keywords are not in the dictionary
    max_cal_iter=1000L
    model_delay_filter=1

    ; turn off beam averaging (this is set as 16 in eor_defaults)
    beam_nfreq_avg=1

    ; recalculate all products except mapping function. I'm not sure why this is set
    recalculate_all=1
    mapfn_recalculate=0

    ; set flux cutoff for calibration sources
    calibration_flux_threshold=0.1

    ; turn off time averaging
    cal_time_average=0
    ; turn off frequency averaging
    n_avg=1

    ; sidelobe subtraction
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')

    ; prevent power leakage by not gridding longer baselines (this is set as 600 in eor_defaults)
    ps_kspan=200.

    ; this is only a cal run so stop before gridding
    cal_stop=1

    ; use Ian's speedup
    use_adaptive_calibration_gain=1
    calibration_base_gain=0.5

    ; other calibration settings
    no_frequency_flagging=1 ;turn of coarse edge flagging
    cal_reflection_mode_theory=1
    cal_mode_fit=[90,150,230,320]
    auto_ratio_calibration=1 ; use wengyang's auto calibration
    calibration_auto_fit=0 ; this is default
    digital_gain_jump_polyfit=0 ; this is default
    end


    'eor_latest_greatest_image_phase2_no_freq_av_no_freq_flag': begin

    instrument='mwa2'
    ; for phase 2, larger default dimension is not necessary
    dimension = 1024

    ; set file pathways
    model_uv_transfer='uvfits/transfer/' + obs_id + '_model_uv_arr.sav'
    transfer_calibration = 'uvfits/transfer/' + obs_id + '_cal.sav'
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'

    ; apply 'Blackman-Harris^2' window function to gridding kernel
    kernel_window=1

    ; not in dictionary
    debug_dim=1

    ; set the factor at which to clip the beam model
    beam_mask_threshold=1e3

    ; turn off beam averaging (this is set at 16 in eor_defaults)
    beam_nfreq_avg=1

    ; turn off time averaging
    cal_time_average=0
    ; turn off frequency averaging
    n_avg=1

    ; don't save out calibrated visibilities
    return_cal_visibilities=0

    ; make visibilities for the subtraction model separately from the model used in calibration
    model_visibilities=1

    ; prevent power leakage by not gridding longer baselines (this is set at 600 in eor_defaults)
    ps_kspan=200.

    ; not sure why calibration keywords are needed for gridding
    cal_time_average=0
    auto_ratio_calibration=1
    cal_bp_transfer=0

    end


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
    endif else if platform eq 'azure' then begin
      vis_file_list = 'uvfits/' + STRING(obs_id) + '.uvfits'
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


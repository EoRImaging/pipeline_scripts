pro jade_copy

    compile_opt strictarr

    ;-- Read command-line arguments
    args = Command_Line_Args(count=nargs)

    obs_idx          = args[0]  ; OBSID index in data_path
    data_path        = args[1]
    output_directory = args[2]
    version          = args[3]

    ;-- Determine vis_file_list using obs_idx as an index
    file_list = file_search(data_path + '*.uvfits', count=nfiles)
    if nfiles EQ 0 then message, 'No .uvfits files found in ' + data_path
    if long(obs_idx) GE nfiles then message, 'obs_idx out of bounds.'

    vis_file_list = [file_list[long(obs_idx)]]

    ;-- Directory setup
    fhd_file_list = fhd_path_setup(vis_file_list, version=version, output_directory=output_directory)
    healpix_path  = fhd_path_setup(output_dir=output_directory, subdir='Healpix', output_filename='Combined_obs', version=version)

    ; -- Custom keywords go here --> These will override the keywords in eor_wrapper_defaults
    calibration_catalog_file_path         = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds                     = 'EoR0_high_healpix_inds_3x.idlsave'
    beam_clip_floor                       = 1
    model_delay_filter                    = 1
    FoV                                   = 0
    interpolate_kernel                    = 1
    beam_nfreq_avg                        = 1
    calibration_flux_threshold            = 0.1
    cal_time_average                      = 0
    calibration_subtract_sidelobe_catalog = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog       = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog             = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES          = 1
    ALLOW_SIDELOBE_CAL_SOURCES            = 1
    diffuse_calibrate                     = 0
    diffuse_model                         = 0
    ps_kspan                              = 200.  ; NEW: set to 200
    n_avg                                 = 4     ; average up to 160 kHz
    cal_stop                              = 0     ; if 1, code stops after calibration and does NOT produce Healpix cubes
    cal_bp_transfer                       = 0
    max_cal_iter                          = 1000L
    cal_reflection_mode_theory            = 1
    cal_mode_fit                          = [90,150,230,320]
    use_adaptive_calibration_gain         = 1
    calibration_base_gain                 = 0.5
    auto_ratio_calibration                = 1
    calibration_auto_fit                  = 0
    digital_gain_jump_polyfit             = 0
    instrument                            = 'mwa2' ; MWA Phase II
    recalculate_all                       = 1      ; WARNING: will not read in sav files

    ;-- Set EoR defaults and bundle all the extra keywords into a structure
    eor_wrapper_defaults, extra
    fhd_depreciation_test, _Extra=extra

    print, ''
    print, 'Keywords set in wrapper:'
    print, structure_to_text(extra)
    print, ''

    ;-- This is the main FHD procedure
    general_obs, _extra=extra

end
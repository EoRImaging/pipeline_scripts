pro ps_wrapper_pls, folder_name=folder_name, obs_range=obs_range, eppsversion=eppsversion
  except=!except
  !except=0
  heap_gc

  ; parse command line args
  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  if nargs ne 0 then begin
    folder_name = args[0]
    obs_range = args[1]
    eppsversion = args[2]
  endif
  ; if nargs gt 3 then platform = args[3] else platform = '' ;indicates if running on AWS

  ; have to use eppsversion instead of version or keywords will be set incorrectly
  cmd_args={eppsversion:eppsversion}

  ; set defaults
  plot_kpar_power=1
  plot_kperp_power=1
  png=1
  plot_k0_power=1
  exact_obsnames=1
  ; refresh_ps=1

  case eppsversion of
    
    'freq_av_four': begin
	freq_avg_factor=4
	force_even_freqs=1
	refresh_ps=1
    end

    'single_edge_flagging': begin
	freq_flag_repeat=24
	edge_flags1=fltarr(32)
        edge_flags1[0]=1
        edge_flags1[31]=1
	freq_flags=edge_flags1
	freq_flag_name='edge1'
    end

    'double_edge_flagging': begin
        freq_flag_repeat=24
	edge_flags2=fltarr(32)
        edge_flags2[0:1]=1
        edge_flags2[30:31]=1
        freq_flags=edge_flags2
	freq_flag_name='edge2'
    end

    'triple_edge_flagging': begin
        freq_flag_repeat=24
        edge_flags2=fltarr(32)
        edge_flags2[0:2]=1
        edge_flags2[29:31]=1
        freq_flags=edge_flags2
        freq_flag_name='edge3'
    end

    'quad_edge_flagging': begin
        freq_flag_repeat=24
        edge_flags2=fltarr(32)
        edge_flags2[0:3]=1
        edge_flags2[28:31]=1
        freq_flags=edge_flags2
        freq_flag_name='edge4'
    end

    'single_edge_flagging_av_four': begin
        freq_flag_repeat=24
        edge_flags1=fltarr(32)
        edge_flags1[0]=1
        edge_flags1[31]=1
        freq_flags=edge_flags1
        freq_flag_name='edge1'
	freq_avg_factor=4
        force_even_freqs=1
    end

    'double_edge_flagging_av_four': begin
        freq_flag_repeat=24
        edge_flags2=fltarr(32)
        edge_flags2[0:1]=1
        edge_flags2[30:31]=1
        freq_flags=edge_flags2
        freq_flag_name='edge2'
	freq_avg_factor=4
        force_even_freqs=1
    end

    'triple_edge_flagging_av_four': begin
        freq_flag_repeat=24
        edge_flags2=fltarr(32)
        edge_flags2[0:2]=1
        edge_flags2[29:31]=1
        freq_flags=edge_flags2
        freq_flag_name='edge3'
	freq_avg_factor=4
        force_even_freqs=1
    end

    'quad_edge_flagging_av_four': begin
        freq_flag_repeat=24
        edge_flags2=fltarr(32)
        edge_flags2[0:3]=1
        edge_flags2[28:31]=1
        freq_flags=edge_flags2
        freq_flag_name='edge4'
	freq_avg_factor=4
	force_even_freqs=1
    end

    'double_edge_flagging_av_four_uneven': begin
        freq_flag_repeat=24
	edge_flags2=fltarr(32)
        edge_flags2[0:1]=1
        edge_flags2[30:31]=1
        freq_flags=edge_flags2
	freq_avg_factor=4
	force_even_freqs=0
    end

    'freq_av_four_force_even_freqs': begin
        allow_uneven_freqs=0
        freq_av_factor=4
    end

    'freq_av_four_allow_uneven_freqs': begin
        freq_av_factor=4
    end

    'default_eor_ps_settings': begin
        plot_kpar_power=1
        plot_kperp_power=1
        png=1
        plot_k0_power=1
        exact_obsnames=1
    end

    'cat_return_sum_cubes': begin
        plot_k0_power=1
    end

  endcase

  ps_wrapper, folder_name, obs_range, data_subdirs=data_subdirs, $
    exact_obsnames = exact_obsnames, ps_foldername = ps_foldername, $
    version_test = version_test, $
    ps_folder_branch = ps_folder_branch, copy_master_uvf = copy_master_uvf, $
    no_evenodd = no_evenodd, no_wtvar_rts = no_wtvar_rts, $
    set_data_ranges = set_data_ranges, beamfiles = beamfiles, rts = rts, $
    casa = casa, sim = sim, save_slices = save_slices, save_sum_cube = save_sum_cube, $
    no_binning = no_binning, refresh_dft = refresh_dft, refresh_ps = refresh_ps, $
    refresh_binning = refresh_binning, refresh_info = refresh_info, $
    refresh_beam = refresh_beam, dft_fchunk = dft_fchunk, require_radec = require_radec, $
    delta_uv_lambda = delta_uv_lambda, max_uv_lambda = max_uv_lambda, $
    full_image = full_image, image_clip = image_clip, $
    pol_inc = pol_inc, type_inc = type_inc, freq_ch_range = freq_ch_range, $
    freq_flags = freq_flags, freq_flag_name = freq_flag_name, $
    freq_flag_repeat = freq_flag_repeat, $
    freq_avg_factor = freq_avg_factor, force_even_freqs = force_even_freqs, $
    allow_beam_approx = allow_beam_approx, uvf_input = uvf_input, uv_avg = uv_avg, $
    uv_img_clip = uv_img_clip, freq_dft = freq_dft, dft_z_use = dft_z_use, $
    std_power = std_power, $
    inverse_covar_weight = inverse_covar_weight, ave_removal = ave_removal, $
    no_wtd_avg = no_wtd_avg, norm_rts_with_fhd = norm_rts_with_fhd, $
    use_weight_cutoff_sim = use_weight_cutoff_sim, $
    wt_cutoffs = wt_cutoffs, wt_measures = wt_measures, fix_sim_input = fix_sim_input, $
    no_spec_window = no_spec_window, spec_window_type = spec_window_type, $
    no_kzero = no_kzero, plot_slices = plot_slices, slice_type = slice_type, $
    uvf_plot_type = uvf_plot_type, plot_stdset = plot_stdset, plot_1to2d = plot_1to2d, $
    plot_2d_masked = plot_2d_masked, plot_kpar_power = plot_kpar_power, $
    plot_kperp_power = plot_kperp_power, plot_k0_power = plot_k0_power, $
    plot_noise_1d = plot_noise_1d, plot_sim_noise = plot_sim_noise, $
    data_range = data_range, sigma_range = sigma_range, nev_range = nev_range, $
    slice_range = slice_range, snr_range = snr_range, noise_range = noise_range, $
    nnr_range = nnr_range, range_1d = range_1d, color_type = color_type, $
    log_kpar = log_kpar, log_kperp = log_kperp, $
    kpar_bin = kpar_bin, kperp_bin = kperp_bin, $
    log_k1d = log_k1d, k1d_bin = k1d_bin, plot_1d_delta = plot_1d_delta, $
    plot_1d_error_bars = plot_1d_error_bars, plot_1d_nsigma = plot_1d_nsigma, $
    set_krange_1dave = set_krange_1dave, kpar_range_1dave = kpar_range_1dave, $
    bin_arr_3d = bin_arr_3d, kperp_range_1dave = kperp_range_1dave, $
    kperp_range_lambda_1dave = kperp_range_lambda_1dave, kx_range_1dave = kx_range_1dave, $
    kx_range_lambda_1dave = kx_range_lambda_1dave, ky_range_1dave = ky_range_1dave, $
    ky_range_lambda_1dave = ky_range_lambda_1dave, $
    kperp_range_lambda_kparpower = kperp_range_lambda_kparpower, $
    kpar_range_kperppower = kpar_range_kperppower, $
    kperp_linear_axis = kperp_linear_axis, kpar_linear_axis = kpar_linear_axis, $
    kperp_plot_range = kperp_plot_range, kperp_lambda_plot_range = kperp_lambda_plot_range, $
    kpar_plot_range = kpar_plot_range, baseline_axis = baseline_axis, $
    delay_axis = delay_axis, cable_length_axis = cable_length_axis, hinv = hinv, $
    plot_wedge_line = plot_wedge_line, wedge_angles = wedge_angles, wedge_names = wedge_names, $
    coarse_harm_width = coarse_harm_width, plot_eor_1d = plot_eor_1d, $
    plot_flat_1d = plot_flat_1d, no_text_1d = no_text_1d, save_path = save_path, $
    savefilebase = savefilebase, plot_path = plot_path, plot_filebase = plot_filebase, $
    individual_plots = individual_plots, plot_binning_hist = plot_binning_hist, $
    note = note, png = png, eps = eps, pdf = pdf, cube_power_info = cube_power_info, $
    no_dft_progress = no_dft_progress, loc_name = loc_name

end

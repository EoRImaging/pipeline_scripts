pro enterprise_wrapper, folder_name, obs_name, data_subdirs=data_subdirs, dirty_folder = dirty_folder, $
    rts = rts, no_wtvar_rts = no_wtvar_rts, type_inc = type_inc, $
    refresh_dft = refresh_dft, refresh_ps = refresh_ps, refresh_info = refresh_info, $
    refresh_rtscube = refresh_rtscube, refresh_binning = refresh_binning, refresh_beam = refresh_beam, $
    pol_inc = pol_inc, no_spec_window = no_spec_window, $
    spec_window_type = spec_window_type, sim = sim, uvf_input = uvf_input, $
    freq_ch_range = freq_ch_range, individual_plots = individual_plots, $
    kperp_range_1dave = kperp_range_1dave, kperp_range_lambda_1dave = kperp_range_lambda_1dave, $
    kpar_range_1dave = kpar_range_1dave, use_weight_cutoff = use_weight_cutoff, fix_sim_input = fix_sim_input, $
    plot_kpar_power = plot_kpar_power, plot_kperp_power = plot_kperp_power, $
    plot_k0_power = plot_k0_power, plot_noise_1d = plot_noise_1d, plot_sim_noise = plot_sim_noise, range_1d = range_1d, $
    coarse_harm_width = coarse_harm_width, kperp_plot_range = kperp_plot_range, $
    kperp_lambda_plot_range = kperp_lambda_plot_range, kpar_plot_range = kpar_plot_range, $
    png = png, eps = eps, pdf = pdf, plot_stdset = plot_stdset, $
    plot_slices = plot_slices, slice_type = slice_type, uvf_plot_type = uvf_plot_type, max_uv_lambda = max_uv_lambda, $
    kperp_linear_axis = kperp_linear_axis, kpar_linear_axis = kpar_linear_axis, set_data_ranges = set_data_ranges,$
    cube_power_info = cube_power_info, ps_foldername = ps_foldername, data_range = data_range, $
    norm_rts_with_fhd = norm_rts_with_fhd, wedge_angles = wedge_angles
    
  ;; The only required input is the datafile name (including the full path)
    
  if keyword_set(rts) then begin
    ;    froot = '/data3/MWA/bpindor/RTS/dec_11/'
    ;
    ;    ;     data_dir = froot + 'BdaggerV/'
    ;    data_dir = froot + ['PSF0_0/','PSF0_1/']
    ;
    ;    ;     weights_dir = froot + 'Bdagger1/'
    ;    weights_dir = froot + ['PSF1_0/','PSF1_1/']
    ;
    ;    ;     variance_dir = froot + 'BdaggerB/'
    ;    variance_dir = froot + ['PSF2_0/','PSF2_1/']
    ;
    ;    datafiles = [[file_search(data_dir[0] + '*.fits')],[file_search(data_dir[1] + '*.fits')]]
    ;    weightfiles = [[file_search(weights_dir[0] + '*.fits')],[file_search(weights_dir[1] + '*.fits')]]
    ;    variancefiles = [[file_search(variance_dir[0] + '*.fits')],[file_search(variance_dir[1] + '*.fits')]]
  
  
  
    if n_elements(folder_name) eq 0 then folder_name = '/data3/MWA/bpindor/RTS/feb_9/'
    
    ;; check for folder existence, otherwise look for common folder names to figure out full path.
    ;; If none found, try '/data3/MWA/bpindor/RTS/'
    start_path = '/data3/MWA/bpindor/RTS/'
    folder_test = file_test(folder_name, /directory)
    if folder_test eq 0 then begin
      pos_RTS = strpos(folder_name, 'RTS')
      if pos_RTS gt -1 then begin
        test_name = start_path + strmid(folder_name, pos_RTS)
        folder_test = file_test(test_name, /directory)
        if folder_test eq 1 then folder_name = test_name
      endif
    endif
    if folder_test eq 0 then begin
      test_name = start_path + folder_name
      folder_test = file_test(test_name, /directory)
      if folder_test eq 1 then folder_name = test_name
    endif
    
    if folder_test eq 0 then message, 'folder not found'
    
    if n_elements(dirty_folder) gt 0 then begin
      ;; check for folder existence, otherwise look for common folder names to figure out full path.
      ;; If none found, try '/data3/MWA/bpindor/RTS/'
      start_path = '/data3/MWA/bpindor/RTS/'
      folder_test = file_test(dirty_folder, /directory)
      if folder_test eq 0 then begin
        pos_RTS = strpos(dirty_folder, 'RTS')
        if pos_RTS gt -1 then begin
          test_name = start_path + strmid(dirty_folder, pos_RTS)
          folder_test = file_test(test_name, /directory)
          if folder_test eq 1 then dirty_folder = test_name
        endif
      endif
      if folder_test eq 0 then begin
        test_name = start_path + dirty_folder
        folder_test = file_test(test_name, /directory)
        if folder_test eq 1 then dirty_folder = test_name
      endif
      
      if folder_test eq 0 then message, 'dirty_folder not found'
      
    endif
    
    if n_elements(ps_foldername) eq 0 then ps_foldername = 'ps/'
    save_path = folder_name + '/' + ps_foldername
    obs_info = ps_filenames(folder_name, obs_name, dirty_folder = dirty_folder, rts = rts, sim = sim, casa = casa, $
      save_paths = save_path, plot_path = save_path, refresh_info = refresh_info, no_wtvar_rts = no_wtvar_rts)
      
    if tag_exist(obs_info, 'dirtyfiles') then dirtyfiles = obs_info.dirtyfiles.(0)
    
    if obs_info.info_files[0] ne '' then datafile = obs_info.info_files[0] else $
      if obs_info.cube_files.(0)[0] ne '' then datafile = obs_info.cube_files.(0) else $
      datafile = rts_fits2idlcube(obs_info.datafiles.(0), obs_info.weightfiles.(0), obs_info.variancefiles.(0), $
      dirtyfiles = dirtyfiles, pol_inc = pol_inc, save_path = obs_info.folder_names[0]+path_sep(), $
      refresh = refresh_dft, no_wtvar = no_wtvar_rts)
      
    if keyword_set(refresh_rtscube) then $
      datafile = rts_fits2idlcube(obs_info.datafiles.(0), obs_info.weightfiles.(0), obs_info.variancefiles.(0), $
      dirtyfiles = dirtyfiles, pol_inc = pol_inc, save_path = obs_info.folder_names[0]+path_sep(), $
      /refresh, no_wtvar = no_wtvar_rts)
      
    if keyword_set(no_wtvar_rts) then return
    
    max_uv_lambda = 300
    
    note = obs_info.rts_types
    if not file_test(save_path, /directory) then file_mkdir, save_path
    
    plot_path = save_path + 'plots/'
    if not file_test(plot_path, /directory) then file_mkdir, plot_path
    
    if keyword_set(set_data_ranges) then begin
      if n_elements(range_1d) eq 0 then range_1d = [1e4, 1e15]
      
      ;if obs_info.integrated[0] gt 0 then begin
      sigma_range = [2e5, 2e9]
      nev_range = [2e6, 2e10]
      ;sigma_range = nev_range
      ;      endif else begin
      ;        sigma_range = [1e7, 2e11]
      ;        nev_range = [2e8, 2e12]
      ;      endelse
      
      data_range = [1e3, 1e15]
      nnr_range = [1e-1, 1e1]
      snr_range = [1e-5, 1e7]
      
      noise_range = nev_range
    endif
    
  endif else begin
  
    ;; check for folder existence, otherwise look for common folder names to figure out full path.
    start_path = '/data4/MWA/'
    folder_test = file_test(folder_name, /directory)
    if folder_test eq 0 then begin
      pos_aug23 = strpos(folder_name, 'FHD_Aug23')
      if pos_aug23 gt -1 then begin
        test_name = start_path + strmid(folder_name, pos_aug23)
        folder_test = file_test(test_name, /directory)
        if folder_test eq 1 then folder_name = test_name
      endif
    endif
    if folder_test eq 0 then begin
      test_name = start_path + 'FHD_Aug23/' + folder_name
      folder_test = file_test(test_name, /directory)
      if folder_test eq 1 then folder_name = test_name
    endif
    
    if folder_test eq 0 then message, 'folder not found'
    
    if n_elements(ps_foldername) eq 0 then ps_foldername = 'ps/'
    save_path = folder_name + '/' + ps_foldername
    if keyword_set(uvf_input) then data_subdirs = '' else data_subdirs = 'Healpix/'
    obs_info = ps_filenames(folder_name, obs_name, exact_obsnames = exact_obsnames, rts = rts, sim = sim, $
      uvf_input = uvf_input, casa = casa, data_subdirs = data_subdirs, $
      save_paths = save_path, plot_path = save_path, refresh_info = refresh_info)
      
    if obs_info.info_files[0] ne '' then datafile = obs_info.info_files[0] else datafile = obs_info.cube_files.(0)
    if keyword_set(uvf_input) then plot_filebase = obs_info.fhd_types[0] + '_uvf'$
    else  plot_filebase = obs_info.fhd_types[0]
    if stregex(obs_info.fhd_types[0], obs_info.obs_names[0], /boolean) eq 0 then $
      plot_filebase = plot_filebase + '_' + obs_info.obs_names[0]
      
    note = obs_info.fhd_types[0]
    if keyword_set(uvf_input) then note = note + '_uvf'
    
    if tag_exist(obs_info, 'beam_files') then beamfiles = obs_info.beam_files
    
    if not file_test(save_path, /directory) then file_mkdir, save_path
    
    plot_path = save_path + 'plots/'
    if not file_test(plot_path, /directory) then file_mkdir, plot_path
    
    if keyword_set(sim) then begin
      plot_eor_1d=1
      if n_elements(range_1d) eq 0 then range_1d = [1e3, 1e7]
      
      if keyword_set(use_weight_cutoff) then begin
        ;wt_measures = [strarr(2)+'ave', strarr(2)+'min']
        ;wt_cutoffs = [0.5,1, 2, 0.5,1, 2]
      
        ;wt_measures = strarr(1)+'ave';, strarr(2)+'min']
        ;wt_measures = strarr(3)+'min'
        ;wt_measures=['ave','min']
        ;wt_cutoffs = [2,1];, 2];, 1, 2]
        ;wt_cutoffs = 1;[0.5,1];, 1, 2]
        ;wt_measures = 'min'; strarr(2)+'min';[strarr(2)+'ave', strarr(2)+'min']
      
        wt_cutoffs = [0,1]
        wt_measures = strarr(2)+'min'
      endif
    endif
    
    if n_elements(set_data_ranges) eq 0 and not keyword_set(sim) then set_data_ranges = 1
    
    if keyword_set(set_data_ranges) then begin
      if n_elements(range_1d) eq 0 then range_1d = [1e4, 1e15]
      
      if obs_info.integrated[0] gt 0 then begin
        sigma_range = [2e5, 2e9]
        nev_range = [2e6, 2e10]
      ;sigma_range = nev_range
      endif else begin
        sigma_range = [1e7, 2e11]
        nev_range = [2e8, 2e12]
      endelse
      
      data_range = [1e3, 1e15]
      nnr_range = [1e-1, 1e1]
      snr_range = [1e-5, 1e7]
      
      noise_range = nev_range
    endif
    
    
  endelse
  
  ;; dft_fchunk applies only to Healpix datasets (it's ignored otherwise) and it specifies how many
  ;;   frequencies to process
  ;;   through the dft at once. This keyword allows for trade-offs between memory use and speed.
  ;; The optimum setting varies by computer and the speed is NOT a linear function of this parameter
  ;;   (it's not even monotonic) so some experimenting is required. The memory required is approximately linear --
  ;;   the higher this value the more memory required.
  ;; The default is 1 (to minimize memory use)
  ;; The maximum value of this parameter is the number of frequency slices in the cube
  ;;   (if its set too large it will be reduced to the maximum)
  
  dft_fchunk = 1
  
  
  ;; save_path specifies a location to save the power spectrum files.
  ;; This is also where the code looks for intermediate save files to avoid re-running code.
  ;; If this is parameter is not set, the files will be saved in the same directory as the datafile.
  
  
  ;; savefilebase specifies a base name to use for the save files
  
  ;; plot_path specifies a location to save plot files.
  ;; If this parameter is not set, the plots will be saved in the same directory as the datafile.
  
  ;; plot_filebase specifies a base name to use for the plot files
  
  
  ;; freq_ch_range specifies which frequency channels to include in the power spectrum.
  ;; Fewer number of channels makes the dfts faster
  
  ;; pol_inc specifies which polarizations to generate the power spectra for.
  ;; The default is ['xx,'yy']
  
  ;; cut_image keyword only applies to Healpix datasets. It allows for limiting the field of view in the
  ;; image plane by only using Healpix pixels inside a 30 degree diameter circle
  ;; centered in the middle of the field.
  ;; Currently defaults to on. Set equal to 0 to turn it off, 1 to turn it on
  
  
  ;; There are 3 refresh flags to indicate that various stages should be re-calculated
  ;;   (rather than using previous save files if they exist).
  ;; If an early stage is recalculated, all subsequent stages will also be recalculated
  ;; The earliest stage is refresh_dft, which is only used for Healpix datasets (it's ignored otherwise)
  ;; The next stage is refresh_ps and the last stage is refresh_binning.
  ;; To set any of these flags, set them equal to 1 (true)
  
  ;; options for binning:
  ;; log_kperp, log_kpar and log_k1d are flags: set to 1 (true) for logarithmic bins
  ;; kperp_bin, kpar_bin and k1d_bin take scalar values to control bin sizes.
  ;;   (The actual binsize for linear binning and the log binsize for log binning -- bins per decade = 1/binsize)
  
  
  ;; options for plotting:
  ;; kperp_linear_axis is a flag, set to 1 to use a linear kperp axis (default is log axis)
  ;; kpar_linear_axis is a flag, set to 1 to use a linear kpar axis (default is log axis)
  ;; data_range specifies the min & max value of the signal colorbar (values outside that range are
  ;     clipped to those values)
  ;; sigma_range, nev_range, snr_range, noise_range, nnr_range control the other colorbar ranges
  ;; baseline_axis is a flag (defaulted to true) to mark baseline; length along top axis of 2d plots
  ;     (set to 0 to turn off)
  ;; delay_axis is a flag (defaulted to true) to mark delay time along right axis of 2d plots
  ;    (set to 0 to turn off)
  ;; hinv is a flag (defaulted to true) to use h^-1 Mpc rather than physical Mpc in plot units
  ;    (set to 0 to turn off)
  ;; plot_wedge_line is a flag (defaulted to true) to plot a line marking the wedge (both horizon & FoV)
  ;    (set to 0 to turn off)
  ;; pub is a flag to make save plots as eps files rather than displaying to the screen
  
  ps_main_plots, datafile, beamfiles = beamfiles, plot_path = plot_path, plot_filebase = plot_filebase, $
    save_path = save_path, savefilebase = savefilebase, pol_inc = pol_inc, rts = rts, casa = casa, $
    refresh_dft = refresh_dft, refresh_ps = refresh_ps, refresh_binning = refresh_binning, $
    refresh_info = refresh_info, refresh_beam = refresh_beam, $
    freq_ch_range = freq_ch_range, freq_flags = freq_flags, freq_flag_name = freq_flag_name, $
    max_uv_lambda = max_uv_lambda, no_spec_window = no_spec_window, spec_window_type = spec_window_type, $
    std_power = std_power, no_wtd_avg = no_wtd_avg, $
    sim = sim, cut_image = cut_image, dft_ian = dft_ian, $
    uvf_input = uvf_input, uv_avg = uv_avg, uv_img_clip = uv_img_clip, $
    log_kpar = log_kpar, log_kperp = log_kperp, kpar_bin = kpar_bin, kperp_bin = kperp_bin, $
    log_k1d = log_k1d, k1d_bin = k1d_bin, $
    kperp_range_1dave = kperp_range_1dave, kperp_range_lambda_1dave = kperp_range_lambda_1dave, $
    kpar_range_1dave = kpar_range_1dave, $
    wt_cutoffs = wt_cutoffs, wt_measures = wt_measures, fix_sim_input = fix_sim_input, $
    kperp_linear_axis = kperp_linear_axis, kpar_linear_axis = kpar_linear_axis, kperp_plot_range = kperp_plot_range, $
    kperp_lambda_plot_range = kperp_lambda_plot_range, kpar_plot_range = kpar_plot_range, $
    plot_slices = plot_slices, slice_type = slice_type, uvf_plot_type = uvf_plot_type, plot_stdset = plot_stdset, $
    plot_kpar_power = plot_kpar_power, plot_kperp_power = plot_kperp_power, plot_k0_power = plot_k0_power, $
    plot_noise_1d = plot_noise_1d, plot_sim_noise = plot_sim_noise, $
    data_range = data_range, sigma_range = sigma_range, nev_range = nev_range, snr_range = snr_range, $
    noise_range = noise_range, nnr_range = nnr_range, $
    range_1d = range_1d, slice_range = slice_range, $
    baseline_axis = baseline_axis, delay_axis = delay_axis, hinv = hinv, $
    plot_wedge_line = plot_wedge_line, wedge_angles = wedge_angles, coarse_harm_width = coarse_harm_width, plot_eor_1d = plot_eor_1d, $
    individual_plots = individual_plots, note = note, png = png, eps = eps, pdf = pdf, $
    cube_power_info = cube_power_info, $
    norm_rts_with_fhd = norm_rts_with_fhd, type_inc = type_inc
    
    
  if not keyword_set(set_data_ranges)and keyword_set(plot_stdset) then begin
    print, 'data_range used: ', number_formatter(data_range, format = '(e7.1)')
    print, 'sigma_range used: ', number_formatter(sigma_range, format = '(e7.1)')
    print, 'nev_range used: ', number_formatter(nev_range, format = '(e7.1)')
    if n_elements(nnr_range) gt 0 then print, 'nnr_range used: ', number_formatter(nnr_range, format = '(e7.1)')
    print, 'snr_range used: ', number_formatter(snr_range, format = '(e7.1)')
    if n_elements(noise_range) gt 0 then print, 'noise_range used: ', $
      number_formatter(noise_range, format = '(e7.1)')
  endif
  
end

pro enterprise_diff_wrapper, folder_names, obs_names_in, cube_types = cube_types, pols = pols, refresh_diff = refresh_diff, $
    spec_window_types = spec_window_types, all_type_pol = all_type_pol, $
    png = png, eps = eps, pdf = pdf, data_range = data_range, data_min_abs = data_min_abs, $
    kperp_linear_axis = kperp_linear_axis, kpar_linear_axis = kpar_linear_axis, sim = sim, $
    plot_1d = plot_1d, axis_type_1d=axis_type_1d, window_num = window_num, $
    ps_foldernames = ps_foldernames, diff_save_path = diff_save_path, exact_obsnames = exact_obsnames
    
  message, 'Error: This wrapper is depricated and will not continue to be supported. Please call ps_diff_wrapper instead. ' + $
    'This line can be commented out to allow the deprecacated code to run.'
    
  if n_elements(folder_names) gt 2 then message, 'only 1 or 2 folder_names allowed'
  if n_elements(folder_names) eq 0 then message, 'at least 1 folder name must be specified'
  if n_elements(obs_names_in) gt 2 then message, 'only 1 or 2 obs_names_in allowed'
  if n_elements(spec_window_types) gt 2 then message, 'only 1 or 2 spec_window_types allowed'
  
  folder_names = enterprise_folder_locs(folder_names, rts = rts)
  
  obs_info = ps_filenames(folder_names, obs_names_in, dirty_folder = dirty_folder, exact_obsnames = exact_obsnames, rts = rts, sim = sim, $
    uvf_input = uvf_input, casa = casa, data_subdirs = data_subdirs, $
    ps_foldernames = ps_foldernames, save_paths = save_paths, plot_paths = plot_paths, refresh_info = refresh_info, no_wtvar_rts = no_wtvar_rts)
    
  if n_elements(diff_save_path) gt 0 then diff_plot_path = diff_save_path + path_sep() + 'plots' + path_sep()
  
  wh_noinfo = where(obs_info.info_files eq '', count_noinfo)
  if count_noinfo gt 0 then message, 'Info files are not all present'
  
  ps_difference_plots, folder_names, obs_info, cube_types, pols, spec_window_types = spec_window_types, $
    all_type_pol = all_type_pol, refresh_diff = refresh_diff, freq_ch_range = freq_ch_range, $
    plot_path = diff_plot_path, plot_filebase = plot_filebase, save_path = diff_save_path, $
    savefilebase = savefilebase, $
    note = note, kperp_linear_axis = kperp_linear_axis, kpar_linear_axis = kpar_linear_axis, $
    plot_1d = plot_1d, axis_type_1d=axis_type_1d, $
    wt_cutoffs = wt_cutoffs, wt_measures = wt_measures, $
    data_range = data_range, data_min_abs = data_min_abs, diff_ratio = diff_ratio, $
    quiet = quiet, png = png, eps = eps, pdf = pdf, window_num = window_num
    
end

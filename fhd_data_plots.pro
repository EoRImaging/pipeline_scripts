pro fhd_data_plots, datafile, save_path = save_path, savefilebase = savefilebase, plot_path = plot_path, $
                    pol_inc = pol_inc, type_inc = type_inc, $
                    refresh_dft = refresh_dft, dft_fchunk = dft_fchunk, refresh_ps = refresh_ps, refresh_binning = refresh_binning, $
                    std_power = std_power, no_kzero = no_kzero, slice_nobin = slice_nobin, $
                    data_range = data_range, $
                    log_kpar = log_kpar, log_kperp = log_kperp, kpar_bin = kpar_bin, kperp_bin = kperp_bin, log_k1d = log_k1d, $
                    k1d_bin = k1d_bin, kperp_linear_axis = kperp_linear_axis, kpar_linear_axis = kpar_linear_axis, $
                    baseline_axis = baseline_axis, delay_axis = delay_axis, hinv = hinv, plot_wedge_line = plot_wedge_line, $
                    grey_scale = grey_scale, pub = pub

  nfiles = n_elements(datafile)
  if nfiles gt 2 then message, 'only 1 or 2 datafiles is supported'

  if keyword_set(refresh_dft) then refresh_ps = 1
  if keyword_set(refresh_ps) then refresh_binning = 1

  ;; default to including baseline axis & delay axis
  if n_elements(baseline_axis) eq 0 then baseline_axis = 1
  if n_elements(delay_axis) eq 0 then delay_axis = 1

  ;; default to hinv
  if n_elements(hinv) eq 0 then hinv = 1

  ;; default to plot wedge line
  if n_elements(plot_wedge_line) eq 0 then plot_wedge_line=1

  if n_elements(pol_inc) eq 0 then pol_inc = ['xx', 'yy']
  pol_enum = ['xx', 'yy']
  npol = n_elements(pol_inc)
  pol_num = intarr(npol)
  for i=0, npol-1 do begin
     wh = where(pol_enum eq pol_inc[i], count)
     if count eq 0 then message, 'pol ' + pol_inc[i] + ' not recognized.'
     pol_num[i] = wh[0]
  endfor
  pol_inc = pol_enum[pol_num[uniq(pol_num, sort(pol_num))]]
  
  if n_elements(type_inc) eq 0 then type_inc = ['dirty', 'model', 'res']
  type_enum = ['dirty', 'model', 'res']
  ntype = n_elements(type_inc)
  type_num = intarr(ntype)
  for i=0, ntype-1 do begin
     wh = where(type_enum eq type_inc[i], count)
     if count eq 0 then message, 'type ' + type_inc[i] + ' not recognized.'
     type_num[i] = wh[0]
  endfor
  type_inc = type_enum[type_num[uniq(type_num, sort(type_num))]]

  fadd = ''
  if keyword_set(std_power) then fadd = fadd + '_sp'
  
  fadd_2dbin = ''
  wt_fadd_2dbin = ''
  ;;if keyword_set(fill_holes) then fadd_2dbin = fadd_2dbin + '_nohole'
  if keyword_set(no_kzero) then begin
     fadd_2dbin = fadd_2dbin + '_nok0'
     wt_fadd_2dbin = wt_fadd_2dbin + '_nok0'
  endif
  if keyword_set(log_kpar) then begin
     fadd_2dbin = fadd_2dbin + '_logkpar'
     wt_fadd_2dbin = wt_fadd_2dbin + '_logkpar'
  endif
  if keyword_set(log_kperp) then begin
     fadd_2dbin = fadd_2dbin + '_logkperp'
     wt_fadd_2dbin = wt_fadd_2dbin + '_logkperp'
  endif

  fadd_1dbin = ''
  if keyword_set(log_k) then fadd_1dbin = fadd_1dbin + '_logk'

  n_cubes = npol*ntype
  type_pol_str = strarr(n_cubes)
  for i=0, npol-1 do type_pol_str[ntype*i:i*ntype+ntype-1] = type_inc + '_' + pol_inc[i]
  weight_labels = strupcase(pol_inc)
  weight_ind = intarr(n_cubes)
  for i=0, npol-1 do weight_ind[ntype*i:i*ntype+ntype-1] = i
  wt_file_labels = '_weights_' + strlowcase(weight_labels[weight_ind])
  file_labels = '_' + strlowcase(type_pol_str)
  titles = strarr(n_cubes)
  for i=0, npol-1 do titles[ntype*i:i*ntype+ntype-1] = type_inc + ' ' + strupcase(pol_inc[i])
  
  if n_elements(savefilebase) ne 0 then begin
     if n_elements(savefilebase) ne n_cubes then begin
        if n_elements(savefilebase) eq 1 then begin
           ;; need general_filebase for 1D plotfiles, make sure it doesn't have a full path
           general_filebase = file_basename(savefilebase)
           savefilebase = savefilebase + file_labels 
        endif else $
           message, 'savefilebase must be a scalar or have a number of elements given by the number of polarizations * number of types'
     endif else begin
        ;; need general_filebase for 1D plotfiles, make sure it doesn't have a full path
        nparts_max = 20
        fileparts = strarr(nparts_max, n_cubes)
        for i=0, n_cubes-1 do begin
           temp = strsplit(file_basename(savefilebase[i]), '_', /extract)
           if n_elements(temp) gt nparts_max then begin
              temp2 = strarr(n_elements(temp) - nparts_max, n_cubes)
              fileparts = [fileparts, temp2]
           endif 
           fileparts[*,i] = temp
        endfor

        match_test = strcmp(fileparts[*,0], fileparts[*,1:*])
        wh_diff = where(match_test eq 0, count_diff, complement = wh_same, ncomplement = count_same)
        if count_diff eq 0 then general_filebase = file_basename(savefilebase[0]) $
           else begin
              if count_same gt 0 then general_filebase = strjoin(fileparts[wh_same,0], '_') $
              else general_filebase = strjoin(file_basename(savefilebase),'_')
           endelse
     endelse
  endif

  for i=0, n_cubes-1 do begin
     pol = pol_inc[i / ntype]
     type = type_inc[i mod ntype]

     file_struct = fhd_file_setup(datafile, pol, type, savefilebase = savefilebase, save_path = save_path)
     if i eq 0 then file_struct_arr = replicate(file_struct, n_cubes)
     file_struct_arr[i] = file_struct
  endfor
  undefine, file_struct

  ;; need general_filebase for 1D plotfiles, make sure it doesn't have a full path
  if n_elements(general_filebase) eq 0 then begin
     if n_cubes eq 1 then general_filebase = file_struct_arr.general_filebase $
     else begin
        nparts_max = 10
        fileparts = strarr(nparts_max, n_cubes)
        for i=0, n_cubes-1 do begin
           temp = strsplit(file_struct_arr(i).general_filebase, '_', /extract)
           if n_elements(temp) gt nparts_max then begin
              temp2 = strarr(n_elements(temp) - nparts_max, n_cubes)
              fileparts = [fileparts, temp2]
              nparts_max = n_elements(temp)
           endif 
           fileparts[0:n_elements(temp)-1,i] = temp
        endfor

        match_test = strcmp(fileparts[*,0], fileparts[*,1:*])
        wh_diff = where(match_test eq 0, count_diff, complement = wh_same, ncomplement = count_same)
        if count_diff eq 0 then general_filebase = file_struct_arr(0).general_filebase $
           else begin
              if count_same gt 0 then general_filebase = strjoin(fileparts[wh_same,0], '_') $
              else general_filebase = strjoin(file_struct_arr.general_filebase,'_')
           endelse
     endelse
  endif

  savefiles_2d = file_struct_arr.savefile_froot + file_struct_arr.savefilebase + fadd_2dbin + '_2dkpower.idlsave'
  test_save_2d = file_test(savefiles_2d) *  (1 - file_test(savefiles_2d, /zero_length))

  savefiles_1d = file_struct_arr.savefile_froot + file_struct_arr.savefilebase + fadd_1dbin + '_1dkpower.idlsave'
  test_save_1d = file_test(savefiles_1d) *  (1 - file_test(savefiles_1d, /zero_length))

  if keyword_set(refresh_binning) then begin
     test_save_2d = test_save_2d*0
     test_save_1d = test_save_1d*0
  endif

  if n_elements(file_struct_arr[0].nside) ne 0 then healpix = 1 else healpix = 0

  n_freq = n_elements(file_struct_arr[0].frequencies)
  if healpix and n_elements(dft_fchunk) ne 0 then if dft_fchunk gt n_freq then begin
     print, 'dft_fchunk is larger than the number of frequency slices, setting it to the number of slices -- ' + $
            number_formatter(n_freq)
     dft_fchunk = n_freq
  endif

  for i=0, n_cubes-1 do begin

     ;; if binsizes are specified, check that binsize is right
     if (n_elements(kperp_bin) ne 0 or n_elements(kpar_bin) ne 0) and test_save_2d[i] gt 0 then begin
        if n_elements(kpar_bin) ne 0 then begin
           kpar_bin_file = getvar_savefile(savefiles_2d[i], kpar_bin)
           if abs(kpar_bin - kpar_bin_file) gt 0. then test_save_2d[i]=0
        endif
        if test_save_2d[i] gt 0 and n_elements(kpar_bin) ne 0 then begin
           kperp_bin_file = getvar_savefile(savefiles_2d[i], kperp_bin)
           if abs(kperp_bin - kperp_bin_file) gt 0. then test_save_2d[i]=0
        endif
     endif

     if n_elements(k1d_bin) ne 0 and test_save_1d[i] gt 0 then begin
        k_bin_file = getvar_savefile(savefiles_1d[i], k_bin)
        if abs(k_bin - k_bin_file) gt 0. then test_save_1d[i]=0
     endif

     test = test_save_2d[i] * test_save_1d[i]

     if test eq 0 then begin

        if healpix then begin
           weight_refresh = intarr(n_cubes)
           if keyword_set(refresh_dft) then begin
              temp = weight_ind[uniq(weight_ind, sort(weight_ind))]
              for j=0, n_elements(temp)-1 do weight_refresh[(where(weight_ind eq temp[j]))[0]] = 1
           endif

           fhd_3dps, file_struct_arr[i], kcube_refresh = refresh_ps, dft_refresh_data = refresh_dft, $
                     dft_refresh_weight = weight_refresh[i], $
                     dft_fchunk = dft_fchunk, std_power = std_power, no_kzero = no_kzero, $
                     log_kpar = log_kpar, log_kperp = log_kperp, kpar_bin = kpar_bin, kperp_bin = kperp_bin, $
                     /quiet
        endif else $
           fhd_3dps, file_struct_arr[i], kcube_refresh = refresh_ps, std_power = std_power, no_kzero = no_kzero, $
                     log_kpar = log_kpar, log_kperp = log_kperp, kpar_bin = kpar_bin, kperp_bin = kperp_bin, /quiet
     endif
  endfor


  restore, savefiles_2d[0]
  wh_good_kperp = where(total(power, 2) gt 0, count)
  if count eq 0 then stop
  ;;kperp_plot_range = [min(kperp_edges[wh_good_kperp]), max(kperp_edges[wh_good_kperp+1])]

  ;;kperp_plot_range = [6e-3, min([max(kperp_edges[wh_good_kperp+1]),1.1e-1])]
  ;;kperp_plot_range = [5./kperp_lambda_conv, min([max(kperp_edges[wh_good_kperp+1]),1.1e-1])]

  kperp_plot_range = [5./kperp_lambda_conv, file_struct_arr.max_baseline_lambda/kperp_lambda_conv]

  if keyword_set(hinv) then kperp_plot_range = kperp_plot_range / hubble_param
  

  if n_elements(plot_path) ne 0 then plotfile_path = plot_path $
  else if n_elements(save_path) ne 0 then plotfile_path = save_path else plotfile_path = file_struct_arr.savefile_froot
  plotfile_base = plotfile_path + file_struct_arr.savefilebase + fadd
  plotfile_base_wt = plotfile_path + file_struct_arr.weight_savefilebase + wt_file_labels[uniq(weight_ind, sort(weight_ind))] + fadd

  plot_fadd = ''
  if keyword_set(grey_scale) then plot_fadd = plot_fadd + '_grey'

  plotfiles_2d = plotfile_base + fadd_2dbin + '_2dkpower' + plot_fadd + '.eps'
  plotfiles_2d_wt = plotfile_base_wt + fadd_2dbin + '_2d' + plot_fadd + '.eps'
  plotfiles_2d_noise = plotfile_base + fadd_2dbin + '_2dnoise' + plot_fadd + '.eps'
  plotfiles_2d_snr = plotfile_base + fadd_2dbin + '_2dsnr' + plot_fadd + '.eps'
  plotfile_1d = plotfile_path + general_filebase + fadd + fadd_1dbin + '_1dkpower' + '.eps'

  ;; if not keyword_set(slice_nobin) then slice_fadd = '_binned' else slice_fadd = ''
  ;; yslice_plotfile = plotfile_base + '_xz_plane' + plot_fadd + slice_fadd + '.eps'
  ;; xslice_plotfile = plotfile_base + '_yz_plane' + plot_fadd + slice_fadd + '.eps'
  ;; zslice_plotfile = plotfile_base + '_xy_plane' + plot_fadd + slice_fadd + '.eps'

  if keyword_set(plot_wedge_line) then begin
     z0_freq = 1420.40 ;; MHz
     redshifts = z0_freq/file_struct_arr[0].frequencies - 1
     mean_redshift = mean(redshifts)

     cosmology_measures, mean_redshift, wedge_factor = wedge_factor
     ;; assume 20 degrees from pointing center to first null
     source_dist = 20d * !dpi / 180d
     fov_amp = wedge_factor * source_dist

     ;; calculate angular distance to horizon
     horizon_amp = wedge_factor * ((file_struct_arr[0].max_theta+90d) * !dpi / 180d)

     wedge_amp = [fov_amp, horizon_amp]
  endif else wedge_amp = 0d

  nplots = n_cubes + npol
  
  savefiles_2d_use = strarr(nplots)
  plotfiles_2d_use = strarr(nplots)
  plot_sigma = intarr(nplots)
  plot_titles = strarr(nplots)
  for i=0, npol-1 do begin
     savefiles_2d_use[i*(ntype+1):i*(ntype+1)+ntype-1] = savefiles_2d[i*ntype:i*ntype+ntype-1]
     savefiles_2d_use[i*(ntype+1)+ntype] = savefiles_2d[i*ntype]
     plotfiles_2d_use[i*(ntype+1):i*(ntype+1)+ntype-1] = plotfiles_2d[i*ntype:i*ntype+ntype-1]
     plotfiles_2d_use[i*(ntype+1)+ntype] = plotfiles_2d_wt[i]
     plot_sigma[i*(ntype+1)+ntype]=1
     plot_titles[i*(ntype+1):i*(ntype+1)+ntype-1] = titles[i*ntype:i*ntype+ntype-1] + textoidl(' P_k', font = font)
     plot_titles[i*(ntype+1)+ntype] = weight_labels[i] + ' Expected Noise'
  endfor

  if keyword_set(pub) then begin
     for i=0, nplots-1 do begin
        
        if plot_sigma[i] eq 0 then $
           kpower_2d_plots, savefiles_2d_use[i], /pub, plotfile = plotfiles_2d_use[i], $
                            kperp_plot_range = kperp_plot_range, kpar_plot_range = kpar_plot_range, data_range = data_range, $
                            title = plot_titles[i], grey_scale = grey_scale, plot_wedge_line = plot_wedge_line, hinv = hinv, $
                            wedge_amp = wedge_amp, baseline_axis = baseline_axis, delay_axis = delay_axis, $
                            kperp_linear_axis = kperp_linear_axis, kpar_linear_axis = kpar_linear_axis $
        else kpower_2d_plots, savefiles_2d_use[i], /plot_sigma, /pub, plotfile = plotfiles_2d_use[i],$
                              kperp_plot_range = kperp_plot_range, kpar_plot_range = kpar_plot_range, data_range = sigma_range, $
                              title = plot_titles[i], grey_scale = grey_scale, plot_wedge_line = plot_wedge_line, hinv = hinv, $
                              wedge_amp = wedge_amp, baseline_axis = baseline_axis, delay_axis = delay_axis, $
                              kperp_linear_axis = kperp_linear_axis, kpar_linear_axis = kpar_linear_axis
     endfor

     for i=0, n_cubes-1 do kpower_2d_plots, savefiles_2d[i], /pub, /snr, plotfile = plotfiles_2d_snr[i], $
                                            kperp_plot_range = kperp_plot_range, kpar_plot_range = kpar_plot_range, $
                                            data_range = snr_range, $
                                            title = titles[i] + ' SNR (' + textoidl('P_k/N_E', font = font)+')', $
                                            grey_scale = grey_scale, plot_wedge_line = plot_wedge_line, hinv = hinv, $
                                            wedge_amp = wedge_amp, baseline_axis = baseline_axis, delay_axis = delay_axis, $
                                            kperp_linear_axis = kperp_linear_axis, kpar_linear_axis = kpar_linear_axis
     if nfiles eq 2 then begin  
        for i=0, n_cubes-1 do kpower_2d_plots, savefiles_2d[i], /pub, /plot_noise, plotfile = plotfiles_2d_noise[i], $
                                               kperp_plot_range = kperp_plot_range, kpar_plot_range = kpar_plot_range, $
                                               data_range = noise_range, title = titles[i] + ' Observed Noise', $
                                               grey_scale = grey_scale, plot_wedge_line = plot_wedge_line, hinv = hinv, $
                                               wedge_amp = wedge_amp, baseline_axis = baseline_axis, delay_axis = delay_axis, $
                                               kperp_linear_axis = kperp_linear_axis, kpar_linear_axis = kpar_linear_axis

     for i=0, n_cubes-1 do kpower_2d_plots, savefiles_2d[i], /pub, /nnr, plotfile = plotfiles_2d_snr[i], $
                                            kperp_plot_range = kperp_plot_range, kpar_plot_range = kpar_plot_range, $
                                            data_range = nnr_range, $
                                            title = titles[i] + ' Noise Ratio (' + textoidl('N_O/N_E', font = font) + ')', $
                                            grey_scale = grey_scale, plot_wedge_line = plot_wedge_line, hinv = hinv, $
                                            wedge_amp = wedge_amp, baseline_axis = baseline_axis, delay_axis = delay_axis, $
                                            kperp_linear_axis = kperp_linear_axis, kpar_linear_axis = kpar_linear_axis
  endif   
  endif else begin

     ncol = ntype + 1 ;; ntype + 1 for sigma
     nrow = npol
     start_multi_params = {ncol:ncol, nrow:nrow, ordering:'row'}
     window_num = 1
     
     for i=0, nplots-1 do begin
        if i gt 0 then  pos_use = positions[*,i]

        if plot_sigma[i] eq 0 then $
           kpower_2d_plots, savefiles_2d_use[i], multi_pos = pos_use, start_multi_params = start_multi_params, $
                            kperp_plot_range = kperp_plot_range, kpar_plot_range = kpar_plot_range, data_range = data_range,  $
                            title = plot_titles[i], grey_scale = grey_scale, plot_wedge_line = plot_wedge_line, hinv = hinv, $
                            wedge_amp = wedge_amp, baseline_axis = baseline_axis, delay_axis = delay_axis, $
                            kperp_linear_axis = kperp_linear_axis, kpar_linear_axis = kpar_linear_axis, window_num = window_num $
        else kpower_2d_plots, savefiles_2d_use[i], multi_pos = pos_use, start_multi_params = start_multi_params, /plot_sigma, $
                              kperp_plot_range = kperp_plot_range, kpar_plot_range = kpar_plot_range, title = plot_titles[i], $
                              grey_scale = grey_scale, plot_wedge_line = plot_wedge_line, wedge_amp = wedge_amp, hinv = hinv, $
                              baseline_axis = baseline_axis, delay_axis = delay_axis, $
                              kperp_linear_axis = kperp_linear_axis, kpar_linear_axis = kpar_linear_axis, window_num = window_num 
        if i eq 0 then begin
           positions = pos_use
           undefine, start_multi_params
        endif
     endfor
     undefine, positions, pos_use

     ;; now plot SNR -- no separate sigma plots
     nrow = npol
     ncol = ntype
     start_multi_params = {ncol:ncol, nrow:nrow, ordering:'row'}
     
     window_num = 2
     ;;snr_range = [1e0, 1e6]
     for i=0, n_cubes-1 do begin
        if i gt 0 then  pos_use = positions[*,i]
        
        kpower_2d_plots, savefiles_2d[i], /snr, multi_pos = pos_use, start_multi_params = start_multi_params, $
                         kperp_plot_range = kperp_plot_range, kpar_plot_range = kpar_plot_range, data_range = snr_range, $
                         title = titles[i] + ' SNR (' + textoidl('P_k/N_E', font = font)+')', $
                         grey_scale = grey_scale, plot_wedge_line = plot_wedge_line, wedge_amp = wedge_amp, hinv = hinv, $
                         baseline_axis = baseline_axis, delay_axis = delay_axis, kperp_linear_axis = kperp_linear_axis, $
                         kpar_linear_axis = kpar_linear_axis, window_num = window_num
        if i eq 0 then begin
           positions = pos_use
           undefine, start_multi_params
        endif
     endfor
     undefine, positions, pos_use


     if nfiles eq 2 then begin
        
        window_num = 3
        start_multi_params = {ncol:ncol, nrow:nrow, ordering:'row'}
  
        ;;noise_range = [1e18, 1e22]
        for i=0, n_cubes-1 do begin
           if i gt 0 then  pos_use = positions[*,i]
           
           kpower_2d_plots, savefiles_2d[i], /plot_noise, multi_pos = pos_use, start_multi_params = start_multi_params, $
                            kperp_plot_range = kperp_plot_range, kpar_plot_range = kpar_plot_range, data_range = noise_range, $
                            title = titles[i] + ' Observed Noise', grey_scale = grey_scale, $
                            plot_wedge_line = plot_wedge_line, wedge_amp = wedge_amp, hinv = hinv, $
                            baseline_axis = baseline_axis, delay_axis = delay_axis, kperp_linear_axis = kperp_linear_axis, $
                            kpar_linear_axis = kpar_linear_axis, window_num = window_num
           if i eq 0 then begin
              positions = pos_use
              undefine, start_multi_params
           endif
        endfor

        window_num = 4
        start_multi_params = {ncol:ncol, nrow:nrow, ordering:'row'}
        undefine, pos_use
        
        for i=0, n_cubes-1 do begin
           if i gt 0 then  pos_use = positions[*,i]
           
           kpower_2d_plots, savefiles_2d[i], /nnr, multi_pos = pos_use, start_multi_params = start_multi_params, $
                            kperp_plot_range = kperp_plot_range, kpar_plot_range = kpar_plot_range, data_range = nnr_range, $
                            title = titles[i] + ' Noise Ratio (' + textoidl('N_O/N_E', font = font) + ')', $
                            grey_scale = grey_scale, plot_wedge_line = plot_wedge_line, wedge_amp = wedge_amp, hinv = hinv, $
                            baseline_axis = baseline_axis, delay_axis = delay_axis, kperp_linear_axis = kperp_linear_axis, $
                            kpar_linear_axis = kpar_linear_axis, window_num = window_num
           if i eq 0 then begin
              positions = pos_use
              undefine, start_multi_params
           endif
        endfor

     endif

   endelse

  file_arr = savefiles_1d
  kpower_1d_plots, file_arr, window_num = 5, colors = colors, names = titles, delta = delta, hinv = hinv, pub = pub, $
                   plotfile = plotfile_1d

end

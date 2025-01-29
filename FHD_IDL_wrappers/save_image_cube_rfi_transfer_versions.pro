pro save_image_cube_rfi_transfer_versions, obs_id, output_directory, version, transfer_obs_id, time_trim_early, time_trim_late, platform


  ; parse command line args
  compile_opt strictarr
  cm_args = command_line_args(count = nargs)
  if nargs gt 0l then begin
    args = cm_args
    obs_id = args[0]
    output_directory = args[1]
    version = args[2]

    if nargs gt 3 then begin
        transfer_obs_id = args[3]
    endif else begin
        transfer_obs_id = obs_id
        message, 'No transfer_obs_id provided, using the obs_id provided to transfer cal. Ignore this message if doing a calibration only run.'
    endelse
        
    if nargs gt 4 then begin
      time_trim_early = float(args[4])
      time_trim_late = float(args[5])
    endif
    
    if nargs gt 6 then begin
      ; will be "aws" if running on AWS
      platform = args[6]
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
  ; ensure obs_id is a string for file naming
  obs_id = number_formatter(obs_id)
  transfer_obs_id = number_formatter(transfer_obs_id)
  if obs_id ge 1156551320 then begin
      instrument = "mwa2"
  endif

  case version of
   
    "save_image_cube_rfi_transfer_cal": begin
        ;;Fill model visibilities turned on
        fill_model_visibilities=1
        beam_nfreq_avg=1

        model_delay_filter=1
        cal_time_average=0
        max_cal_iter=1000L

        ; Wenyang's auto cal
        auto_ratio_calibration=1

        ; fit for the cable lengths
        cal_reflection_mode_theory=1
        cal_mode_fit=[90,150,230,320];,400,524]

        digital_gain_jump_polyfit=1
        cal_stop=1

        ; use the DFT approximation rather than a flux cut
        dft_threshold=1

        ; Use Ian's new speedup
        use_adaptive_calibration_gain=1
        calibration_base_gain=0.5
       
       
        if platform eq 'aws' then begin
        vis_path = '/uvfits/'
        endif else begin
            if stregex(hostname, 'salix', /boolean) eq 1 then begin
              vis_path = '/Volumes/Data4/elillesk/data_and_analysis/uvfits/aws_redownload/'
            endif else begin
              vis_path = '';;'/data3/users/bryna/van_vleck_corrected/'
            endelse
        endelse
       
  end  


  
   
    
    
    
    'save_image_cube_rfi_transfer_grid_trimmed': begin
      if n_elements(time_trim_early) eq 0 then message, 'time_trim_early and time_trim_late must be provided for trimmed versions.'
      if n_elements(time_trim_late) eq 0 then message, 'time_trim_early and time_trim_late must be provided for trimmed versions.'
      ;time_cut = [48,-42] ;corresponds with the first time included being the time starting at 24th time index, the time stops being included at the 32nd time index, with 53 total time indices and 2 second intervals. (24*2 = 48, 53*2 - 32*2 = 42)
      time_cut = [time_trim_early,time_trim_late]
      beam_nfreq_avg = 1
      restrict_hpx_inds = 'EoR0_high_healpix_inds_3x.idlsave'

      ; ; change from van_vleck:
      ; ; use a bigger kspan. defaults to 600
      ; ps_kspan=200.
      ; ; save the uvf cubes out
      save_uvf = 1
      save_image_cubes = 1

      kernel_window = 1 ; Modified gridding kernel, 1='Blackman-Harris^2'
      calibrate_visibilities = 0
      return_cal_visibilities = 0
      model_visibilities = 1
      beam_mask_threshold = 1e3

      ; use the DFT approximation
      dft_threshold = 1

      if platform eq 'aws' then begin
      ;;This never gets used
        ; these paths work because of the AWS wrapper that copies the files here
        ;model_uv_transfer = '/uvfits/transfer/' + obs_id + '_model_uv_arr.sav'
        transfer_calibration = '/uvfits/transfer/' + transfer_obs_id + '_cal.sav'
      endif else begin
        if stregex(hostname, 'salix', /boolean) eq 1 then begin
          fhd_cal_folder = '/Volumes/Data3/elillesk/data_and_analysis/fhd/fhd_save_image_cube_rfi_transfer_cal/'
        endif else begin
          fhd_cal_folder = '';;'/data3/users/bryna/fhd_outs/orthoslant_interp_cal1/'
        endelse
        ;model_uv_transfer = fhd_cal_folder + 'cal_prerun/' + obs_id + '_model_uv_arr.sav'
        transfer_calibration = fhd_cal_folder + 'calibration/' + transfer_obs_id + '_cal.sav'
      endelse
      
      
      if platform eq 'aws' then begin
        vis_path = '/uvfits/'
      endif else begin
        if stregex(hostname, 'salix', /boolean) eq 1 then begin
          vis_path = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_ionospheric_or_missing/'
        endif else begin
          vis_path = '';;'/data3/users/bryna/van_vleck_corrected/'
        endelse
      endelse
      
    end
        
    
    'save_image_cube_rfi_transfer_grid': begin
      ;;if obs_id ge 1156551320 then transfer_obs_id = 1160667040 else transfer_obs_id = 1094490936
      

      beam_nfreq_avg = 1
      restrict_hpx_inds = 'EoR0_high_healpix_inds_3x.idlsave'

      ; ; change from van_vleck:
      ; ; use a bigger kspan. defaults to 600
      ; ps_kspan=200.
      ; ; save the uvf cubes out
      save_uvf = 1
      save_image_cubes = 1

      kernel_window = 1 ; Modified gridding kernel, 1='Blackman-Harris^2'
      calibrate_visibilities = 0
      return_cal_visibilities = 0
      model_visibilities = 1
      beam_mask_threshold = 1e3

      ; use the DFT approximation
      dft_threshold = 1

      if platform eq 'aws' then begin
      ;;This never gets used
        ; these paths work because of the AWS wrapper that copies the files here
        ;model_uv_transfer = '/uvfits/transfer/' + obs_id + '_model_uv_arr.sav' ;;Want this off for this version!
        transfer_calibration = '/uvfits/transfer/' + transfer_obs_id + '_cal.sav'
      endif else begin
        if stregex(hostname, 'salix', /boolean) eq 1 then begin
          fhd_cal_folder = '/Volumes/Data3/elillesk/data_and_analysis/fhd/fhd_save_image_cube_rfi_transfer_cal/'
        endif else begin
          fhd_cal_folder = '';;'/data3/users/bryna/fhd_outs/orthoslant_interp_cal1/'
        endelse
        ;model_uv_transfer = fhd_cal_folder + 'cal_prerun/' + obs_id + '_model_uv_arr.sav'
        transfer_calibration = fhd_cal_folder + 'calibration/' + transfer_obs_id + '_cal.sav'
      endelse
      
      
      if platform eq 'aws' then begin
        vis_path = '/uvfits/'
      endif else begin
        if stregex(hostname, 'salix', /boolean) eq 1 then begin
          vis_path = '/Volumes/Data3/elillesk/data_and_analysis/uvfits/2014_ionospheric_or_missing/'
        endif else begin
          vis_path = '';;'/data3/users/bryna/van_vleck_corrected/'
        endelse
      endelse
      
    end
    
    
endcase

  
  vis_file_list = vis_path + obs_id + '.uvfits'

  fhd_file_list = fhd_path_setup(vis_file_list, version = version, output_directory = output_directory)
  healpix_path = fhd_path_setup(output_dir = output_directory, subdir = 'Healpix', output_filename = 'Combined_obs', version = version)

  ; Set global defaults and bundle all the variables into a structure.
  ; Any keywords set on the command line or in the top-level wrapper will supercede these defaults
  eor_wrapper_defaults, extra
  fhd_depreciation_test, _extra = extra

  print, ''
  print, 'Keywords set in wrapper:'
  print, structure_to_text(extra)
  print, ''

  general_obs, _extra = extra
end

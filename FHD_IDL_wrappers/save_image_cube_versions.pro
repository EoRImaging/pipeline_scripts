pro save_image_cube_versions, obs_id, output_directory, version, platform
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
  ; ensure obs_id is a string for file naming
  obs_id = number_formatter(obs_id)

  case version of
    'save_image_cube_grid1': begin
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
        ; these paths work because of the AWS wrapper that copies the files here
        model_uv_transfer = '/uvfits/transfer/' + obs_id + '_model_uv_arr.sav'
        transfer_calibration = '/uvfits/transfer/' + obs_id + '_cal.sav'
      endif else begin
        if stregex(hostname, 'salix', /boolean) eq 1 then begin
          fhd_cal_folder = '/Volumes/Data1/bryna/orthoslant_interp/fhd_orthoslant_interp_cal1/'
        endif else begin
          fhd_cal_folder = '/data3/users/bryna/fhd_outs/orthoslant_interp_cal1/'
        endelse
        model_uv_transfer = fhd_cal_folder + 'cal_prerun/' + obs_id + '_model_uv_arr.sav'
        transfer_calibration = fhd_cal_folder + 'calibration/' + obs_id + '_cal.sav'
      endelse
    end
  endcase

  if platform eq 'aws' then begin
    vis_path = '/uvfits/'
  endif else begin
    if stregex(hostname, 'salix', /boolean) eq 1 then begin
      vis_path = '/Volumes/Data1/bryna/van_vleck_uvfits/'
    endif else begin
      vis_path = '/data3/users/bryna/van_vleck_corrected/'
    endelse
  endelse
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
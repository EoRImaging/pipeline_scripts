pro van_vleck_versions;, obs_id, output_directory, version, platform

  ; parse command line args
  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  obs_id = args[0]
  output_directory = args[1]
  version = args[2]
  if nargs gt 3 then platform = args[3] else platform = '' ;indicates if running on AWS

    case version of
        "van_vleck_cal1": begin
            beam_nfreq_avg=1

            model_delay_filter=1
            cal_time_average=0
            max_cal_iter=1000L

            ; do not apply bandpass or cable dependent bandpass:
            cable_bandpass_fit=0
            bandpass_calibrate=0

            ; use the auto calibration
            calibration_auto_fit=1

            ; fit for all the cable lengths
            cal_reflection_mode_theory=1
            cal_mode_fit=[90,150,230,320,400,524]

            digital_gain_jump_polyfit=1
            calibration_flux_threshold=0.1
            cal_stop=1
        end
        "van_vleck_grid1": begin
            beam_nfreq_avg=1
            restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
            ps_kspan=200.
            kernel_window=1 ;Modified gridding kernel, 1='Blackman-Harris^2'
            calibrate_visibilities=0
            return_cal_visibilities=0
            model_visibilities=1
            beam_mask_threshold=1e3

            ; these paths work because of the AWS wrapper that copies the files here
            model_uv_transfer='/uvfits/transfer/' + obs_id + '_model_uv_arr.sav'
            transfer_calibration = '/uvfits/transfer/' + obs_id + '_cal.sav'
        end
    endcase

    if platform eq 'aws' then begin
        vis_file_list = '/uvfits/' + string(obs_id) + '.uvfits'
    endif

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
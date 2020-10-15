pro van_vleck_versions, obs_id, output_directory, version, platform

    case version of
        "van_vleck_ver1": begin
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

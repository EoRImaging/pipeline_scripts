pro lwa_beam_versions, output_directory, version

    ; parse command line args
    compile_opt strictarr
    cm_args = Command_Line_Args(count=nargs)
    if nargs gt 0L then begin
        args = cm_args
        output_directory = args[1]
        version = args[2]
        spawn, 'hostname', hostname
    endif else begin
        if n_elements(output_directory) eq 0 then message, "output_directory must be provided."
        if n_elements(version) eq 0 then message, "version must be provided."
        spawn, 'hostname', hostname
    endelse        

    case version of
        "lwa1": begin
            recalculate_all = 1
            instrument = 'lwa'
            import_pyuvdata_beam_filepath = '/Users/bryna/Projects/Physics/data_files/lwa_beam_testing/LWAbeam_2015.fits'
            calibrate_visibilities = 0
            return_cal_visibilities = 0
            model_visibilities = 0
            n_pol = 2
            image_filter_fn = "filter_uv_natural"
            split_ps_export = 0  ;do not attempt even-odd splitting, required when only one time step is present
            save_uvf = 1
            beam_nfreq_avg = 1  ;do not average beam
        end
    endcase

    if stregex(hostname, 'peony', /boolean) eq 1 then begin
        vis_path = '/Users/bryna/Projects/Physics/data_files/lwa_beam_testing/'
    endif else begin
        stop
    endelse
    vis_file_list = vis_path  + 'cal46_time11_newcal_cyg_cas.uvfits'

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

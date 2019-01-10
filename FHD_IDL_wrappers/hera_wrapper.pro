pro hera_wrapper
except=!except
!except=0
heap_gc 

; parse command line args
  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  IF keyword_set(args) then begin
    obs_id = args[0]
    output_directory = args[1]
    version = args[2]
  endif

amp_degree=0
FoV=45.
dimension=1024
recalculate_all=1
deconvolution_over_resolution=1
vis_auto_model=0
vis_baseline_hist=0
calibration_visibilities_subtract=0
return_cal_visibilities=0
cleanup=1
ps_export=1
pad_uv_image=1
split_ps_export=1
combine_healpix=0
mapfn_recalculate=0
healpix_recalculate=0
silent=0
save_visibilities=1
snapshot_healpix_export=1
save_imagecube=0 
save_uvf=0
image_filter_fn='filter_uv_uniform'
export_images=1
instrument='hera'

uvfits_version=5
uvfits_subversion=1
allow_sidelobe_cal_sources=1
allow_sidelobe_model_sources=1
cable_bandpass_fit=0
saved_run_bp=0
case version of
 'ImageCube': begin
        calib_cat='GLEAM_plus_rlb2017.sav'
        calibration_catalog_file_path=filepath(calib_cat,root=rootdir('FHD'),subdir='catalog_data')
        model_catalog_file_path=filepath(calib_cat,root=rootdir('FHD'),subdir='catalog_data')
        subtract_sidelobe_catalog=filepath(calib_cat,root=rootdir('FHD'),subdir='catalog_data')
        verbose=1
        unflag_all=0
        beam_model_version=3 ;Nick F imported beam Model
        galaxy_model=0
	max_calibration_sources=10000
        max_model_sources=10000
        max_sources=10000
        n_pol=2
        nfreq_avg=1
        freq_start=120.
        freq_end=180.
        calibration_polyfit=0
        cal_amp_degree_fit=0
        cal_phase_degree_fit=0
	dft_threshold=1
	no_ps=0
	bandpass_calibrate=0
        firstpass=1
        deconvolve=0
        gain_factor=0.1
        filter_background=1
        calibrate_visibilities=1
        return_decon_visibilities=0
        model_visibilities=1 ;set to 0 for decon/ 1 for firstpass
        cable_bandpass_fit=0
        flag_calibration=1
        flag_visibilities=0
        min_baseline=25.0 ;found through minimizing visibility residuals
        min_cal_baseline=25.0 ;"   "
        calibration_auto_initialize=1
        calibration_auto_fit=1
        time_offset=25. ; for 50 sec obs
        beam_offset_time=25. ;"   "  
        cal_time_average=1
        beam_threshold=.01
        beam_model_threshold=.01
        beam_cal_threshold=.01
     end
endcase
   

data_directory='/users/jkerriga/data/jkerriga/FHD_HERA_ANALYSIS'
vis_file_list=file_search(data_directory,obs_id,count=n_files)
undefine, uvfits_subversion, uvfits_version

fhd_file_list=fhd_path_setup(vis_file_list,version=version,output_directory=output_directory)
healpix_path=fhd_path_setup(output_dir=output_directory,subdir='Healpix',output_filename='Combined_obs',version=version)

extra=var_bundle() ; bundle all the variables into a structure

print,""
print,"Keywords set in wrapper:"
print,structure_to_text(extra)
print,""
general_obs,_Extra=extra

end

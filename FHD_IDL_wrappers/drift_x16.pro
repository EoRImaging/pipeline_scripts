PRO Drift_x16,cleanup=cleanup,ps_export=ps_export,recalculate_all=recalculate_all,export_images=export_images,version=version,$
    channel_select=channel_select,_Extra=extra
except=!except
!except=0 
heap_gc

calibrate_visibilities=1
IF N_Elements(recalculate_all) EQ 0 THEN recalculate_all=1
IF N_Elements(export_images) EQ 0 THEN export_images=1
IF N_Elements(cleanup) EQ 0 THEN cleanup=0
IF N_Elements(ps_export) EQ 0 THEN ps_export=0
IF N_Elements(channel_select) EQ 0 THEN channel_select=121
IF N_Elements(version) EQ 0 THEN version=''
image_filter_fn='filter_uv_uniform' ;applied ONLY to output images

IF channel_select LE 0 THEN data_directory=rootdir('mwa')+filepath('',root='DATA',subdir=['X16','Drift']) $
    ELSE data_directory=rootdir('mwa')+filepath('',root='DATA',subdir=['X16','Drift',Strn(Floor(channel_select))])
vis_file_list=file_search(data_directory,'*.uvfits',count=n_files)
fhd_file_list=fhd_path_setup(vis_file_list,version=version,_Extra=extra)
healpix_path=fhd_path_setup(output_dir=data_directory,subdir='Healpix',output_filename='Combined_obs',version=version,_Extra=extra)
catalog_file_path=filepath('MRC_full_radio_catalog.fits',root=rootdir('FHD'),subdir='catalog_data')
;calibration_catalog_file_path=filepath('MRC_full_radio_catalog.sav',root=rootdir('FHD'),subdir='catalog_data')
calibration_catalog_file_path=filepath('mwa_calibration_source_list.sav',root=rootdir('FHD'),subdir='catalog_data')

;instrument='mwa32t' ;broken, since it would need separate beam generation files
combine_obs=0
dimension=1024.
max_sources=10000.
pad_uv_image=2.
precess=0 ;set to 1 ONLY for X16 PXX scans (i.e. Drift_X16.pro)
IF dimension GT 2048 THEN pad_uv_image=1.
no_ps=1 ;don't save postscript copy of images
gain_factor=0.2
min_baseline=1.
min_cal_baseline=50.
no_fits=1
silent=0
smooth_width=11.
nfreq_avg=16.
ps_kbinsize=0.5
ps_kspan=600.
split_ps=1
bandpass_calibrate=0
calibration_polyfit=0.
no_restrict_cal_sources=1
no_rephase=Keyword_Set(data_version)
calibrate_visibilities=1
max_cal_iter=100L
save_visibilities=0
mark_zenith=1
psf_resolution=32.
beam_diff_image=1
beam_residual_threshold=0.1
output_residual_histogram=1
show_beam_contour=1
contour_level=[0,0.01,0.05,0.1,0.2,0.5,0.67,0.9]
contour_color='blue'

cmd_args=extra
extra=var_bundle()
general_obs,_Extra=extra
!except=except
END
PRO general_obs,cleanup=cleanup,ps_export=ps_export,recalculate_all=recalculate_all,export_images=export_images,version=version,$
    beam_recalculate=beam_recalculate,healpix_recalculate=healpix_recalculate,mapfn_recalculate=mapfn_recalculate,$
    grid=grid,deconvolve=deconvolve,image_filter_fn=image_filter_fn,data_directory=data_directory,n_pol=n_pol,precess=precess,$
    vis_file_list=vis_file_list,fhd_file_list=fhd_file_list,healpix_path=healpix_path,catalog_file_path=catalog_file_path,$
    complex_beam=complex_beam,double_precison_beam=double_precison_beam,pad_uv_image=pad_uv_image,max_sources=max_sources,$
    update_file_list=update_file_list,combine_healpix=combine_healpix,start_fi=start_fi,end_fi=end_fi,flag=flag,$
    transfer_mapfn=transfer_mapfn,split_ps_export=split_ps_export,_Extra=extra
except=!except
!except=0 
heap_gc

;Set which procedures are to be run
IF N_Elements(recalculate_all) EQ 0 THEN recalculate_all=0
IF N_Elements(export_images) EQ 0 THEN export_images=0
IF N_Elements(cleanup) EQ 0 THEN cleanup=0
IF N_Elements(ps_export) EQ 0 THEN ps_export=0

;Set up paths
IF N_Elements(version) EQ 0 THEN version=0
IF N_Elements(data_directory) EQ 0 THEN data_directory=rootdir('mwa')+filepath('',root='DATA',subdir=['X16','Drift'])
IF N_Elements(vis_file_list) EQ 0 THEN vis_file_list=file_search(data_directory,'*_cal.uvfits',count=n_files)
IF N_Elements(fhd_file_list) EQ 0 THEN fhd_file_list=fhd_path_setup(vis_file_list,version=version)
IF N_Elements(healpix_path) EQ 0 THEN healpix_path=fhd_path_setup(output_dir=data_directory,subdir='Healpix',output_filename='Combined_obs',version=version)
IF N_Elements(catalog_file_path) EQ 0 THEN catalog_file_path=filepath('MRC full radio catalog.fits',root=rootdir('mwa'),subdir='DATA')
n_files=N_Elements(vis_file_list)

;Set which files to restore or recalculate (if the file is not found, it will be recalculated regardless)
IF N_Elements(double_precison_beam) EQ 0 THEN double_precison_beam=0
IF N_Elements(beam_recalculate) EQ 0 THEN beam_recalculate=recalculate_all
IF N_Elements(healpix_recalculate) EQ 0 THEN healpix_recalculate=recalculate_all
IF N_Elements(mapfn_recalculate) EQ 0 THEN mapfn_recalculate=recalculate_all
IF N_Elements(flag) EQ 0 THEN flag=0
IF N_Elements(grid) EQ 0 THEN grid=recalculate_all
IF N_Elements(deconvolve) EQ 0 THEN deconvolve=recalculate_all
IF N_Elements(transfer_mapfn) EQ 0 THEN transfer_mapfn=0

;Set up gridding and deconvolution parameters
IF N_Elements(complex_beam) EQ 0 THEN complex_beam=1
IF N_Elements(n_pol) EQ 0 THEN n_pol=2
IF N_Elements(precess) EQ 0 THEN precess=0 ;set to 1 ONLY for X16 PXX scans (i.e. Drift_X16.pro)
IF N_Elements(gain_factor) EQ 0 THEN gain_factor=0.15
IF N_Elements(max_sources) EQ 0 THEN max_sources=10000. ;maximum total number of source components to fit
IF N_Elements(add_threshold) EQ 0 THEN add_threshold=0.65 ;also fit additional components brighter than this threshold
IF N_Elements(independent_fit) EQ 0 THEN independent_fit=0 ;set to 1 to fit I, Q, (U, V) seperately. Otherwise, only I (and U) is fit
;dimension=1024.

;Set up output image parameters
IF N_Elements(pad_uv_image) EQ 0 THEN pad_uv_image=2. ;grid output images at a higher resolution if set (ignored for quickview images)
IF N_Elements(image_filter_fn) EQ 0 THEN image_filter_fn='filter_uv_hanning' ;applied ONLY to output images
noise_calibrate=0
align=0

IF N_Elements(start_fi) EQ 0 THEN start_fi=0
fi=start_fi
IF N_Elements(end_fi) EQ 0 THEN end_fi=n_files-1
WHILE fi LE end_fi DO BEGIN
    IF ~Keyword_Set(silent) THEN print,String(format='("On observation ",A," of ",A)',Strn(Floor(fi-start_fi)),Strn(Floor(end_fi-start_fi)))
    uvfits2fhd,vis_file_list[fi],file_path_fhd=fhd_file_list[fi],n_pol=n_pol,$
        independent_fit=independent_fit,beam_recalculate=beam_recalculate,transfer_mapfn=transfer_mapfn,$
        mapfn_recalculate=mapfn_recalculate,flag=flag,grid=grid,healpix_recalculate=healpix_recalculate,$
        /silent,max_sources=max_sources,deconvolve=deconvolve,catalog_file_path=catalog_file_path,$
        export_images=export_images,noise_calibrate=noise_calibrate,align=align,$
        dimension=dimension,image_filter_fn=image_filter_fn,pad_uv_image=pad_uv_image,$
        complex=complex_beam,double=double_precison_beam,precess=precess,$
        quickview=quickview,gain_factor=gain_factor,add_threshold=add_threshold,_Extra=extra
    fi+=1.
    IF Keyword_Set(update_file_list) THEN BEGIN ;use this if simultaneously downloading and deconvolving observations
        vis_file_list=file_search(data_directory,'*_cal.uvfits',count=n_files)
        fhd_file_list=fhd_path_setup(vis_file_list,version=version)
        end_fi=n_files
    ENDIF
ENDWHILE

map_projection='orth'
IF N_Elements(combine_healpix) EQ 0 THEN combine_healpix=recalculate_all*(n_files GT 1)
IF Keyword_Set(combine_healpix) THEN BEGIN
    combine_obs_sources,fhd_file_list,calibration,source_list,restore_last=0,output_path=healpix_path
    combine_obs_healpix,fhd_file_list,hpx_inds,residual_hpx,weights_hpx,dirty_hpx,sources_hpx,restored_hpx,obs_arr=obs_arr,$
        nside=nside,restore_last=0,flux_scale=flux_scale,output_path=healpix_path,image_filter_fn=image_filter_fn,_Extra=extra
    combine_obs_hpx_image,fhd_file_list,hpx_inds,residual_hpx,weights_hpx,dirty_hpx,sources_hpx,restored_hpx,$
        weight_threshold=0.5,fraction_pol=0.5,high_dirty=6.0,low_dirty=-1.5,high_residual=3.0,high_source=3.0,$
        nside=nside,output_path=healpix_path,restore_last=0,obs_arr=obs_arr,map_projection=map_projection,_Extra=extra
    calibration_test,fhd_file_list,output_path=healpix_path
ENDIF

IF Keyword_Set(ps_export) THEN BEGIN
    IF Keyword_Set(split_ps_export) THEN BEGIN
        vis_split_export_multi,n_avg=n_avg,output_path=healpix_path,vis_file_list=vis_file_list,fhd_file_list=fhd_file_list,/even,_Extra=extra
        vis_split_export_multi,n_avg=n_avg,output_path=healpix_path,vis_file_list=vis_file_list,fhd_file_list=fhd_file_list,/odd,_Extra=extra
    ENDIF ELSE vis_split_export_multi,n_avg=n_avg,output_path=healpix_path,vis_file_list=vis_file_list,fhd_file_list=fhd_file_list,_Extra=extra
ENDIF
IF Keyword_Set(cleanup) THEN FOR fi=0,n_files-1 DO fhd_cleanup,fhd_file_list[fi]


!except=except
END
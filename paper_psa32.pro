PRO paper_psa32,cleanup=cleanup,ps_export=ps_export,recalculate_all=recalculate_all,export_images=export_images,version=version,$
    beam_recalculate=beam_recalculate,healpix_recalculate=healpix_recalculate,mapfn_recalculate=mapfn_recalculate,$
    grid=grid,deconvolve=deconvolve,_Extra=extra
except=!except
!except=0 
heap_gc

IF N_Elements(recalculate_all) EQ 0 THEN recalculate_all=1
IF N_Elements(export_images) EQ 0 THEN export_images=1
IF N_Elements(cleanup) EQ 0 THEN cleanup=0
IF N_Elements(ps_export) EQ 0 THEN ps_export=0
IF N_Elements(version) EQ 0 THEN version=0
image_filter_fn='filter_uv_radial' ;applied ONLY to output images

;data_directory=rootdir('mwa')+filepath('',root='PAPER_DATA',subdir=['psa32'])
;data_directory='/data2/PAPER/psa32/'
IF StrLowCase(!version.os_family) EQ 'unix' THEN data_directory='/data2/PAPER/psa32/' $
    ELSE data_directory=rootdir('mwa')+filepath('',root='PAPER_DATA',subdir=['psa32'])
vis_file_list=file_search(data_directory,'*.uvfits',count=n_files)
fhd_file_list=fhd_path_setup(vis_file_list,version=version)

healpix_path=fhd_path_setup(output_dir=data_directory,subdir='Healpix',output_filename='Combined_obs',version=version)
catalog_file_path=filepath('MRC full radio catalog.fits',root=rootdir('mwa'),subdir='DATA')

;dimension=1024.
FoV=160.
dimension=1024.
psf_dim=6.

max_sources=10000.
pad_uv_image=2.
precess=0 ;set to 1 ONLY for X16 PXX scans (i.e. Drift_X16.pro)
instrument='paper'
lat=Ten(-30,42,17.5)
lon=Ten(21,25,41)
n_pol=2
;mirror_X=1
;independent_fit=1 ;not sure of polarization calibration for now!
time_offset=5.*60. ;time offset of phase center from start time. PAPER data are phased to 5 minutes after the start time. 
no_ps=1
no_complex_beam=1
nfreq_avg=1.

general_obs,cleanup=cleanup,ps_export=ps_export,recalculate_all=recalculate_all,export_images=export_images,version=version,$
    beam_recalculate=beam_recalculate,healpix_recalculate=healpix_recalculate,mapfn_recalculate=mapfn_recalculate,$
    grid=grid,deconvolve=deconvolve,image_filter_fn=image_filter_fn,data_directory=data_directory,n_pol=n_pol,$
    vis_file_list=vis_file_list,fhd_file_list=fhd_file_list,healpix_path=healpix_path,catalog_file_path=catalog_file_path,$
    dimension=dimension,max_sources=max_sources,pad_uv_image=pad_uv_image,precess=precess,no_ps=no_ps,$
    rotate_uv=rotate_uv,scale_uv=scale_uv,mirror_X=mirror_X,lon=lon,lat=lat,FoV=FoV,time_offset=time_offset,$
    complex_beam=complex_beam,double_precison_beam=double_precison_beam,instrument=instrument,psf_dim=psf_dim,$
    no_complex_beam=no_complex_beam,nfreq_avg=nfreq_avg,_Extra=extra

!except=except
END
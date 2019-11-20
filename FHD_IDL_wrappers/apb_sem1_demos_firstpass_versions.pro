pro eor_firstpass_versions
except=!except
!except=0
heap_gc

; wrapper to contain all the parameters for various runs we might do
; using firstpass.

; To replicate Beardsley's thesis/paper, this should be run against FHD
; githash 2e8225bc02ed94968f55740f93026029030d6ba1

; parse command line args
compile_opt strictarr
args = Command_Line_Args(count=nargs)
obs_id = args[0]
;obs_id = '1061316296'
output_directory = args[1]
;output_directory = '/nfs/eor-00/h1/nbarry/'
version = args[2]
;version = 'default'
cmd_args={version:version}

; Set default values for everything
calibrate_visibilities=1
recalculate_all=0
cleanup=0
ps_export=0
split_ps_export=1
combine_healpix=0
deconvolve=0
mapfn_recalculate=0
healpix_recalculate=0
flag_visibilities=0
vis_baseline_hist=1
silent=0
save_visibilities=1
calibration_visibilities_subtract=0
snapshot_healpix_export=1
n_avg=2
ps_kbinsize=0.5
ps_kspan=600.
image_filter_fn='filter_uv_uniform'

uvfits_version=4
uvfits_subversion=1

catalog_file_path=filepath('MRC_full_radio_catalog.fits',root=rootdir('FHD'),subdir='catalog_data')
calibration_catalog_file_path=filepath('mwa_calibration_source_list.sav',root=rootdir('FHD'),subdir='catalog_data')

dimension=2048
max_sources=20000
pad_uv_image=2.
FoV=0
no_ps=1
min_baseline=1.
min_cal_baseline=50.
ring_radius=10.*pad_uv_image
nfreq_avg=16
no_rephase=1
combine_obs=0
smooth_width=11.
bandpass_calibrate=1
calibration_polyfit=2
no_restrict_cal_sources=1
cal_cable_reflection_fit=150
restrict_hpx_inds=1

kbinsize=0.5
psf_resolution=100

; some new defaults (possibly temporary)
beam_model_version=2
dipole_mutual_coupling_factor=1
calibration_flag_iterate = 0

no_calibration_frequency_flagging=1

; even newer defaults
export_images=1
;cal_cable_reflection_correct=150
cal_cable_reflection_mode_fit=150
model_catalog_file_path=filepath('mwa_calibration_source_list.sav',root=rootdir('FHD'),subdir='catalog_data')
model_visibilities=0
return_cal_visibilities=1
allow_sidelobe_cal_sources=1
allow_sidelobe_model_sources=1

beam_offset_time=56 ; make this a default. But it won't compound with setting it directly in a version so I think it's ok.

case version of
   'apb_ghost_line':begin
      psf_resolution=16.
   end
   'apb_ghost_line_2':begin
      psf_resolution=16.
      production=1
      diffuse_model=filepath('EoR0_diffuse_model_94.sav',root=rootdir('FHD'),subdir='catalog_data')
      model_visibilities=1
      calibration_visibilities_subtract=0
      return_cal_visibilities=1
      undefine,model_catalog_file_path
    end
    'apb_jan2016_no_diffuse':begin
      foo=1 ; do nothing
    end
   'apb_mwacs_cat': begin
         ;Standard MWACS for comparison
      calibration_catalog_file_path=filepath('mwa_commissioning_source_list.sav',root=rootdir('FHD'),subdir='catalog_data')
   end
   'apb_reflection_line':begin
      undefine,cal_cable_reflection_fit
      undefine,cal_cable_reflection_mode_fit
    end

   else: print,'Default parameters'
endcase

SPAWN, 'read_uvfits_loc.py -v ' + STRING(uvfits_version) + ' -s ' + $
  STRING(uvfits_subversion) + ' -o ' + STRING(obs_id), vis_file_list
;vis_file_list=vis_file_list ; this is silly, but it's so var_bundle sees it.
undefine,uvfits_version ; don't need these passed further
undefine,uvfits_subversion
undefine,obs_id

fhd_file_list=fhd_path_setup(vis_file_list,version=version,output_directory=output_directory)
healpix_path=fhd_path_setup(output_dir=output_directory,subdir='Healpix',output_filename='Combined_obs',version=version)

extra=var_bundle() ; bundle all the variables into a structure

general_obs,_Extra=extra

end

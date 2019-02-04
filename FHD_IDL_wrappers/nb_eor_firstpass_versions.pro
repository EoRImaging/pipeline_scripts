pro nb_eor_firstpass_versions
  except=!except
  !except=0
  heap_gc
  
  ; wrapper to contain all the parameters for various runs we might do
  ; using firstpass.
  
  ; parse command line args
  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  IF keyword_set(args) then begin
    obs_id = args[0]
    output_directory = args[1]
    version = args[2]
    if nargs gt 3 then platform = args[3] else platform = '' ;indicates if running on AWS
  endif else begin
    ;obs_id = '1141660840'
    obs_id = '1061316296'
    ;obs_id = '1061319472'
    output_directory = '/nfs/mwa-04/r1/EoRuvfits/analysis/'
    version = 'nb_test'
    platform=''
  endelse
  cmd_args={version:version}
  
  uvfits_version=5
  uvfits_subversion=1
  
  case version of

  ;;;;; Nichole's versions
  
  ;************************** models **************************
  'nb_model_beam_per_baseline_clipfloor_BH': begin
    beam_clip_floor=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    beam_per_baseline=1
    psf_image_resolution=1.
    psf_resolution=2.
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    ps_kspan=200.
    healpix_recalculate=1
    snapshot_recalculate=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=384
grid_with_window=1
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_beam_per_baseline_clipfloor_image2': begin
    beam_clip_floor=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    beam_per_baseline=1
    psf_image_resolution=2.
    psf_resolution=2.
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    ps_kspan=200.
    healpix_recalculate=1
    snapshot_recalculate=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=384
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BHgrid': begin
    debug_beam_clip_floor=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=384
    ps_kspan=200.
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_delay_filter=1
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BHgrid_nofilter_upcenter': begin
    beam_clip_floor=1
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=384
    ps_kspan=200.
    ;save_uvf=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BHgrid_nofilter_update_nopadding': begin
    beam_clip_floor=1
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=384
    ps_kspan=200.
    save_uvf=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BHgrid_nofilter_update_nopadding_freqdep_1navg': begin
    beam_clip_floor=1
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    ;debug_dim=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=1
    ps_kspan=200.
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BHgrid_nofilter_update_hpx_freqdep_1navg_interp_onlyBH': begin
    beam_clip_floor=1
only_BH=1
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    ;debug_dim=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=1
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BH2grid_nofilter_update_fullsky_freqdep_1navg_interp_rephase_18dim_1e3': begin
BH2_grid=1
    beam_clip_floor=1
;only_BH=1 *was on for rephase*
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    debug_dim=1
beam_mask_threshold=1e3
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=1
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BH2_signalloss_update_1e2': begin
BH2_grid=1
    ;beam_clip_floor=1
;only_BH=1 *was on for rephase*
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    debug_dim=1
Z_update=1
model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth/cal_prerun/' + obs_id + '_model_uv_arr.sav'
beam_mask_threshold=1e3
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=1
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BH2_signalloss_update': begin
BH2_grid=1
    beam_clip_floor=1
;only_BH=1 *was on for rephase*
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    debug_dim=1
Z_update=1
model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth/cal_prerun/' + obs_id + '_model_uv_arr.sav'
beam_mask_threshold=1e3
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=1
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_signalloss': begin
;BH2_grid=1
    beam_clip_floor=1
;only_BH=1 *was on for rephase*
  ;  grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
 ;   debug_dim=1
model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth/cal_prerun/' + obs_id + '_model_uv_arr.sav'
;beam_mask_threshold=1e3
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=1
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BH2grid_beamdep_comp_nomutual': begin
BH2_grid=1
    beam_clip_floor=1
    ;v4_1=1
    dipole_mutual_coupling_factor=0
    ;beam_model_version=1
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    debug_dim=1
beam_mask_threshold=1e3
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=1.
    ;beam_dim_fit=1
    ps_kspan=200.
;model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth/cal_prerun/' + obs_id + '_model_uv_arr.sav'
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BH2grid_beamdep_simple_wmutual': begin
BH2_grid=1
    beam_clip_floor=1
    ;v4_1=1
    ;dipole_mutual_coupling_factor=0
    beam_model_version=1
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    debug_dim=1
beam_mask_threshold=1e3
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=1.
    ;beam_dim_fit=1
    ps_kspan=200.
;model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth/cal_prerun/' + obs_id + '_model_uv_arr.sav'
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BH2grid_beamdep_Jupdate': begin
BH2_grid=1
J_update=1
    beam_clip_floor=1
    ;v4_1=1
    ;dipole_mutual_coupling_factor=0
    ;beam_model_version=1
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    debug_dim=1
beam_mask_threshold=1e3
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=1.
    ;beam_dim_fit=1
    ps_kspan=200.
;model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth/cal_prerun/' + obs_id + '_model_uv_arr.sav'
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BH2grid_beamdep_Zupdate_tileflag': begin
BH2_grid=1
Z_update=1
    beam_clip_floor=1
    ;v4_1=1
    ;dipole_mutual_coupling_factor=0
    ;beam_model_version=1
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    ;unflag_all=1
    no_frequency_flagging=1
    debug_dim=1
beam_mask_threshold=1e3
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=1.
    ;beam_dim_fit=1
    ps_kspan=200.
;model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth/cal_prerun/' + obs_id + '_model_uv_arr.sav'
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BH2grid_beamdep_JZupdate': begin
BH2_grid=1
J_update=1
Z_update=1
    beam_clip_floor=1
    ;v4_1=1
    ;dipole_mutual_coupling_factor=0
    ;beam_model_version=1
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    debug_dim=1
beam_mask_threshold=1e3
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=1.
    ;beam_dim_fit=1
    ps_kspan=200.
;model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth/cal_prerun/' + obs_id + '_model_uv_arr.sav'
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BHgrid_nofilter_update_fullsky_freqdep_1navg_interp_rephase_18dim': begin
    beam_clip_floor=1
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    debug_dim=1
    ;beam_mask_threshold=1e3
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=1
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BHgrid_nofilter_update_hpx_freqdep_1navg_interp_flagging': begin
    beam_clip_floor=1
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    ;unflag_all=1
    ;debug_dim=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=1
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BHgrid_nofilter_update_hpx_freqdep_1navg_interp_noclip': begin
    ;beam_clip_floor=1
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    ;unflag_all=1
    ;debug_dim=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=1
    ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_BH2grid_nofilter_update_nopadding': begin
    beam_clip_floor=1
    grid_with_window=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=384
    ps_kspan=200.
    save_uvf=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model': begin
    debug_beam_clip_floor=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=384
    model_delay_filter=1
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_freqdep_nofilter': begin
    beam_clip_floor=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    ;nfreq_avg=384
    ;model_delay_filter=1
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_freqdep_flagged': begin
    beam_clip_floor=1
    calibrate_visibilities=0
    model_visibilities=1
    ;unflag_all=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    ;nfreq_avg=384
    model_delay_filter=1
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_nofilter': begin
    debug_beam_clip_floor=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    beam_mask_threshold=1e3
    diffuse_calibrate=0
    nfreq_avg=384
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_nofilter_nobeamclip_nomask': begin
    ;debug_beam_clip_floor=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    beam_mask_threshold=1e3
    diffuse_calibrate=0
    nfreq_avg=384
    ps_kspan=200.
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_nofilter_nobeamclip_interpthresh': begin
    ;debug_beam_clip_floor=1
    interpolate_beam_threshold=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    beam_mask_threshold=1e3
    diffuse_calibrate=0
    nfreq_avg=384
    ps_kspan=200.
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_goldenset': begin
    debug_beam_clip_floor=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    undefine, diffuse_model, diffuse_calibrate
    nfreq_avg=384
    model_delay_filter=1
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_interpolate': begin
    beam_clip_floor=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    recalculate_all=1
    interpolate_kernel=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=384
    model_delay_filter=1
    ps_kspan=200.
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_model_filter_flagged': begin
    debug_beam_clip_floor=1
    calibrate_visibilities=0
    model_visibilities=1
    unflag_all=1
    recalculate_all=1
    mapfn_recalculate=0
    return_cal_visibilities=0
    undefine, diffuse_model, diffuse_calibrate
    nfreq_avg=16
    model_delay_filter=1
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  ;************************** models **************************
  
  ;************************** sims **************************
  'nb_sim_beam_per_baseline': begin
    debug_beam_clip_floor=1
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model_beam_per_baseline'
    beam_per_baseline=1
    psf_image_resolution=1.
    psf_resolution=2.
    recalculate_all=1
    mapfn_recalculate=0
    ps_kspan=200.
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    diffuse_model=0
    diffuse_calibrate=0
    nfreq_avg=384
    remove_sim_flags=1
    max_calibration_sources=4000
    sim_perf_calibrate=1
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_noise_only': begin
    debug_beam_clip_floor=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
    diffuse_calibrate=0
    remove_sim_flags=1
    nfreq_avg=384
    sim_noise='/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper/metadata/1061316296_obs.sav'
    model_delay_filter=1
    model_visibilities=0
    calibrate_visibilities=0
    model_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_BHgrid_nofilter_eor': begin
    debug_beam_clip_floor=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model_BHgrid_nofilter'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
    diffuse_calibrate=0
    remove_sim_flags=1
    nfreq_avg=384
    sim_over_calibrate=1
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    eor_savefile='/fred/oz048/MWA/CODE/FHD/calibration_sim/fhd_mwa_hash/vis_data/'
    cal_time_average=0
    calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_BHgrid_nofilter_eor_4000perf': begin
    debug_beam_clip_floor=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model_BHgrid_nofilter'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
    diffuse_calibrate=0
    remove_sim_flags=1
    nfreq_avg=384
    sim_perf_calibrate=1
    max_calibration_sources=4000
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    eor_savefile='/fred/oz048/MWA/CODE/FHD/calibration_sim/fhd_mwa_hash/vis_data/'
    cal_time_average=0
    calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_signal_loss': begin
    debug_beam_clip_floor=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
    diffuse_calibrate=0
    remove_sim_flags=1
    nfreq_avg=384
    sim_over_calibrate=1
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    eor_savefile='/fred/oz048/MWA/CODE/FHD/calibration_sim/fhd_mwa_hash/vis_data/'
    model_delay_filter=1
    cal_time_average=0
    calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_BH2_BH2_signalloss_foregrounds': begin
    beam_clip_floor=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model_BH2_signalloss'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
    diffuse_calibrate=0
    remove_sim_flags=1
    nfreq_avg=1
    sim_perf_calibrate=1
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    eor_savefile='/fred/oz048/MWA/CODE/FHD/calibration_sim/fhd_mwa_hash/vis_data/'
    ;model_delay_filter=1
    ;cal_time_average=0
max_calibration_sources=4000
    interpolate_kernel=1
beam_mask_threshold=1e3
    debug_dim=1
BH2_grid=1
    grid_with_window=1
    calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_BH2_BH2_justEoR': begin
    calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    beam_clip_floor=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model_BH2_signalloss'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
    diffuse_calibrate=0
    remove_sim_flags=1
    model_visibilities=0
    calibrate_visibilities=0
    nfreq_avg=1
    sim_perf_calibrate=1
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    eor_savefile='/fred/oz048/MWA/CODE/FHD/calibration_sim/fhd_mwa_hash/vis_data/'
    ;model_delay_filter=1
    ;cal_time_average=0
max_calibration_sources=4000
    interpolate_kernel=1
beam_mask_threshold=1e3
    debug_dim=1
BH2_grid=1
    grid_with_window=1
  end
  'nb_sim_BH2_BH2_signalloss_exactforegrounds_6000': begin
    beam_clip_floor=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model_BH2_signalloss_update'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
Z_update=1
    diffuse_calibrate=0
    remove_sim_flags=1
    nfreq_avg=1
    sim_perf_calibrate=1
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    eor_savefile='/fred/oz048/MWA/CODE/FHD/calibration_sim/fhd_mwa_hash/vis_data/'
    ;model_delay_filter=1
    ;cal_time_average=0
max_calibration_sources=6000
    interpolate_kernel=1
beam_mask_threshold=1e3
    debug_dim=1
BH2_grid=1
    grid_with_window=1
    calibration_flux_threshold=0.1
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_BH2_BH2_signalloss_exactforegrounds_6000_coarse': begin
    beam_clip_floor=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model_BH2_signalloss_update'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
Z_update=1
    diffuse_calibrate=0
    remove_sim_flags=1
    ;nfreq_avg=1
    sim_perf_calibrate=1
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    eor_savefile='/fred/oz048/MWA/CODE/FHD/calibration_sim/fhd_mwa_hash/vis_data/'
    ;model_delay_filter=1
    ;cal_time_average=0
max_calibration_sources=6000
    interpolate_kernel=1
beam_mask_threshold=1e3
    debug_dim=1
BH2_grid=1
    grid_with_window=1
    calibration_flux_threshold=0.1
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_BH2_BH2_signalloss_exactforegrounds_6000_over': begin
    beam_clip_floor=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model_BH2_signalloss_update'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
Z_update=1
    diffuse_calibrate=0
    remove_sim_flags=1
    nfreq_avg=1
    sim_over_calibrate=1
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    eor_savefile='/fred/oz048/MWA/CODE/FHD/calibration_sim/fhd_mwa_hash/vis_data/'
    ;model_delay_filter=1
    ;cal_time_average=0
max_calibration_sources=6000
    interpolate_kernel=1
beam_mask_threshold=1e3
    debug_dim=1
BH2_grid=1
    grid_with_window=1
    calibration_flux_threshold=0.1
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_BH2_BH2_signalloss_noforegrounds_over': begin
    beam_clip_floor=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model_BH2_signalloss_update'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
Z_update=1
    diffuse_calibrate=0
    remove_sim_flags=1
    nfreq_avg=1
    sim_over_calibrate=1
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    eor_savefile='/fred/oz048/MWA/CODE/FHD/calibration_sim/fhd_mwa_hash/vis_data/'
    ;model_delay_filter=1
    ;cal_time_average=0
;max_calibration_sources=6000
    interpolate_kernel=1
beam_mask_threshold=1e3
    debug_dim=1
BH2_grid=1
    grid_with_window=1
model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth/cal_prerun/' + obs_id + '_model_uv_arr.sav'
  end
  'nb_sim_BH2_BH2_signalloss_foregrounds_8000': begin
    beam_clip_floor=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
Z_update=1
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model_BH2_signalloss_update'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
    diffuse_calibrate=0
    remove_sim_flags=1
    nfreq_avg=1
    sim_perf_calibrate=1
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    eor_savefile='/fred/oz048/MWA/CODE/FHD/calibration_sim/fhd_mwa_hash/vis_data/'
    ;model_delay_filter=1
    ;cal_time_average=0
max_calibration_sources=8000
    interpolate_kernel=1
beam_mask_threshold=1e3
    debug_dim=1
BH2_grid=1
    grid_with_window=1
    calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_BH2_BH2_signalloss_foregrounds_10000': begin
    beam_clip_floor=1
Z_update=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model_BH2_signalloss_update'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
    diffuse_calibrate=0
    remove_sim_flags=1
    nfreq_avg=1
    sim_perf_calibrate=1
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    eor_savefile='/fred/oz048/MWA/CODE/FHD/calibration_sim/fhd_mwa_hash/vis_data/'
    ;model_delay_filter=1
    ;cal_time_average=0
max_calibration_sources=10000
    interpolate_kernel=1
beam_mask_threshold=1e3
    debug_dim=1
BH2_grid=1
    grid_with_window=1
    calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_BH2_signalloss_foregrounds_10000': begin
    beam_clip_floor=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model_signalloss'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
    diffuse_calibrate=0
    remove_sim_flags=1
    nfreq_avg=1
    sim_perf_calibrate=1
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    eor_savefile='/fred/oz048/MWA/CODE/FHD/calibration_sim/fhd_mwa_hash/vis_data/'
    ;model_delay_filter=1
    ;cal_time_average=0
max_calibration_sources=10000
    interpolate_kernel=1
beam_mask_threshold=1e3
    debug_dim=1
BH2_grid=1
    grid_with_window=1
    calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_nofilter': begin
    debug_beam_clip_floor=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model_nofilter'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
    diffuse_calibrate=0
    remove_sim_flags=1
    nfreq_avg=384
    sim_perf_calibrate=1
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    cal_time_average=0
    calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_overfit': begin
    debug_beam_clip_floor=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
    diffuse_calibrate=0
    remove_sim_flags=1
    nfreq_avg=384
    max_calibration_sources=4000
    sim_over_calibrate=1
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    eor_savefile='/fred/oz048/MWA/CODE/FHD/calibration_sim/fhd_mwa_hash/vis_data/'
    model_delay_filter=1
    cal_time_average=0
    calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_perf_noeor': begin
    debug_beam_clip_floor=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ps_kspan=200.
    in_situ_sim_input = '/fred/oz048/MWA/CODE/FHD/fhd_nb_model'
    recalculate_all=1
    mapfn_recalculate=0
    diffuse_model=0
    diffuse_calibrate=0
    remove_sim_flags=1
    nfreq_avg=384
    max_calibration_sources=4000
    sim_perf_calibrate=1
    cal_mode_fit=0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_theory=0
    model_delay_filter=1
    cal_time_average=0
    calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_goldenset': begin
    in_situ_sim_input = '/nfs/mwa-04/r1/EoRuvfits/analysis/fhd_nb_model_goldenset'
    debug_beam_clip_floor=1
    max_calibration_sources=4000
    nfreq_avg=384
    sim_over_calibrate=1
    undefine, diffuse_model, diffuse_calibrate
    recalculate_all=1
    mapfn_recalculate=0
    healpix_recalculate=1
    model_delay_filter=1
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  'nb_sim_hash_perfect_smooth': begin
    in_situ_sim_input = '/nfs/mwa-04/r1/EoRuvfits/analysis/fhd_nb_model_goldenset'
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ;calibrate_visibilities=0
    debug_beam_clip_floor=1
        remove_sim_flags=1
    ;max_calibration_sources=4000
    nfreq_avg=384
    sim_over_calibrate=1
    diffuse_model=0
    diffuse_calibrate=0
    cal_mode_fit=0
    recalculate_all=1
    mapfn_recalculate=0
    healpix_recalculate=1
        model_delay_filter=1
    eor_savefile = '/nfs/mwa-04/r1/EoRuvfits/analysis/calibration_sim/fhd_nb_hash_smoothbeam/vis_data/'
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
'nb_sim_hash_overfit': begin
    in_situ_sim_input = '/nfs/mwa-04/r1/EoRuvfits/analysis/fhd_nb_model_goldenset'
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ;calibrate_visibilities=0
    debug_beam_clip_floor=1
        remove_sim_flags=1
    ;max_calibration_sources=4000
    nfreq_avg=384
    sim_over_calibrate=1
    diffuse_model=0
    diffuse_calibrate=0
    cal_mode_fit=0
    recalculate_all=1
    mapfn_recalculate=0
    healpix_recalculate=1
        model_delay_filter=1
    eor_savefile = '/nfs/mwa-04/r1/EoRuvfits/analysis/calibration_sim/fhd_nb_hash_removesimflags/vis_data/'
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
'nb_sim_hash_overfit_uvf': begin
    in_situ_sim_input = '/nfs/mwa-04/r1/EoRuvfits/analysis/fhd_nb_model_goldenset'
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ;calibrate_visibilities=0
    debug_beam_clip_floor=1
        remove_sim_flags=1
    ;max_calibration_sources=4000
    nfreq_avg=384
    sim_over_calibrate=1
    diffuse_model=0
    diffuse_calibrate=0
    cal_mode_fit=0
    ;recalculate_all=1
    ;mapfn_recalculate=0
    ;healpix_recalculate=1
        model_delay_filter=1
        save_uvf=1
    eor_savefile = '/nfs/mwa-04/r1/EoRuvfits/analysis/calibration_sim/fhd_mwa_hash/vis_data/'
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
'nb_sim_hash_only_pskspan60': begin
    ;in_situ_sim_input = '/nfs/mwa-01/r1/EoRuvfits/analysis/fhd_nb_model_goldenset_psf300'
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ;calibrate_visibilities=0
    debug_beam_clip_floor=1
        remove_sim_flags=1
    ;max_calibration_sources=4000
    nfreq_avg=384
    sim_over_calibrate=1
    diffuse_model=0
    diffuse_calibrate=0
    ps_kspan=120.
    cal_mode_fit=0
    recalculate_all=1
    mapfn_recalculate=0
    healpix_recalculate=1
        psf_resolution=100.
        calibrate_visibilities=0
    eor_savefile = '/nfs/mwa-04/r1/EoRuvfits/analysis/calibration_sim/fhd_mwa_hash/vis_data/'
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
 'nb_sim_fullbeam_16': begin
    in_situ_sim_input = '/nfs/mwa-04/r1/EoRuvfits/analysis/fhd_nb_model_fullbeam_16'
    eor_savefile = '/nfs/mwa-04/r1/EoRuvfits/analysis/calibration_sim/fhd_mwa_hash/vis_data/'
        restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ;calibrate_visibilities=0
    ;model_visibilities=1
    max_calibration_sources=4000
    debug_beam_clip_floor=1
    beam_mask_threshold=1e3
    sim_perf_calibrate=1
    diffuse_model=0
    diffuse_calibrate=0
    recalculate_all=1
    mapfn_recalculate=0
    healpix_recalculate=1
    nfreq_avg=16
    cal_mode_fit=0
        pskspan=200.
    ;model_delay_filter=1
    remove_sim_flags=1
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
   'nb_sim_simplebeam_16': begin
    in_situ_sim_input = '/nfs/mwa-04/r1/EoRuvfits/analysis/fhd_nb_model_fullbeam_16'
    eor_savefile = '/nfs/mwa-04/r1/EoRuvfits/analysis/calibration_sim/fhd_mwa_hash/vis_data/'
        restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    ;calibrate_visibilities=0
    ;model_visibilities=1
    max_calibration_sources=4000
    debug_beam_clip_floor=1
    beam_mask_threshold=1e3
    sim_perf_calibrate=1
    diffuse_model=0
    diffuse_calibrate=0
    recalculate_all=1
    mapfn_recalculate=0
    healpix_recalculate=1
    nfreq_avg=16
      beam_model_version=1
  dipole_mutual_coupling_factor=0
    cal_mode_fit=0
    pskspan=200.
    ;model_delay_filter=1
    remove_sim_flags=1
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
'nb_sim_large_unflag_eorhash_pskspan100': begin
    in_situ_sim_input = '/nfs/mwa-04/r1/EoRuvfits/analysis/fhd_nb_model_unflag_384'
    eor_savefile = '/nfs/mwa-04/r1/EoRuvfits/analysis/calibration_sim/fhd_mwa_hash/vis_data/'
    ;calibrate_visibilities=0
    ;model_visibilities=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    max_calibration_sources=4000
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    sim_perf_calibrate=1
    diffuse_model=0
    diffuse_calibrate=0
    recalculate_all=1
    mapfn_recalculate=0
    healpix_recalculate=1
    nfreq_avg=384
    ;n_avg=384
    cal_mode_fit=0
    remove_sim_flags=1
    ps_kspan=200.
    ;cal_time_average=1 ;reseting the gains makes this unnecessary
    model_delay_filter=1
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
'nb_sim_large_unflag_eorhash_pskspan200': begin
    in_situ_sim_input = '/nfs/mwa-04/r1/EoRuvfits/analysis/fhd_nb_model_unflag_384'
    eor_savefile = '/nfs/mwa-04/r1/EoRuvfits/analysis/calibration_sim/fhd_mwa_hash/vis_data/'
    ;calibrate_visibilities=0
    ;model_visibilities=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    max_calibration_sources=4000
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    sim_perf_calibrate=1
    diffuse_model=0
    diffuse_calibrate=0
    recalculate_all=1
    mapfn_recalculate=0
    healpix_recalculate=1
    nfreq_avg=384
    ;n_avg=384
    cal_mode_fit=0
    remove_sim_flags=1
    ps_kspan=400.
    ;cal_time_average=1 ;reseting the gains makes this unnecessary
    model_delay_filter=1
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end  
 'nb_sim_uvf_pskspan300_v2_noflags_40-50': begin
    in_situ_sim_input = '/nfs/mwa-04/r1/EoRuvfits/analysis/fhd_nb_model_unflag_16'
    ;eor_savefile = '/nfs/mwa-04/r1/EoRuvfits/analysis/calibration_sim/fhd_nb_goldenset_bubbles/vis_data/'
    ;calibrate_visibilities=0
    ;model_visibilities=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    max_calibration_sources=4000
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    sim_perf_calibrate=1
    diffuse_model=0
    diffuse_calibrate=0
    recalculate_all=1
    mapfn_recalculate=0
    healpix_recalculate=1
    nfreq_avg=16
    remove_sim_flags=1
    ;n_avg=384
    cal_mode_fit=0
    save_uvf=1
    ps_kspan=600.
    max_baseline=50.
    min_baseline=40.
    ;cal_time_average=1 ;reseting the gains makes this unnecessary
    model_delay_filter=1
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
  end
  ;************************** sims **************************
  
  ;************************** data **************************
  'nb_pipeline_paper': begin
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    debug_beam_clip_floor=1
    model_delay_filter=1
    ;return_cal_visibilities=0
    FoV=0
    time_cut=-2
    snapshot_recalculate=1
    ;recalculate_all=1
    transfer_psf = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop/beams'
        model_transfer = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop/cal_prerun/vis_data'
    ;        debug_gain_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop/calibration'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
    calibration_auto_fit=1
    ;cal_stop=1
    cal_bp_transfer=0
  ;saved_run_bp=0
  ;double memory, time
  end
  'nb_pipeline_paper_calstop_fullbeam': begin
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    beam_clip_floor=1
    model_delay_filter=1
    ;return_cal_visibilities=0
    FoV=0
    time_cut=-2
    snapshot_recalculate=1
    interpolate_kernel=1
    nfreq_avg=1
beam_stop=1
    ;recalculate_all=1
    ;transfer_psf = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop/beams'
    ;    model_transfer = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop/cal_prerun/vis_data'
    ;        debug_gain_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop/calibration'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
    calibration_auto_fit=1
    cal_stop=1
    ;cal_bp_transfer=0
  ;saved_run_bp=0
  ;double memory, time
  end
  'nb_calstop_fullbeam_GLEAMtenth': begin
    calibration_catalog_file_path=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    beam_clip_floor=1
    model_delay_filter=1
    ;return_cal_visibilities=0
;model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth/cal_prerun/' + obs_id + '_model_uv_arr.sav'
    FoV=0
    time_cut=-2
    snapshot_recalculate=1
    interpolate_kernel=1
    nfreq_avg=1
    recalculate_all=1
    mapfn_recalculate=0
    Z_update=1
    calibration_flux_threshold=0.1
    ;recalculate_all=1
    ;transfer_psf = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop/beams'
    ;    model_transfer = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop/cal_prerun/vis_data'
    ;        debug_gain_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop/calibration'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
    calibration_auto_fit=1
    cal_stop=1
    cal_bp_transfer=0
  ;saved_run_bp=0
  ;double memory, time
  end
  'nb_calstop_fullbeam_GLEAMtenth_missing': begin
    calibration_catalog_file_path=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    beam_clip_floor=1
    model_delay_filter=1
    ;return_cal_visibilities=0
;model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth/cal_prerun/' + obs_id + '_model_uv_arr.sav'
    FoV=0
v4=1
    time_cut=-2
    snapshot_recalculate=1
    interpolate_kernel=1
    nfreq_avg=1
    recalculate_all=1
    mapfn_recalculate=0
    Z_update=1
    calibration_flux_threshold=0.1
    ;recalculate_all=1
    ;transfer_psf = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop/beams'
    ;    model_transfer = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop/cal_prerun/vis_data'
    ;        debug_gain_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop/calibration'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
    calibration_auto_fit=1
    antenna_mod_index=256.
    cal_stop=1
    cal_bp_transfer=0
  ;saved_run_bp=0
  ;double memory, time
  end
  'nb_calstop_fullbeam_GLEAMfifth': begin
    calibration_catalog_file_path=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    beam_clip_floor=1
    model_delay_filter=1
    ;return_cal_visibilities=0
    FoV=0
    time_cut=-2
    snapshot_recalculate=1
    interpolate_kernel=1
    nfreq_avg=1
    calibration_flux_threshold=0.05
    ;recalculate_all=1
    ;transfer_psf = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop/beams'
    ;    model_transfer = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop/cal_prerun/vis_data'
    ;        debug_gain_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop/calibration'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_EGC_v2_181MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
    calibration_auto_fit=1
    cal_stop=1
    ;cal_bp_transfer=0
  ;saved_run_bp=0
  ;double memory, time
  end
  'nb_data_gauss': begin
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    debug_beam_clip_floor=1
    ;return_cal_visibilities=0
    FoV=0
    time_cut=-2
    snapshot_recalculate=1
    ;recalculate_all=1
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
    calibration_auto_fit=1
    ;cal_stop=1
    cal_bp_transfer=0
  ;saved_run_bp=0
  end
  'nb_data_BH2grid_BH2degrid': begin
;
BH2_grid=1
    debug_dim=1
beam_mask_threshold=1e3
    recalculate_all=1
    mapfn_recalculate=0
    nfreq_avg=1
    interpolate_kernel=1
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    time_cut=-2
    interpolate_kernel=1
    snapshot_recalculate=1
    ;recalculate_all=1
    cal_time_average=0
    model_visibilities=1
    transfer_calibration = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop_fullbeam/calibration/' + obs_id + '_cal.sav'
;    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
;    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
;    subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
;    ALLOW_SIDELOBE_MODEL_SOURCES =1
;    ALLOW_SIDELOBE_CAL_SOURCES =1
    ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
    calibration_auto_fit=1
    ;cal_stop=1
    cal_bp_transfer=0
  ;saved_run_bp=0
    beam_clip_floor=1
    grid_with_window=1
  end
  'nb_data_BH2grid_BH2degrid_sidelobes': begin
;
BH2_grid=1
    debug_dim=1
beam_mask_threshold=1e3
;    recalculate_all=1
;    mapfn_recalculate=0
    nfreq_avg=1
    interpolate_kernel=1
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    time_cut=-2
    interpolate_kernel=1
    snapshot_recalculate=1
    ;recalculate_all=1
    cal_time_average=0
    model_visibilities=1
    model_psf='/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop_fullbeam/beams/'
    transfer_calibration = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop_fullbeam/calibration/' + obs_id + '_cal.sav'
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
    calibration_auto_fit=1
    ;cal_stop=1
    cal_bp_transfer=0
  ;saved_run_bp=0
    beam_clip_floor=1
    grid_with_window=1
  end
  'nb_data_BH2grid_BH2degrid_GLEAMtenth_Z_v4': begin
model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth_missing/cal_prerun/' + obs_id + '_model_uv_arr.sav'
BH2_grid=1
    debug_dim=1
beam_mask_threshold=1e3
    recalculate_all=1
    mapfn_recalculate=0
    nfreq_avg=1
    interpolate_kernel=1
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    really_v4=1
;    beam_dim_fit=1
    time_cut=-2
    interpolate_kernel=1
    snapshot_recalculate=1
    ;recalculate_all=1
    cal_time_average=0
    model_visibilities=1
    ;model_psf='/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop_fullbeam/beams/'
    transfer_calibration = '/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth_missing/calibration/' + obs_id + '_cal.sav'
    ;calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ;model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ;subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ;ALLOW_SIDELOBE_MODEL_SOURCES =1
    ;ALLOW_SIDELOBE_CAL_SOURCES =1
    ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
;    calibration_auto_fit=1
    ;cal_stop=1
    cal_bp_transfer=0
  ;saved_run_bp=0
    beam_clip_floor=1
    grid_with_window=1
    Z_update=1
  end
  'nb_data_BH2grid_BH2degrid_GLEAMtenth_Z': begin
model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth_missing/cal_prerun/' + obs_id + '_model_uv_arr.sav'
BH2_grid=1
    debug_dim=1
beam_mask_threshold=1e3
    recalculate_all=1
    mapfn_recalculate=0
    nfreq_avg=1
    interpolate_kernel=1
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
;    beam_dim_fit=1
    time_cut=-2
    interpolate_kernel=1
    snapshot_recalculate=1
    ;recalculate_all=1
    cal_time_average=0
    model_visibilities=1
    ;model_psf='/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop_fullbeam/beams/'
    transfer_calibration = '/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth_missing/calibration/' + obs_id + '_cal.sav'
    ;calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ;model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ;subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ;ALLOW_SIDELOBE_MODEL_SOURCES =1
    ;ALLOW_SIDELOBE_CAL_SOURCES =1
    ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
    calibration_auto_fit=1
        antenna_mod_index=256
    ;cal_stop=1
    cal_bp_transfer=0
  ;saved_run_bp=0
    beam_clip_floor=1
    grid_with_window=1
    Z_update=1
  end
  'nb_data_BH2grid_BH2degrid_GLEAMtenth': begin
model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth/cal_prerun/' + obs_id + '_model_uv_arr.sav'
BH2_grid=1
    debug_dim=1
beam_mask_threshold=1e3
;    recalculate_all=1
;    mapfn_recalculate=0
    nfreq_avg=1
    interpolate_kernel=1
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    beam_dim_fit=1
    time_cut=-2
    interpolate_kernel=1
    snapshot_recalculate=1
    ;recalculate_all=1
    cal_time_average=0
    model_visibilities=1
    ;model_psf='/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop_fullbeam/beams/'
    transfer_calibration = '/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMtenth/calibration/' + obs_id + '_cal.sav'
    ;calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ;model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ;subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ;ALLOW_SIDELOBE_MODEL_SOURCES =1
    ;ALLOW_SIDELOBE_CAL_SOURCES =1
    ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
    calibration_auto_fit=1
    ;cal_stop=1
    cal_bp_transfer=0
  ;saved_run_bp=0
    beam_clip_floor=1
    grid_with_window=1
  end
  'nb_data_BH2grid_BH2degrid_GLEAMfifth': begin
model_uv_transfer='/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMfifth/cal_prerun/' + obs_id + '_model_uv_arr.sav'
BH2_grid=1
    debug_dim=1
beam_mask_threshold=1e3
;    recalculate_all=1
;    mapfn_recalculate=0
    nfreq_avg=1
    interpolate_kernel=1
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    beam_dim_fit=1
    time_cut=-2
    interpolate_kernel=1
    snapshot_recalculate=1
    ;recalculate_all=1
    cal_time_average=0
    model_visibilities=1
    ;model_psf='/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop_fullbeam/beams/'
    transfer_calibration = '/fred/oz048/MWA/CODE/FHD/fhd_nb_calstop_fullbeam_GLEAMfifth/calibration/' + obs_id + '_cal.sav'
    ;calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ;model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ;subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ;ALLOW_SIDELOBE_MODEL_SOURCES =1
    ;ALLOW_SIDELOBE_CAL_SOURCES =1
    ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
    calibration_auto_fit=1
    ;cal_stop=1
    cal_bp_transfer=0
  ;saved_run_bp=0
    beam_clip_floor=1
    grid_with_window=1
  end
  'nb_data_BH2grid_BH2degrid_beg': begin
;
BH2_grid=1
    debug_dim=1
beam_mask_threshold=1e3
    ;recalculate_all=1
    ;mapfn_recalculate=0
    nfreq_avg=1
freq_end=182.4
    interpolate_kernel=1
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    time_cut=-2
    interpolate_kernel=1
    snapshot_recalculate=1
    ;recalculate_all=1
    cal_time_average=0
    model_visibilities=1
    transfer_calibration = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop_fullbeam/calibration/' + obs_id + '_cal.sav'
;    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
;    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
;    subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
;    ALLOW_SIDELOBE_MODEL_SOURCES =1
;    ALLOW_SIDELOBE_CAL_SOURCES =1
    ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
    calibration_auto_fit=1
    ;cal_stop=1
    cal_bp_transfer=0
  ;saved_run_bp=0
    beam_clip_floor=1
    grid_with_window=1
  end
  'nb_data_BH2grid_BH2degrid_end': begin
; 
BH2_grid=1
    debug_dim=1
beam_mask_threshold=1e3
    ;recalculate_all=1
    ;mapfn_recalculate=0
    nfreq_avg=1
freq_start=182.4
    interpolate_kernel=1
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    time_cut=-2
    interpolate_kernel=1
    snapshot_recalculate=1
    ;recalculate_all=1
    cal_time_average=0
    model_visibilities=1
    transfer_calibration = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop_fullbeam/calibration/' + obs_id + '_cal.sav'
;    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
;    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
;    subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
;    ALLOW_SIDELOBE_MODEL_SOURCES =1
;    ALLOW_SIDELOBE_CAL_SOURCES =1
    ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
    calibration_auto_fit=1
    ;cal_stop=1
    cal_bp_transfer=0
  ;saved_run_bp=0
    beam_clip_floor=1
    grid_with_window=1
  end
  'nb_data_BH2grid_BH2degrid_BH2cal': begin
;
BH2_grid=1
    debug_dim=1
beam_mask_threshold=1e3
    ;recalculate_all=1
    ;mapfn_recalculate=0
    nfreq_avg=1
    interpolate_kernel=1
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=1
    FoV=0
    time_cut=-2
    interpolate_kernel=1
    ;snapshot_recalculate=1
    ;recalculate_all=1
    cal_time_average=0
;    model_visibilities=1
    ;transfer_calibration = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop_fullbeam/calibration/' + obs_id + '_cal.sav'
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
   ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
    calibration_auto_fit=1
    ;cal_stop=1
    cal_bp_transfer=0
  ;saved_run_bp=0
    beam_clip_floor=1
    grid_with_window=1
  end
  'nb_data_BH2grid_regdegrid_delay': begin
BH2_grid=1
    debug_dim=1
beam_mask_threshold=1e3
    recalculate_all=1
    mapfn_recalculate=0
    interpolate_kernel=1  
  calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    return_cal_visibilities=0
    FoV=0
    nfreq_avg=1
    time_cut=-2
    interpolate_kernel=1
    ;snapshot_recalculate=1
    ;recalculate_all=1
    cal_time_average=0
        model_transfer = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop_fullbeam/cal_prerun/vis_data'
    model_visibilities=1
    transfer_calibration = '/fred/oz048/MWA/CODE/FHD/fhd_nb_pipeline_paper_calstop_fullbeam/calibration/' + obs_id + '_cal.sav'
;    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
;    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
;    subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
;    ALLOW_SIDELOBE_MODEL_SOURCES =1
;    ALLOW_SIDELOBE_CAL_SOURCES =1
    ;return_sidelobe_catalog=1
    diffuse_calibrate=0
    diffuse_model=0
    digital_gain_jump_polyfit=1
    ps_kspan=200.
    calibration_auto_fit=1
    ;cal_stop=1
    cal_bp_transfer=0
  ;saved_run_bp=0
    beam_clip_floor=1
    grid_with_window=1
  end
  'nb_no_long_tiles': begin
    diffuse_calibrate=filepath('EoR0_diffuse_model_94.sav',root=rootdir('FHD'),subdir='catalog_data')
    cable_bandpass_fit=1
    tile_flag_list=[78,79,87,88,95,96,97,98,104,112,113,122,123,124]
  end
  'nb_spec_indices': begin
    calibration_catalog_file_path=filepath('mwa_calibration_source_list_gleam_kgs_fhd_fornax.sav',root=rootdir('FHD'),subdir='catalog_data')
    degrid_spectral=1
    flatten_spectrum=1
    diffuse_spectral_index=-0.5
  end
  'nb_decon_July2016_presidelobe_Aug27': begin
    max_sources=200000
    calibration_catalog_file_path=filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    ;dft_threshold=1
    gain_factor=0.1
    deconvolve=1
    return_decon_visibilities=1
    smooth_width=32
    deconvolution_filter='filter_uv_uniform'
    filter_background=1
    dimension=2048
    return_cal_visibilities=0
    FoV=0
    pad_uv_image=1
    ;time_cut=[2,-2]
    snapshot_healpix_export=1
    ;snapshot_recalculate=1
    recalculate_all=1
    subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAMIDR4_181_consistent.sav'
    ALLOW_SIDELOBE_MODEL_SOURCES =1
    ALLOW_SIDELOBE_CAL_SOURCES =1
    return_sidelobe_catalog=1
    undefine, diffuse_calibrate, diffuse_model
    debug_region_grow=1
  ;saved_run_bp=0
  ;double memory, time
  end  
  'nb_2014zenith_calonly': begin
    cal_bp_transfer=0
    diffuse_calibrate=0
    diffuse_model=0
    uvfits_version=5
    uvfits_subversion=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    ;transfer_psf = '/nfs/mwa-04/r1/EoRuvfits/analysis/fhd_nb_2014zenith_calonly/beams_save'
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    ;phase_longrun=1 ;add to github
    digital_gain_jump_polyfit=1 
    no_ref_tile=1
    cal_stop=1
    time_cut=-4
  end
  'nb_2013zenith_calonly': begin
    saved_run_bp=0
    undefine, diffuse_calibrate, diffuse_model
    uvfits_version=4
    uvfits_subversion=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    save_antenna_model=1
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    ;phase_longrun=1 ;add to github
    jump_longrun=1 
    no_ref_tile=1
    cal_stop=1
    time_cut=-4
  end
  'nb_2013zenith_calonly_autovis': begin
    cal_bp_transfer=0
    diffuse_calibrate=0
    diffuse_model=0
    uvfits_version=5
    uvfits_subversion=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    ;phase_longrun=1 ;add to github
    cal_stop=1
    time_cut=-4
  end
  'nb_2013cal_redo': begin
    cal_bp_transfer=0
    diffuse_calibrate=0
    diffuse_model=0
    uvfits_version=4
    uvfits_subversion=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    save_antenna_model=1
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    ;beam_mask_threshold=1e3
    nfreq_avg=8
    ;phase_longrun=1 ;add to github
    digital_gain_jump_polyfit=1
    no_ref_tile=1
    cal_stop=1
    time_cut=-4
  end
  'nb_auto_binoffset0': begin
    cal_bp_transfer=0
    diffuse_calibrate=0
    diffuse_model=0
    beam_offset_time=0
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    ;transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    ;phase_longrun=1 ;add to github
    cal_stop=1
    time_cut=-4
  end
  'nb_Aug2017_std': begin
    saved_run_bp=0
    undefine, diffuse_calibrate, diffuse_model
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    ;phase_longrun=1 ;add to github
    jump_longrun=1 
    ;no_ref_tile=1
    ;cal_stop=1
    time_cut=-4
  end
  'nb_Aug2017_globalbp': begin
    saved_run_bp=0
    cable_bandpass_fit=0
    undefine, diffuse_calibrate, diffuse_model
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    ;recalculate_all=1
    ;mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    ;phase_longrun=1 ;add to github
    jump_longrun=1 
    ;no_ref_tile=1
    ;cal_stop=1
    time_cut=-4
  end
  'nb_Aug2017_globalbp_wo_cable': begin
    cal_bp_transfer=0
    cable_bandpass_fit=0
    undefine, diffuse_calibrate, diffuse_model
    undefine, cal_reflection_mode_theory,cal_reflection_mode_file,cal_reflection_mode_delay,cal_reflection_hyperresolve, cal_mode_fit
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    ;recalculate_all=1
    ;mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    time_cut=-4
  end
  'nb_Aug2017_globalbp_w_cable_w_digjump_extraflagged': begin
    cal_bp_transfer=0
    cable_bandpass_fit=0
    diffuse_calibrate=0
    diffuse_model=0
    cal_reflection_mode_theory = 150
    cal_reflection_hyperresolve=1
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly_autovis/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
         debug_gain_transfer='/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013longrun_std/calibration/'
                 tile_flag_list = ['111','118','121','128','131','132','133','141','142','144','151','152','163','164']
    ;recalculate_all=1
    ;mapfn_recalculate=0
    digital_gain_jump_polyfit=1 
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    time_cut=-4
  end
  'nb_Aug2017_zeroedbp': begin
    cal_bp_transfer=0
    cable_bandpass_fit=1
    diffuse_calibrate=0
    diffuse_model=0
    cal_reflection_mode_theory=0
    cal_reflection_mode_file=0
    cal_reflection_mode_delay=0
    cal_reflection_hyperresolve=0
     cal_mode_fit=0
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly_autovis/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    debug_amp_longrun='/nfs/mwa-10/r1/EoRuvfits/analysis/ave_cals/full_ave_amp_zeroed.sav'
     debug_gain_transfer='/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013longrun_std/calibration/'
                ; tile_flag_list = ['111','118','121','128','131','132','133','141','142','144','151','152','163','164']
    recalculate_all=1
    mapfn_recalculate=0
    digital_gain_jump_polyfit=1 
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    time_cut=-4
  end
  'nb_Aug2017_globalbp_w_cable_w_digjump_nophaseref': begin
    cal_bp_transfer=0
    cable_bandpass_fit=0
    undefine, diffuse_calibrate, diffuse_model
    cal_reflection_mode_theory = 150
    cal_reflection_hyperresolve=1
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    ;recalculate_all=1
    ;mapfn_recalculate=0
    digital_gain_jump_polyfit=1 
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    time_cut=-4
    no_ref_tile=1
  end
  'nb_Aug2017_globalbp_w_cable_w_digjump_nophaseref_phaseave': begin
    cal_bp_transfer=0
    cable_bandpass_fit=0
    undefine, diffuse_calibrate, diffuse_model
    cal_reflection_mode_theory = 150
    cal_reflection_hyperresolve=1
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    ;recalculate_all=1
    ;mapfn_recalculate=0
    digital_gain_jump_polyfit=1 
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    time_cut=-4
    no_ref_tile=1
    debug_phase_longrun='/nfs/mwa-10/r1/EoRuvfits/analysis/ave_cals/full_ave_phase_dayref.sav'
  end
  'nb_Aug2017_globalbp_w_cable_w_digjump_phaseave': begin
    cal_bp_transfer=0
    cable_bandpass_fit=0
    diffuse_calibrate=0
     diffuse_model=0
    cal_reflection_mode_theory = 150
    cal_reflection_hyperresolve=1
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly_autovis/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    ;recalculate_all=1
    ;mapfn_recalculate=0
    digital_gain_jump_polyfit=1 
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    time_cut=-4
    ;no_ref_tile=1
    debug_phase_longrun='/nfs/mwa-10/r1/EoRuvfits/analysis/ave_cals/full_ave_phase_dayref.sav'
  end  

  'nb_Aug2017_cablebp_w_cable_w_digjump': begin
    cal_bp_transfer=0
    cable_bandpass_fit=1
    undefine, diffuse_calibrate, diffuse_model
    cal_reflection_mode_theory = 150
    cal_reflection_hyperresolve=1
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    recalculate_all=1
    mapfn_recalculate=0
    digital_gain_jump_polyfit=1 
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    time_cut=-4
  end
  'nb_Aug2017_savedbp_w_cable_w_digjump': begin
    cal_bp_transfer=1
    cable_bandpass_fit=1
    diffuse_calibrate=0
     diffuse_model=0
    cal_reflection_mode_theory = 150
    rephase_weights=1
    cal_reflection_hyperresolve=1
    uvfits_version=4
    uvfits_subversion=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly_autovis/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
                debug_gain_transfer='/nfs/mwa-04/r1/EoRuvfits/analysis/fhd_nb_Aug2017_savedbp_w_cable_w_digjump/calibration/'
    ;recalculate_all=1
    ;mapfn_recalculate=0
    snapshot_recalculate=1
    save_visibilities=0
    export_images=0
    grid_recalculate=0
    digital_gain_jump_polyfit=1 
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    time_cut=-4
  end 

  'nb_Aug2017_tilebp_w_cable_w_digjump': begin
    cal_bp_transfer=0
    cable_bandpass_fit=1
    diffuse_calibrate=0
    diffuse_model=0
    cal_reflection_mode_theory = 150
    cal_reflection_hyperresolve=1
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    debug_amp_longrun='/nfs/mwa-10/r1/EoRuvfits/analysis/ave_cals/full_ave_amp.sav'
    recalculate_all=1
    mapfn_recalculate=0
    digital_gain_jump_polyfit=1 
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    time_cut=-4
  end
  'nb_Aug2017_savedbp': begin
    saved_run_bp=1
    cable_bandpass_fit=1
    undefine, diffuse_calibrate, diffuse_model
    uvfits_version=5
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_241brighter_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_241brighter_ssextended.sav'
    ;calibration_flux_threshold = .1
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    ;phase_longrun=1 ;add to github
    jump_longrun=1 
    no_ref_tile=1
    time_cut=-4
    ;cal_stop=1
  end
'nb_Aug2017_autocal_wo_cable_w_digjump': begin
    cal_transfer_bp=0

    diffuse_calibrate=0
    diffuse_model=0
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
        cal_reflection_mode_theory = 0
    cal_reflection_hyperresolve=0
    cal_reflection_mode_file=0
    cal_reflection_mode_delay=0
    cal_mode_fit=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly_autovis/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    ;channel_edge_flag_width=2
    calibration_auto_fit=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    ;phase_longrun=1 ;add to github
    digital_gain_jump_polyfit=1 
    ;no_ref_tile=1
    ;cal_stop=1
    time_cut=-4
  end
'nb_Aug2017_autocal1_beam0': begin
    cal_transfer_bp=0

    diffuse_calibrate=0
    diffuse_model=0
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    ;model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/cal_prerun/vis_data'
    ;transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_offset_time=0
    ;channel_edge_flag_width=2
    calibration_auto_fit=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    ;phase_longrun=1 ;add to github
    digital_gain_jump_polyfit=1 
    ;no_ref_tile=1
    cal_stop=1
    time_cut=-4
  end
  'nb_2013longrun_std': begin
    cal_bp_transfer=0
    diffuse_calibrate=0
    diffuse_model=0
    uvfits_version=4
    uvfits_subversion=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    tile_flag_list = ['111','118','121','128','131','132','133','141','142','144','151','152','163','164']
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    ;phase_longrun=1 ;add to github
    digital_gain_jump_polyfit=1
    ;no_ref_tile=1
    ;cal_stop=1
    time_cut=-4
  end
  'nb_vis_stats': begin ;run on 1061313496
    cal_bp_transfer=0
    diffuse_calibrate=0
    diffuse_model=0
    uvfits_version=4
    uvfits_subversion=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    ;model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/cal_prerun/vis_data'
    ;transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    tile_flag_list = ['111','118','121','128','131','132','133','141','142','144','151','152','163','164']
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    ;phase_longrun=1 ;add to github
    digital_gain_jump_polyfit=1
    ;no_ref_tile=1
    ;cal_stop=1
    time_cut=-4
  end
  'nb_2013longrun_autocal': begin
    cal_bp_transfer=0
    diffuse_calibrate=0
    diffuse_model=0
    uvfits_version=4
    uvfits_subversion=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
        model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly_autovis/cal_prerun/vis_data'
            tile_flag_list = ['111','118','121','128','131','132','133','141','142','144','151','152','163','164']
            debug_gain_transfer='/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013longrun_std/calibration/'
    ;snapshot_recalculate=1
    ;save_visibilities=0
    ;export_images=0
    ;grid_recalculate=0
    ;rephase_weights=1
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    digital_gain_jump_polyfit=1
    calibration_auto_fit=1
    nfreq_avg=8
    time_cut=-4
  end
  'nb_2013longrun_autocal_pskspan100': begin
    cal_bp_transfer=0
    diffuse_calibrate=0
    diffuse_model=0
    uvfits_version=4
    uvfits_subversion=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    model_subtract_sidelobe_catalog=filepath('GLEAM_EGC_catalog_KGSscale_ssextended.sav',root=rootdir('FHD'),subdir='catalog_data')
    ;transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    ;transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013cal_redo/beams'
    ;    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly_autovis/cal_prerun/vis_data'
    ;        model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013cal_redo/cal_prerun/vis_data'
            tile_flag_list = ['111','118','121','128','131','132','133','141','142','144','151','152','163','164']
     ;       debug_gain_transfer='/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013longrun_std/calibration/'
     ;recalculate_all=1
     mapfn_recalculate=0
    grid_recalculate=0
    snapshot_recalculate=1
    save_visibilities=1
    export_images=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    ;beam_mask_threshold=1e3
    digital_gain_jump_polyfit=1
    calibration_auto_fit=1
    nfreq_avg=8
    time_cut=-4
    ;no_ref_tile=1
    ps_kspan=200.
  end
  'nb_2013longrun_autocal_pskspan100_horizonhpx': begin
    cal_bp_transfer=0
    diffuse_calibrate=0
    diffuse_model=0
    uvfits_version=4
    uvfits_subversion=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
        model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly_autovis/cal_prerun/vis_data'
            tile_flag_list = ['111','118','121','128','131','132','133','141','142','144','151','152','163','164']
            debug_gain_transfer='/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013longrun_std/calibration/'
    ;snapshot_recalculate=1
    ;save_visibilities=0
    ;export_images=0
    grid_recalculate=0
    save_visibilities=0
    export_images=0
    ;rephase_weights=1
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    digital_gain_jump_polyfit=1
    calibration_auto_fit=1
    nfreq_avg=8
    time_cut=-4
    ps_kspan=200.
  end
 'nb_2013longrun_autocal_pskbinsize2': begin
    cal_bp_transfer=0
    diffuse_calibrate=0
    diffuse_model=0
    uvfits_version=4
    uvfits_subversion=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
        model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly_autovis/cal_prerun/vis_data'
            tile_flag_list = ['111','118','121','128','131','132','133','141','142','144','151','152','163','164']
            debug_gain_transfer='/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013longrun_std/calibration/'
    ;snapshot_recalculate=1
    ;save_visibilities=0
    ;export_images=0
    ;grid_recalculate=0
    ;rephase_weights=1
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    digital_gain_jump_polyfit=1
    calibration_auto_fit=1
    nfreq_avg=8
    time_cut=-4
    ps_kbinsize=2.
  end
  'nb_2014longrun_autocal': begin
    cal_bp_transfer=0
    diffuse_calibrate=0
    diffuse_model=0
    uvfits_version=5
    uvfits_subversion=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    transfer_psf = '/nfs/mwa-01/r1/EoRuvfits/analysis/fhd_nb_2014zenith_calonly/beams'
        model_transfer = '/nfs/mwa-01/r1/EoRuvfits/analysis/fhd_nb_2014zenith_calonly/cal_prerun/vis_data'
            tile_flag_list = ['111','118','121','128','131','132','133','141','142','144','151','152','163','164']
            debug_gain_transfer='/nfs/mwa-01/r1/EoRuvfits/analysis/fhd_nb_2014zenith_calonly/calibration/'
    ;snapshot_recalculate=1
    ;save_visibilities=0
    ;export_images=0
    ;grid_recalculate=0
    ;rephase_weights=1
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    digital_gain_jump_polyfit=1
    calibration_auto_fit=1
    nfreq_avg=8
    time_cut=-4
  end
 'nb_2014longrun_std': begin
    cal_bp_transfer=0
    diffuse_calibrate=0
    diffuse_model=0
    uvfits_version=5
    uvfits_subversion=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    ;transfer_psf = '/nfs/mwa-04/r1/EoRuvfits/analysis/fhd_nb_2014zenith_calonly/beams_save'
    ;    model_transfer = '/nfs/mwa-04/r1/EoRuvfits/analysis/fhd_nb_2014zenith_calonly/cal_prerun/vis_data'
            tile_flag_list = ['111','118','121','128','131','132','133','141','142','144','151','152','163','164']
    ;        debug_gain_transfer='/nfs/mwa-04/r1/EoRuvfits/analysis/fhd_nb_2014zenith_calonly/calibration/'
    ;snapshot_recalculate=1
    ;save_visibilities=0
    ;export_images=0
    ;grid_recalculate=0
    ;rephase_weights=1
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    digital_gain_jump_polyfit=1
    ;calibration_auto_fit=1
    nfreq_avg=8
    time_cut=-4
  end
  'nb_2013longrun_zeroedbp': begin
    cal_bp_transfer=0
    cable_bandpass_fit=1
    diffuse_calibrate=0
    diffuse_model=0
    cal_reflection_mode_theory=0
    cal_reflection_mode_file=0
    cal_reflection_mode_delay=0
    cal_reflection_hyperresolve=0
     cal_mode_fit=0
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly_autovis/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    debug_amp_longrun='/nfs/mwa-10/r1/EoRuvfits/analysis/ave_cals/full_ave_amp_zeroed.sav'
     debug_gain_transfer='/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013longrun_std/calibration/'
                 tile_flag_list = ['111','118','121','128','131','132','133','141','142','144','151','152','163','164']
    recalculate_all=1
    mapfn_recalculate=0
    digital_gain_jump_polyfit=1 
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    time_cut=-4
  end
  'nb_Aug2017_aveamp': begin
    saved_run_bp=0
    undefine, diffuse_calibrate, diffuse_model
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    ;tile_flag_list = ['111','118','121','128','131','132','133','141','142','144','151','152','163','164']
    amp_longrun=1
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    ;phase_longrun=1 ;add to github
    jump_longrun=1 
    ;no_ref_tile=1
    ;cal_stop=1
    time_cut=-4
  end
    'nb_Aug2017_aveampphase_dayref_tileflag': begin
    saved_run_bp=0
    undefine, diffuse_calibrate, diffuse_model
    uvfits_version=4
    uvfits_subversion=1
    ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    tile_flag_list = ['111','118','121','128','131','132','133','141','142','144','151','152','163','164']
    amp_longrun=1
    phase_longrun=2
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    ;phase_longrun=1 ;add to github
    jump_longrun=1 
    ;no_ref_tile=1
    ;cal_stop=1
    time_cut=-4
  end
    'nb_2013longrun_aveampphase': begin
    cal_bp_transfer=0
    undefine, diffuse_calibrate, diffuse_model
    uvfits_version=5
    uvfits_subversion=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_transfer = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/cal_prerun/vis_data'
    transfer_psf = '/nfs/mwa-10/r1/EoRuvfits/analysis/fhd_nb_2013zenith_calonly/beams'
    tile_flag_list = ['111','118','121','128','131','132','133','141','142','144','151','152','163','164']
    debug_amp_longrun=1
    debug_phase_longrun=1
    recalculate_all=1
    mapfn_recalculate=0
    debug_beam_clip_floor=1
    model_delay_filter=1
    beam_mask_threshold=1e3
    nfreq_avg=8
    ;phase_longrun=1 ;add to github
    digital_gain_jump_polyfit=1 
    undefine, cal_reflection_mode_theory,cal_reflection_mode_file,cal_reflection_mode_delay,cal_reflection_hyperresolve
    ;no_ref_tile=1
    ;cal_stop=1
    time_cut=-4
  end
  'nb_notileref': begin
    ;longrun_cal=1
    cal_time_average=0 ;to match longrun
    saved_bp=0
    undefine, diffuse_calibrate, diffuse_model
    uvfits_version=4
    uvfits_subversion=1
    recalculate_all=1
    mapfn_recalculate=0
    ;undefine, cal_cable_reflection_correct,cal_cable_reflection_fit,cal_cable_reflection_mode_fit
    ;phase_longrun=1
    no_ref_tile = 1
    cal_stop=1
  ;jump_longrun=1
  end
 'nb_paper_beam_test': begin
    ;following Nichole's example exactly
    instrument = 'paper'
    calibration_auto_initialize = 1
    ref_antenna = 1
    time_offset=5.*60.
    hera_inds = [80,104,96,64,53,31,65,88,9,20,89,43,105,22,81,10,72,112,97]+1
    paper_inds = [1,3,4,13,15,16,23,26,37,38,41,42,46,47,49,50,56,54,58,59,61,63,66,67,70,71,73,74,82,83,87,90,98,99,103,106,124,123,122,121,120,119,118,117,0,14,44,113,126,127]+1
    paper_hex = [2,21,45,17,68,62,116,125,84,100,85,57,69,40,101,102,114,115,86]+1
    paper_pol = [25,19,48,29,24,28,55,34,27,51,35,75,18,76,5,77,32,78,30,79,33,91,6,92,52,93,7,94,12,95,8,107,11,108,36,109,60,110,39,111]+1
    tile_flag_list = [paper_hex,paper_pol,hera_inds] ;flag all but PAPER imaging
    cal_time_average = 0
    nfreq_average = 1024
    calibration_catalog_file_path=filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    cable_bandpass_fit = 0
    saved_run_bp = 0
    cal_mode_fit = 0
    max_calibration_sources = 500
    diffuse_calibrate=0
    diffuse_model=0
    cal_cable_reflection_fit=0
    cal_cable_reflection_mode_fit=0
    cal_cable_reflection_correct=0
    beam_offset_time = 300
    flag_calibration = 0
    min_cal_baseline = 10
    calibration_polyfit = 0
    bandpass_calibrate = 0
    ;flag_visibilities = 1
    dimension = 4096
    elements = 4096
  end  
'nb_channel_7_001': begin ;run on 1061313496
    split_ps_export=1
    freq_end = 187
    freq_start = 181
    time_cut=[0,-110] ;2seconds in the middle
    ;flag_visibilities=1
    transfer_weights = '/nfs/mwa-01/r1/EoRuvfits/analysis/fhd_nb_channel_7_weights/vis_data/1061313496_flags.sav'
    transfer_calibration = '/nfs/mwa-01/r1/EoRuvfits/analysis/fhd_nb_channel_7_weights/calibration/1061313496_cal.sav'
    recalculate_all=1
    mapfn_recalculate=0
    end
'nb_channel_7_052': begin ;run on 1061313496
    split_ps_export=1
    freq_end = 187
    freq_start = 181
    time_cut=[100,-10] ;2seconds in the middle
    ;flag_visibilities=1
    transfer_weights = '/nfs/mwa-01/r1/EoRuvfits/analysis/fhd_nb_channel_7_weights/vis_data/1061313496_flags.sav'
    transfer_calibration = '/nfs/mwa-01/r1/EoRuvfits/analysis/fhd_nb_channel_7_weights/calibration/1061313496_cal.sav'
    recalculate_all=1
    mapfn_recalculate=0
    end
'nb_channel_7_midobs': begin ;run on 1061313496
    save_imagecube=1
    save_uvf=1
    split_ps_export=1
    freq_end = 187
    freq_start = 181
    time_cut=[56,-54] ;2seconds in the middle
    ;flag_visibilities=1
    transfer_weights = '/nfs/mwa-01/r1/EoRuvfits/analysis/fhd_nb_channel_7_weights/vis_data/1061313496_flags.sav'
    transfer_calibration = '/nfs/mwa-01/r1/EoRuvfits/analysis/fhd_nb_channel_7_weights/calibration/1061313496_cal.sav'
    recalculate_all=1
    mapfn_recalculate=0
    ;image_filter_fn='filter_uv_natural'
  end
  'nb_channel_7_weights': begin
    cal_bp_transfer=1
    cable_bandpass_fit=1
    diffuse_calibrate=0
     diffuse_model=0
    cal_reflection_mode_theory = 150
    cal_reflection_hyperresolve=1
    uvfits_version=4
    uvfits_subversion=1
    cal_time_average=0
    calibration_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    calibration_catalog_file_path='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    model_subtract_sidelobe_catalog='/nfs/eor-00/h1/nbarry/MWA/IDL_code/FHD/catalog_data/GLEAM_EGC_catalog_KGSscale_ssextended.sav'
    digital_gain_jump_polyfit=1 
    debug_beam_clip_floor=1
    model_delay_filter=1
  end 
endcase

;case version of 

  ;'nb_test': begin
  ;  vis_file_list = '/nfs/eor-11/r1/EoRuvfits/jd2456528v4_1/1061319472/1061319472.uvfits'
  ;end
  ;else: begin
  ;  if platform eq 'aws' then vis_file_list = '/uvfits/' + STRING(obs_id) + '.uvfits' else begin
     vis_file_list = '/fred/oz048/MWA/data/2013/v5_1/' + string(obs_id) +'.uvfits'
    ;  vis_file_list = '/fred/oz048/MWA/data/2013/' +string(obs_id)+ '/'+ string(obs_id) +'.uvfits'
  ;  endelse
  ;end
 ;vis_file_list = '/fred/oz048/MWA/data/2013/' +string(obs_id)+ '/'+ string(obs_id) +'.uvfits'  
print, vis_file_list
;endcase

;vis_file_list=vis_file_list ; this is silly, but it's so var_bundle sees it.
undefine, uvfits_subversion, uvfits_version

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

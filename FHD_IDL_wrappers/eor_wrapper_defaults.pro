PRO eor_wrapper_defaults,extra
  ; Set the default settings for all EOR observations.
  ; This file can be copied and modified for other types of observations, under a new name.
  ; The defaults set in this file will be overridden

  calibrate_visibilities=1
  recalculate_all=0
  cleanup=0
  snapshot_healpix_export=1
  n_avg=2
  ps_kbinsize=0.5
  ps_kspan=600.
  uvfits_version=5
  uvfits_subversion=1
  dimension=2048
  max_deconvolution_components=20000
  FoV=0
  min_baseline=1.
  min_cal_baseline=50.
  pad_uv_image=1.
  ring_radius=10.*pad_uv_image
  beam_nfreq_avg=16
  no_rephase=1
  restrict_hpx_inds=1
  kbinsize=0.5
  psf_resolution=100
  beam_model_version=2
  no_calibration_frequency_flagging=1
  allow_sidelobe_cal_sources=1
  allow_sidelobe_model_sources=1

  ;beam
  beam_offset_time=56 ; make this a default. But it won't compound with setting it directly in a version so I think it's ok.
  beam_clip_floor=1
  interpolate_kernel=1
  beam_recalculate=1

  ;Calibration keywords
  cable_bandpass_fit=1
  cal_bp_transfer=1
  calibration_polyfit=1
  cal_amp_degree_fit=2
  cal_phase_degree_fit=1
  cal_reflection_hyperresolve=1
  cal_reflection_mode_theory=150

  ;catalog keywords
  calibration_catalog_file_path = filepath('GLEAM_v2_plus_rlb2019.sav',root=rootdir('FHD'),subdir='catalog_data')
  model_catalog_file_path = calibration_catalog_file_path

  ;These defaults should match those in FHD itself, so setting them here is redundant
  split_ps_export=1
  combine_healpix=0
  deconvolve=0
  flag_visibilities=0
  vis_baseline_hist=1
  silent=0
  save_visibilities=1
  calibration_visibilities_subtract=0
  bandpass_calibrate=1
  export_images=1
  model_visibilities=0
  return_cal_visibilities=1
  dipole_mutual_coupling_factor=1
  calibration_flag_iterate = 0
  image_filter_fn='filter_uv_uniform'
  deconvolution_filter='filter_uv_uniform'
  smooth_width=32.
  no_restrict_cal_sources=1
  pad_uv_image=1.
  no_ps=1
  diffuse_calibrate=0
  diffuse_model=0

  extra=var_bundle(level=0) ; first gather all variables set in the top-level wrapper
  extra=var_bundle(level=1) ; next gather all variables set in this file, removing any duplicates.
END


pro lmb_zenith
  except=!except
  !except=0
  heap_gc

  ; parse command line args
  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  PRINT, args
  ;obs_id = args[0]
  obs_id = '1061315688'
  ;output_directory = args[1]
  output_directory = '/home/lmberkhout/data/MWA/data/golden_day'
  ;version = args[2]
  version = 'simulation_interp'
  ;vis_file_list = args[1]

  ;if nargs gt 3 then platform = args[3] else platform = '' ;indicates if running on AWS
  ;if nargs gt 4 then cal_obs_id = args[4] else cal_obs_id = '' ;let it run calibration on my funky obs names...

  cmd_args={version:version}
  
   case version of
    'use_grid_window_calprerun_2': begin
      calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      filter_background=1
      digital_gain_jump_polyfit=1
      recalculate_all=1
      diffuse_calibrate=0
      diffuse_model=0
      subtract_sidelobe_catalog=filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      dft_threshold=0
      ring_radius=0
      debug_region_grow=0
      ps_kspan=200.
      healpix_recalculate=1
      snapshot_recalculate=1
      vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315448.uvfits'
      beam_clip_floor=1
      cal_bp_transfer=0
      cal_stop = 1
    end
    'use_grid_window_cal_postrun_2': begin
      calibrate_visibilities=0
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      model_visibilities=1
      save_visibilities=1
      kernel_window='Blackman-Harris^2'
      debug_dim=1
      beam_mask_threshold=1e3
      uvfits_version = 4
      uvfits_subversion = 1
      filter_background=1
      digital_gain_jump_polyfit=1
      diffuse_calibrate=0
      diffuse_model=0
      dft_threshold=0
      ring_radius=0
      debug_region_grow=0
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
      ps_kspan=200.
      transfer_calibration = '/home/lmberkhout/data/MWA/data/golden_day/fhd_use_grid_window_calprerun_2/' + obs_id      
      vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315448.uvfits'
      beam_clip_floor=1
      grid_with_window=1
    end
    'control_run': begin
      kernel_window=1
      calibrate_visibilities=0
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      model_visibilities=1
      save_visibilities=1
      unflag_all=1
      debug_dim=1
      beam_mask_threshold=1e3
      beam_clip_floor=1
      nfreq_avg=384
      ps_kspan=200.
      interpolate_kernel=1
      vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315448.uvfits' 
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave' 
   end   
   'simulation': begin 
      kernel_window=1
      calibrate_visibilities=0
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      model_visibilities=1
      save_visibilities=1
      unflag_all=1
      debug_dim=1
      beam_mask_threshold=1e3
      beam_clip_floor=1
      nfreq_avg=384
      ps_kspan=200.
      interpolate_kernel=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
      extra_vis_filepath='/home/lmberkhout/data/MWA/data/golden_day/1061311664.uvfits'
      vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315448.uvfits'
      in_situ_sim_input='/home/lmberkhout/data/MWA/data/golden_day/fhd_control_run/vis_data'
      remove_sim_flags=1 
   end 
      'control_run_w_coarse_harm': begin
      kernel_window=1
      calibrate_visibilities=0
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      model_visibilities=1
      save_visibilities=1
      ;unflag_all=1
      debug_dim=1
      beam_mask_threshold=1e3
      beam_clip_floor=1
      nfreq_avg=384
      ps_kspan=200.
      interpolate_kernel=1
      vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315448.uvfits'
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
   end
     'simulation_w_coarse_harm': begin
      kernel_window=1
      calibrate_visibilities=0
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      model_visibilities=1
      save_visibilities=1
      ;unflag_all=1
      debug_dim=1
      beam_mask_threshold=1e3
      beam_clip_floor=1
      nfreq_avg=384
      ps_kspan=200.
      interpolate_kernel=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
      extra_vis_filepath='/home/lmberkhout/data/MWA/data/golden_day/1061311664.uvfits'
      vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315448.uvfits'
      in_situ_sim_input='/home/lmberkhout/data/MWA/data/golden_day/fhd_control_run_w_coarse_harm/vis_data'
      remove_sim_flags=1
   end
      'control_run_no_kspan_uvf': begin
      kernel_window=1
      save_uvf=1
      calibrate_visibilities=0
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      model_visibilities=1
      save_visibilities=1
      unflag_all=1
      debug_dim=1
      beam_mask_threshold=1e3
      beam_clip_floor=1
      nfreq_avg=384
      ;ps_kspan=200.
      interpolate_kernel=1
      vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315448.uvfits'
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
   end
   'control_run_no_kspan_uvf': begin
     kernel_window=1
     save_uvf=1
     calibrate_visibilities=0
     return_cal_visibilities=0
     calibration_visibilities_subtract=0
     model_visibilities=1
     save_visibilities=1
     unflag_all=1
     debug_dim=1
     beam_mask_threshold=1e3
     beam_clip_floor=1
     nfreq_avg=384
     ;ps_kspan=200.
     interpolate_kernel=1
     vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315448.uvfits'
     restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
   end
  'simulation_no_kspan_uvf': begin
      kernel_window=1
      save_uvf=1
      calibrate_visibilities=0
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      model_visibilities=1
      save_visibilities=1
      unflag_all=1
      debug_dim=1
      beam_mask_threshold=1e3
      beam_clip_floor=1
      nfreq_avg=384
      ;ps_kspan=200.
      interpolate_kernel=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
      extra_vis_filepath='/home/lmberkhout/data/MWA/data/golden_day/1061311664.uvfits'
      vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315448.uvfits'
      in_situ_sim_input='/home/lmberkhout/data/MWA/data/golden_day/fhd_control_run_no_kspan_uvf/vis_data'
      remove_sim_flags=1
   endcase
      'control_run_no_kspan': begin
      kernel_window=1
      ;save_uvf=1
      calibrate_visibilities=0
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      model_visibilities=1
      save_visibilities=1
      unflag_all=1
      debug_dim=1
      beam_mask_threshold=1e3
      beam_clip_floor=1
      nfreq_avg=384
      ;ps_kspan=200.
      interpolate_kernel=1
      vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315448.uvfits'
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
   endcase
     'simulation_no_kspan_save': begin
      kernel_window=1
      ;save_uvf=1
      calibrate_visibilities=0
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      model_visibilities=1
      save_visibilities=1
      unflag_all=1
      debug_dim=1
      beam_mask_threshold=1e3
      beam_clip_floor=1
      nfreq_avg=384
      ;ps_kspan=200.
      interpolate_kernel=1
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
      extra_vis_filepath='/home/lmberkhout/data/MWA/data/golden_day/1061311664.uvfits'
      vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315448.uvfits'
      in_situ_sim_input='/home/lmberkhout/data/MWA/data/golden_day/fhd_control_run_no_kspan/vis_data'
      remove_sim_flags=1
  endcase    
    'control_interp': begin
      kernel_window=1
      ;save_uvf=1
      calibrate_visibilities=0
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      model_visibilities=1
      save_visibilities=1
      unflag_all=1
      debug_dim=1
      beam_mask_threshold=1e3
      beam_clip_floor=1
      nfreq_avg=384
      ;ps_kspan=200.
      interpolate_kernel=1
      vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315688.uvfits'
      restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
   endcase
      'simulation_interp': begin
      kernel_window=1
      ;save_uvf=1
      calibrate_visibilities=0
      return_cal_visibilities=0
      calibration_visibilities_subtract=0
      model_visibilities=1
      save_visibilities=1
      unflag_all=1
      debug_dim=1
      beam_mask_threshold=1e3
      beam_clip_floor=1
      nfreq_avg=384
      n_avg = 1
      image_filter_fn = 'filter_uv_natural'
      rephase_weights=0
      ;recalculate_all = 1 
      healpix_recalculate=1
      save_imagecube=1
      ;ps_kspan=200.
      interpolate_kernel=1
      ;restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
      extra_vis_filepath='/home/lmberkhout/data/MWA/data/golden_day/1061311664.uvfits'
      vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315688.uvfits'
      in_situ_sim_input='/home/lmberkhout/data/MWA/data/golden_day/fhd_control_interp/vis_data'
      remove_sim_flags=1
  endcase
  'simulation_interp_uvf': begin
    kernel_window=1
    save_uvf=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    healpix_recalculate=1
    ;ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/home/lmberkhout/data/MWA/data/golden_day/1061311664.uvfits'
    vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315688.uvfits'
    in_situ_sim_input='/home/lmberkhout/data/MWA/data/golden_day/fhd_control_interp/vis_data'
    remove_sim_flags=1
  endcase
  'control_run_adam': begin
    kernel_window=1
    save_uvf=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    ;ps_kspan=200.
    interpolate_kernel=1
    cal_stop=1
    vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061316296.uvfits'
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
  endcase
  'simulation_adam': begin
    kernel_window=1
    save_uvf=1
    calibrate_visibilities=0
    return_cal_visibilities=0
    calibration_visibilities_subtract=0
    model_visibilities=1
    save_visibilities=1
    unflag_all=1
    debug_dim=1
    beam_mask_threshold=1e3
    beam_clip_floor=1
    nfreq_avg=384
    healpix_recalculate=1
    ;ps_kspan=200.
    interpolate_kernel=1
    restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
    extra_vis_filepath='/home/lmberkhout/data/MWA/data/golden_day/1061311664.uvfits'
    vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061316296.uvfits'
    in_situ_sim_input='/home/lmberkhout/data/MWA/data/golden_day/fhd_control_run_adam/vis_data'
    remove_sim_flags=1
   endcase
   'control_master': begin
     kernel_window=1
     ;save_uvf=1
     calibrate_visibilities=0
     return_cal_visibilities=0
     calibration_visibilities_subtract=0
     model_visibilities=1
     save_visibilities=1
     unflag_all=1
     debug_dim=1
     beam_mask_threshold=1e3
     beam_clip_floor=1
     nfreq_avg=384
     ;ps_kspan=200.
     interpolate_kernel=1
     cal_stop = 1
     vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315688.uvfits'
     restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
   endcase
   'simulation_master': begin
     kernel_window=1
     save_uvf=1
     calibrate_visibilities=0
     return_cal_visibilities=0
     calibration_visibilities_subtract=0
     model_visibilities=1
     save_visibilities=1
     unflag_all=1
     debug_dim=1
     beam_mask_threshold=1e3
     beam_clip_floor=1
     nfreq_avg=384
     n_avg = 1
     ;recalculate_all = 1
     rephase_weights=0
     healpix_recalculate=1
     save_imagecube=1
     ;ps_kspan=200.
     interpolate_kernel=1
     restrict_hpx_inds='EoR0_high_healpix_inds_3x.idlsave'
     extra_vis_filepath='/home/lmberkhout/data/MWA/data/golden_day/1061311664.uvfits'
     vis_file_list='/home/lmberkhout/data/MWA/data/golden_day/1061315688.uvfits'
     in_situ_sim_input='/home/lmberkhout/data/MWA/data/golden_day/fhd_control_master/vis_data'
     remove_sim_flags=1
   endcase
end
;if cal_obs_id ne '' then begin
;    transfer_calibration = '/cal/' + cal_obs_id + '_cal.sav'
;    cal_bp_transfer = '/cal/' + cal_obs_id + '_bandpass.txt'
;  endif

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
  ;print,extra.filter_name
  general_obs,_Extra=extra

end

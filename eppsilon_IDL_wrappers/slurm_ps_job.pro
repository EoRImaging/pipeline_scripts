pro slurm_ps_job
  ;; wrapper for ps_wrapper to take in shell parameters

  PROFILER, /RESET
  RESOLVE_ROUTINE, 'ps_wrapper', /QUIET
  RESOLVE_ALL, /CONTINUE_ON_ERROR, /QUIET

  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  folder_name=args[0]
  obs_range=args[1]
  if (nargs eq 3) then n_obs=args[2]
  print,'folder_name = '+folder_name
  print,'obs_range = '+obs_range
  image_window_name = 'Blackman-Harris'
  if (nargs eq 3) then begin
     n_obs=args[2]
     ps_wrapper,folder_name,obs_range,n_obs=n_obs,kperp_range_lambda_1dave=[5,50],/plot_kpar_power,/plot_kperp_power,/png,/plot_k0_power,/exact_obsnames,loc_name='oscar'
  endif else begin
     ps_wrapper,folder_name,obs_range,kperp_range_lambda_1dave=[5,50],/plot_kpar_power,/plot_kperp_power,/png,/plot_k0_power,/exact_obsnames,loc_name='oscar'
  endelse
  
  PROFILER,filename='/users/wl42/scratch/FHD_out/IDL_ps_profile.out', /REPORT
end

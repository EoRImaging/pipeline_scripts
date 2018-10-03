pro aws_ps_single_obs_job
  ;wrapper for ps_wrapper to take in shell parameters from a grid engine bash script

  ;***Read-in typical parameters
  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  obs_id=args[0]
  outdir=args[1]
  fhd_version=args[2]
  image_window_name=args[3]
  refresh_ps=args[4]
  uvf_input=args[5]

  refresh_ps = fix(refresh_ps)
  if (refresh_ps ne 0) and (refresh_ps ne 1) then begin
    print, 'Parameter refresh_ps must be 0 or 1. Returning.'
    return
  endif

  if image_window_name eq 0 then undefine, image_window_name
  if refresh_ps eq 0 then undefine, refresh_ps
  if uvf_input eq 0 then undefine, uvf_input

  ps_wrapper, outdir+'/fhd_'+fhd_version, obs_id, /png, image_window_name=image_window_name, refresh_ps=refresh_ps, uvf_input=uvf_input

end

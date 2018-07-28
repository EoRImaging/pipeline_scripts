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

  if image_window_name eq '' then begin
    image_window_name = 0
    image_window_frac_size = 0
  endif else begin
    if image_window_name eq 'Blackman-Harris' then begin
      image_window_frac_size = 0.5
    endif else begin
      print, 'Invalid image_window_name. Returning.'
      return
    endelse
  endelse

  refresh_ps = fix(refresh_ps)
  if (refresh_ps ne 0) and (refresh_ps ne 1) then begin
    print, 'Parameter refresh_ps must be 0 or 1. Returning.'
    return
  endif

  ps_wrapper, outdir+'/fhd_'+fhd_version, obs_id, /png, image_window_name=image_window_name, image_window_frac_size=image_window_frac_size, refresh_ps=refresh_ps

end

pro aws_ps_single_obs_job
  ;wrapper for ps_wrapper to take in shell parameters from a grid engine bash script

  ;***Read-in typical parameters
  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  obs_id=args[0]
  outdir=args[1]
  fhd_version=args[2]
  refresh_ps=args[3]
  uvf_input=args[4]
  wt_cutoffs=args[5]

  refresh_ps = fix(refresh_ps)
  if (refresh_ps ne 0) and (refresh_ps ne 1) then begin
    print, 'Parameter refresh_ps must be 0 or 1. Returning.'
    return
  endif

  if refresh_ps eq 0 then undefine, refresh_ps
  if uvf_input eq 0 then undefine, uvf_input

  ps_wrapper, outdir+'/fhd_'+fhd_version, obs_id, /png, /plot_kpar_power, refresh_ps=refresh_ps, uvf_input=uvf_input, wt_cutoffs=wt_cutoffs, freq_ch_range=[9, 126]

end

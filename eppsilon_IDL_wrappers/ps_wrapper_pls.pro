pro ps_wrapper_pls, folder_name=folder_name, obs_range=obs_range, eppsversion=eppsversion
  except=!except
  !except=0
  heap_gc

  ; parse command line args
  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  if nargs ne 0 then begin
    folder_name = args[0]
    obs_range = args[1]
    eppsversion = args[2]
  endif
  ; if nargs gt 3 then platform = args[3] else platform = '' ;indicates if running on AWS

  ; have to use eppsversion instead of version or keywords will be set incorrectly
  cmd_args={eppsversion:eppsversion}

  case eppsversion of

    'default_eor_ps_settings': begin
        plot_kpar_power=1
        plot_kperp_power=1
        png=1
        plot_k0_power=1
        exact_obsnames=1
    end

    'cat_return_sum_cubes': begin
	save_sum_cube=1
        plot_kpar_power=1
        plot_kperp_power=1
        png=1
        plot_k0_power=1
        exact_obsnames=1
    end
  endcase

  eor_ps_defaults,extra

  print,""
  print,"Keywords set in wrapper:"
  print,structure_to_text(extra)
  print,""

  ps_wrapper,folder_name,obs_range,_Strict_Extra=extra

end

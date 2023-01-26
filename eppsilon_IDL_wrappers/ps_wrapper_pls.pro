pro ps_wrapper_pls
  except=!except
  !except=0
  heap_gc

  ; parse command line args
  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  folder_name = args[0]
  output_directory = args[1]
  version = args[2]
  if nargs gt 3 then platform = args[3] else platform = '' ;indicates if running on AWS

  cmd_args={version:version}

  case version of

    'default_eor_ps_settings': begin
        plot_kpar_power=0
        plot_kperp_power=0
        png=0
        plot_k0_power=0
        exact_obsnames=0
    end
  endcase

  extra=var_bundle(level=1) ; gather all variables set in this file

  print,""
  print,"Keywords set in wrapper:"
  print,structure_to_text(extra)
  print,""

  ps_wrapper,_Extra=extra

end
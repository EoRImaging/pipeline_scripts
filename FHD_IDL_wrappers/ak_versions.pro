pro ak_versions
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
  output_directory = '/home/vydula'
  ;version = args[2]
  version = 'simple_test'
  ;vis_file_list = args[1]

  ;if nargs gt 3 then platform = args[3] else platform = '' ;indicates if running on AWS
  ;if nargs gt 4 then cal_obs_id = args[4] else cal_obs_id = '' ;let it run calibration on my funky obs names...

  cmd_args={version:version}

   case version of
   'simple_test': begin
      ;uvfits_version = 4
      ;uvfits_subversion = 1
      calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      diffuse_calibrate = 0
      diffuse_model = 0
      subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      ps_kspan=200.
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      recalculate_all = 1
      cal_bp_transfer = 0
      vis_file_list = '/home/lmberkhout/data/MWA/data/golden_day/1061315688.uvfits'
      end
   endcase

  ; Directory setup
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

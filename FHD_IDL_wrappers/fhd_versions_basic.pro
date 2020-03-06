pro fhd_versions_basic
  except=!except
  !except=0
  heap_gc
  
  obs_id = '1061316296' ;obsid of observation to run
  output_directory = '/path/to/directory' ;path to the FHD output directory
  version = 'example_run' ;version name
  vis_file_list = '/path/to/uvfits/'+obs_id+'.uvfits' ;path to uvfits file

  case version of

    'example_run': begin
      ;set run keywords here
      ;see FHD dictionary for keyword examples
    end

  endcase

  ;make output directories:
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

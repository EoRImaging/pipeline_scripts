pro mjw_fhd_versions
  except=!except
  !except=0
  heap_gc

  ; parse command line args
  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  obs_id = args[0]
  output_directory = args[1]
  version = args[2]
  if nargs gt 3 then platform = args[3] else platform = '' ;indicates if running on AWS
  if nargs gt 4 then cal_obs_id = args[4] else cal_obs_id = '' ;let it run calibration on my funky obs names...

  cmd_args={version:version}

  case version of

    'mjw_default': begin

    end

    'mjw_NB_transfer_1': begin
    uvfits_version = 4
    uvfits_subversion = 1
    transfer_calibration = '/cal/1061318616_cal.sav'
    cal_bp_transfer = '1061318616_bandpass.txt'
    bandpass_calibrate = 1
    ;calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    filter_background = 1
    diffuse_calibrate = 0
    diffuse_model = 0
    subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    dft_threshold = 0
    ring_radius = 0
    debug_region_grow = 0
    recalculate_all = 1
    vis_file_list = '/uvfits/1061318616.uvfits'
    model_visibilities = 1

    end

    'mjw_NB_transfer_2': begin
    uvfits_version = 4
    uvfits_subversion = 1
    transfer_calibration = '/cal/1061318736_cal.sav'
    cal_bp_transfer = '/cal/1061318736_bandpass.txt'
    bandpass_calibrate = 1
    ;calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    filter_background = 1
    diffuse_calibrate = 0
    diffuse_model = 0
    subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    dft_threshold = 0
    ring_radius = 0
    debug_region_grow = 0
    recalculate_all = 1
    vis_file_list = '/uvfits/1061318736.uvfits'
    model_visibilities = 1

    end

    'mjw_NB_transfer_3': begin
    uvfits_version = 4
    uvfits_subversion = 1
    transfer_calibration = '/cal/1061318864_cal.sav'
    cal_bp_transfer = '/cal/1061318864_bandpass.txt'
    bandpass_calibrate = 1
    ;calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    filter_background = 1
    diffuse_calibrate = 0
    diffuse_model = 0
    subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    dft_threshold = 0
    ring_radius = 0
    debug_region_grow = 0
    recalculate_all = 1
    vis_file_list = '/uvfits/1061318864.uvfits'
    model_visibilities = 1

    end

    'mjw_NB_transfer_4': begin
    uvfits_version = 4
    uvfits_subversion = 1
    transfer_calibration = '/cal/1061319224_cal.sav'
    cal_bp_transfer = '/cal/1061319224_bandpass.txt'
    bandpass_calibrate = 1
    ;calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    filter_background = 1
    diffuse_calibrate = 0
    diffuse_model = 0
    subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    dft_threshold = 0
    ring_radius = 0
    debug_region_grow = 0
    recalculate_all = 1
    vis_file_list = '/uvfits/1061319224.uvfits'
    model_visibilities = 1

    end

    'mjw_NB_transfer_5': begin
    uvfits_version = 4
    uvfits_subversion = 1
    transfer_calibration = '/cal/1061319352_cal.sav'
    cal_bp_transfer = '/cal/1061319352_bandpass.txt'
    bandpass_calibrate = 1
    ;calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    filter_background = 1
    diffuse_calibrate = 0
    diffuse_model = 0
    subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    dft_threshold = 0
    ring_radius = 0
    debug_region_grow = 0
    recalculate_all = 1
    vis_file_list = '/uvfits/1061319352.uvfits'
    model_visibilities = 1

    end

    'mjw_NB_transfer_6': begin
    uvfits_version = 4
    uvfits_subversion = 1
    transfer_calibration = '/cal/1061319472_cal.sav'
    cal_bp_transfer = '/cal/1061319472_bandpass.txt'
    bandpass_calibrate = 1
    ;calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
    calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    filter_background = 1
    diffuse_calibrate = 0
    diffuse_model = 0
    subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
    dft_threshold = 0
    ring_radius = 0
    debug_region_grow = 0
    recalculate_all = 1
    vis_file_list = '/uvfits/1061319472.uvfits'
    model_visibilities = 1

    end

    'mjw_vanilla_test': begin
      uvfits_version = 4
      uvfits_subversion = 1
      calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      filter_background = 1
      diffuse_calibrate = 0
      diffuse_model = 0
      subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
      dft_threshold = 0
      ring_radius = 0
      debug_region_grow = 0
      recalculate_all = 1
      cal_bp_transfer = 0
      platform = 'aws'

     end

     'mjw_vanilla_test_transfer': begin
       uvfits_version = 4
       uvfits_subversion = 1
       bandpass_calibrate = 1
       ;calibration_catalog_file_path = filepath('master_sgal_cat.sav',root=rootdir('FHD'),subdir='catalog_data')
       calibration_catalog_file_path = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
       filter_background = 1
       diffuse_calibrate = 0
       diffuse_model = 0
       subtract_sidelobe_catalog = filepath('GLEAMIDR4_181_consistent.sav',root=rootdir('FHD'),subdir='catalog_data')
       dft_threshold = 0
       ring_radius = 0
       debug_region_grow = 0
       recalculate_all = 1
       model_visibilities = 1

      end

  endcase

  if ~keyword_set(vis_file_list) and keyword_set(instrument) then begin
    if instrument eq 'hera' then begin
      vis_file_list = '/nfs/eor-00/h1/rbyrne/HERA_analysis/zen.2458042.'+obs_id+'.xx.HH.uvR.uvfits'
      if obs_id eq '38650' then begin
        vis_file_list = '/nfs/eor-00/h1/rbyrne/HERA_analysis/zen.2458042.'+obs_id+'.yy.HH.uvR.uvfits'
      endif
    endif
  endif

  if ~keyword_set(vis_file_list) then begin
    if platform eq 'aws' then begin
      vis_file_list = '/uvfits/' + STRING(obs_id) + '.uvfits'
    endif else begin
      SPAWN, 'read_uvfits_loc.py -v ' + STRING(uvfits_version) + ' -s ' + $
        STRING(uvfits_subversion) + ' -o ' + STRING(obs_id), vis_file_list
    endelse
  endif

  if cal_obs_id ne '' then begin
    transfer_calibration = '/cal/' + cal_obs_id + '_cal.sav'
    cal_bp_transfer = '/cal/' + cal_obs_id + '_bandpass.txt'
  endif

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

  general_obs,_Extra=extra

end

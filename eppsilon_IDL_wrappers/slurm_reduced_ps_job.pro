pro slurm_reduced_ps_job
  ;; wrapper for ps_wrapper. Meant for separated mode.

  compile_opt strictarr
  args = Command_Line_Args(count=nargs)
  folder_name=args[0]
  obs_range=args[1]
  ;if (nargs eq 3) then n_obs=args[2]
  print,'folder_name = '+folder_name
  print,'obs_range = '+obs_range

  ;;;;;; FT Parameters
;  freq_ch_range=[ 0, 129 ]   ; 10MHz for the correct MWA channelization ( z = 7.019 to 7.5)
;  freq_ch_range=[ 130, 259 ] 
;  freq_ch_range=[ 260, 383 ] 
  no_spec_window=1

;  kperp_range_1dave = []    ; Set to limit kperp range for binning
  std_power = 0    ; Use FT instead of Lomb-Scargle
  refresh_beam=0
  refresh_dft=0
 
 ; Colorbar options
  color_type='linear'

  ;;;;; BinninMWAGoldenZenith;   kperp_range_lambda_1dave=[0.0,25.0]
;  kpar_range_kperppower=[0.3,0.4]

  ; Which cubes?
  pol_inc=['xx']
;  type_inc=['RES']

  ;;;;;; Which plots?:
  plot_stdset=0
  plot_slices=0
;  slice_type='raw'
;  uvf_plot_type='abs'	; These two only used if plot_slices=1
  plot_2d_masked=0
  plot_1to2d=0    ; Show where the 2d bins are on the 2d plot
  plot_kpar_power=0
  plot_kperp_power=0
  plot_k0_power = 0    ; Causes issues when running with other 1d plots
  plot_noise_1d = 0
  plot_sim_noise = 0
  plot_binning_hist= 0   ;for debugging

  ;;;;;; 2D plotting options
  plot_wedge_line=1
  wedge_angles=[90.0]
  
  kperp_linear_axis=0
  kpar_linear_axis=0
;  kperp_plot_range=[5,10]
;  kperp_lambda_plot_range=
;  kpar_plot_range=
  baseline_axis=1
  delay_axis=1
  cable_length_axis=0

  ;;;;;; 1D plotting options
  set_krange_1dave=0
;  range_1d=
  plot_1d_delta=0    ; Physical or theoretician units?
  plot_1d_error_bars=1
;  plot_1d_nsigma=2
;  plot_eor_1d=1
  plot_flat_1d=0
  no_text_1d=0
  sim=1
  png=1
;  data_range=[1,3]

  hinv=0

  extra = var_bundle()

  ps_wrapper,folder_name,obs_range,/exact_obsnames,loc_name='oscar', _Extra=extra

end

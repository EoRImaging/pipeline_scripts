PRO sim_versions_wrapper, version=version, sources_file_name=sources_file_name, catalog_file_name=catalog_file_name,fov=fov,$
    set_sidelobe_keywords=set_sidelobe_keywords;, _Extra=extra

except=!except
!except=0
heap_gc


; parse command line args
compile_opt strictarr
args = Command_Line_Args(count=nargs)
obs_id = args[0]
output_directory = args[1]
version = args[2]
sim_id = args[3]

;;; Old
;  '256' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat_256.hdf5"
;  '256_bigvar' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_bigvar_256.hdf5"
;  '512' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat_512.hdf5"
;  '1024' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat_1024.hdf5"
;  '256_smooth' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_smoothed_256.hdf5"
;  '512_smooth' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_smoothed_512.hdf5"
;  '1024_smooth' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_smoothed_1024.hdf5"
;  '256_ugrade' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_ugrade_256.hdf5"
;  '512_ugrade' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_ugrade_512.hdf5"
;  '1024_ugrade' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_ugrade_1024.hdf5"
;  '512_area-scale' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_pixarea-scale_512.hdf5"
;  '1024_area-scale' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_pixarea-scale_1024.hdf5"
;  '512_len-scale' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_pixlen-scale_512.hdf5"
;  '1024_len-scale' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_pixlen-scale_1024.hdf5"
;  '2048' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat_2048.hdf5"

;; Vary choice of hdf5 input
case sim_id of
    'hera_256_lowband' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/hera_gaussian_10MHz_nside256_K_sig2.0_lowband.hdf5"
    'hera_512_lowband' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/hera_gaussian_10MHz_nside512_K_sig2.0_lowband.hdf5"
    'hera_1024_lowband' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/hera_gaussian_10MHz_nside1024_K_sig2.0_lowband.hdf5"
    'hera_256_freqfix' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/hera_gaussian_10MHz_nside256_K_var2.0_freqfix.hdf5"
    'hera_512_freqfix' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/hera_gaussian_10MHz_nside512_K_var2.0_freqfix.hdf5"
    'hera_1024_freqfix' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/hera_gaussian_10MHz_nside1024_K_var2.0_freqfix.hdf5"
    'mwa_256' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_256_K_var2.0.hdf5"
    'mwa_512' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_512_K_var2.0.hdf5"
    'mwa_1024' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_1024_K_var2.0.hdf5"
    'sig3_256' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_nside256_K_sig3.0.hdf5"
    'sig3_512' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_nside512_K_sig3.0.hdf5"
    'sig3_1024' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_nside1024_K_sig3.0.hdf5"
    'vscale_sig2_256' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/voxscaled_mwa_gaussian_nside256_K_sig2.0.hdf5"
    'vscale_sig2_512' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/voxscaled_mwa_gaussian_nside512_K_sig2.0.hdf5"
    'vscale_sig2_1024' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/voxscaled_mwa_gaussian_nside1024_K_sig2.0.hdf5"
    'vsq_scale_sig2_256' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/vox_sq_scaled_mwa_gaussian_nside256_K_sig2.0.hdf5"
    'vsq_scale_sig2_512' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/vox_sq_scaled_mwa_gaussian_nside512_K_sig2.0.hdf5"
    'vsq_scale_sig2_1024' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/voxscaled_mwa_gaussian_nside1024_K_sig2.0.hdf5"
    'inv_vscale_sig2_256' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/vox_inv_scaled_mwa_gaussian_nside256_K_sig2.0.hdf5"
    'inv_vscale_sig2_512' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/vox_inv_scaled_mwa_gaussian_nside512_K_sig2.0.hdf5"
    'inv_vscale_sig2_1024' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/vox_inv_scaled_mwa_gaussian_nside1024_K_sig2.0.hdf5"
    'inv_sq_vscale_sig2_256' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/vox_inv_sq_scaled_mwa_gaussian_nside256_K_sig2.0.hdf5"
    'inv_sq_vscale_sig2_512' : bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/vox_inv_sq_scaled_mwa_gaussian_nside256_K_sig2.0.hdf5"
  else: print, 'No matches'
END
if nargs eq 5 then begin
	; This will be used if being run in variation mode. For this, I'll need to set an obs_id_suffix
	print, "Passed successfully"
	param_set=args[4]
endif

cmd_args={version:version}

if n_elements(obs_id) eq 0 then begin
	print, n_elements(obs_id) eq 0
	print, 'Bad'
endif

uvfits_version=4
uvfits_subversion=1


;Set defaults
;sources_file_name="zem_simulation_sources/sim_source_list1"  ; Temporarily using smaller source list to improve gridding time.
;sources_file_name="mwa_calibration_source_list_gleam_kgs_fhd_fornax"
sources_file_name="GLEAM_EGC_catalog"
export_images = 1 ; toggles the output of images from fhd_quickview
save_visibilities=1
model_visibilities=1
make_regular_bls=0
save_antenna_model=1
snapshot_healpix_export = 1
ps_export=1
split_ps_export=1
save_imagecube=0
save_uvf=0
dft_threshold=0   ; Approximate the DFT (1) or not (0)
no_frequency_flagging=1   ; Don't automatically flag the coarse channels for MWA

restore_last=1   ;    Use saved beam model

beam_offset_time=0   ; How far into the file to calculate the beam model? (seconds)

;grid_interpolate=1   ; This doesn't see to do anything..
unflag_all=1       ; Don't flag any visibilities

n_pol = 2
image_filter_fn='filter_uv_uniform' ; not sure if this makes sense for simulations
vis_baseline_hist=1
;dimension=1024
dimension=2048
if n_elements(fov) eq 0 then fov=0.   ; Smaller for HERA, maybe 10 to 15. (80 originally) -- overrides kbinsize
beam_nfreq_avg=10    ; Fine frequencies per coarse channel.

max_sources=10000
psf_resolution=100.
kbinsize=0.5
;kbinsize=0.25
;recalculate_all=0 ; If there is no data being used for context, FHD should calculate everything from scratch.
grid_recalculate = 1 ; This is needed in array_simulator to enter the gridding/imaging sections
include_catalog_sources = 1 ; toggles the use of catalog sources in the simulation source list.
eor_sim = 0; toggles eor simulation in vis_simulate

no_rephase=1 ;set to use obsra, obsdec for phase center even if phasera, phasedec present in a .metafits file
;force_rephase_to_zenith=1
; To work with Bryna's changes for noise simulations, include_noise must be explicitly off. Should be investigated and fixed!
include_noise=0
noise_sigma_freq=0

beam_model_version=2

;Convoluted way of setting up 'instrument' for use here, while still leaving it to be passed in Extra
IF N_Elements(extra) GT 0 THEN IF Tag_exist(extra,'instrument') THEN instrument=extra.instrument
IF N_Elements(instrument) EQ 0 THEN instrument='mwa'
IF N_Elements(double_precison_beam) EQ 0 THEN double_precison_beam=0


if n_elements(version) eq 0 then begin ;version provides a name for the output subdirectory
    print, 'Please provide a version designator.'
    return
endif

;;** Setting up the source_array structure that contains the sources to be used in the simulation
;if n_elements(sources_file_name) eq 0 then begin
;    print, 'Please supply the name of an input file with sources to simulate.'
;    return
;endif else print, 'Using sources: ' + sources_file_name


case version of
; Add snapshot_healpix_export=0 for faster runtime if not doing eppsilon

;;pointsource ==> GLEAM_EGC_catalog
;bubble_fname ==> /users/alanman/data/alanman/BubbleCube/TiledHpxCubes/light_cone_surfaces.hdf5
;diffuse_model=filepath('gsm_150MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
;beam_nfreq_avg = 203
;eor_sim
;flat_sigma
;set_sidelobe_keywords=0

    'gaussian_bubble_gauss_100d': begin
        beam_model_version=0
    	dimension=1024
    	instrument='gaussian'
    	nfreq_avg=102  ; 10 Mhz
    	include_catalog_sources=0
    	snapshot_healpix_export=0
        select_radius_multiplier=1.5
        save_antenna_model=0
    end

    'gaussian_bubble_gauss_70d': begin
        beam_model_version=1
    	dimension=1024
    	instrument='gaussian'
    	nfreq_avg=102  ; 10 Mhz
    	include_catalog_sources=0
    	snapshot_healpix_export=0
        select_radius_multiplier=1.5
        save_antenna_model=0
    end

    'gaussian_bubble_gauss_40d': begin
        beam_model_version=2
    	dimension=1024
    	instrument='gaussian'
    	nfreq_avg=102  ; 10 Mhz
    	include_catalog_sources=0
    	snapshot_healpix_export=0
        select_radius_multiplier=1.5
        save_antenna_model=0
    end

    'gaussian_bubble_gauss_35d': begin
        beam_model_version=3
    	dimension=1024
    	instrument='gaussian'
    	nfreq_avg=102  ; 10 Mhz
    	include_catalog_sources=0
    	snapshot_healpix_export=0
        select_radius_multiplier=1.5
        save_antenna_model=0
    end

    'gaussian_bubble_gauss_16d': begin
        beam_model_version=4
    	dimension=1024
    	instrument='gaussian'
    	nfreq_avg=102  ; 10 Mhz
    	include_catalog_sources=0
    	snapshot_healpix_export=0
        select_radius_multiplier=1.5
        save_antenna_model=0
    end

    'gaussian_bubble_gauss_10d': begin
        beam_model_version=5
    	dimension=1024
    	instrument='gaussian'
    	nfreq_avg=102  ; 10 Mhz
    	include_catalog_sources=0
    	snapshot_healpix_export=0
        select_radius_multiplier=1.5
        save_antenna_model=0
    end


    'gaussian_bubble_gauss_70d_nometafits': begin
;    0: sigma = 100./(2*sqrt(2.*alog(2.)))
;    1: sigma = 70./(2*sqrt(2.*alog(2.)))
;    2: sigma = 40./(2*sqrt(2.*alog(2.)))
;    3: sigma = 35./(2*sqrt(2.*alog(2.)))
;    4: sigma = 16./(2*sqrt(2.*alog(2.)))
;    5: sigma = 10./(2*sqrt(2.*alog(2.)))
        ;beam_model_version=uint(sim_id)
        beam_model_version=1
    	dimension=1024
    	instrument='gaussian'
    	nfreq_avg=102  ; 10 Mhz
    	include_catalog_sources=0
;    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
        save_antenna_model=0
;        bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_256_K_var2.0.hdf5"
    end   ; Gaussian beam model. beam_model_version sets width

    'tophat_bubble_gauss_shellreplace': begin
        ;; 10MHz files
    	dimension=1024
    	instrument='tophat'
    	nfreq_avg=102  ; 10 Mhz
    	include_catalog_sources=0
    	snapshot_healpix_export=0
        select_radius_multiplier=1.5
        shellreplace=1
        save_antenna_model=0   ; Trying to cut down on file bloat for large run
    end

    'hera_bubble_gauss_shellreplace_saved': begin
        ;; 10MHz files
    	dimension=1024
    	instrument='hera'
    	nfreq_avg=102  ; 10 Mhz
    	include_catalog_sources=0
    	snapshot_healpix_export=0
        select_radius_multiplier=1.5
        shellreplace=1
        save_antenna_model=0   ; Trying to cut down on file bloat for large run
    end

    'hera_bubble_gauss': begin
        ;; 10MHz files
    	dimension=1024
    	instrument='hera'
    	nfreq_avg=102  ; 10 Mhz
    	include_catalog_sources=0
    	snapshot_healpix_export=0
        select_radius_multiplier=1.5
        save_antenna_model=0   ; Trying to cut down on file bloat for large run
    end

    'hera_bubble_gauss_paperbeam': begin
        ;; 10MHz files
    	dimension=1024
    	instrument='paper'
    	nfreq_avg=102
    	include_catalog_sources=0
    	snapshot_healpix_export=0
        select_radius_multiplier=1.5
    end

    'hera_bubble_gauss_mwabeam': begin
        ;; 10MHz files
    	dimension=1024
    	instrument='mwa'
    	nfreq_avg=102
    	include_catalog_sources=0
    	snapshot_healpix_export=0
        select_radius_multiplier=1.5
    end

    'hera_bubble_gauss_mwabeam_shellreplace': begin
        ;; 10MHz files
    	dimension=1024
    	instrument='mwa'
    	nfreq_avg=102
        shellreplace=1
    	include_catalog_sources=0
    	snapshot_healpix_export=0
        select_radius_multiplier=1.5
    end

    'hera_bubble_gauss_herabeam': begin
        ;; 10MHz files
    	dimension=1024
    	instrument='hera'
    	nfreq_avg=102
    	include_catalog_sources=0
    	snapshot_healpix_export=0
        select_radius_multiplier=1.5
    end

    'hera19_uncomp_short_diffuse_k025': begin
	dimension=1024
	instrument='hera'
	beam_nfreq_avg=1024
	include_catalog_sources=0
	snapshot_healpix_export=0
	kbinsize=0.25
	diffuse_model=filepath('gsm_150MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    end

    'hera19_comp_diff-eor0': begin
	dimension=1024
	instrument='hera'
	beam_nfreq_avg=1024
	include_catalog_sources=0
	snapshot_healpix_export=0
	diffuse_model=filepath('EoR0_diffuse_model.sav',root=rootdir('FHD'),subdir='catalog_data')

    end

    'calsky_heracomp_gaussian' : begin
	dimension=1024
	instrument='hera'
	beam_nfreq_avg=203
	include_catalog_sources=0
	snapshot_healpix_export=0
	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/gaussian_cube.hdf5"
    end

    'euler_calsky_mwa_gaussian_256' : begin
        dimension=1024
        instrument='mwa'
        beam_nfreq_avg=384
        include_catalog_sources=0
        snapshot_healpix_export=1
        select_radius_multiplier=1.5
        bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_nside256_sig2.0_calsky_cube.hdf5"
    end

    'mwa128_hdf5_point' : begin
	dimension=1024
	instrument='mwa'
	beam_nfreq_avg=384
	include_catalog_sources=0
	snapshot_healpix_export=1
	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_points.hdf5"
    end

    'mwa_bubble_gauss_bigdim' : begin
    	dimension=2048
    	instrument='mwa'
    	beam_nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
;    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat.hdf5"
    end

    'mwa_bubble_gauss_map-replace_var4' : begin
    	dimension=1024
    	instrument='mwa'
    	beam_nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.0
        orthomap_var = 4.0
        ;; For this --- temporarily replacing the input map with a gaussian orthoslant of mean 0 var 1
;    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat.hdf5"
    end

    'mwa_bubble_gauss_map-replace_var2' : begin
    	dimension=1024
    	instrument='mwa'
    	beam_nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.0
        orthomap_var = 2.0
        ;; For this --- temporarily replacing the input map with a gaussian orthoslant of mean 0 var 1
;    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat.hdf5"
    end

    'mwa_bubble_gauss_wideselect' : begin
    	dimension=1024
    	instrument='mwa'
    	beam_nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=7.0
;    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat.hdf5"
    end

    'mwa_bubble_gauss_d128' : begin
    	dimension=128
    	instrument='mwa'
    	beam_nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
;    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat.hdf5"
    end

    'mwa_bubble_gauss_d256' : begin
    	dimension=256
    	instrument='mwa'
    	beam_nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
;    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat.hdf5"
    end

    'mwa_bubble_gauss_d512' : begin
    	dimension=512
    	instrument='mwa'
    	beam_nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
;    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat.hdf5"
    end

    'mwa_bubble_gauss_asJy' : begin
    	dimension=1024
    	instrument='mwa'
    	beam_nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
        ;;; Removed /from_jansky in healpix_interpolate step of eor_bubble_sim
;    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat.hdf5"
    end

    'mwa_bubble_gauss_binned_complex-fix' : begin
    	dimension=1024
    	instrument='mwa'
    	beam_nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
;    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat.hdf5"
    end

    'mwa_bubble_gauss_rootscale' : begin
    	dimension=1024
    	instrument='mwa'
    	nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/scaled_mwa_gaussian_var2_nside256.hdf5"
    	;bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/rootscaled_mwa_gaussian_var2_nside256.hdf5"
    end

    'mwa_bubble_gauss_bryna-scale' : begin
    	dimension=1024
    	instrument='mwa'
    	beam_nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_eorsim_512_K_v2.hdf5"
    	;bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_eorsim_256_K_v2.hdf5"
    end

    'mwa_bubble_gauss_quarter-interp-wide' : begin
    	dimension=2048
    	instrument='mwa'
    	beam_nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
        ; When run --- healpix_interpolate sets the gaussian restorin beam width to 1/4 of the area_ratio
;    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat.hdf5"
    end

    'mwa_bubble_gauss_ltaper' : begin
    	dimension=1024
    	instrument='mwa'
    	beam_nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
        ltaper=1.0    ; tanh taper function in lspace for healpix maps
;    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat.hdf5"
    end


    'mwa_bubble_gauss_256_herabeam' : begin
    	dimension=1024
    	instrument='hera'
    	nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
        kbinsize=0.1
    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_nside256_K_var2.0_freqfix.hdf5"
    end

    'mwa_bubble_gauss_256' : begin
    	dimension=1024
    	instrument='mwa'
    	nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
;    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_nside256_K_var2.0_freqfix.hdf5"      ; Commented out on 1/7/19. This is not vox-vol scaled
        bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/vox_inv_scaled_mwa_gaussian_nside256_K_sig2.0.hdf5"
    end

    'mwa_bubble_gauss_256_chrom' : begin
    	dimension=1024
    	instrument='mwa'
    	nfreq_avg=16
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
;    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_nside256_K_var2.0_freqfix.hdf5"      ; Commented out on 1/7/19. This is not vox-vol scaled
        bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/vox_inv_scaled_mwa_gaussian_nside256_K_sig2.0.hdf5"
    end

    'mwa_bubble_gauss_512_shellreplace' : begin
    	dimension=1024
    	instrument='mwa'
    	nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
        shellreplace=1
        snapshot_healpix_export=0
    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_nside512_K_var2.0_freqfix.hdf5"
    end

    'mwa_bubble_gauss_512' : begin
    	dimension=1024
    	instrument='mwa'
    	nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_nside512_K_var2.0_freqfix.hdf5"
    end
    'mwa_bubble_gauss_512_off-freq' : begin
    	dimension=1024
    	instrument='mwa'
    	nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_512_K_var2.0.hdf5"
    end

    'mwa_bubble_gauss_1024' : begin
    	dimension=1024
    	instrument='mwa'
    	nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_nside1024_K_var2.0_freqfix.hdf5"
    end

    'mwa_bubble_gauss_ugrade' : begin
    	dimension=1024
    	instrument='mwa'
    	nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_ugrade_256.hdf5"
    end


    'mwa_bubble_gauss' : begin
    	dimension=1024
    	instrument='mwa'
    	beam_nfreq_avg=384
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        select_radius_multiplier=1.5
    ;	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/variance_one/mwa_gaussian_flat_1024.hdf5"
    end

    'hera_bubble_calsky-patchy':begin
        dimension=1024
        instrument='hera'
        beam_nfreq_avg=105 ; Using 10MHz uncomp files
        include_catalog_sources=0
        select_radius_multiplier=1.5
        snapshot_healpix_export=0   ; Save on time
        bubble_fname='/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_patchy_calsky_cube.hdf5'
    end

    'hera_bubble_calsky-neutral':begin
        dimension=1024
        instrument='hera'
        beam_nfreq_avg=105 ; Using 10MHz uncomp files
        include_catalog_sources=0
        select_radius_multiplier=1.5
        snapshot_healpix_export=0   ; Save on time
        ;bubble_fname='/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_dens_calsky_cube.hdf5'
        bubble_fname='/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/hera_neutral_calsky_cube.hdf5'
    end

    'hera_bubble_gauss' : begin
    	dimension=1024
    	instrument='hera'
    	beam_nfreq_avg=105    ; Using the 10MHz files
    	include_catalog_sources=0
    	snapshot_healpix_export=0
        select_radius_multiplier=1.5
;    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_gaussian_flat.hdf5"
    end

    'mwa_calsky_dens_bubble' : begin
    	dimension=1024
    	instrument='mwa'
    	beam_nfreq_avg=384
        rephase_weights=0        ; Assume phase center is the pointing center.
        select_radius_multiplier=1.5     ; Extra width for healpix selection, on top of primary beam width.
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        bubble_fname='/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_dens_calsky_cube.hdf5'
    end

    'mwa_calsky_neutral_512_bubble' : begin
    	dimension=1024
    	instrument='mwa'
    	beam_nfreq_avg=384
        rephase_weights=0        ; Assume phase center is the pointing center.
        select_radius_multiplier=1.5     ; Extra width for healpix selection, on top of primary beam width.
    	include_catalog_sources=0
    	snapshot_healpix_export=1
        bubble_fname='/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_nside512_neutral_calsky_cube.hdf5'
    end

    'mwa_cora_bubble' : begin
    	dimension=1024
    	instrument='mwa'
    	beam_nfreq_avg=384
        rephase_weights=0        ; Assume phase center is the pointing center.
        select_radius_multiplier=1.5     ; Extra width for healpix selection, on top of primary beam width.
    	include_catalog_sources=0
    	snapshot_healpix_export=1
    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/cora_mwa_10MHz.hdf5"
    end

    'mwa_lin_bubble' : begin
    	dimension=1024
    	instrument='mwa'
    	beam_nfreq_avg=384
        rephase_weights=0        ; Assume phase center is the pointing center.
        select_radius_multiplier=1.5     ; Extra width for healpix selection, on top of primary beam width.
    	include_catalog_sources=0
    	snapshot_healpix_export=1
    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_lin_light_cone_surfaces.hdf5"
    end

    'mwa_lin_bubble_hires' : begin
    	dimension=1024
    	instrument='mwa'
    	beam_nfreq_avg=384
        rephase_weights=0        ; Assume phase center is the pointing center.
        select_radius_multiplier=1.5     ; Extra width for healpix selection, on top of primary beam width.
    	include_catalog_sources=0
    	snapshot_healpix_export=1
    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/mwa_lin_hires_light_cone_surfaces.hdf5"
    end

    'mwa_lin_bubble_ctile-gauss' : begin
    	dimension=1024
    	instrument='mwa'
    	beam_nfreq_avg=384
        rephase_weights=0        ; Assume phase center is the pointing center.
        select_radius_multiplier=1.5     ; Extra width for healpix selection, on top of primary beam width.
    	include_catalog_sources=0
    	snapshot_healpix_export=1
    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/tiled_gaussian_nside512_light_cone_surfaces.hdf5"
    end

    'mwa_lin_bubble_ctile-gauss_hires' : begin
    	dimension=1024
    	instrument='mwa'
    	beam_nfreq_avg=384
        rephase_weights=0        ; Assume phase center is the pointing center.
        select_radius_multiplier=1.5     ; Extra width for healpix selection, on top of primary beam width.
    	include_catalog_sources=0
    	snapshot_healpix_export=1
    	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/tiled_gaussian_nside1024_light_cone_surfaces.hdf5"
    end

    'hera_uncomp_10MHz_bubble': begin
        dimension=1024
        instrument='hera'
        beam_nfreq_avg = 105   ; The input files only have 102 channels.
        include_catalog_sources=0
        snapshot_healpix_export=0
	    bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/hera_uncomp_10MHz_lin_light_cone_surfaces.hdf5"
    end

    'hera19_comp_short_bubble' : begin
	dimension=1024
	instrument='hera'
	beam_nfreq_avg=203
	include_catalog_sources=0
	snapshot_healpix_export=0
	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/paper_comp_lin_light_cone_surfaces.hdf5"
    end

    'hera19_comp_short_eor' : begin
	dimension=1024
	instrument='hera'
	beam_nfreq_avg=203
	include_catalog_sources=0
	snapshot_healpix_export=0
    eor_sim=1
    end

    'hera19_uncomp_mwa-model_diffuse' : begin
	dimension=1024
	instrument='mwa'
;	beam_model_version=3
	beam_nfreq_avg=1024
	include_catalog_sources=0
	snapshot_healpix_export=0
	diffuse_model=filepath('gsm_150MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    end


    'hera19_uncomp_beam-model3_diffuse' : begin
	dimension=1024
	instrument='hera'
	beam_model_version=3
	beam_nfreq_avg=1024
	include_catalog_sources=0
	snapshot_healpix_export=0
	psf_resolution=10
	diffuse_model=filepath('gsm_150MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    end

    'hera19_comp_short_diffuse' : begin
	dimension=1024
	instrument='hera'
	beam_nfreq_avg=203
	include_catalog_sources=0
	snapshot_healpix_export=0
	diffuse_model=filepath('gsm_150MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    end


    'hera19_uncomp_short_diffuse' : begin
	dimension=1024
	instrument='hera'
	beam_nfreq_avg=1024
	include_catalog_sources=0
	snapshot_healpix_export=0
	diffuse_model=filepath('gsm_150MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
    end

    'hera19_comp_short_point' : begin
	dimension=1024
	instrument='hera'
	beam_nfreq_avg=203
	snapshot_healpix_export=0
	max_model_sources=10000
    end

    'hera19_uncomp_short_point' : begin
	dimension=1024
	instrument='hera'
	beam_nfreq_avg=1024
	snapshot_healpix_export=0
	max_model_sources=10000
    end


    'hera19_comp_short_eor' : begin
	dimension=1024
	instrument='hera'
	beam_nfreq_avg=203
	snapshot_healpix_export=0
	include_catalog_sources=0
	eor_sim=1
    end

    'hera_eor_flat' : begin
        dimension=1024
        instrument='mwa'
        nfreq_avg=102    ; Reduced bandwidth
        snapshot_healpix_export=0
        include_catalog_sources=0
        save_antenna_model=0   ; Trying to cut down on file bloat for large run
        eor_sim=1
        flat_sigma=1
    end

    'mwa_eor_flat' : begin
        dimension=1024
        instrument='mwa'
        beam_nfreq_avg=384
        snapshot_healpix_export=1
        include_catalog_sources=0
        eor_sim=1
        flat_sigma=1
    end

    'mwa128_eor' : begin
        dimension=1024
        instrument='mwa'
        beam_nfreq_avg=384
        snapshot_healpix_export=1
        include_catalog_sources=0
        eor_sim=1
    end

    'mwa_point_gleam': begin
        dimension=1024
        instrument='mwa'
        nfreq_avg=384
        sources_file_name='GLEAM_EGC_catalog'
        max_model_sources=7000
        snapshot_healpix_export=1
        dft_threshold=0
    end

;   'sim_mwa_mwabeams': begin
;	dimension=1024
;	instrument='mwa'
;	sources_file_name='GLEAM_EGC_catalog'
;	max_model_sources=7000
;	dft_threshold=0
;	beam_nfreq_avg=16
;   end
;
;   'sim_mwa_fornax_herabeams': begin
;	dimension=1024
;	instrument='paper'
;	sources_file_name='GLEAM_EGC_catalog'
;	max_model_sources=7000
;	dft_threshold=0
;	beam_nfreq_avg=16
;   end
;
;
;   'sim_mwa_fornax_paperbeams': begin
;	dimension=1024
;	instrument='paper'
;	sources_file_name='GLEAM_EGC_catalog'
;	max_model_sources=7000
;	dft_threshold=0
;	beam_nfreq_avg=16
;   end
;
;
;   'sim_mwa_fornax_eor_herabeam': begin
;	dimension=1024
;	instrument='hera'
;	sources_file_name='GLEAM_EGC_catalog'
;	max_model_sources=0
;	dft_threshold=0
;	beam_nfreq_avg=16
;	include_catalog_sources=0
;	eor_sim=1
;   end
;
;
;   'sim_mwa_fornax_eor_paperbeam': begin
;	dimension=1024
;	instrument='paper'
;	sources_file_name='GLEAM_EGC_catalog'
;	max_model_sources=0
;	dft_threshold=0
;	beam_nfreq_avg=16
;	include_catalog_sources=0
;	eor_sim=1
;   end
;
;   'sim_mwa_fornax_eor_meta': begin
;	dimension=1024
;	instrument='mwa'
;	sources_file_name='GLEAM_EGC_catalog'
;	max_model_sources=0
;	dft_threshold=0
;	beam_nfreq_avg=16
;	include_catalog_sources=0
;	eor_sim=1
;   end


   'test_diffuse': begin
	include_catalog_sources=0
	eor_sim=0
	diffuse_model=filepath('gsm_150MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
	;bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/paper_comp_lin_light_cone_surfaces.hdf5"
	;max_model_sources=10
	instrument='hera'
	dft_threshold=1
	dimension=512
	beam_nfreq_avg=1024
   end

   'sim_mwa_goldensubset': begin
	; For comparison with a firstpass run.
        max_model_sources=1000
	instrument='mwa'
	beam_nfreq_avg=384
	ps_nfreq_avg=1
	dimension=1024
        dft_threshold=0
	diffuse_model=filepath('gsm_150MHz.sav',root=rootdir('FHD'),subdir='catalog_data')
	restrict_hpx_inds="EoR0_high_healpix_inds.idlsave"
   end

   'test': begin
	include_catalog_sources=0
	eor_sim=0
	bubble_fname="/users/alanman/data/alanman/BubbleCube/TiledHpxCubes/paper_comp_lin_light_cone_surfaces.hdf5"
	;max_model_sources=10
	instrument='hera'
	dft_threshold=1
	dimension=512
	beam_nfreq_avg=1024
   end

endcase

;print, 'max_sources = '+ String(max_model_sources)
;max_model_sources=max_sources


sources_file_path = filepath(string(format='(A,".sav")',sources_file_name),root=rootdir('FHD'), subdir='catalog_data')

;restore, sources_file_path
;source_array = catalog
;undefine, catalog

SPAWN, 'locate_uvfits_oscar.py -o ' + STRING(obs_id), vis_file_list

temp_path=vis_file_list[0] ; vis_file_list needs needs to be a scalar each time it is passed to array_simulator. For now, we are only using one file.:
undefine, vis_file_list
sim_from_uvfits_filepath = temp_path ; used in array_simulator_init.pro

print, 'Reading from file: ' + sim_from_uvfits_filepath

IF ~(sim_id eq version) THEN begin
      sim_id = version + "_" + sim_id
endif
file_path_fhd = fhd_path_setup(sim_from_uvfits_filepath,output_directory=output_directory,version=sim_id,_Extra=extra) ;Creates output directories for each obsid
temp_path2 = file_path_fhd[0]
undefine, file_path_fhd
file_path_fhd = temp_path2


if isa(param_set, /String) then begin
	test=execute(param_set,1)
	print, 'kbinsize set to ', kbinsize
	param_set = StrJoin( StrSplit(param_set, '=', /Extract), '-')
	file_path_fhd = file_path_fhd + "_" + param_set
endif


undefine,uvfits_version ; don't need these passed further
undefine,uvfits_subversion
undefine,obs_id



if n_elements(set_sidelobe_keywords) eq 0 then set_sidelobe_keywords=0

allow_sidelobe_image_output=set_sidelobe_keywords
allow_sidelobe_sources=set_sidelobe_keywords
allow_sidelobe_model_sources=set_sidelobe_keywords
allow_sidelobe_cal_sources=set_sidelobe_keywords



IF N_Elements(complex_beam) EQ 0 THEN complex_beam=1
IF N_Elements(precess) EQ 0 THEN precess=0 ;set to 1 ONLY for X16 PXX scans (i.e. Drift_X16.pro)

if make_regular_bls eq 1 THEN BEGIN
;	uvw = hera_baselines()
	ps_kspan=600
	simulate_baselines=1
	nsample=100
	sim_uu = findgen(nsample)*ps_kspan/nsample - ps_kspan/2
	sim_vv = findgen(nsample)*ps_kspan/nsample - ps_kspan/2
	f_use = 150e6
	sim_uu = sim_uu / f_use
	sim_vv = sim_vv / f_use

	max_n_baseline = 8000
	n_time = 2*ceil(nsample/float(max_n_baseline))
	n_per_time = floor(nsample/(n_time/2.))
	if n_per_time*n_time ne nsample then begin
	  nsample = n_per_time*n_time/2.
	  sim_uu = sim_uu[0:nsample-1]
	  sim_vv = sim_vv[0:nsample-1]
	endif
	sim_uu = reform(sim_uu, n_per_time, 1, n_time/2)
	sim_vv = reform(sim_vv, n_per_time, 1, n_time/2)

	sim_baseline_uu = reform([[sim_uu], [sim_uu]], n_per_time*n_time)
	sim_baseline_vv = reform([[sim_vv], [sim_vv]], n_per_time*n_time)

	sim_baseline_time = [intarr(n_per_time), intarr(n_per_time)+1]
	if n_time gt 2 then for i=1, n_time/2-1 do sim_baseline_time = [sim_baseline_time, intarr(n_per_time)+2*i, intarr(n_per_time)+2*i+1]
endif

;; Baseline Simulation
IF N_Elements(n_avg) EQ 0 THEN n_avg=1
;IF N_Elements(ps_kbinsize) EQ 0 THEN ps_kbinsize=0.5
;IF N_Elements(ps_kspan) EQ 0 THEN ps_kspan=600.
catalog_file_path=sources_file_path
if keyword_set(bubble_fname) then print, 'bubble_fname: ', bubble_fname

extra=var_bundle()

array_simulator, vis_arr, flag_arr, obs, status_str, psf, params, jones, _Extra=extra

heap_gc

!except=except

end

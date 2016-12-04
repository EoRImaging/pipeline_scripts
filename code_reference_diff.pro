PRO code_reference_diff,hash_ref=hash_ref,hash_diff=hash_diff,iter_ref=iter_ref,iter_diff=iter_diff,ratio_data_range=ratio_data_range,_Extra=extra

all_type_pol = 1
png=1

data_directory=rootdir('mwa')+filepath('',root='DATA3',subdir=['128T','code_reference'])
vis_file_list=file_search(data_directory,'*.uvfits',count=n_files)
IF n_files EQ 0 THEN vis_file_list=file_search(data_directory,'*.uvfits.sav',count=n_files) ;compatibility with my laptop 

dir_list=file_search(data_directory,'fhd_v*'+path_sep(),/Test_directory,count=n_directories)
    
hash_match=Strpos(file_basename(dir_list),hash_ref)
false_match=Strpos(file_basename(dir_list),'minus')
match_i=where((hash_match GE 0) AND (false_match EQ -1),n_match)
CASE n_match OF
    0: BEGIN print,"Hash"+hash_ref+" not found! Returning." & RETURN & END
    1: version_ref=file_basename(dir_list[match_i])
    ELSE: BEGIN
        IF N_Elements(iter_ref) GT 0 THEN BEGIN
            match_list=file_basename(dir_list[match_i])
            iter_pos=Strpos(match_list,'run') 
            iter_list=Strarr(n_match)
            FOR i=0,n_match-1 DO iter_list[i]=(iter_pos[i] GT 0) ? Strmid(match_list[i],iter_pos[i]+3):'0'
            match_i_i=where(Strn(iter_ref) EQ iter_list,n_match2)
            IF n_match2 EQ 0 THEN match_i_i=0
            version_ref=file_basename(dir_list[match_i[match_i_i[0]]])
        ENDIF ELSE version_ref=file_basename(dir_list[match_i[0]]) 
    ENDELSE
ENDCASE
IF Strpos(version_ref,'fhd_') EQ 0 THEN version_ref=strmid(version_ref,4)
version_ref=version_ref[0]
fhd_dir_ref=file_dirname(fhd_path_setup(vis_file_list[0],version=version_ref,_Extra=extra))
branch_name_i=(Strpos(version_ref,'_',/reverse_search))[0]
IF branch_name_i LT 0 THEN BEGIN
    ref_branch='' 
    version_ref_short=version_ref
ENDIF ELSE BEGIN
    version_ref_short=Strmid(version_ref,0,branch_name_i)
    ref_branch=Strmid(version_ref,branch_name_i+1)
ENDELSE

IF N_Elements(hash_diff) EQ 0 THEN hash_diff=hash_ref
hash_match=Strpos(file_basename(dir_list),hash_diff)
false_match=Strpos(file_basename(dir_list),'minus')
match_i=where((hash_match GE 0) AND (false_match EQ -1),n_match)
CASE n_match OF
    0: BEGIN print,"Hash"+hash_diff+" not found! Returning." & RETURN & END
    1: version_diff=file_basename(dir_list[match_i])
    ELSE: BEGIN
        IF N_Elements(iter_diff) GT 0 THEN BEGIN
            match_list=file_basename(dir_list[match_i])
            iter_pos=Strpos(match_list,'run') 
            iter_list=Strarr(n_match)
            FOR i=0,n_match-1 DO iter_list[i]=(iter_pos[i] GT 0) ? Strmid(match_list[i],iter_pos[i]+3):'0'
            match_i_i=where(Strn(iter_diff) EQ iter_list,n_match2)
            IF n_match2 EQ 0 THEN match_i_i=0
            version_diff=file_basename(dir_list[match_i[match_i_i[0]]])
        ENDIF ELSE version_diff=file_basename(dir_list[match_i[0]]) 
    ENDELSE
ENDCASE
IF Strpos(version_diff,'fhd_') EQ 0 THEN version_diff=strmid(version_diff,4)
version_diff=version_diff[0]
fhd_dir_diff=file_dirname(fhd_path_setup(vis_file_list[0],version=version_diff,_Extra=extra))
branch_name_i=(Strpos(version_diff,'_',/reverse_search))[0]

IF branch_name_i LT 0 THEN BEGIN
    diff_branch='' 
    version_diff_short=version_diff
ENDIF ELSE BEGIN
    version_diff_short=Strmid(version_diff,0,branch_name_i)
    diff_branch=Strmid(version_diff,branch_name_i+1)
ENDELSE

IF Keyword_Set(ref_branch) AND Keyword_Set(diff_branch) THEN plot_dir=ref_branch+'-'+diff_branch+'_' ELSE plot_dir='' 
plot_dir+=version_ref_short+'-'+version_diff_short

plot_path=filepath('',root=file_dirname(fhd_dir_ref),sub=plot_dir)
IF file_test(plot_path,/directory) EQ 0 THEN file_mkdir,plot_path


folder_names=[fhd_dir_ref,fhd_dir_diff]
save_path = plot_path ; folder_names+path_sep()+'ps'+path_sep()
IF file_test(save_path) THEN file_delete,save_path,/quiet,/recursive
file_mkdir,save_path
data_subdirs = 'Healpix'+path_sep()
obs_info = ps_filenames(folder_names, rts = 0, sim = 0, casa = 0, data_subdirs = data_subdirs, save_paths = folder_names+path_sep()+'ps'+path_sep())

;if n_elements(set_data_ranges) eq 0 and not keyword_set(sim) then set_data_ranges = 1
;    
;if keyword_set(set_data_ranges) then begin
;  if keyword_set(obs_info.integrated[0]) then begin
;    sigma_range = [2e5, 2e9]
;    nev_range = [2e6, 2e10]
;  endif else begin
;    sigma_range = [1e4, 2e6]
;    nev_range = [5e4, 2e7]
;  endelse
;  
;  if n_elements(data_range) eq 0 then data_range = [1e3, 1e15]
;  if n_elements(nnr_range) eq 0 then nnr_range = [1e-1, 1e1]
;  if n_elements(snr_range) eq 0 then snr_range = [1e-5, 1e7]
;  
;  noise_range = nev_range
;endif

if tag_exist(obs_info, 'diff_note') then $
    IF Tag_Exist(obs_info, 'diff_plot_path') THEN obs_info.diff_plot_path = obs_info.diff_save_path $
    ELSE obs_info = create_struct(obs_info, 'diff_plot_path', obs_info.diff_save_path)

note = obs_info.diff_note
plot_path = obs_info.diff_plot_path

ps_difference_plots, folder_names,obs_info, cube_types, pols, spec_window_types = spec_window_types, all_type_pol = all_type_pol, $
    plot_path = plot_path, plot_filebase = plot_filebase, save_path = save_path, savefilebase = savefilebase, $
    note = note, kperp_linear_axis = kperp_linear_axis, kpar_linear_axis = kpar_linear_axis, data_range = data_range, data_min_abs = data_min_abs, $
    quiet = quiet, png = png, eps = eps, pdf = pdf

if n_elements(ratio_data_range) eq 0 then ratio_data_range = [1e-3, 1e1]

diff_range=[-1,1]
ps_ratio_plots, folder_names, obs_info, $
    plot_path = plot_path, plot_filebase = plot_filebase, $
    note = note, spec_window_types = spec_window_types, data_range = ratio_data_range, $
    kperp_linear_axis = kperp_linear_axis, kpar_linear_axis = kpar_linear_axis, diff_ratio = diff_ratio, diff_range = diff_range, $
    plot_wedge_line = plot_wedge_line, quiet = quiet, png = png, eps = eps, pdf = pdf, window_num = window_num

file_delete,save_path,/quiet,/recursive
END
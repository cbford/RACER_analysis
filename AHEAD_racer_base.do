*****************
* AHEAD RACER base
* K Rowe
* 25.02.2019
*****************

*****************
*  WM data *
******************

* Import data *

import excel "F:\My Documents\My ACADEMICS\DPHIL documents\DPHIL PSYCHIATRY\AHEAD Study\Data\Baseline\RACER\Combined spreadsheets\collated_SPATIAL_base_trim_deriv.xlsx", sheet("Sheet2") firstrow

* Get rid of practice trials *

drop if wm_record_type_no==0

* Keep relevant variables only *

keep recordid wm_missed_targets wm_sessiondate wm_sessiondatetime wm_numbertutorials wm_numberpractices wm_seq wm_load wm_encoding wm_delay wm_probe wm_iti wm_dotloc1 wm_dotloc2 wm_dotloc3 wm_record_type wm_record_type_no wm_timedout_outcome wm_first_touch_resp_time wm_second_touch_resp_time wm_third_touch_resp_time wm_first_touch_pos_x wm_first_touch_pos_y wm_second_touch_pos_x wm_second_touch_pos_y wm_third_touch_pos_x wm_third_touch_pos_y wm_first_touch_ctrdist_nearest wm_first_touch_ctrdist_dota wm_first_touch_ctrdist_dotb wm_first_touch_ctrdist_dotc wm_second_touch_ctrdist_nearest wm_second_touch_ctrdist_dota wm_second_touch_ctrdist_dotb wm_second_touch_ctrdist_dotc wm_third_touch_ctrdist_nearest wm_third_touch_ctrdist_dota wm_third_touch_ctrdist_dotb wm_third_touch_ctrdist_dotc wm_first_touch_touched_stim wm_first_touch_touched_stimnum wm_second_touch_touched_stim wm_second_touch_touched_stimnum wm_third_touch_touched_stim wm_third_touch_touched_stimnum wm_first_touch_nearest_stim wm_first_touch_nearest_stimnum wm_second_touch_nearest_stim wm_second_touch_nearest_stimnum wm_third_touch_nearest_stim wm_third_touch_nearest_stimnum wm_probe_touch_count wm_active_dota_number wm_active_dota_pos_x wm_active_dota_pos_y wm_active_dotb_number wm_active_dotb_pos_x wm_active_dotb_pos_y wm_active_dotc_number wm_active_dotc_pos_x wm_active_dotc_pos_y

* Create error flag for trials with distance label error (e.g AAB or ACA etc) *

gen error_flag=0
replace error_flag=1 if wm_load==2 & (wm_first_touch_nearest_stim==wm_second_touch_nearest_stim) & (wm_first_touch_nearest_stim !=. & wm_second_touch_nearest_stim !=.)
replace error_flag=1 if wm_load==3 & ((wm_first_touch_nearest_stim==wm_second_touch_nearest_stim)| (wm_third_touch_nearest_stim==wm_second_touch_nearest_stim)| (wm_first_touch_nearest_stim==wm_third_touch_nearest_stim))& (wm_first_touch_nearest_stim !=. & wm_second_touch_nearest_stim !=. & wm_third_touch_nearest_stim !=.)
replace error_flag=1 if wm_load==3 & ((wm_first_touch_nearest_stim==wm_second_touch_nearest_stim) & (wm_first_touch_nearest_stim !=. & wm_second_touch_nearest_stim !=.))
sum error_flag, detail
hist error_flag, freq

* Create new distance variables that don't repeat stim *
** First put values into new variables as is for trials w/o error flag;

gen wm_first_touch_dist_new = wm_first_touch_ctrdist_nearest
gen wm_first_stim_new = wm_first_touch_nearest_stim if wm_load==1
gen wm_second_touch_dist_new = wm_second_touch_ctrdist_nearest if wm_load==2 & error_flag==0
* CHECK - SHOULD BE REPLACE gen wm_first_stim_new = wm_first_touch_nearest_stim if wm_load==2 & error_flag==0
gen wm_second_stim_new = wm_second_touch_nearest_stim if wm_load==2 & error_flag==0
replace wm_second_touch_dist_new = wm_second_touch_ctrdist_nearest if wm_load==3 & error_flag==0
gen wm_third_touch_dist_new = wm_third_touch_ctrdist_nearest if wm_load==3 & error_flag==0
replace wm_first_stim_new = wm_first_touch_nearest_stim if wm_load==3 & error_flag==0
replace wm_second_stim_new = wm_second_touch_nearest_stim if wm_load==3 & error_flag==0
gen wm_third_stim_new = wm_third_touch_nearest_stim if wm_load==3 & error_flag==0

* Creating new nearest touch distances - load=2 *
* A A / 1 1 *
replace wm_second_touch_dist_new = wm_second_touch_ctrdist_dotb if wm_load==2 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota)
replace wm_first_stim_new = 1 if wm_load==2 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota)
replace wm_second_stim_new = 2 if wm_load==2 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota)

* B B / 2 2*
replace wm_second_touch_dist_new = wm_second_touch_ctrdist_dota if wm_load==2 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb)
replace wm_first_stim_new = 2 if wm_load==2 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb)
replace wm_second_stim_new = 1 if wm_load==2 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb)

* Creating new nearest touch distances - load=3 *
* True nearest touch = A B C / 1 2 3 *

replace wm_second_touch_dist_new = wm_second_touch_ctrdist_dotb if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) & (wm_second_touch_ctrdist_dotb < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
replace wm_third_touch_dist_new = wm_third_touch_ctrdist_dotc if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) & (wm_second_touch_ctrdist_dotb < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
replace wm_first_stim_new = 1 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) & (wm_second_touch_ctrdist_dotb < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
replace wm_second_stim_new = 2 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) & (wm_second_touch_ctrdist_dotb < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=. 
replace wm_third_stim_new = 3 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) & (wm_second_touch_ctrdist_dotb < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.

*True nearest touch = A B C / 1 2 3 BUT 3rd response missing *

replace wm_second_touch_dist_new = wm_second_touch_ctrdist_dotb if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) & (wm_second_touch_ctrdist_dotb < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==.
replace wm_third_touch_dist_new = wm_third_touch_ctrdist_dotc if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) & (wm_second_touch_ctrdist_dotb < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==.
replace wm_first_stim_new = 1 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) & (wm_second_touch_ctrdist_dotb < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==.
replace wm_second_stim_new = 2 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) & (wm_second_touch_ctrdist_dotb < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==. 

* True nearest touch = A C B / 1 3 2 *

replace wm_second_touch_dist_new = wm_second_touch_ctrdist_dotc if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) &(wm_second_touch_ctrdist_dotb > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
replace wm_third_touch_dist_new = wm_third_touch_ctrdist_dotb if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) &(wm_second_touch_ctrdist_dotb > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
replace wm_first_stim_new = 1 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) &(wm_second_touch_ctrdist_dotb > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
replace wm_second_stim_new = 3 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) &(wm_second_touch_ctrdist_dotb > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
replace wm_third_stim_new = 2 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) &(wm_second_touch_ctrdist_dotb > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.

* True nearest touch = A C B / 1 3 2 BUT 3rd response missing *

replace wm_second_touch_dist_new = wm_second_touch_ctrdist_dotc if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) & (wm_second_touch_ctrdist_dotb > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==.
replace wm_third_touch_dist_new = wm_third_touch_ctrdist_dotb if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) & (wm_second_touch_ctrdist_dotb > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==.
replace wm_first_stim_new = 1 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) & (wm_second_touch_ctrdist_dotb > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==.
replace wm_second_stim_new = 3 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dota) & (wm_second_touch_ctrdist_dotb > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==.

* True nearest touch = B A C / 2 1 3 *

replace wm_second_touch_dist_new = wm_second_touch_ctrdist_dota if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
replace wm_third_touch_dist_new = wm_third_touch_ctrdist_dotc if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
replace wm_first_stim_new = 2 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
replace wm_second_stim_new = 1 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
replace wm_third_stim_new = 3 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
			
* True nearest touch = B A C / 2 1 3 BUT 3rd response missing *

replace wm_second_touch_dist_new = wm_second_touch_ctrdist_dota if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==.
replace wm_third_touch_dist_new = wm_third_touch_ctrdist_dotc if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==.
replace wm_first_stim_new = 2 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==.
replace wm_second_stim_new = 1 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==.

* True nearest touch = B C A / 2 3 1 *

replace wm_second_touch_dist_new = wm_second_touch_ctrdist_dotc if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
replace wm_third_touch_dist_new = wm_third_touch_ctrdist_dota if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
replace wm_first_stim_new = 2 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
replace wm_second_stim_new = 3 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.
replace wm_third_stim_new = 1 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc!=.

* True nearest touch = B C A -- BUT 3rd response missing;

replace wm_second_touch_dist_new = wm_second_touch_ctrdist_dotc if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==.
replace wm_third_touch_dist_new = wm_third_touch_ctrdist_dota if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==.
replace wm_first_stim_new = 2 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==.
replace wm_second_stim_new = 3 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotb) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotc) & wm_third_touch_ctrdist_dotc==.

* True nearest touch = C A B / 3 1 2 *

replace wm_second_touch_dist_new = wm_second_touch_ctrdist_dota if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) & (wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc!=.
replace wm_third_touch_dist_new = wm_third_touch_ctrdist_dotb if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) & (wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc!=.
replace wm_first_stim_new = 3 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) & (wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc!=.
replace wm_second_stim_new = 1 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) & (wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc!=.
replace wm_third_stim_new = 2 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) & (wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc!=.

* True nearest touch = C A B / 3 1 2 -- BUT 3rd response missing *

replace wm_second_touch_dist_new = wm_second_touch_ctrdist_dota if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) &(wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc==.
replace wm_third_touch_dist_new = wm_third_touch_ctrdist_dotb if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) &(wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc==.
replace wm_first_stim_new = 3 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) &(wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc==.
replace wm_second_stim_new = 1 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) &(wm_second_touch_ctrdist_dota < wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc==.

* True nearest touch = C B A / 3 2 1 *

replace wm_second_touch_dist_new = wm_second_touch_ctrdist_dotb if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc!=.
replace wm_third_touch_dist_new = wm_third_touch_ctrdist_dota if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc!=.
replace wm_first_stim_new = 3 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc!=.
replace wm_second_stim_new = 2 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc!=.
replace wm_third_stim_new = 1 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc!=.

* True nearest touch = C B A / 3 2 1 -- BUT 3rd response missing *

replace wm_second_touch_dist_new = wm_second_touch_ctrdist_dotb if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc==.
replace wm_third_touch_dist_new = wm_third_touch_ctrdist_dota if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc==.
replace wm_first_stim_new = 3 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc==.
replace wm_second_stim_new = 2 if wm_load==3 & error_flag==1 & (wm_first_touch_ctrdist_nearest==wm_first_touch_ctrdist_dotc) & (wm_second_touch_ctrdist_dota > wm_second_touch_ctrdist_dotb) & wm_third_touch_ctrdist_dotc==.

* Calculate average distance across trials *

*load=1;

gen wm_ave_dist=. 
replace wm_ave_dist = wm_first_touch_dist_new if wm_load==1

*load = 2 and no missing values;

replace wm_ave_dist = (wm_first_touch_dist_new + wm_second_touch_dist_new)/2 if wm_load==2 & wm_first_touch_dist_new!=. & wm_second_touch_dist_new!=.

*load = 2 but second touch is missing;

replace wm_ave_dist = wm_first_touch_dist_new if wm_load==2 & wm_first_touch_dist_new!=. & wm_second_touch_dist_new==. 

*load = 2 but all are missing;

replace wm_ave_dist = . if wm_load==2 & wm_first_touch_dist_new==. & wm_second_touch_dist_new==. 

*load = 3 and no missing values;

replace wm_ave_dist = (wm_first_touch_dist_new + wm_second_touch_dist_new + wm_third_touch_dist_new)/3 if wm_load==3 & wm_first_touch_dist_new!=. & wm_second_touch_dist_new!=. & wm_third_touch_dist_new!=. 

*load = 3 and second & third touches missing;

replace wm_ave_dist = wm_first_touch_dist_new if wm_load==3 & wm_first_touch_dist_new!=. & wm_second_touch_dist_new==. & wm_third_touch_dist_new==. 

*load = 3 and only third touch missing;

replace wm_ave_dist = (wm_first_touch_dist_new + wm_second_touch_dist_new)/2 if wm_load==3 & wm_first_touch_dist_new!=. & wm_second_touch_dist_new!=. & wm_third_touch_dist_new==. 

*load = 3 and all are missing;

replace wm_ave_dist = . if wm_load==3 & wm_first_touch_dist_new==. & wm_second_touch_dist_new==. & wm_third_touch_dist_new==. 

* Distribution *

kdensity wm_ave_dist

* Log transform distance *

gen log_wm_ave_dist = log(wm_ave_dist)

kdensity log_wm_ave_dist

* Calculate number of missed targets (ie. Timed Out) *

*load = 1
gen wm_missed_targets = .
replace wm_missed_targets = 1 if wm_load==1 & wm_first_touch_resp_time==.

*load=2;

replace wm_missed_targets = 2 if wm_load==2 & wm_first_touch_resp_time==. & wm_second_touch_resp_time==. 
replace wm_missed_targets = 1 if wm_load=2 & wm_first_touch_resp_time!=. & wm_second_touch_resp_time==. 
replace wm_missed_targets = 0 if wm_load=2 & wm_first_touch_resp_time!=. & wm_second_touch_resp_time!=. 

*load=3;

replace wm_missed_targets = 3 if wm_load=3 & wm_first_touch_resp_time==. & wm_second_touch_resp_time==. & wm_third_touch_resp_time==.
replace wm_missed_targets = 2 if wm_load=3 & wm_first_touch_resp_time!=. & wm_second_touch_resp_time==. & wm_third_touch_resp_time==. 
replace wm_missed_targets = 1 if wm_load=3 & wm_first_touch_resp_time!=. & wm_second_touch_resp_time!=. & wm_third_touch_resp_time==. 
replace wm_missed_targets = 0 if wm_load=3 & wm_first_touch_resp_time!=. & wm_second_touch_resp_time!=. & wm_third_touch_resp_time!=.

* Frequency distribution *

kdensity wm_missed_targets
hist wm_missed_targets, freq

* Binary missed 1, not missed 0 *

gen wm_missed_binary = .
replace wm_missed_binary = 0 if wm_missed_targets==0
replace wm_missed_binary = 1 if wm_missed_targets>0
hist wm_missed_binary, freq


* Shorten long variable names so wide format variables names don't exceed 32 characters length *

rename wm_second_touch_ctrdist_nearest wm_secondtouch_ctrdistnearest
rename wm_second_touch_touched_stimnum wm_secondtouch_touched_stimnum
rename wm_second_touch_nearest_stimnum wm_secondtouch_neareststimnum

* Convert from long to wide format (using these 3 new variable names) *

reshape wide wm_missed_binary wm_missed_targets log_wm_ave_dist wm_ave_dist error_flag wm_first_touch_dist_new wm_first_stim_new wm_second_touch_dist_new wm_second_stim_new wm_third_touch_dist_new wm_third_stim_new wm_sessiondate wm_sessiondatetime wm_numbertutorials wm_numberpractices wm_load wm_encoding wm_delay wm_probe wm_iti wm_dotloc1 wm_dotloc2 wm_dotloc3 wm_record_type wm_record_type_no wm_timedout_outcome wm_first_touch_resp_time wm_second_touch_resp_time wm_third_touch_resp_time wm_first_touch_pos_x wm_first_touch_pos_y wm_second_touch_pos_x wm_second_touch_pos_y wm_third_touch_pos_x wm_third_touch_pos_y wm_first_touch_ctrdist_nearest wm_first_touch_ctrdist_dota wm_first_touch_ctrdist_dotb wm_first_touch_ctrdist_dotc wm_secondtouch_ctrdistnearest wm_second_touch_ctrdist_dota wm_second_touch_ctrdist_dotb wm_second_touch_ctrdist_dotc wm_third_touch_ctrdist_nearest wm_third_touch_ctrdist_dota wm_third_touch_ctrdist_dotb wm_third_touch_ctrdist_dotc wm_first_touch_touched_stim wm_first_touch_touched_stimnum wm_second_touch_touched_stim wm_secondtouch_touched_stimnum wm_third_touch_touched_stim wm_third_touch_touched_stimnum wm_first_touch_nearest_stim wm_first_touch_nearest_stimnum wm_second_touch_nearest_stim wm_secondtouch_neareststimnum wm_third_touch_nearest_stim wm_third_touch_nearest_stimnum wm_probe_touch_count wm_active_dota_number wm_active_dota_pos_x wm_active_dota_pos_y wm_active_dotb_number wm_active_dotb_pos_x wm_active_dotb_pos_y wm_active_dotc_number wm_active_dotc_pos_x wm_active_dotc_pos_y, i(recordid) j(wm_seq)

* Replace faulty id no *

replace recordid = "AREM9019" in 68
sort recordid

****************** By Condition: Load/Delay combinations *************************
	* load=1, delay=0 (4)
	* load=1, delay=3 (7)
	* load=2, delay=0 (4)
	* load=2, delay=3 (7)
	* load=3, delay=0 (4)
	* load=3, delay=3 (7)
***************************************************************************;

* drop faulty versions of variables *

drop wm_avedistlloadnodelay wm_avedistlloaddelay wm_avedistmloadnodelay wm_avedistmloaddelay wm_avedisthloadnodelay wm_avedisthloaddelay wm_avedistmhloadnodelay wm_avedistmhloaddelay

* code for long data *

by recordid: egen wm_avedistlloadnodelay = mean(wm_ave_dist) if wm_load==1 & wm_delay==0

by recordid: egen wm_avedistlloaddelay = mean(wm_ave_dist) if wm_load==1 & wm_delay==3

by recordid: egen wm_avedistmloadnodelay = mean(wm_ave_dist) if wm_load==2 & wm_delay==0

by recordid: egen wm_avedistmloaddelay = mean(wm_ave_dist) if wm_load==2 & wm_delay==3

by recordid: egen wm_avedisthloadnodelay = mean(wm_ave_dist) if wm_load==3 & wm_delay==0

by recordid: egen wm_avedisthloaddelay = mean(wm_ave_dist) if wm_load==3 & wm_delay==3

by recordid: egen  wm_avedistmhloadnodelay = mean(wm_ave_dist) if wm_load==2/3 & wm_delay==0

by recordid: egen  wm_avedistmhloaddelay = mean(wm_ave_dist) if wm_load==2/3 & wm_delay==3

** Diff scores *

gen wm_avedistdiffllndhld = wm_avedistlloadnodelay - wm_avedisthloaddelay
kdensity wm_avedistdiffllndhld

************ By Load Condition: Load=1, Load=2, Load=3 *******************

by recordid: egen wm_avedistlowload = mean(wm_ave_dist) if wm_load==1

by recordid: egen wm_avedistmedload = mean(wm_ave_dist) if wm_load==2

by recordid: egen wm_avedisthighload = mean(wm_ave_dist) if wm_load==3

************ By Delay: Delay=0 and Delay=3 ******************

by recordid: egen wm_avedistnodelay = mean(wm_ave_dist) if wm_delay==0

by recordid: egen wm_avedistdelay = mean(wm_ave_dist) if wm_delay==3

* Diff scores *

gen wm_avedistdiffndd = wm_avedistnodelay - wm_avedistdelay
kdensity wm_avedistdiffndd

* code for wide data - failing *

by recordid: egen wm_avedistlloadnodelay = mean(wm_ave_dist1 wm_ave_dist2 wm_ave_dist3 wm_ave_dist4 wm_ave_dist5 wm_ave_dist6 wm_ave_dist7 wm_ave_dist8 wm_ave_dist9 wm_ave_dist10 wm_ave_dist11 wm_ave_dist12 wm_ave_dist13 wm_ave_dist14 wm_ave_dist15 wm_ave_dist16 wm_ave_dist17 wm_ave_dist18 wm_ave_dist19 wm_ave_dist20 wm_ave_dist21 wm_ave_dist22 wm_ave_dist23 wm_ave_dist24 wm_ave_dist25 wm_ave_dist26 wm_ave_dist27 wm_ave_dist28 wm_ave_dist29 wm_ave_dist30 wm_ave_dist31 wm_ave_dist32 wm_ave_dist33) if wm_load1/wmload33==1 & wm_delay1/wm_delay33==0

egen wm_avedistlloaddelay = rowmean(wm_ave_dist1 wm_ave_dist2 wm_ave_dist3 wm_ave_dist4 wm_ave_dist5 wm_ave_dist6 wm_ave_dist7 wm_ave_dist8 wm_ave_dist9 wm_ave_dist10 wm_ave_dist11 wm_ave_dist12 wm_ave_dist13 wm_ave_dist14 wm_ave_dist15 wm_ave_dist16 wm_ave_dist17 wm_ave_dist18 wm_ave_dist19 wm_ave_dist20 wm_ave_dist21 wm_ave_dist22 wm_ave_dist23 wm_ave_dist24 wm_ave_dist25 wm_ave_dist26 wm_ave_dist27 wm_ave_dist28 wm_ave_dist29 wm_ave_dist30 wm_ave_dist31 wm_ave_dist32 wm_ave_dist33) if wm_load1/wm_load33==1 & wm_delay1/wm_delay33==3

egen wm_avedistmloadnodelay = rowmean(wm_ave_dist1 wm_ave_dist2 wm_ave_dist3 wm_ave_dist4 wm_ave_dist5 wm_ave_dist6 wm_ave_dist7 wm_ave_dist8 wm_ave_dist9 wm_ave_dist10 wm_ave_dist11 wm_ave_dist12 wm_ave_dist13 wm_ave_dist14 wm_ave_dist15 wm_ave_dist16 wm_ave_dist17 wm_ave_dist18 wm_ave_dist19 wm_ave_dist20 wm_ave_dist21 wm_ave_dist22 wm_ave_dist23 wm_ave_dist24 wm_ave_dist25 wm_ave_dist26 wm_ave_dist27 wm_ave_dist28 wm_ave_dist29 wm_ave_dist30 wm_ave_dist31 wm_ave_dist32 wm_ave_dist33) if wm_load1/wm_load33==2 & wm_delay1/wm_delay33==0

egen wm_avedistmloaddelay = rowmean(wm_ave_dist1 wm_ave_dist2 wm_ave_dist3 wm_ave_dist4 wm_ave_dist5 wm_ave_dist6 wm_ave_dist7 wm_ave_dist8 wm_ave_dist9 wm_ave_dist10 wm_ave_dist11 wm_ave_dist12 wm_ave_dist13 wm_ave_dist14 wm_ave_dist15 wm_ave_dist16 wm_ave_dist17 wm_ave_dist18 wm_ave_dist19 wm_ave_dist20 wm_ave_dist21 wm_ave_dist22 wm_ave_dist23 wm_ave_dist24 wm_ave_dist25 wm_ave_dist26 wm_ave_dist27 wm_ave_dist28 wm_ave_dist29 wm_ave_dist30 wm_ave_dist31 wm_ave_dist32 wm_ave_dist33) if wm_load1/wm_load33==2 & wm_delay1/wm_delay33==3

egen wm_avedisthloadnodelay = rowmean(wm_ave_dist1 wm_ave_dist2 wm_ave_dist3 wm_ave_dist4 wm_ave_dist5 wm_ave_dist6 wm_ave_dist7 wm_ave_dist8 wm_ave_dist9 wm_ave_dist10 wm_ave_dist11 wm_ave_dist12 wm_ave_dist13 wm_ave_dist14 wm_ave_dist15 wm_ave_dist16 wm_ave_dist17 wm_ave_dist18 wm_ave_dist19 wm_ave_dist20 wm_ave_dist21 wm_ave_dist22 wm_ave_dist23 wm_ave_dist24 wm_ave_dist25 wm_ave_dist26 wm_ave_dist27 wm_ave_dist28 wm_ave_dist29 wm_ave_dist30 wm_ave_dist31 wm_ave_dist32 wm_ave_dist33) if wm_load1/wm_load33==3 & wm_delay1/wm_delay33==0

egen wm_avedisthloaddelay = rowmean(wm_ave_dist1 wm_ave_dist2 wm_ave_dist3 wm_ave_dist4 wm_ave_dist5 wm_ave_dist6 wm_ave_dist7 wm_ave_dist8 wm_ave_dist9 wm_ave_dist10 wm_ave_dist11 wm_ave_dist12 wm_ave_dist13 wm_ave_dist14 wm_ave_dist15 wm_ave_dist16 wm_ave_dist17 wm_ave_dist18 wm_ave_dist19 wm_ave_dist20 wm_ave_dist21 wm_ave_dist22 wm_ave_dist23 wm_ave_dist24 wm_ave_dist25 wm_ave_dist26 wm_ave_dist27 wm_ave_dist28 wm_ave_dist29 wm_ave_dist30 wm_ave_dist31 wm_ave_dist32 wm_ave_dist33) if wm_load1/wm_load33==3 & wm_delay1/wm_delay33==3

egen wm_avedistmhloadnodelay = rowmean(wm_ave_dist1 wm_ave_dist2 wm_ave_dist3 wm_ave_dist4 wm_ave_dist5 wm_ave_dist6 wm_ave_dist7 wm_ave_dist8 wm_ave_dist9 wm_ave_dist10 wm_ave_dist11 wm_ave_dist12 wm_ave_dist13 wm_ave_dist14 wm_ave_dist15 wm_ave_dist16 wm_ave_dist17 wm_ave_dist18 wm_ave_dist19 wm_ave_dist20 wm_ave_dist21 wm_ave_dist22 wm_ave_dist23 wm_ave_dist24 wm_ave_dist25 wm_ave_dist26 wm_ave_dist27 wm_ave_dist28 wm_ave_dist29 wm_ave_dist30 wm_ave_dist31 wm_ave_dist32 wm_ave_dist33) if wm_load1/wm_load33==2/3 & wm_delay1/wm_delay33==0

egen wm_avedistmhloaddelay = rowmean(wm_ave_dist1 wm_ave_dist2 wm_ave_dist3 wm_ave_dist4 wm_ave_dist5 wm_ave_dist6 wm_ave_dist7 wm_ave_dist8 wm_ave_dist9 wm_ave_dist10 wm_ave_dist11 wm_ave_dist12 wm_ave_dist13 wm_ave_dist14 wm_ave_dist15 wm_ave_dist16 wm_ave_dist17 wm_ave_dist18 wm_ave_dist19 wm_ave_dist20 wm_ave_dist21 wm_ave_dist22 wm_ave_dist23 wm_ave_dist24 wm_ave_dist25 wm_ave_dist26 wm_ave_dist27 wm_ave_dist28 wm_ave_dist29 wm_ave_dist30 wm_ave_dist31 wm_ave_dist32 wm_ave_dist33) if wm_load1/wm_load33==2/3 & wm_delay1/wm_delay33==3

************ By Load Condition: Load=1, Load=2, Load=3 *******************

egen wm_avedistlowload = rowmean(wm_ave_dist1 wm_ave_dist2 wm_ave_dist3 wm_ave_dist4 wm_ave_dist5 wm_ave_dist6 wm_ave_dist7 wm_ave_dist8 wm_ave_dist9 wm_ave_dist10 wm_ave_dist11 wm_ave_dist12 wm_ave_dist13 wm_ave_dist14 wm_ave_dist15 wm_ave_dist16 wm_ave_dist17 wm_ave_dist18 wm_ave_dist19 wm_ave_dist20 wm_ave_dist21 wm_ave_dist22 wm_ave_dist23 wm_ave_dist24 wm_ave_dist25 wm_ave_dist26 wm_ave_dist27 wm_ave_dist28 wm_ave_dist29 wm_ave_dist30 wm_ave_dist31 wm_ave_dist32 wm_ave_dist33) if wm_load1-wm_load33==1

egen wm_avedistmedload = rowmean(wm_ave_dist1 wm_ave_dist2 wm_ave_dist3 wm_ave_dist4 wm_ave_dist5 wm_ave_dist6 wm_ave_dist7 wm_ave_dist8 wm_ave_dist9 wm_ave_dist10 wm_ave_dist11 wm_ave_dist12 wm_ave_dist13 wm_ave_dist14 wm_ave_dist15 wm_ave_dist16 wm_ave_dist17 wm_ave_dist18 wm_ave_dist19 wm_ave_dist20 wm_ave_dist21 wm_ave_dist22 wm_ave_dist23 wm_ave_dist24 wm_ave_dist25 wm_ave_dist26 wm_ave_dist27 wm_ave_dist28 wm_ave_dist29 wm_ave_dist30 wm_ave_dist31 wm_ave_dist32 wm_ave_dist33) if wm_load1-wm_load33==2

egen wm_avedisthighload = rowmean(wm_ave_dist1 wm_ave_dist2 wm_ave_dist3 wm_ave_dist4 wm_ave_dist5 wm_ave_dist6 wm_ave_dist7 wm_ave_dist8 wm_ave_dist9 wm_ave_dist10 wm_ave_dist11 wm_ave_dist12 wm_ave_dist13 wm_ave_dist14 wm_ave_dist15 wm_ave_dist16 wm_ave_dist17 wm_ave_dist18 wm_ave_dist19 wm_ave_dist20 wm_ave_dist21 wm_ave_dist22 wm_ave_dist23 wm_ave_dist24 wm_ave_dist25 wm_ave_dist26 wm_ave_dist27 wm_ave_dist28 wm_ave_dist29 wm_ave_dist30 wm_ave_dist31 wm_ave_dist32 wm_ave_dist33) if wm_load1-wm_load33==3

************ By Delay: Delay=0 and Delay=3 ******************

egen wm_avedistnodelay = rowmean(wm_ave_dist1 wm_ave_dist2 wm_ave_dist3 wm_ave_dist4 wm_ave_dist5 wm_ave_dist6 wm_ave_dist7 wm_ave_dist8 wm_ave_dist9 wm_ave_dist10 wm_ave_dist11 wm_ave_dist12 wm_ave_dist13 wm_ave_dist14 wm_ave_dist15 wm_ave_dist16 wm_ave_dist17 wm_ave_dist18 wm_ave_dist19 wm_ave_dist20 wm_ave_dist21 wm_ave_dist22 wm_ave_dist23 wm_ave_dist24 wm_ave_dist25 wm_ave_dist26 wm_ave_dist27 wm_ave_dist28 wm_ave_dist29 wm_ave_dist30 wm_ave_dist31 wm_ave_dist32 wm_ave_dist33) if wm_delay1-wm_delay33==0

egen wm_avedistdelay = rowmean(wm_ave_dist1 wm_ave_dist2 wm_ave_dist3 wm_ave_dist4 wm_ave_dist5 wm_ave_dist6 wm_ave_dist7 wm_ave_dist8 wm_ave_dist9 wm_ave_dist10 wm_ave_dist11 wm_ave_dist12 wm_ave_dist13 wm_ave_dist14 wm_ave_dist15 wm_ave_dist16 wm_ave_dist17 wm_ave_dist18 wm_ave_dist19 wm_ave_dist20 wm_ave_dist21 wm_ave_dist22 wm_ave_dist23 wm_ave_dist24 wm_ave_dist25 wm_ave_dist26 wm_ave_dist27 wm_ave_dist28 wm_ave_dist29 wm_ave_dist30 wm_ave_dist31 wm_ave_dist32 wm_ave_dist33) if wm_delay1-wm_delay33==3

* Row total missing targets *

egen wm_missed_total = rowtotal(wm_missed_targets*)
count if wm_missed_total > 
hist wm_missed_total, freq discrete
kdensity wm_missed_total

* Row total average distance from target * 

egen wm_total_ave_dist = rowtotal(wm_ave_dist*)
hist wm_total_ave_dist, freq
kdensity wm_total_ave_dist

* Log transformed total average distance from target *

gen log_wm_total_ave_dist = log(wm_total_ave_dist)
hist log_wm_total_ave_dist, freq
kdensity log_wm_total_ave_dist

*****************
*  IC data *
******************

* Import data *

import excel "F:\My Documents\My ACADEMICS\DPHIL documents\DPHIL PSYCHIATRY\AHEAD Study\Data\Baseline\RACER\Combined spreadsheets\collated_INHIBITION_base_nosum_trim.xlsx", sheet("Sheet2") cellrange(A1:CV4959) firstrow

recode responded_binary (.=0)
 
* Get rid of practice trials *

drop if record_type_no==0 

* Generate correct distt_calculated *

gen distt_calculated = sqrt((((first_touch_pos_x - activetargetpos_x)^2) + ((first_touch_pos_y - active_dot_pos_y)^2)))

* Keep relevant variables only *

keep distt_calculated condition correct_outcome first_touch_pos_x activetargetpos_x first_touch_pos_y active_dot_pos_y first_touch_ctrdistl first_touch_ctrdistr first_touch_ctrdists first_touch_ctrdistt first_touch_game_seq first_touch_pos_x first_touch_pos_y first_touch_resp_time fullscreen numberpractices numbertutorials record_type record_type_no responded_outcome seq recordid sessiondate sessiondatetime side timedout_outcome Inh_Accuracy responded_binary

* 4 Conditions: samesider samesidel opp_sider opp_sidel *

egen newcond = concat(condition side)

* Reshape long to wide *

reshape wide distt_calculated condition correct_outcome first_touch_pos_x activetargetpos_x first_touch_pos_y active_dot_pos_y first_touch_ctrdistl first_touch_ctrdistr first_touch_ctrdists first_touch_ctrdistt first_touch_game_seq  first_touch_resp_time fullscreen numberpractices numbertutorials record_type record_type_no responded_outcome sessiondate sessiondatetime side timedout_outcome Inh_Accuracy responded_binary newcond, i(recordid) j(seq)

* Rename faulty ID *

replace recordid = "AREM9019" in 67
sort recordid

* Mean correct RTs *

egen meancongrt = rowmean(first_touch_resp_time1 first_touch_resp_time2 first_touch_resp_time3 first_touch_resp_time8 first_touch_resp_time10 first_touch_resp_time11 first_touch_resp_time12 first_touch_resp_time13 first_touch_resp_time15 first_touch_resp_time17 first_touch_resp_time18 first_touch_resp_time22 first_touch_resp_time23 first_touch_resp_time26 first_touch_resp_time27 first_touch_resp_time29 first_touch_resp_time34 first_touch_resp_time35 first_touch_resp_time38 first_touch_resp_time41 first_touch_resp_time42 first_touch_resp_time44 first_touch_resp_time45 first_touch_resp_time47 first_touch_resp_time50 first_touch_resp_time51 first_touch_resp_time52 first_touch_resp_time55 first_touch_resp_time58 first_touch_resp_time59)
kdensity meancongrt

egen meanincongrt = rowmean(first_touch_resp_time4 first_touch_resp_time5 first_touch_resp_time6 first_touch_resp_time7 first_touch_resp_time9 first_touch_resp_time14 first_touch_resp_time16 first_touch_resp_time19 first_touch_resp_time20 first_touch_resp_time21 first_touch_resp_time24 first_touch_resp_time25 first_touch_resp_time28 first_touch_resp_time30 first_touch_resp_time31 first_touch_resp_time32 first_touch_resp_time33 first_touch_resp_time36 first_touch_resp_time37 first_touch_resp_time39 first_touch_resp_time40 first_touch_resp_time43 first_touch_resp_time46 first_touch_resp_time48 first_touch_resp_time49 first_touch_resp_time53 first_touch_resp_time54 first_touch_resp_time56 first_touch_resp_time57 first_touch_resp_time60)
kdensity meanincongrt

twoway (kdensity meancongrt) (kdensity meanincongrt)

gen meaninhdiffrt = meancongrt - meanincongrt
kdensity meaninhdiffrt




*****************
* AHEAD RACER endline
* K Rowe
* 26.02.2019
*****************

*****************
*  WM data *
******************

* Import data *

import excel "F:\My Documents\My ACADEMICS\DPHIL documents\DPHIL PSYCHIATRY\AHEAD Study\Data\Endline\RACER endline\AHEAD_RACER_WM_end_trim.xlsx", sheet("Sheet2") cellrange(A1:EK3079) firstrow

* Get rid of practice trials *

drop if endwm_record_type_no==0

* Rename long variables *

rename endwm_first_touch_ctrdist_neares endwm_firsttouchctrdistnearest
rename endwm_second_touch_ctrdist_neare endwm_sectouchctrdistnearest
rename endwm_third_touch_ctrdist_neares endwm_thirdtouchctrdistnearest
rename endwm_first_touch_touched_stimnu endwm_firsttouchtouchedstimnum
rename endwm_second_touch_touched_stimn endwm_sectouchtouchedstimnum
rename endwm_third_touch_touched_stimnu endwm_thirdtouchtouchedstimnum
rename endwm_first_touch_nearest_stimnu endwm_firsttouchneareststimnum 
rename endwm_second_touch_nearest_stimn endwm_sectouchneareststimnum
rename endwm_third_touch_nearest_stimnu endwm_thirdtouchneareststimnum

* Keep relevant variables only *

keep recordid endwm_missed_targets endwm_sessiondate endwm_sessiondatetime endwm_numbertutorials endwm_numberpractices endwm_seq endwm_load endwm_encoding endwm_delay endwm_probe endwm_iti endwm_dotloc1 endwm_dotloc2 endwm_dotloc3 endwm_record_type endwm_record_type_no endwm_timedout_outcome endwm_first_touch_resp_time endwm_second_touch_resp_time endwm_third_touch_resp_time endwm_first_touch_pos_x endwm_first_touch_pos_y endwm_second_touch_pos_x endwm_second_touch_pos_y endwm_third_touch_pos_x endwm_third_touch_pos_y endwm_firsttouchctrdistnearest endwm_first_touch_ctrdist_dota endwm_first_touch_ctrdist_dotb endwm_first_touch_ctrdist_dotc endwm_sectouchctrdistnearest endwm_second_touch_ctrdist_dota endwm_second_touch_ctrdist_dotb endwm_second_touch_ctrdist_dotc endwm_thirdtouchctrdistnearest endwm_third_touch_ctrdist_dota endwm_third_touch_ctrdist_dotb endwm_third_touch_ctrdist_dotc endwm_first_touch_touched_stim endwm_firsttouchtouchedstimnum endwm_second_touch_touched_stim endwm_sectouchtouchedstimnum endwm_third_touch_touched_stim endwm_thirdtouchtouchedstimnum endwm_first_touch_nearest_stim endwm_firsttouchneareststimnum endwm_second_touch_nearest_stim endwm_sectouchneareststimnum endwm_third_touch_nearest_stim endwm_thirdtouchneareststimnum endwm_probe_touch_count endwm_active_dota_number endwm_active_dota_pos_x endwm_active_dota_pos_y endwm_active_dotb_number endwm_active_dotb_pos_x endwm_active_dotb_pos_y endwm_active_dotc_number endwm_active_dotc_pos_x endwm_active_dotc_pos_y

* Create error flag for trials with distance label error (e.g AAB or ACA etc) *

gen enderror_flag=0
replace enderror_flag=1 if endwm_load==2 & (endwm_first_touch_nearest_stim==endwm_second_touch_nearest_stim) & (endwm_first_touch_nearest_stim !=. & endwm_second_touch_nearest_stim !=.)
replace enderror_flag=1 if endwm_load==3 & ((endwm_first_touch_nearest_stim==endwm_second_touch_nearest_stim)| (endwm_third_touch_nearest_stim==endwm_second_touch_nearest_stim)| (endwm_first_touch_nearest_stim==endwm_third_touch_nearest_stim))& (endwm_first_touch_nearest_stim !=. & endwm_second_touch_nearest_stim !=. & endwm_third_touch_nearest_stim !=.)
replace enderror_flag=1 if endwm_load==3 & ((endwm_first_touch_nearest_stim==endwm_second_touch_nearest_stim) & (endwm_first_touch_nearest_stim !=. & endwm_second_touch_nearest_stim !=.))
sum enderror_flag, detail
hist enderror_flag, freq

* Create new distance variables that don't repeat stim *
** First put values into new variables as is for trials w/o error flag;

gen endwm_first_touch_dist_new = endwm_firsttouchctrdistnearest
gen endwm_first_stim_new = endwm_first_touch_nearest_stim if endwm_load==1
gen endwm_second_touch_dist_new = endwm_sectouchctrdistnearest if endwm_load==2 & enderror_flag==0
replace endwm_first_stim_new = endwm_first_touch_nearest_stim if endwm_load==2 & enderror_flag==0
gen endwm_second_stim_new = endwm_second_touch_nearest_stim if endwm_load==2 & enderror_flag==0
replace endwm_second_touch_dist_new = endwm_sectouchctrdistnearest if endwm_load==3 & enderror_flag==0
gen endwm_third_touch_dist_new = endwm_thirdtouchctrdistnearest if endwm_load==3 & enderror_flag==0
replace endwm_first_stim_new = endwm_first_touch_nearest_stim if endwm_load==3 & enderror_flag==0
replace endwm_second_stim_new = endwm_second_touch_nearest_stim if endwm_load==3 & enderror_flag==0
gen endwm_third_stim_new = endwm_third_touch_nearest_stim if endwm_load==3 & enderror_flag==0

* Creating new nearest touch distances - load=2 *
* A A / 1 1 *
replace endwm_second_touch_dist_new = endwm_second_touch_ctrdist_dotb if endwm_load==2 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota)
replace endwm_first_stim_new = 1 if endwm_load==2 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota)
replace endwm_second_stim_new = 2 if endwm_load==2 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota)

* B B / 2 2*
replace endwm_second_touch_dist_new = endwm_second_touch_ctrdist_dota if endwm_load==2 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb)
replace endwm_first_stim_new = 2 if endwm_load==2 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb)
replace endwm_second_stim_new = 1 if endwm_load==2 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb)

* Creating new nearest touch distances - load=3 *
* True nearest touch = A B C / 1 2 3 *

replace endwm_second_touch_dist_new = endwm_second_touch_ctrdist_dotb if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) & (endwm_second_touch_ctrdist_dotb < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_third_touch_dist_new = endwm_third_touch_ctrdist_dotc if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) & (endwm_second_touch_ctrdist_dotb < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_first_stim_new = 1 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) & (endwm_second_touch_ctrdist_dotb < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_second_stim_new = 2 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) & (endwm_second_touch_ctrdist_dotb < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=. 
replace endwm_third_stim_new = 3 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) & (endwm_second_touch_ctrdist_dotb < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.

*True nearest touch = A B C / 1 2 3 BUT 3rd response missing *

replace endwm_second_touch_dist_new = endwm_second_touch_ctrdist_dotb if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) & (endwm_second_touch_ctrdist_dotb < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==.
replace endwm_third_touch_dist_new = endwm_third_touch_ctrdist_dotc if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) & (endwm_second_touch_ctrdist_dotb < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==.
replace endwm_first_stim_new = 1 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) & (endwm_second_touch_ctrdist_dotb < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==.
replace endwm_second_stim_new = 2 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) & (endwm_second_touch_ctrdist_dotb < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==. 

* True nearest touch = A C B / 1 3 2 *

replace endwm_second_touch_dist_new = endwm_second_touch_ctrdist_dotc if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) &(endwm_second_touch_ctrdist_dotb > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_third_touch_dist_new = endwm_third_touch_ctrdist_dotb if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) &(endwm_second_touch_ctrdist_dotb > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_first_stim_new = 1 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) &(endwm_second_touch_ctrdist_dotb > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_second_stim_new = 3 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) &(endwm_second_touch_ctrdist_dotb > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_third_stim_new = 2 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) &(endwm_second_touch_ctrdist_dotb > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.

* True nearest touch = A C B / 1 3 2 BUT 3rd response missing *

replace endwm_second_touch_dist_new = endwm_second_touch_ctrdist_dotc if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) & (endwm_second_touch_ctrdist_dotb > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==.
replace endwm_third_touch_dist_new = endwm_third_touch_ctrdist_dotb if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) & (endwm_second_touch_ctrdist_dotb > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==.
replace endwm_first_stim_new = 1 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) & (endwm_second_touch_ctrdist_dotb > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==.
replace endwm_second_stim_new = 3 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dota) & (endwm_second_touch_ctrdist_dotb > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==.

* True nearest touch = B A C / 2 1 3 *

replace endwm_second_touch_dist_new = endwm_second_touch_ctrdist_dota if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_third_touch_dist_new = endwm_third_touch_ctrdist_dotc if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_first_stim_new = 2 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_second_stim_new = 1 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_third_stim_new = 3 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
			
* True nearest touch = B A C / 2 1 3 BUT 3rd response missing *

replace endwm_second_touch_dist_new = endwm_second_touch_ctrdist_dota if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==.
replace endwm_third_touch_dist_new = endwm_third_touch_ctrdist_dotc if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==.
replace endwm_first_stim_new = 2 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==.
replace endwm_second_stim_new = 1 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==.

* True nearest touch = B C A / 2 3 1 *

replace endwm_second_touch_dist_new = endwm_second_touch_ctrdist_dotc if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_third_touch_dist_new = endwm_third_touch_ctrdist_dota if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_first_stim_new = 2 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_second_stim_new = 3 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_third_stim_new = 1 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc!=.

* True nearest touch = B C A -- BUT 3rd response missing;

replace endwm_second_touch_dist_new = endwm_second_touch_ctrdist_dotc if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==.
replace endwm_third_touch_dist_new = endwm_third_touch_ctrdist_dota if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==.
replace endwm_first_stim_new = 2 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==.
replace endwm_second_stim_new = 3 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotb) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotc) & endwm_third_touch_ctrdist_dotc==.

* True nearest touch = C A B / 3 1 2 *

replace endwm_second_touch_dist_new = endwm_second_touch_ctrdist_dota if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) & (endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_third_touch_dist_new = endwm_third_touch_ctrdist_dotb if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) & (endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_first_stim_new = 3 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) & (endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_second_stim_new = 1 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) & (endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_third_stim_new = 2 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) & (endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc!=.

* True nearest touch = C A B / 3 1 2 -- BUT 3rd response missing *

replace endwm_second_touch_dist_new = endwm_second_touch_ctrdist_dota if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) &(endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc==.
replace endwm_third_touch_dist_new = endwm_third_touch_ctrdist_dotb if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) &(endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc==.
replace endwm_first_stim_new = 3 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) &(endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc==.
replace endwm_second_stim_new = 1 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) &(endwm_second_touch_ctrdist_dota < endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc==.

* True nearest touch = C B A / 3 2 1 *

replace endwm_second_touch_dist_new = endwm_second_touch_ctrdist_dotb if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_third_touch_dist_new = endwm_third_touch_ctrdist_dota if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_first_stim_new = 3 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_second_stim_new = 2 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc!=.
replace endwm_third_stim_new = 1 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc!=.

* True nearest touch = C B A / 3 2 1 -- BUT 3rd response missing *

replace endwm_second_touch_dist_new = endwm_second_touch_ctrdist_dotb if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc==.
replace endwm_third_touch_dist_new = endwm_third_touch_ctrdist_dota if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc==.
replace endwm_first_stim_new = 3 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc==.
replace endwm_second_stim_new = 2 if endwm_load==3 & enderror_flag==1 & (endwm_firsttouchctrdistnearest==endwm_first_touch_ctrdist_dotc) & (endwm_second_touch_ctrdist_dota > endwm_second_touch_ctrdist_dotb) & endwm_third_touch_ctrdist_dotc==.

* Calculate average distance across trials *

*load=1;

gen endwm_ave_dist=. 
replace endwm_ave_dist = endwm_first_touch_dist_new if endwm_load==1

*load = 2 and no missing values;

replace endwm_ave_dist = (endwm_first_touch_dist_new + endwm_second_touch_dist_new)/2 if endwm_load==2 & endwm_first_touch_dist_new!=. & endwm_second_touch_dist_new!=.

*load = 2 but second touch is missing;

replace endwm_ave_dist = endwm_first_touch_dist_new if endwm_load==2 & endwm_first_touch_dist_new!=. & endwm_second_touch_dist_new==. 

*load = 2 but all are missing;

replace endwm_ave_dist = . if endwm_load==2 & endwm_first_touch_dist_new==. & endwm_second_touch_dist_new==. 

*load = 3 and no missing values;

replace endwm_ave_dist = (endwm_first_touch_dist_new + endwm_second_touch_dist_new + endwm_third_touch_dist_new)/3 if endwm_load==3 & endwm_first_touch_dist_new!=. & endwm_second_touch_dist_new!=. & endwm_third_touch_dist_new!=. 

*load = 3 and second & third touches missing;

replace endwm_ave_dist = endwm_first_touch_dist_new if endwm_load==3 & endwm_first_touch_dist_new!=. & endwm_second_touch_dist_new==. & endwm_third_touch_dist_new==. 

*load = 3 and only third touch missing;

replace endwm_ave_dist = (endwm_first_touch_dist_new + endwm_second_touch_dist_new)/2 if endwm_load==3 & endwm_first_touch_dist_new!=. & endwm_second_touch_dist_new!=. & endwm_third_touch_dist_new==. 

*load = 3 and all are missing;

replace endwm_ave_dist = . if endwm_load==3 & endwm_first_touch_dist_new==. & endwm_second_touch_dist_new==. & endwm_third_touch_dist_new==. 

* Distribution *

kdensity endwm_ave_dist

* Log transform distance *

gen endlog_wm_ave_dist = log(endwm_ave_dist)

kdensity endlog_wm_ave_dist

* Calculate number of missed targets (ie. Timed Out) *

*load = 1

replace endwm_missed_targets = 1 if endwm_load==1 & endwm_first_touch_resp_time==.

*load=2;

replace endwm_missed_targets = 2 if endwm_load==2 & endwm_first_touch_resp_time==. & endwm_second_touch_resp_time==. 
replace endwm_missed_targets = 1 if endwm_load==2 & endwm_first_touch_resp_time!=. & endwm_second_touch_resp_time==. 
replace endwm_missed_targets = 0 if endwm_load==2 & endwm_first_touch_resp_time!=. & endwm_second_touch_resp_time!=. 

*load=3;

replace endwm_missed_targets = 3 if endwm_load==3 & endwm_first_touch_resp_time==. & endwm_second_touch_resp_time==. & endwm_third_touch_resp_time==.
replace endwm_missed_targets = 2 if endwm_load==3 & endwm_first_touch_resp_time!=. & endwm_second_touch_resp_time==. & endwm_third_touch_resp_time==. 
replace endwm_missed_targets = 1 if endwm_load==3 & endwm_first_touch_resp_time!=. & endwm_second_touch_resp_time!=. & endwm_third_touch_resp_time==. 
replace endwm_missed_targets = 0 if endwm_load==3 & endwm_first_touch_resp_time!=. & endwm_second_touch_resp_time!=. & endwm_third_touch_resp_time!=.

* Frequency distribution *

kdensity endwm_missed_targets
hist endwm_missed_targets, freq

* Binary missed 1, not missed 0 *

gen endwm_missed_binary = .
replace endwm_missed_binary = 0 if endwm_missed_targets==0
replace endwm_missed_binary = 1 if endwm_missed_targets>0
hist endwm_missed_binary, freq

* Shorten long variable names so wide format variables names don't exceed 32 characters length *

rename endwm_second_touch_ctrdist_dota endwm_secondtouchctrdistdota 
rename endwm_second_touch_ctrdist_dotb endwm_secondtouchctrdistdotb
rename endwm_second_touch_ctrdist_dotc endwm_secondtouchctrdistdotc
rename endwm_second_touch_touched_stim endwm_secondtouchtouchedstim
rename endwm_second_touch_nearest_stim endwm_secondtouchneareststim

* Convert from long to wide format (using these 3 new variable names) - FAILED WITH CONDITION VARIABLES SO DROP & WILL NEED TO CREATE IN WIDE FORMAT *

drop endwm_avedistlloadnodelay endwm_avedistlloaddelay endwm_avedistmloadnodelay endwm_avedistmloaddelay endwm_avedisthloadnodelay endwm_avedisthloaddelay endwm_avedistmhloadnodelay endwm_avedistmhloaddelay endwm_avedistlowload endwm_avedistmedload endwm_avedisthighload endwm_avedistnodelay endwm_avedistdelay

reshape wide endwm_missed_binary endwm_missed_targets endlog_wm_ave_dist endwm_ave_dist enderror_flag endwm_first_touch_dist_new endwm_first_stim_new endwm_second_touch_dist_new endwm_second_stim_new endwm_third_touch_dist_new endwm_third_stim_new endwm_sessiondate endwm_sessiondatetime endwm_numbertutorials endwm_numberpractices endwm_load endwm_encoding endwm_delay endwm_probe endwm_iti endwm_dotloc1 endwm_dotloc2 endwm_dotloc3 endwm_record_type endwm_record_type_no endwm_timedout_outcome endwm_first_touch_resp_time endwm_second_touch_resp_time endwm_third_touch_resp_time endwm_first_touch_pos_x endwm_first_touch_pos_y endwm_second_touch_pos_x endwm_second_touch_pos_y endwm_third_touch_pos_x endwm_third_touch_pos_y endwm_firsttouchctrdistnearest endwm_first_touch_ctrdist_dota endwm_first_touch_ctrdist_dotb endwm_first_touch_ctrdist_dotc endwm_sectouchctrdistnearest endwm_secondtouchctrdistdota endwm_secondtouchctrdistdotb endwm_secondtouchctrdistdotc endwm_thirdtouchctrdistnearest endwm_third_touch_ctrdist_dota endwm_third_touch_ctrdist_dotb endwm_third_touch_ctrdist_dotc endwm_first_touch_touched_stim endwm_firsttouchtouchedstimnum endwm_secondtouchtouchedstim endwm_sectouchtouchedstimnum endwm_third_touch_touched_stim endwm_thirdtouchtouchedstimnum endwm_first_touch_nearest_stim endwm_firsttouchneareststimnum endwm_secondtouchneareststim endwm_sectouchneareststimnum endwm_third_touch_nearest_stim endwm_thirdtouchneareststimnum endwm_probe_touch_count endwm_active_dota_number endwm_active_dota_pos_x endwm_active_dota_pos_y endwm_active_dotb_number endwm_active_dotb_pos_x endwm_active_dotb_pos_y endwm_active_dotc_number endwm_active_dotc_pos_x endwm_active_dotc_pos_y, i(recordid) j(endwm_seq)

****************** Ave dist by condition: Load/Delay combinations *************************
	* load=1, delay=0 (4)
	* load=1, delay=3 (7)
	* load=2, delay=0 (4)
	* load=2, delay=3 (7)
	* load=3, delay=0 (4)
	* load=3, delay=3 (7)
***************************************************************************;

* Drop faulty versions *

drop endwm_avedistlloadnodelay endwm_avedistlloaddelay endwm_avedistmloadnodelay endwm_avedistmloaddelay endwm_avedisthloadnodelay endwm_avedisthloaddelay endwm_avedistmhloadnodelay endwm_avedistmhloaddelay endwm_avedistlowload endwm_avedistmedload endwm_avedisthighload endwm_avedistnodelay endwm_avedistdelay

* Wide version of data *
 
by recordid: egen endwm_avedistlloadnodelay = mean(endwm_ave_dist1 endwm_ave_dist2 endwm_ave_dist3 endwm_ave_dist4 endwm_ave_dist5 endwm_ave_dist6 endwm_ave_dist7 endwm_ave_dist8 endwm_ave_dist9 endwm_ave_dist10 endwm_ave_dist11 endwm_ave_dist12 endwm_ave_dist13 endwm_ave_dist14 endwm_ave_dist15 endwm_ave_dist16 endwm_ave_dist17 endwm_ave_dist18 endwm_ave_dist19 endwm_ave_dist20 endwm_ave_dist21 endwm_ave_dist22 endwm_ave_dist23 endwm_ave_dist24 endwm_ave_dist25 endwm_ave_dist26 endwm_ave_dist27 endwm_ave_dist28 endwm_ave_dist29 endwm_ave_dist30 endwm_ave_dist31 endwm_ave_dist32 endwm_ave_dist33) if endwm_load*==1 & endwm_delay1*==0

egen endwm_avedistlloaddelay = rowmean(endwm_ave_dist1 endwm_ave_dist2 endwm_ave_dist3 endwm_ave_dist4 endwm_ave_dist5 endwm_ave_dist6 endwm_ave_dist7 endwm_ave_dist8 endwm_ave_dist9 endwm_ave_dist10 endwm_ave_dist11 endwm_ave_dist12 endwm_ave_dist13 endwm_ave_dist14 endwm_ave_dist15 endwm_ave_dist16 endwm_ave_dist17 endwm_ave_dist18 endwm_ave_dist19 endwm_ave_dist20 endwm_ave_dist21 endwm_ave_dist22 endwm_ave_dist23 endwm_ave_dist24 endwm_ave_dist25 endwm_ave_dist26 endwm_ave_dist27 endwm_ave_dist28 endwm_ave_dist29 endwm_ave_dist30 endwm_ave_dist31 endwm_ave_dist32 endwm_ave_dist33) if endwm_load1/endwm_load33==1 & endwm_delay1/endwm_delay33==3

egen endwm_avedistmloadnodelay = rowmean(endwm_ave_dist1 endwm_ave_dist2 endwm_ave_dist3 endwm_ave_dist4 endwm_ave_dist5 endwm_ave_dist6 endwm_ave_dist7 endwm_ave_dist8 endwm_ave_dist9 endwm_ave_dist10 endwm_ave_dist11 endwm_ave_dist12 endwm_ave_dist13 endwm_ave_dist14 endwm_ave_dist15 endwm_ave_dist16 endwm_ave_dist17 endwm_ave_dist18 endwm_ave_dist19 endwm_ave_dist20 endwm_ave_dist21 endwm_ave_dist22 endwm_ave_dist23 endwm_ave_dist24 endwm_ave_dist25 endwm_ave_dist26 endwm_ave_dist27 endwm_ave_dist28 endwm_ave_dist29 endwm_ave_dist30 endwm_ave_dist31 endwm_ave_dist32 endwm_ave_dist33) if endwm_load1/endwm_load33==2 & endwm_delay1/endwm_delay33==0

egen endwm_avedistmloaddelay = rowmean(endwm_ave_dist1 endwm_ave_dist2 endwm_ave_dist3 endwm_ave_dist4 endwm_ave_dist5 endwm_ave_dist6 endwm_ave_dist7 endwm_ave_dist8 endwm_ave_dist9 endwm_ave_dist10 endwm_ave_dist11 endwm_ave_dist12 endwm_ave_dist13 endwm_ave_dist14 endwm_ave_dist15 endwm_ave_dist16 endwm_ave_dist17 endwm_ave_dist18 endwm_ave_dist19 endwm_ave_dist20 endwm_ave_dist21 endwm_ave_dist22 endwm_ave_dist23 endwm_ave_dist24 endwm_ave_dist25 endwm_ave_dist26 endwm_ave_dist27 endwm_ave_dist28 endwm_ave_dist29 endwm_ave_dist30 endwm_ave_dist31 endwm_ave_dist32 endwm_ave_dist33) if endwm_load1/endwm_load33==2 & endwm_delay1/endwm_delay33==3

egen endwm_avedisthloadnodelay = rowmean(endwm_ave_dist1 endwm_ave_dist2 endwm_ave_dist3 endwm_ave_dist4 endwm_ave_dist5 endwm_ave_dist6 endwm_ave_dist7 endwm_ave_dist8 endwm_ave_dist9 endwm_ave_dist10 endwm_ave_dist11 endwm_ave_dist12 endwm_ave_dist13 endwm_ave_dist14 endwm_ave_dist15 endwm_ave_dist16 endwm_ave_dist17 endwm_ave_dist18 endwm_ave_dist19 endwm_ave_dist20 endwm_ave_dist21 endwm_ave_dist22 endwm_ave_dist23 endwm_ave_dist24 endwm_ave_dist25 endwm_ave_dist26 endwm_ave_dist27 endwm_ave_dist28 endwm_ave_dist29 endwm_ave_dist30 endwm_ave_dist31 endwm_ave_dist32 endwm_ave_dist33) if endwm_load1/endwm_load33==3 & endwm_delay1/endwm_delay33==0

egen endwm_avedisthloaddelay = rowmean(endwm_ave_dist1 endwm_ave_dist2 endwm_ave_dist3 endwm_ave_dist4 endwm_ave_dist5 endwm_ave_dist6 endwm_ave_dist7 endwm_ave_dist8 endwm_ave_dist9 endwm_ave_dist10 endwm_ave_dist11 endwm_ave_dist12 endwm_ave_dist13 endwm_ave_dist14 endwm_ave_dist15 endwm_ave_dist16 endwm_ave_dist17 endwm_ave_dist18 endwm_ave_dist19 endwm_ave_dist20 endwm_ave_dist21 endwm_ave_dist22 endwm_ave_dist23 endwm_ave_dist24 endwm_ave_dist25 endwm_ave_dist26 endwm_ave_dist27 endwm_ave_dist28 endwm_ave_dist29 endwm_ave_dist30 endwm_ave_dist31 endwm_ave_dist32 endwm_ave_dist33) if endwm_load1/endwm_load33==3 & endwm_delay1/endwm_delay33==3

egen endwm_avedistmhloadnodelay = rowmean(endwm_ave_dist1 endwm_ave_dist2 endwm_ave_dist3 endwm_ave_dist4 endwm_ave_dist5 endwm_ave_dist6 endwm_ave_dist7 endwm_ave_dist8 endwm_ave_dist9 endwm_ave_dist10 endwm_ave_dist11 endwm_ave_dist12 endwm_ave_dist13 endwm_ave_dist14 endwm_ave_dist15 endwm_ave_dist16 endwm_ave_dist17 endwm_ave_dist18 endwm_ave_dist19 endwm_ave_dist20 endwm_ave_dist21 endwm_ave_dist22 endwm_ave_dist23 endwm_ave_dist24 endwm_ave_dist25 endwm_ave_dist26 endwm_ave_dist27 endwm_ave_dist28 endwm_ave_dist29 endwm_ave_dist30 endwm_ave_dist31 endwm_ave_dist32 endwm_ave_dist33) if endwm_load1/endwm_load33==2/3 & endwm_delay1/endwm_delay33==0

egen endwm_avedistmhloaddelay = rowmean(endwm_ave_dist1 endwm_ave_dist2 endwm_ave_dist3 endwm_ave_dist4 endwm_ave_dist5 endwm_ave_dist6 endwm_ave_dist7 endwm_ave_dist8 endwm_ave_dist9 endwm_ave_dist10 endwm_ave_dist11 endwm_ave_dist12 endwm_ave_dist13 endwm_ave_dist14 endwm_ave_dist15 endwm_ave_dist16 endwm_ave_dist17 endwm_ave_dist18 endwm_ave_dist19 endwm_ave_dist20 endwm_ave_dist21 endwm_ave_dist22 endwm_ave_dist23 endwm_ave_dist24 endwm_ave_dist25 endwm_ave_dist26 endwm_ave_dist27 endwm_ave_dist28 endwm_ave_dist29 endwm_ave_dist30 endwm_ave_dist31 endwm_ave_dist32 endwm_ave_dist33) if endwm_load1/endwm_load33==2/3 & endwm_delay1/endwm_delay33==3

tabstat endwm_avedistlloadnodelay endwm_avedistlloaddelay endwm_avedistmloadnodelay endwm_avedistmloaddelay endwm_avedisthloadnodelay endwm_avedisthloaddelay, statistics (mean sd)

tabstat endwm_avedistlloadnodelay endwm_avedistmloadnodelay endwm_avedisthloadnodelay endwm_avedistlloaddelay  endwm_avedistmloaddelay  endwm_avedisthloaddelay

** Diff scores *

gen endwm_avedistdiffllndhld = endwm_avedistlloadnodelay - endwm_avedisthloaddelay
kdensity endwm_avedistdiffllndhld

* Compare baseline & endline *

twoway (kdensity wm_avedistdiffllndhld) (kdensity endwm_avedistdiffllndhld) if racer1basecot==1 & racer1endcot==1


*********** By Load Condition: Load=1, Load=2, Load=3 *******************

egen endwm_avedistlowload = rowmean(endwm_ave_dist1 endwm_ave_dist2 endwm_ave_dist3 endwm_ave_dist4 endwm_ave_dist5 endwm_ave_dist6 endwm_ave_dist7 endwm_ave_dist8 endwm_ave_dist9 endwm_ave_dist10 endwm_ave_dist11 endwm_ave_dist12 endwm_ave_dist13 endwm_ave_dist14 endwm_ave_dist15 endwm_ave_dist16 endwm_ave_dist17 endwm_ave_dist18 endwm_ave_dist19 endwm_ave_dist20 endwm_ave_dist21 endwm_ave_dist22 endwm_ave_dist23 endwm_ave_dist24 endwm_ave_dist25 endwm_ave_dist26 endwm_ave_dist27 endwm_ave_dist28 endwm_ave_dist29 endwm_ave_dist30 endwm_ave_dist31 endwm_ave_dist32 endwm_ave_dist33) if endwm_load1-endwm_load33==1

egen endwm_avedistmedload = rowmean(endwm_ave_dist1 endwm_ave_dist2 endwm_ave_dist3 endwm_ave_dist4 endwm_ave_dist5 endwm_ave_dist6 endwm_ave_dist7 endwm_ave_dist8 endwm_ave_dist9 endwm_ave_dist10 endwm_ave_dist11 endwm_ave_dist12 endwm_ave_dist13 endwm_ave_dist14 endwm_ave_dist15 endwm_ave_dist16 endwm_ave_dist17 endwm_ave_dist18 endwm_ave_dist19 endwm_ave_dist20 endwm_ave_dist21 endwm_ave_dist22 endwm_ave_dist23 endwm_ave_dist24 endwm_ave_dist25 endwm_ave_dist26 endwm_ave_dist27 endwm_ave_dist28 endwm_ave_dist29 endwm_ave_dist30 endwm_ave_dist31 endwm_ave_dist32 endwm_ave_dist33) if endwm_load1-endwm_load33==2

egen endwm_avedisthighload = rowmean(endwm_ave_dist1 endwm_ave_dist2 endwm_ave_dist3 endwm_ave_dist4 endwm_ave_dist5 endwm_ave_dist6 endwm_ave_dist7 endwm_ave_dist8 endwm_ave_dist9 endwm_ave_dist10 endwm_ave_dist11 endwm_ave_dist12 endwm_ave_dist13 endwm_ave_dist14 endwm_ave_dist15 endwm_ave_dist16 endwm_ave_dist17 endwm_ave_dist18 endwm_ave_dist19 endwm_ave_dist20 endwm_ave_dist21 endwm_ave_dist22 endwm_ave_dist23 endwm_ave_dist24 endwm_ave_dist25 endwm_ave_dist26 endwm_ave_dist27 endwm_ave_dist28 endwm_ave_dist29 endwm_ave_dist30 endwm_ave_dist31 endwm_ave_dist32 endwm_ave_dist33) if endwm_load1-endwm_load33==3

tabstat endwm_avedistlowload endwm_avedistmedload endwm_avedisthighload, statistics (mean sd)

************ By Delay: Delay=0 and Delay=3 ******************

egen endwm_avedistnodelay = rowmean(endwm_ave_dist1 endwm_ave_dist2 endwm_ave_dist3 endwm_ave_dist4 endwm_ave_dist5 endwm_ave_dist6 endwm_ave_dist7 endwm_ave_dist8 endwm_ave_dist9 endwm_ave_dist10 endwm_ave_dist11 endwm_ave_dist12 endwm_ave_dist13 endwm_ave_dist14 endwm_ave_dist15 endwm_ave_dist16 endwm_ave_dist17 endwm_ave_dist18 endwm_ave_dist19 endwm_ave_dist20 endwm_ave_dist21 endwm_ave_dist22 endwm_ave_dist23 endwm_ave_dist24 endwm_ave_dist25 endwm_ave_dist26 endwm_ave_dist27 endwm_ave_dist28 endwm_ave_dist29 endwm_ave_dist30 endwm_ave_dist31 endwm_ave_dist32 endwm_ave_dist33) if endwm_delay1-endwm_delay33==0

egen endwm_avedistdelay = rowmean(endwm_ave_dist1 endwm_ave_dist2 endwm_ave_dist3 endwm_ave_dist4 endwm_ave_dist5 endwm_ave_dist6 endwm_ave_dist7 endwm_ave_dist8 endwm_ave_dist9 endwm_ave_dist10 endwm_ave_dist11 endwm_ave_dist12 endwm_ave_dist13 endwm_ave_dist14 endwm_ave_dist15 endwm_ave_dist16 endwm_ave_dist17 endwm_ave_dist18 endwm_ave_dist19 endwm_ave_dist20 endwm_ave_dist21 endwm_ave_dist22 endwm_ave_dist23 endwm_ave_dist24 endwm_ave_dist25 endwm_ave_dist26 endwm_ave_dist27 endwm_ave_dist28 endwm_ave_dist29 endwm_ave_dist30 endwm_ave_dist31 endwm_ave_dist32 endwm_ave_dist33) if endwm_delay1-endwm_delay33==3

tabstat endwm_avedistnodelay endwm_avedistdelay, statistics (mean sd)

* Diff scores *

gen endwm_avedistdiffndd = endwm_avedistnodelay - endwm_avedistdelay
kdensity endwm_avedistdiffndd

* Row total missing targets *

egen endwm_missed_total = rowtotal(endwm_missed_targets*)
count if endwm_missed_total > 
hist endwm_missed_total, freq discrete
kdensity endwm_missed_total

* Row total average distance from target * 

egen endwm_total_ave_dist = rowtotal(endwm_ave_dist*)
hist endwm_total_ave_dist, freq
kdensity endwm_total_ave_dist

* Log transformed total average distance from target *

gen endlog_wm_total_ave_dist = log(endwm_total_ave_dist)
hist endlog_wm_total_ave_dist, freq
kdensity endlog_wm_total_ave_dist

*****************
*  IC data *
******************

* Import data *

import excel "F:\My Documents\My ACADEMICS\DPHIL documents\DPHIL PSYCHIATRY\AHEAD Study\Data\Endline\RACER endline\AHEAD_RACER_INH_end_trim.xlsx", sheet("Sheet2") firstrow

* Get rid of practice trials *

drop if endrecord_type_no==0 

* Generate correct distt_calculated *

gen enddistt_calculated = sqrt((((endfirst_touch_pos_x - endactivetargetpos_x)^2) + ((endfirst_touch_pos_y - endactive_dot_pos_y)^2)))

* Keep relevant variables only *

keep enddistt_calculated endcondition endcorrect_outcome endfirst_touch_pos_x endactivetargetpos_x endfirst_touch_pos_y endactive_dot_pos_y endfirst_touch_ctrdistl endfirst_touch_ctrdistr endfirst_touch_ctrdists endfirst_touch_ctrdistt endfirst_touch_game_seq endfirst_touch_pos_x endfirst_touch_pos_y endfirst_touch_resp_time endfullscreen endnumberpractices endnumbertutorials endrecord_type endrecord_type_no endresponded_outcome endseq recordid endsessiondate endsessiondatetime endside endtimedout_outcome endinh_accuracy endresponded_binary

* 4 Conditions: samesider samesidel opp_sider opp_sidel *

egen endnewcond = concat(endcondition endside)

* Reshape long to wide *

reshape wide enddistt_calculated endcondition endcorrect_outcome endfirst_touch_pos_x endactivetargetpos_x endfirst_touch_pos_y endactive_dot_pos_y endfirst_touch_ctrdistl endfirst_touch_ctrdistr endfirst_touch_ctrdists endfirst_touch_ctrdistt endfirst_touch_game_seq  endfirst_touch_resp_time endfullscreen endnumberpractices endnumbertutorials endrecord_type endrecord_type_no endresponded_outcome endsessiondate endsessiondatetime endside endtimedout_outcome endinh_accuracy endresponded_binary endnewcond, i(recordid) j(endseq)

* Mean correct RTs *

egen endmeancongrt = rowmean(endfirst_touch_resp_time1 endfirst_touch_resp_time2 endfirst_touch_resp_time3 endfirst_touch_resp_time8 endfirst_touch_resp_time10 endfirst_touch_resp_time11 endfirst_touch_resp_time12 endfirst_touch_resp_time13 endfirst_touch_resp_time15 endfirst_touch_resp_time17 endfirst_touch_resp_time18 endfirst_touch_resp_time22 endfirst_touch_resp_time23 endfirst_touch_resp_time26 endfirst_touch_resp_time27 endfirst_touch_resp_time29 endfirst_touch_resp_time34 endfirst_touch_resp_time35 endfirst_touch_resp_time38 endfirst_touch_resp_time41 endfirst_touch_resp_time42 endfirst_touch_resp_time44 endfirst_touch_resp_time45 endfirst_touch_resp_time47 endfirst_touch_resp_time50 endfirst_touch_resp_time51 endfirst_touch_resp_time52 endfirst_touch_resp_time55 endfirst_touch_resp_time58 endfirst_touch_resp_time59)
kdensity endmeancongrt

egen endmeanincongrt = rowmean(endfirst_touch_resp_time4 endfirst_touch_resp_time5 endfirst_touch_resp_time6 endfirst_touch_resp_time7 endfirst_touch_resp_time9 endfirst_touch_resp_time14 endfirst_touch_resp_time16 endfirst_touch_resp_time19 endfirst_touch_resp_time20 endfirst_touch_resp_time21 endfirst_touch_resp_time24 endfirst_touch_resp_time25 endfirst_touch_resp_time28 endfirst_touch_resp_time30 endfirst_touch_resp_time31 endfirst_touch_resp_time32 endfirst_touch_resp_time33 endfirst_touch_resp_time36 endfirst_touch_resp_time37 endfirst_touch_resp_time39 endfirst_touch_resp_time40 endfirst_touch_resp_time43 endfirst_touch_resp_time46 endfirst_touch_resp_time48 endfirst_touch_resp_time49 endfirst_touch_resp_time53 endfirst_touch_resp_time54 endfirst_touch_resp_time56 endfirst_touch_resp_time57 endfirst_touch_resp_time60)
kdensity endmeanincongrt

twoway (kdensity endmeancongrt) (kdensity endmeanincongrt)

gen endmeaninhdiffrt = endmeancongrt - endmeanincongrt
kdensity endmeaninhdiffrt



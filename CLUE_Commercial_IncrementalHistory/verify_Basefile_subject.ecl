IMPORT CCLUE_PriorHistory;
//***************************************************************************

//before_project := DATASET('~thor::base::cclue::priorhist::20240102e::subject',CCLUE_PriorHistory.Layouts.delta_subject_clean, THOR);
//OUTPUT(COUNT(before_project),named('before_project'));

after_project := DATASET('~thor::base::cclue::priorhist::kcd::20240901::subject',CCLUE_PriorHistory.Layouts.delta_subject_clean, THOR);
OUTPUT(after_project(last_name='TANVIK' and first_name='MEZA'));

// OUTPUT(COUNT(after_project),named('after_project'));
                                                       
// OUTPUT(COUNT(after_project(Record_Sid<>0 AND delta_ind<>0 )),named('newfields_populated'));
// OUTPUT(COUNT(after_project(Record_Sid=0)),named('Record_sid_data'));
// OUTPUT(COUNT(after_project(delta_ind=0 )),named('delta_ind_data'));
// OUTPUT(COUNT(after_project(delta_ind<>1 )),named('delta_ind_datanot1'));
// OUTPUT(MIN(after_project,record_sid),named('Min_Record_sid'));
// OUTPUT(MAX(after_project,record_sid),named('Max_Record_sid'));

//**************************************************************************

// OUTPUT(COUNT(after_project),named('total_rec_count'));
// Cnt1 := COUNT(after_project(dt_effective_first<>0));
// OUTPUT(Cnt1,named('dt_effective_first_notzero'));
// Cnt2 := COUNT(after_project(dt_effective_first=0));
// OUTPUT(Cnt2,named('dt_effective_first_zero'));

// OUTPUT(COUNT(after_project(dt_effective_last=0)),named('dt_effective_last_zero'));
// OUTPUT(COUNT(after_project(dt_effective_last<>0)),named('dt_effective_last_notzero'));

// total_cnt := cnt1+cnt2;
// OUTPUT(total_cnt,named('total_cnt'));

// OUTPUT(choosen(after_project(dt_effective_first<>0),10),named('first10recs'));
// OUTPUT(choosen(after_project(dt_effective_first=0),10),named('first10recszero'));

// SORT(after_project,-record_sid);                                        
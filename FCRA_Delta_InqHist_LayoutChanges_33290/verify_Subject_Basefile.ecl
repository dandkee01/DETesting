IMPORT ClaimsDiscoveryAuto_InquiryHistory;
//***************************************************************************



//after_project := DATASET('~thor::base::claimsdiscoveryauto::qa::inqhist::subject',ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject, THOR);
after_project :=  DATASET ('~thor::base::claimsdiscoveryauto::qa::inqhist::claim', ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR);

OUTPUT(COUNT(after_project),named('Total_Recs_Count'));
                                                       
OUTPUT(COUNT(after_project(Record_Sid<>0 AND delta_ind<>0 )),named('newfields_populated'));
OUTPUT(COUNT(after_project(Record_Sid=0)),named('Record_sid_data'));
OUTPUT(COUNT(after_project(delta_ind=0 )),named('delta_ind_Zero'));
OUTPUT(COUNT(after_project(delta_ind<>1 )),named('delta_ind_datanot1'));
OUTPUT(MIN(after_project,record_sid),named('Min_Record_sid'));
OUTPUT(MAX(after_project,record_sid),named('Max_Record_sid'));

//**************************************************************************

Cnt1 := COUNT(after_project(dt_effective_first<>0));
OUTPUT(Cnt1,named('dt_effective_first_notzero'));
Cnt2 := COUNT(after_project(dt_effective_first=0));
OUTPUT(Cnt2,named('dt_effective_first_zero'));
total_cnt := cnt1+cnt2;
OUTPUT(total_cnt,named('total_cnt'));

OUTPUT(COUNT(after_project(dt_effective_last=0)),named('dt_effective_last_zero'));
OUTPUT(COUNT(after_project(dt_effective_last<>0)),named('dt_effective_last_notzero'));

OUTPUT(choosen(after_project(dt_effective_first<>0),10),named('first10recs'));
OUTPUT(choosen(after_project(dt_effective_first=0),10),named('first10recszero'));

OUTPUT(SORT(after_project,-dt_effective_first), named('Max_Dt_effective_first'));                                        
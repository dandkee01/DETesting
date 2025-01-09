IMPORT CLUEAuto_InquiryHistory, std,Delta_Macro;
InqSubj_DS := DATASET ('~thor::base::clueauto::kcd::qa::inqhist::subject',CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE,THOR);
output(InqSubj_DS, NAMED('InqSubj_DS'));
dailyFile := '~thor::base::clueauto::kcd::20230228::daily::inqhist::subject';
DailyDS := DATASET (dailyFile,CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE,THOR);
OUTPUT(DailyDS,named('DailyDS'));

// InqSubj_FatherDS := DATASET ('~thor::base::clueauto::kcd::grandfather::inqhist::subject',CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE,THOR);
// OUTPUT(InqSubj_FatherDS,named('InqSubj_FatherDS'));
// OUTPUT(COUNT(InqSubj_FatherDS),named('InqSubj_FatherDS_cnt'));
// DedupCnt := COUNT(DEDUP(sort(InqSubj_FatherDS,#expand(Delta_Macro.constants.Clue_Auto_subject_fields),#expand(Delta_Macro.constants.Clue_Auto_subject_fields))));
// OUTPUT(DedupCnt,named('DedupCnt'));


// OUTPUT(InqSubj_DS(fname='MARIA'),named('MariaqaDS'));
// OUTPUT(DailyDS(fname='MARIA'),named('MariaDailyDS'));
// OUTPUT(InqSubj_FatherDS(fname='MARIA'),named('MariaFaDS'));


// InqSubj_DS(dt_effective_first<>0);
// InqSubj_DS(dt_effective_last<>0);
// InqSubj_DS(delta_ind IN [2,3]);

// OUTPUT(InqSubj_DS(reference_no IN ['23016231810725','23016231510724','23017001200001']), named('InqSubDSAlreadyExists'));
// OUTPUT(DailyDS(reference_no IN ['23016231810725','23016231510724','23017001200001']),named('DailyDSAlreadyExists'));

// OUTPUT(STD.File.SuperFileContents('~thor::base::clueauto::kcd::qa::inqhist::subject'),named('SuperfileContents'));

//************************************* Claim File************************************

IMPORT CLUEAuto_InquiryHistory, STD;

InqClaim_QaDS	:= DATASET ('~thor::base::clueauto::kcd::qa::inqhist::claim',CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR);
InqClaim_QaDS;
InqClaim_DailyDS	:= DATASET ('~thor::base::clueauto::kcd::20230227::daily::inqhist::claim',CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR);
InqClaim_DailyDS(reference_no='23016231210727');
InqClaim_QaDS(reference_no='23016231210727');
InqClaim_QaDS(dt_effective_first<>0);
InqClaim_QaDS(dt_effective_last<>0);
InqClaim_QaDS(delta_ind<>1);
OUTPUT(STD.File.SuperFileContents('~thor::base::clueauto::kcd::qa::inqhist::claim'),named('SuperfileContents'));
GROUP
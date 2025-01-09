IMPORT CLUEAuto_InquiryHistory;

//*****************************************************************************************
// Inquiry History subject file
//*****************************************************************************************

InqSubj_DS := DATASET ('~thor::base::clueauto::kcd::202302062154::daily::inqhist::subject',CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE,THOR);
DailyInqSubj_DS	:= DATASET ('~thor::base::clueauto::kcd::qa::daily::inqhist::subject',CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE,THOR);



//******************************************************************************************
//claims file
//******************************************************************************************

InqClaim_DailyDS	:= DATASET ('~thor::base::clueauto::kcd::qa::daily::inqhist::claim',CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR);
InqClaim_QaDS	:= DATASET ('~thor::base::clueauto::kcd::qa::inqhist::claim',CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR);


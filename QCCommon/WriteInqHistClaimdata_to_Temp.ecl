IMPORT CLUEAuto_InquiryHistory;
DailyInqSubj_DS	:= DATASET ('~thor::base::clueauto::kcd::qa::inqhist::subject',CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE,THOR);

InqClaim_QaDS	:= DATASET ('~thor::base::clueauto::kcd::qa::inqhist::claim',CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR);

OUTPUT(DailyInqSubj_DS,,'~thor::base::cluea::Inqhist_qa::KCD::test',OVERWRITE,COMPRESSED);
OUTPUT(InqClaim_QaDS,,'~thor::base::cluea::InqClaim_qa::KCD::test',OVERWRITE,COMPRESSED);

Inqhist_qa:= DATASET('~thor::base::cluea::Inqhist_qa::KCD::test',CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE,THOR);
InqClaim_qa:= DATASET('~thor::base::cluea::InqClaim_qa::KCD::test',CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR);

Inqhist_qa(fname='MARIA');
//InqClaim_qa(fname='MARIA');
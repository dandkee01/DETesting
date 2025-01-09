IMPORT ClaimsDiscoveryAuto_InquiryHistory, ClaimsDiscoveryAuto_Delta;

BaseSubj   := DATASET('~thor::base::claimsdiscoveryauto::kcd::202303280301::inqhist::subject',ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject,THOR);
DailySubj  := CHOOSEN(DATASET('~thor::base::claimsdiscoveryauto::kcd::qa::delta_key_subject.txt', ClaimsDiscoveryAuto_Delta.Layouts.Delta_Subject, THOR),10);
output(DailySubj,named('DailySubj'));
output(BaseSubj,named('BaseSubj'));
IMPORT ClaimsDiscoveryAuto_InquiryHistory;

DS_0322 :=  DATASET ('~thor::base::claimsdiscoveryauto::20240322::inqhist::claim', ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR);
DS_0322b :=  DATASET ('~thor::base::claimsdiscoveryauto::20240322a::inqhist::claim', ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR);

DS_0322b(record_sid=22748589);

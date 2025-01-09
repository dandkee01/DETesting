IMPORT ClaimsDiscoveryAuto_InquiryHistory,QCCommon, STD, RoxieKeyBuild;

//BaseClaim   := DATASET('~thor::base::claimsdiscoveryauto::kcd::202303280301::inqhist::claim',ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR);
BaseClaim := DATASET('~thor::clda::dandke::qa::deltaclaimtest', ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim, thor);                                     

// below DailyClaim is already passed records , so these records should not make into daily file again.
DailyClaim  := CHOOSEN(DATASET('~thor::base::claimsdiscoveryauto::kcd::202303282052::delta_claim.txt', ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim, THOR),10);
OUTPUT(BaseClaim, named('BaseClaim'));
OUTPUT(DailyClaim, named('DailyClaim'));


//*************************************************************************************************************************************************
ClaimFile := QCCommon.ClaimsDiscoveryauto_InqHist.AppendDeltaClaimTest(BaseClaim,DailyClaim);
ClaimFile;
date := STD.Date.CurrentDate(True); 
RoxieKeyBuild.Mac_SF_BuildProcess_V2(ClaimFile,
																			 '~thor::CLDA::dandke', 
																		   'DeltaClaimTest', 
																			 date,buildclaim, 2,,,true);
//buildclaim;  


IMPORT ClaimsDiscoveryAuto_InquiryHistory;
  
ProdSuperFileName_Subject := '~thor::base::claimsdiscoveryauto::qa::inqhist::subject';
ProdSuperFileName_Claim := '~thor::base::claimsdiscoveryauto::qa::inqhist::claim';


BaseSubject :=  DATASET (ProdSuperFileName_Subject, ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject,THOR);
BaseClaim :=  DATASET (ProdSuperFileName_Claim, ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR);

COUNT(BaseSubject);
COUNT(BaseClaim);


logicalfilelist
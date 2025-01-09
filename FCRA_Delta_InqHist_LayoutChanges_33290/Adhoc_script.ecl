IMPORT ClaimsDiscoveryAuto_InquiryHistory, STD;
	
  ProdSuperFileName_Subject := '~thor::base::claimsdiscoveryauto::qa::inqhist::subject';
	ProdSuperFileName_Claim := '~thor::base::claimsdiscoveryauto::qa::inqhist::claim';


//generating record_sid to existing data for base
BaseSubject :=  DATASET (ProdSuperFileName_Subject, ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject,THOR);
BaseClaim :=  DATASET (ProdSuperFileName_Claim, ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR);

OUTPUT(COUNT(BaseSubject), named('Cnt_Before_BaseSubject'));

	ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject setRecordSid_Subj (ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject L, INTEGER C) := TRANSFORM
		SELF.Record_Sid := C;
		SELF.dt_effective_first := Std.Date.Today();
		SELF.Delta_ind := 1;
		SELF := L;
	END;
		
	Subject_id := PROJECT (BaseSubject,setRecordSid_Subj(LEFT,COUNTER));
	
	Subject_distribute := Distribute (Subject_id,HASH32(Reference_No));
  
  OUTPUT(COUNT(Subject_distribute), named('Cnt_after_BaseSubject'));
  OUTPUT(Subject_distribute, named('Subject_distribute'));
    OUTPUT(MAX(Subject_distribute,Record_Sid), named('Max_record_sidSub'));

  
	OUTPUT(COUNT(BaseClaim), named('Cnt_Before_BaseClaim'));

		ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim setRecordSid_claim (ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim L, INTEGER C) := TRANSFORM
		SELF.Record_Sid := C;
		SELF.dt_effective_first := Std.Date.Today();
		SELF.Delta_ind := 1;
		SELF := L;
	END;
	
		Claim_id := PROJECT (BaseClaim,setRecordSid_claim(LEFT,COUNTER));
	
	Claim_distribute := Distribute (Claim_id,HASH32(Reference_No));
  OUTPUT(COUNT(Claim_distribute), named('Cnt_after_BaseClaim'));
  OUTPUT(Claim_distribute, named('Claim_distribute'));
  OUTPUT(MAX(Claim_distribute,Record_Sid), named('Max_record_sid'));


 /*Sequential(
				output(Subject_distribute,,'~thor::base::claimsdiscoveryauto::20240322::inqhist::subject',overwrite,compressed),
						FileServices.ClearSuperFile(ProdSuperFileName_Subject),
						FileServices.AddSuperFile(ProdSuperFileName_Subject, '~thor::base::claimsdiscoveryauto::20240322::inqhist::subject'),
				output(Claim_distribute,,'~thor::base::claimsdiscoveryauto::20240322::inqhist::claim',overwrite,compressed),
						FileServices.ClearSuperFile(ProdSuperFileName_Claim),
						FileServices.AddSuperFile(ProdSuperFileName_Claim, '~thor::base::claimsdiscoveryauto::20240322::inqhist::claim'));

*/
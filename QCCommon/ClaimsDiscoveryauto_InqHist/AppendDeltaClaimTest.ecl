IMPORT CLUEAuto_InquiryHistory, ClaimsDiscoveryAuto_Delta, ut, std, ClaimsDiscoveryAuto_InquiryHistory;

EXPORT AppendDeltaClaimTest (DATASET (ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim) BaseClaim, DATASET (ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim) DailyClaim) := FUNCTION

ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim getClaimKey (ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim L, INTEGER C) := TRANSFORM
      SELF.Reference_No := L.Reference_No;
			SELF.Unit_No			:= L.Unit_No;
			SELF.Claim_No			:= L.Claim_No;
			SELF.Delta_ind    := 1;
			SELF.dt_effective_first := Std.Date.Today();
			SELF := [];
		END;

		//SortBase	:= SORT(BaseClaim,Reference_No,Unit_No,Claim_No);
		DeltaClaim := PROJECT (DailyClaim,getClaimKey(LEFT,COUNTER));
		SortDaily	:= SORT(DISTRIBUTE(DeltaClaim,HASH32(Reference_No)),Reference_No,Unit_No,Claim_No, LOCAL);
    OUTPUT(SortDaily, named('SortDaily'));
    OUTPUT(COUNT(SortDaily), named('cnt_SortDaily'));
		
		/*To get only latest Active record for the transaction by using sort and dedup*/
		SortBaseClaim := Sort(BaseClaim,Reference_No, Unit_No, Claim_No,  -dt_effective_first, dt_effective_last, Delta_ind);
		DedupBaseClaim := dedup(SortBaseClaim,Reference_No, Unit_No, Claim_No, keep(1));
    
    OUTPUT(DedupBaseClaim, named('DedupBaseClaim'));
    OUTPUT(COUNT(DedupBaseClaim), named('cnt_DedupBaseClaim'));
	
		/*Compare transactions in base file and SortDaily to get old records for the same transactions in DailySubject*/
    /* Set Date_effective on Base file for active transactions*/
    NewDeleteBaseRecs :=  JOIN(DedupBaseClaim,SortDaily,LEFT.Reference_No = RIGHT.Reference_No and LEFT.Unit_No = RIGHT.Unit_No and LEFT.Claim_No = RIGHT.Claim_No,TRANSFORM(ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim,SELF.Delta_ind:=3; SELF.dt_effective_last:=Std.Date.Today(); SELF:=LEFT;), LOOKUP);
    OUTPUT(NewDeleteBaseRecs, named('NewDeleteBaseRecs'));
    OUTPUT(COUNT(NewDeleteBaseRecs), named('cnt_NewDeleteBaseRecs'));		
    NewUpdateBaseRecs :=  JOIN(DedupBaseClaim,SortDaily,LEFT.Reference_No = RIGHT.Reference_No and LEFT.Unit_No = RIGHT.Unit_No and LEFT.Claim_No = RIGHT.Claim_No ,TRANSFORM(ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim,SELF.Delta_ind:=2; SELF.dt_effective_first:=Std.Date.Today(); SELF:=RIGHT;), LOOKUP);
    OUTPUT(NewUpdateBaseRecs, named('NewUpdateBaseRecs'));
    OUTPUT(COUNT(NewUpdateBaseRecs), named('cnt_NewUpdateBaseRecs'));		
    OldRecs := NewUpdateBaseRecs+NewDeleteBaseRecs;
    
		ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim OldRecs_Transform(ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim le,ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim ri) := TRANSFORM
			IsSkip := (le.Delta_ind = 2 AND Ri.Delta_ind =3) OR (le.Delta_ind = 3 AND Ri.Delta_ind =2);
			SELF.Reference_No							:= IF(Not IsSkip, le.Reference_No, skip);
			SELF.Unit_No									:= IF(not IsSkip, le.Unit_No, skip);
			SELF.Claim_No									:= IF(not IsSkip, le.Claim_No, skip);
			SELF.Delta_ind								:= IF(not IsSkip, le.Delta_ind, skip);
			SELF.dt_effective_first				:= IF(not IsSkip, le.dt_effective_first, skip);
			SELF.dt_effective_last				:= IF(not IsSkip, le.dt_effective_last, skip);
			SELF													:= le;
	  END;
	
		UpdatedBaseRecs := JOIN(OldRecs, OldRecs, LEFT.reference_no=RIGHT.reference_no and
																	LEFT.unit_no=RIGHT.unit_no and
																	LEFT.Claim_No= RIGHT.Claim_No and
																	LEFT.delta_ind != RIGHT.delta_ind, OldRecs_Transform(left,right),LEFT OUTER);
    OUTPUT(UpdatedBaseRecs, named('UpdatedBaseRecs'));
    OUTPUT(COUNT(UpdatedBaseRecs), named('cnt_UpdatedBaseRecs'));                             

    /* To get new transactions and set delta_ind as 1*/
    NewRecs := JOIN(SortDaily,NewUpdateBaseRecs,LEFT.Reference_No = RIGHT.Reference_No and LEFT.Unit_No = RIGHT.Unit_No and	LEFT.Claim_No = RIGHT.Claim_No,TRANSFORM(ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim,SELF.Delta_ind:=1;SELF.dt_effective_first:=Std.Date.Today();SELF:=LEFT), LEFT Only);
    OUTPUT(NewRecs, named('NewRecs'));
    OUTPUT(COUNT(NewRecs), named('cnt_NewRecs')); 
		OUTPUT(OldRecs, named('OldRecs'));
    OUTPUT(COUNT(OldRecs), named('cnt_OldRecs'));	

    
		Sort_UpdatedBaseRecs := Sort(UpdatedBaseRecs,Reference_No,Unit_No);
		Sort_NewRecs := Sort(NewRecs,Reference_No,Unit_No);
		
		MergeClaim := MERGE(Sort_UpdatedBaseRecs,Sort_NewRecs,SORTED(Reference_No,Unit_No,Claim_No), LOCAL);
    OUTPUT(MergeClaim, named('MergeClaim'));
    OUTPUT(COUNT(MergeClaim), named('cnt_MergeClaim')); 

		
		//MergeClaim := MERGE(SortBase,SortDaily,SORTED(Reference_No,Unit_No,Claim_No));
	
		RETURN DEDUP(SORT(MergeClaim,Reference_No,Unit_No,Claim_No,delta_ind, dt_effective_first, dt_effective_last),Reference_No,Unit_No,Claim_No,delta_ind, dt_effective_first, dt_effective_last);
END;

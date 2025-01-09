IMPORT CLUEAuto_InquiryHistory, STD;

DailyClaim := CHOOSEN(DATASET('~thor::base::clueauto::kcd::20230228::delta_claim.txt',CLUEAuto_Delta.Layouts.DeltaClaim, THOR),2);
BaseClaim	 := DATASET ('~thor::base::clueauto::kcd::20230227::inqhist::claim',CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR); // father version data
CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim getClaimKey (CLUEAuto_Delta.Layouts.DeltaClaim L, INTEGER C) := TRANSFORM
			SELF.Reference_No := L.Reference_Number;
			SELF.Unit_No			:= L.ClaimData[C].Unit_No;
			SELF.Claim_No			:= L.ClaimData[C].Ambest_No [2..6] + L.ClaimData[C].Claim_No;
			SELF.Delta_ind    := 1;
			SELF.dt_effective_first := Std.Date.Today();
			SELF := [];
		END;

Daily_Claim := NORMALIZE (DailyClaim,COUNT(LEFT.ClaimData),getClaimKey(LEFT,COUNTER));
OUTPUT(Daily_Claim,named('Daily_Claim'));
OUTPUT(Daily_Claim(reference_no IN ['23383001400012','23383001400013']),named('Daily_Claim1'));
OUTPUT(BaseClaim(reference_no IN ['23383001400012','23383001400013']),named('Base_Claim'));

SortDaily	:= SORT(DISTRIBUTE(Daily_Claim,HASH32(Reference_No)),Reference_No,Unit_No,Claim_No,LOCAL);
		
		/*To get only latest Active record for the transaction by using sort and dedup*/
		SortBaseClaim := Sort(BaseClaim,Reference_No, Unit_No, Claim_No,  -dt_effective_first, dt_effective_last, Delta_ind);
		DedupBaseClaim := dedup(SortBaseClaim,Reference_No, Unit_No, Claim_No, keep(1));
	
		/*Compare transactions in base file and SortDaily to get old records for the same transactions in DailySubject*/
    /* Set Date_effective on Base file for active transactions*/
    NewDeleteBaseRecs :=  JOIN(DedupBaseClaim,SortDaily,LEFT.Reference_No = RIGHT.Reference_No and LEFT.Unit_No = RIGHT.Unit_No and LEFT.Claim_No = RIGHT.Claim_No ,TRANSFORM(CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim,SELF.Delta_ind:=3; SELF.dt_effective_last:=Std.Date.Today(); SELF:=LEFT;), LOOKUP);
  	NewUpdateBaseRecs :=  JOIN(DedupBaseClaim,SortDaily,LEFT.Reference_No = RIGHT.Reference_No and LEFT.Unit_No = RIGHT.Unit_No and LEFT.Claim_No = RIGHT.Claim_No ,TRANSFORM(CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim,SELF.Delta_ind:=2; SELF.dt_effective_first:=Std.Date.Today(); SELF:=RIGHT;), LOOKUP);

		OldRecs := NewUpdateBaseRecs+NewDeleteBaseRecs;
    OUTPUT(OldRecs,named('OldRecs'));
    
    CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim OldRecs_Transform(CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim le,CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim ri) := TRANSFORM
			IsSkip := (le.Delta_ind = 2 AND Ri.Delta_ind =3) OR (le.Delta_ind = 3 AND Ri.Delta_ind =2);
			SELF.Reference_No 						:= IF(Not IsSkip, le.Reference_No, skip);
			SELF.Unit_No									:= IF(not IsSkip, le.Unit_No, skip);
			SELF.Claim_No									:= IF(not IsSkip, le.Claim_No, skip);
			SELF.Delta_ind								:= IF(not IsSkip, le.Delta_ind, skip);
			SELF.dt_effective_first				:= IF(not IsSkip, le.dt_effective_first, skip);
			SELF.dt_effective_last				:= IF(not IsSkip, le.dt_effective_last, skip);
			SELF := le;
	  END;
	
		UpdatedBaseRecs := JOIN(OldRecs, OldRecs, LEFT.reference_no=RIGHT.reference_no and
	                                 LEFT.unit_no=RIGHT.unit_no and
																	 LEFT.Claim_No= RIGHT.Claim_No and
                                   LEFT.delta_ind != RIGHT.delta_ind, OldRecs_Transform(left,right),LEFT OUTER);
                                   
    OUTPUT( UpdatedBaseRecs,named('UpdatedBaseRecs'));    
    
    NewRecs := JOIN(SortDaily,NewUpdateBaseRecs,LEFT.Reference_No = RIGHT.Reference_No and LEFT.Unit_No = RIGHT.Unit_No and LEFT.Claim_No = RIGHT.Claim_No	,TRANSFORM(CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim,SELF.Delta_ind:=1;SELF.dt_effective_first:=Std.Date.Today();SELF:=LEFT), LEFT Only);
		OUTPUT( NewRecs,named('NewRecs'));    

		MergeClaim := MERGE(UpdatedBaseRecs,NewRecs,SORTED(Reference_No,Unit_No,Claim_No),LOCAL);
    OUTPUT( MergeClaim,named('MergeClaim'));    
	
		D_Claim := DISTRIBUTE (MergeClaim,HASH32(Reference_No));
		
		output(DEDUP(SORT(MergeClaim,Reference_No,Unit_No, Claim_No, delta_ind, dt_effective_first, dt_effective_last,LOCAL),Reference_No,Unit_No,Claim_No,delta_ind, dt_effective_first, dt_effective_last,LOCAL));
    
    





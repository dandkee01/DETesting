IMPORT CLUEAuto_InquiryHistory, ClaimsDiscoveryAuto_Delta, ut, _control, std;
IMPORT ClaimsDiscoveryAuto_InquiryHistory;

EXPORT AppendDeltaSubj (DATASET (ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject) BaseSubj, DATASET (ClaimsDiscoveryAuto_Delta.Layouts.Delta_Subject) DailySubj) := FUNCTION
	ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject ConvertSubj (ClaimsDiscoveryAuto_Delta.Layouts.Delta_Subject L, INTEGER C) := TRANSFORM
		SELF.Reference_No 						:= L.reference_number;
		SELF.Unit_No									:= L.subject_unit_number;
		SELF.Transaction_Id						:= L.transaction_id;
		SELF.Customer_No							:= L.customer_number;
		SELF.Account_No								:= L.account_number + L.account_suffix;
		SELF.Quoteback								:= L.quoteback;
		SELF.DateOfOrder							:= L.order_date;
		SELF.Process_date             := L.Process_date;
		SELF.LName										:= L.subject_last_name;
		SELF.FName										:= L.subject_first_name;
		SELF.MName										:= L.subject_middle_name;
		SELF.SName										:= L.subject_name_suffix;
		SELF.House_No									:= IF (C = 1,L.current_house_number,L.former_house_number);
		SELF.Street_Name							:= IF (C = 1,L.current_street_name,L.former_street_name);
		SELF.Apt_No										:= IF (C = 1,L.current_apartment_number,L.former_apartment_number);
		SELF.City											:= IF (C = 1,L.current_city,L.former_city);
		SELF.State										:= IF (C = 1,L.current_state,L.former_state);
		SELF.Zip5											:= IF (C = 1,L.current_zip,L.former_zip);
		SELF.Zip4											:= IF (C = 1,L.current_zip_plus4,L.former_zip_plus4);
		SELF.DriversLicense_No				:= IF (C = 1,L.current_dl_number,L.former_dl_number);
		SELF.DriversLicense_State			:= IF (C = 1,L.current_dl_state,L.former_dl_state);
		SELF.Policy_No								:= L.policy_number;
		SELF.SSN											:= L.subject_ssn;
		SELF.DOB											:= L.subject_dob;
		SELF.Sex											:= L.subject_sex;
		SELF.Did											:= (INTEGER)L.did;
		SELF.Delta_ind                := 1;
		SELF.dt_effective_first       := Std.Date.Today();
		SELF := [];
	END;
	
		Subject_Data 	 := NORMALIZE(DailySubj,2,ConvertSubj(LEFT,COUNTER));
    OUTPUT(Subject_Data,named('Subject_Data'));

	Filter_Blank_Data := TRIM(Subject_Data.Street_Name) = '' AND (INTEGER)Subject_Data.Zip5 = 0 AND TRIM(Subject_Data.DriversLicense_No) = '';
	Remove_Blank_Data := Subject_Data (~Filter_Blank_Data);
	
	CleanedName 		:= ClaimsDiscoveryAuto_InquiryHistory.StandardizeName_CLUE(Remove_Blank_Data);
	CleanedAddress 	:= ClaimsDiscoveryAuto_InquiryHistory.StandardizeAddress_CLUE(CleanedName);
	
	maxrid := MAX (BaseSubj,Source_Rid) : global;
	
	ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject getMaxRid (ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject L, INTEGER C) := TRANSFORM
		SELF.Source_Rid := maxrid + C;
		SELF := L;
	END;
	
	CleanSubject := PROJECT (CleanedAddress,getMaxRid(LEFT,COUNTER));
	
	Cleaned_Subject := ClaimsDiscoveryAuto_InquiryHistory.CleanSubjectData(CleanSubject) : persist ('~thor::claimsdiscoveryauto::dailyih::subj');
	
	/* External Link Subject file */
	Prod_XDL_File := ClaimsDiscoveryAuto_InquiryHistory.XDL_File (Cleaned_Subject) : persist ('~thor::claimsdiscoveryauto::dailyih::xdl::file', _Control.ThisCluster.LexIDCluster);
	DEV_XDL_File 	:= ClaimsDiscoveryAuto_InquiryHistory.XDL_File (Cleaned_Subject) : persist ('~thor::claimsdiscoveryauto::dailyih::xdl::file','thor400_126_staging_dev');
	
	DailyXDLFile 	:= IF (_control.ThisEnvironment.Name = 'Prod',Prod_XDL_File,DEV_XDL_File);

	
	ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject RemoveBlank (ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject L) := TRANSFORM
		SELF.DateOfOrder 				:= IF (L.DateOfOrder = '','00000000',l.DateOfOrder);
		SELF.Zip5								:= IF (L.Zip5 = '','00000',l.Zip5);
		SELF.Zip4								:= IF (L.Zip5 = '','0000',l.Zip4);
		SELF.SSN 								:= IF (L.SSN = '','000000000',l.SSN);
		SELF.DOB 								:= IF (L.DOB = '','00000000',l.DOB);
		SELF.CleanAddress.Zip5	:= IF (L.Zip5 = '','00000',l.CleanAddress.Zip5);
		SELF.CleanAddress.Zip4	:= IF (L.Zip5 = '','0000',l.CleanAddress.Zip4);	
		SELF := L;
	END;

	P_DailySubject := PROJECT(Cleaned_Subject,RemoveBlank(LEFT));
	P_DailyXDLSubject := PROJECT(DailyXDLFile,RemoveBlank(LEFT));
	
	DailySubject := SORT(P_DailySubject,Reference_No,Unit_No);
	DailyXDLSubject := SORT(P_DailyXDLSubject,Reference_No,Unit_No);
		
	  /* Compare Did in DailySubject and dailyXDL for the same transaction to set Deltaind 2 and 3 and date effective*/
  UpdatedRecs := ClaimsDiscoveryAuto_InquiryHistory.Mac_AppendJoin(DailyXDLSubject,DailySubject,LEFT,2);
    OUTPUT(DailyXDLFile,named('DailyXDLFile'));

  OUTPUT(UpdatedRecs,named('UpdatedRecs'));
	DeleteRecs := ClaimsDiscoveryAuto_InquiryHistory.Mac_AppendJoin(UpdatedRecs,DailySubject,RIGHT,3);
  OUTPUT(DeleteRecs,named('DeleteRecs'));

	
	UnchangedRecs := JOIN(DailyXDLSubject,DailySubject, LEFT.Transaction_Id	= RIGHT.Transaction_Id
																								and LEFT.Source_Rid	= RIGHT.Source_Rid
																								and LEFT.Unit_No	= RIGHT.Unit_No
																								and LEFT.Did=RIGHT.Did,
																								TRANSFORM(ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject,SELF:=RIGHT;));
  OUTPUT(UnchangedRecs, named('UnchangedRecs'));                                              

  /*To get only latest Active record for the transaction from basefile by using sort and dedup*/
  SortBaseSubj := Sort(BaseSubj,#expand(ClaimsDiscoveryAuto_InquiryHistory.Constants.ClaimsDiscovery_Auto_subject_fields), -dt_effective_first, dt_effective_last, Delta_ind );
	DedupBaseSubj := dedup(SortBaseSubj,#expand(ClaimsDiscoveryAuto_InquiryHistory.Constants.ClaimsDiscovery_Auto_subject_fields), keep(1));
	
  /*Compare transactions in base file and dailySubject to get old records for the same transactions in DailySubject*/
  /* Set Date_effective on Base file for latest active transaction*/
	NewDeleteBaseRecs := ClaimsDiscoveryAuto_InquiryHistory.Mac_AppendJoin(DedupBaseSubj,DailyXDLSubject,LEFT,3,true);
  OUTPUT(NewDeleteBaseRecs,named('NewDeleteBaseRecs'));
	NewUpdateBaseRecs := ClaimsDiscoveryAuto_InquiryHistory.Mac_AppendJoin(DedupBaseSubj,UnchangedRecs,RIGHT,2,true);
  OUTPUT(NewUpdateBaseRecs,named('NewUpdateBaseRecs'));


	OldRecs := NewUpdateBaseRecs+NewDeleteBaseRecs;
	
	UpdatedBaseRecs := ClaimsDiscoveryAuto_InquiryHistory.ExtractUpdatedBaseSubject(OldRecs);
  OUTPUT(UpdatedBaseRecs,named('UpdatedBaseRecs'));

 /* To get new transactions and set delta_ind as 1*/
	NewRecs := JOIN(DailyXDLSubject, UpdatedRecs+NewUpdateBaseRecs, LEFT.Transaction_Id = RIGHT.Transaction_Id and LEFT.Unit_No = RIGHT.Unit_No and LEFT.Source_rid = RIGHT.Source_rid, TRANSFORM(ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject,SELF.Delta_ind:=1;SELF.dt_effective_first:=Std.Date.Today();SELF:=LEFT), LEFT Only);
  OUTPUT(NewRecs,named('NewRecs'));
 
	Sort_UpdatedRecs := Sort(UpdatedRecs,Reference_No,Unit_No);
	Sort_DeleteRecs := Sort(DeleteRecs,Reference_No,Unit_No);
	Sort_UpdatedBaseRecs := Sort(UpdatedBaseRecs,Reference_No,Unit_No);
	Sort_NewRecs := Sort(NewRecs,Reference_No,Unit_No);

	//MergeSubject := MERGE(BaseSubj,DailySubject,SORTED(Reference_No,Unit_No),LOCAL);
	MergeSubject := Merge(Sort_UpdatedRecs, Sort_DeleteRecs, Sort_UpdatedBaseRecs, Sort_NewRecs, SORTED(Reference_No,Unit_No), LOCAL);
	
	RETURN DEDUP(SORT(MergeSubject,RECORD),RECORD);
END;

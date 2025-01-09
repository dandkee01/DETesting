Import CLUEAuto_InquiryHistory,CLUEAuto_Delta, STD,_Control;

//DailySubj := DATASET('~thor::base::clueauto::kcd::20230228::delta_key_subject.txt',CLUEAuto_Delta.Layouts.Delta_Subject,THOR);
DailySubj := DATASET('~thor::base::clueauto::kcd::20230226::delta_key_subject.txt',CLUEAuto_Delta.Layouts.Delta_Subject,THOR);
output(DailySubj, NAMED('DailySubj'));
BaseSubj := DATASET ('~thor::base::clueauto::kcd::20230227::inqhist::subject',CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE,THOR);
output(BaseSubj, NAMED('BaseSubj'));
DailySubjBase := '~thor::base::clueauto::kcd::20230228::daily::inqhist::subject';
DailyDS := DATASET (DailySubjBase,CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE,THOR);
OUTPUT(DailyDS,named('DailyDS'));

CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE ConvertSubj (CLUEAuto_Delta.Layouts.Delta_Subject L, INTEGER C) := TRANSFORM
		SELF.Reference_No 						:= L.reference_number;
		SELF.Unit_No									:= L.subject_unit_no;
		SELF.Transaction_Id						:= L.transaction_id;
		SELF.Customer_No							:= L.customer_number;
		SELF.Account_No								:= L.account_number;
		SELF.Quoteback								:= L.quoteback;
		SELF.DateOfOrder							:= L.order_date;
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
		SELF.Service_Type							:= L.service_type;
		SELF.Process_Date							:= L.process_date;
		SELF.Spl_Bill_Id							:= L.spec_bill_id;
		SELF.Bill_As									:= L.bill_as;
		SELF.Report_As								:= L.report_as;	
		SELF.Delta_ind                := 1;
		SELF.dt_effective_first       := Std.Date.Today();
		SELF := [];
	END;
	
	Subject_Data 	 := NORMALIZE(DailySubj,2,ConvertSubj(LEFT,COUNTER));
  OUTPUT(Subject_Data,named('Subject_Data'));
	Filter_Blank_Data := TRIM(Subject_Data.Street_Name) = '' AND (INTEGER)Subject_Data.Zip5 = 0 AND TRIM(Subject_Data.DriversLicense_No) = '';
	Remove_Blank_Data := Subject_Data (~Filter_Blank_Data);
	
	S_Subject_Data := SORT(DISTRIBUTE(Remove_Blank_Data,HASH32(Reference_No)),Reference_No,Unit_No,LOCAL);

	CleanedName := CLUEAuto_InquiryHistory.StandardizeName_CLUE(S_Subject_Data);
	CleanedAddress := CLUEAuto_InquiryHistory.StandardizeAddress_CLUE(CleanedName);
	
	maxrid := MAX (BaseSubj,Source_Rid) : global;
	output(maxrid,named('maxrid'));
  
	CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE getMaxRid (CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE L, INTEGER C) := TRANSFORM
		SELF.Source_Rid := maxrid + C;
		SELF := L;
	END;
	
	CleanSubject := PROJECT (CleanedAddress,getMaxRid(LEFT,COUNTER));
	
	Cleaned_Subject := CLUEAuto_InquiryHistory.CleanSubjectData(CleanSubject) : persist ('~thor::clueauto::dailyih::subj');

	/* External Link Subject file */
	Prod_XDL_File := CLUEAuto_InquiryHistory.XDL_File_CLUE (Cleaned_Subject,30,6) : persist ('~thor::clueauto::dailyih::xdl::file', _Control.ThisCluster.LexIDCluster);
	DEV_XDL_File 	:= CLUEAuto_InquiryHistory.XDL_File_CLUE (Cleaned_Subject,30,6) : persist ('~thor::clueauto::dailyih::xdl::file','thor400_126_staging_dev');
	
	DailyXDLFile 	:= IF (_control.ThisEnvironment.Name = 'Prod',Prod_XDL_File,DEV_XDL_File);
	
	CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE RemoveBlank (CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE L) := TRANSFORM
		SELF.DateOfOrder 				:= IF (L.DateOfOrder = '','00000000',l.DateOfOrder);
		SELF.Zip5								:= IF (L.Zip5 = '','00000',l.Zip5);
		SELF.Zip4								:= IF (L.Zip5 = '','0000',l.Zip4);
		SELF.SSN 								:= IF (L.SSN = '','000000000',l.SSN);
		SELF.DOB 								:= IF (L.DOB = '','00000000',l.DOB);
		SELF.CleanAddress.Zip5	:= IF (L.Zip5 = '','00000',l.CleanAddress.Zip5);
		SELF.CleanAddress.Zip4	:= IF (L.Zip5 = '','0000',l.CleanAddress.Zip4);	
		SELF.Process_Date 			:= IF (L.Process_Date = '','00000000',l.Process_Date);
		SELF := L;
	END;

	DailySubject := PROJECT(Cleaned_Subject,RemoveBlank(LEFT));
	DailyXDLSubject := PROJECT(DailyXDLFile,RemoveBlank(LEFT));

  /* Compare Did in DailySubject and dailyXDL for the same transaction to set Deltaind 2 and 3 and date effective*/
  UpdatedRecs := CLUEAuto_InquiryHistory.Mac_AppendJoin(DailyXDLSubject,DailySubject,LEFT,2);
  output(UpdatedRecs,named('UpdatedRecs'));
	DeleteRecs := CLUEAuto_InquiryHistory.Mac_AppendJoin(UpdatedRecs,DailySubject,RIGHT,3);
  output(DeleteRecs,named('DeleteRecs'));
	
	UnchangedRecs := JOIN(DailyXDLSubject,DailySubject, LEFT.Transaction_Id	= RIGHT.Transaction_Id
																								and LEFT.Source_Rid	= RIGHT.Source_Rid
																								and LEFT.Unit_No	= RIGHT.Unit_No
																								and LEFT.Did=RIGHT.Did,
																								TRANSFORM(CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE,SELF:=RIGHT;));
   output(UnchangedRecs,named('UnchangedRecs'));
 
  /*To get only latest Active record for the transaction from basefile by using sort and dedup*/
  SortBaseSubj := Sort(BaseSubj,#expand(CLUEAuto_InquiryHistory.Constants.Clue_Auto_subject_fields), -dt_effective_first, dt_effective_last, Delta_ind );
	DedupBaseSubj := dedup(SortBaseSubj,#expand(CLUEAuto_InquiryHistory.Constants.Clue_Auto_subject_fields), keep(1));
	
  /*Compare transactions in base file and dailySubject to get old records for the same transactions in DailySubject*/
  /* Set Date_effective on Base file for latest active transaction*/
  NewDeleteBaseRecs := CLUEAuto_InquiryHistory.Mac_AppendJoin(DedupBaseSubj,DailyXDLSubject,LEFT,3,true);
  output(NewDeleteBaseRecs,named('NewDeleteBaseRecs'));

	NewUpdateBaseRecs := CLUEAuto_InquiryHistory.Mac_AppendJoin(DedupBaseSubj,UnchangedRecs,RIGHT,2,true);
   output(NewUpdateBaseRecs,named('NewUpdateBaseRecs'));


	
	OldRecs := NewUpdateBaseRecs+NewDeleteBaseRecs: persist ('~thor::clueauto::dailyih::OldRecs');
  output(OldRecs,named('OldRecs'));

	
	UpdatedBaseRecs := CLUEAuto_InquiryHistory.ExtractUpdatedBaseSubject(OldRecs):persist ('~thor::clueauto::dailyih::UpdatedBaseRecs');	
	output(UpdatedBaseRecs,named('UpdatedBaseRecs'));
																	
 /* To get new transactions and set delta_ind as 1*/
  NewRecs := JOIN(DailyXDLSubject, UpdatedRecs+NewUpdateBaseRecs, LEFT.Transaction_Id = RIGHT.Transaction_Id and LEFT.Unit_No = RIGHT.Unit_No and LEFT.Source_rid = RIGHT.Source_rid, TRANSFORM(CLUEAuto_InquiryHistory.Layouts.Inquiry_Subject_CLUE,SELF.Delta_ind:=1;SELF.dt_effective_first:=Std.Date.Today();SELF:=LEFT), LEFT Only);
	output(NewRecs,named('NewRecs'));

	Sort_UpdatedRecs := Sort(UpdatedRecs,Reference_No,Unit_No);
	Sort_DeleteRecs := Sort(DeleteRecs,Reference_No,Unit_No);
	Sort_UpdatedBaseRecs := Sort(UpdatedBaseRecs,Reference_No,Unit_No);
	Sort_NewRecs := Sort(NewRecs,Reference_No,Unit_No);
	
  MergeSubject := Merge(Sort_UpdatedRecs, Sort_DeleteRecs, Sort_UpdatedBaseRecs, Sort_NewRecs, SORTED(Reference_No,Unit_No), LOCAL);
 
  
	D_Subject := DISTRIBUTE (MergeSubject,HASH32(Reference_No));																									
	

	Subject_RemoveDups := DEDUP(SORT(D_Subject,reference_no, unit_no, transaction_id, customer_no, account_no, dateoforder, 
																		lname, fname, mname, sname, house_no, street_name, apt_no, city, state, zip5, zip4,
																		driverslicense_no, driverslicense_state, policy_no, ssn, dob, sex, service_type, process_date,
																		spl_bill_id, bill_as, report_as, xlink_weight, did, delta_ind, dt_effective_first, dt_effective_last, LOCAL),
																		reference_no, unit_no, transaction_id, customer_no, account_no, dateoforder, 
																		lname, fname, mname, sname, house_no, street_name, apt_no, city, state, zip5, zip4,
																		driverslicense_no, driverslicense_state, policy_no, ssn, dob, sex, service_type, process_date,
																		spl_bill_id, bill_as, report_as, xlink_weight, did, delta_ind, dt_effective_first, dt_effective_last, LOCAL);

	Subject_RemoveDups;
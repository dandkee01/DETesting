IMPORT CustomerSupport, ut, RoxieKeyBuild;

  SHARED BOOLEAN FCRA		:= TRUE;
	SHARED STRING sProduct  := 'log_ncf';
	SHARED STRING TableName:= 'transaction_log_report_code';
	SHARED ConstantsV2			:= CustomerSupport.ConstantsV2;

  currbase_inquiry 		:= CustomerSupport.Files.read_log_ncf_transaction_log_rptcd_Base (ConstantsV2(sProduct,TableName,,FCRA).base_file);
  OUTPUT(COUNT(currbase_inquiry),named('currbase_inquiry'));
	dailies_inquiry 			:= CustomerSupport.Files.read_log_ncf_transaction_log_rptcd_spray(ConstantsV2(sProduct,TableName,,FCRA).spray_File );
  OUTPUT(COUNT(dailies_inquiry),named('dailies_inquiry'));
  
  OUTPUT(COUNT(DEDUP(SORT(dailies_inquiry,transaction_id,report_code,date_added),transaction_id,report_code,date_added)), named('Count_After_Dedup'));

	/* slim_rec := record
	 string60 transaction_id;
	end;

	slim_inquiry := project(dailies_inquiry,slim_rec);
  OUTPUT(COUNT(slim_inquiry),named('slim_inquiry'));

	dailies := dedup(slim_inquiry,all);
  OUTPUT(COUNT(dailies),named('dailies'));
	transbuss:=output(enth(dailies,10),named('NewTransactionIDs_'+sProduct));

	DistDailies := DISTRIBUTE(dailies_inquiry,HASH64(transaction_id));
	OUTPUT(COUNT(DistDailies),named('DistDailies'));

	MERGE replaced with DEDUP(SORT)
	New_base_inquiry := DEDUP(SORT(DistDailies & currbase_inquiry, transaction_id,report_code,date_added, LOCAL), transaction_id,report_code,date_added, LOCAL);
	OUTPUT(COUNT(New_base_inquiry),named('New_base_inquiry'));

	Dist_New_base_inquiry	:= DISTRIBUTE(New_base_inquiry,HASH64(transaction_id));
	OUTPUT(COUNT(Dist_New_base_inquiry),named('Dist_New_base_inquiry'));

	*/
IMPORT CustomerSupport, ut, RoxieKeyBuild;

  SHARED BOOLEAN FCRA		:= TRUE;
	SHARED STRING sProduct  := 'log_ncf';
	SHARED STRING TableName:= 'transaction_log_report_code';
	SHARED ConstantsV2			:= CustomerSupport.ConstantsV2;

  currbase_inquiry 		:= CustomerSupport.Files.read_log_ncf_transaction_log_rptcd_Base (ConstantsV2(sProduct,TableName,,FCRA).base_file);
  OUTPUT(currbase_inquiry(transaction_id IN['11168527R62810','11168527R62847','11168527R62868','11168527R62871']),NAMED('Latest_Records'));
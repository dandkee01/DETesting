 
 import ut,std,STANDARD, Orbit3, CustomerSupport,CLUETrans_Build;

 BOOLEAN FCRA		:= FALSE;
 STRING sProduct  := 'log_rules';
 STRING TableName:= 'intermediate_log';	
 
 ExistingTxLog     :=  CustomerSupport.Files.read_intermediate_log_base(CustomerSupport.ConstantsV2(sProduct,TableName,,FCRA).base_file);
       
 
 
 OUTPUT(ExistingTxLog,named('records')); 
 OUTPUT(COUNT(ExistingTxLog),named('Total_Recs_tx'));
 
 OUTPUT(COUNT(ExistingTxLog(global_sid=572)),named('globalSid_572'));
 OUTPUT(COUNT(ExistingTxLog(global_sid<>572)),named('globalSid_Not572'));

 OUTPUT(COUNT(ExistingTxLog(record_sid=0)),named('record_sid_Zero_tx'));
 OUTPUT(COUNT(ExistingTxLog(record_sid<>0)),named('record_sid_notZero_tx'));
 
 OUTPUT(MAX(ExistingTxLog,record_sid),named('Max_RecordSid'));
 

import ut,std;
 
 import ut,std,STANDARD, Orbit3, CustomerSupport,CLUETrans_Build;

ExistingTxLog     := CLUETrans_Build.Files.DS_BASE_TXLOG;        
 
 
 OUTPUT(ExistingTxLog,named('ExistingTxLog_records')); 
 OUTPUT(COUNT(ExistingTxLog),named('Total_Recs_tx'));
 
 OUTPUT(COUNT(ExistingTxLog(global_sid=2012)),named('globalSid_2012'));
 OUTPUT(COUNT(ExistingTxLog(global_sid<>2012)),named('globalSid_Not2012'));

 OUTPUT(COUNT(ExistingTxLog(record_sid=0)),named('record_sid_Zero_tx'));
 OUTPUT(COUNT(ExistingTxLog(record_sid<>0)),named('record_sid_notZero_tx'));
 
//*********************************************************************************************
 ExistingPersonLog := CLUETrans_Build.Files.DS_BASE_PERSON_LOG;   

 OUTPUT(ExistingPersonLog,named('ExistingPersonLog_records')); 
 OUTPUT(COUNT(ExistingPersonLog),named('Total_Recs_per'));
 
 OUTPUT(COUNT(ExistingPersonLog(global_sid=1742)),named('globalSid_1742'));
 OUTPUT(COUNT(ExistingPersonLog(global_sid<>1742)),named('globalSid_Not1742'));

 OUTPUT(COUNT(ExistingPersonLog(record_sid=0)),named('record_sid_Zero_per'));
 OUTPUT(COUNT(ExistingPersonLog(record_sid<>0)),named('record_sid_notZero_per'));
 
 //**********************************************************************************************
 
 ExistingVINLog    := CLUETrans_Build.Files.DS_BASE_VIN_LOG;      

 OUTPUT(ExistingVINLog,named('ExistingVINLog_records')); 
 OUTPUT(COUNT(ExistingVINLog),named('Total_Recs_vin'));
 
 OUTPUT(COUNT(ExistingVINLog(global_sid=2022)),named('globalSid_2022'));
 OUTPUT(COUNT(ExistingVINLog(global_sid<>2022)),named('globalSid_Not2022'));

 OUTPUT(COUNT(ExistingVINLog(record_sid=0)),named('record_sid_Zero_vin'));
 OUTPUT(COUNT(ExistingVINLog(record_sid<>0)),named('record_sid_notZero_vin'));
 
 //***********************************************************************************************
 
 ExistingClaimLog  := CLUETrans_Build.Files.DS_BASE_Claim_LOG; 


 OUTPUT(ExistingClaimLog,named('ExistingClaimLog_records')); 
 OUTPUT(COUNT(ExistingClaimLog),named('Total_Recs_Claim'));
 
 OUTPUT(COUNT(ExistingClaimLog(global_sid=1722)),named('globalSid_1722'));
 OUTPUT(COUNT(ExistingClaimLog(global_sid<>1722)),named('globalSid_Not1722'));

 OUTPUT(COUNT(ExistingClaimLog(record_sid=0)),named('record_sid_Zero_Claim'));
 OUTPUT(COUNT(ExistingClaimLog(record_sid<>0)),named('record_sid_notZero_Claim'));
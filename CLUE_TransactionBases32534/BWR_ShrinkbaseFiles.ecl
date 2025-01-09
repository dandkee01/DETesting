#workunit('priority','high');
#workunit('priority','10');

 import ut,std,STANDARD, Orbit3, CustomerSupport,CLUETrans_Build;

//ExistingTxLog     := CHOOSEN(CLUETrans_Build.Files.DS_BASE_TXLOG,100);        
ExistingTxLog     := CLUETrans_Build.Files.DS_BASE_TXLOG;        
 
 //OUTPUT(ExistingTxLog,,'~thor::base::clue::shrinkkcd::transaction_log.txt', overwrite, __compressed__, named('base_test'));
 OUTPUT(COUNT(ExistingTxLog),named('ExistingTxLog_cnt'));
 OUTPUT(MAX(ExistingTxLog,record_sid),named('ExistingTxLog_Maxsid'));
 
//*********************************************************************************************
 //ExistingPersonLog := CHOOSEN(CLUETrans_Build.Files.DS_BASE_PERSON_LOG,100);   
 ExistingPersonLog := CLUETrans_Build.Files.DS_BASE_PERSON_LOG;   

 //OUTPUT(ExistingPersonLog,,'~thor::base::clue::shrinkkcd::transaction_log_person.txt', overwrite, __compressed__); 
 OUTPUT(COUNT(ExistingPersonLog),named('ExistingPersonLog_cnt'));
 OUTPUT(MAX(ExistingPersonLog,record_sid),named('ExistingPersonLog_Maxsid'));
 
 //**********************************************************************************************
 
 //ExistingVINLog    := CHOOSEN(CLUETrans_Build.Files.DS_BASE_VIN_LOG,100);      
 ExistingVINLog    := CLUETrans_Build.Files.DS_BASE_VIN_LOG;      

 //OUTPUT(ExistingVINLog,,'~thor::base::clue::shrinkkcd::transaction_log_vin.txt', overwrite, __compressed__); 
 OUTPUT(COUNT(ExistingVINLog),named('ExistingVINLog_cnt'));
 OUTPUT(MAX(ExistingVINLog,record_sid),named('ExistingVINLog_Maxsid'));
 
 //***********************************************************************************************
 
 //ExistingClaimLog  := CHOOSEN(CLUETrans_Build.Files.DS_BASE_Claim_LOG,100);  
 ExistingClaimLog  := CLUETrans_Build.Files.DS_BASE_Claim_LOG;  

//OUTPUT(ExistingClaimLog,,'~thor::base::clue::shrinkkcd::transaction_log_claim.txt', overwrite, __compressed__);
OUTPUT(COUNT(ExistingClaimLog),named('ExistingClaimLog_cnt'));
OUTPUT(MAX(ExistingClaimLog,record_sid),named('ExistingClaimLog_Maxsid'));
 
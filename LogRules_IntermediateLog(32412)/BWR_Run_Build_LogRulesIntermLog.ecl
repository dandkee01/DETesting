IMPORT CustomerSupport;
#WORKUNIT('priority','high');  
#WORKUNIT('priority',10);      
#workunit('name','CS LOG RULES Inquiry History Log - 20240327d');

product	       := 'log_rules';
LogName        := 'log_rules_intermediate_log';
tableName	     := 'intermediate_log';
RunSequence    := '20240327d';
//FlagString     := '[{\'20240325\', 894055}, {\'20240327d\', 144852}]';
//UniXCount  := '1038907';
CustomerSupport.Build_Log_Rules_Intermediate_Log('20240327d').SprayBase_Build;
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString, product, tableName);
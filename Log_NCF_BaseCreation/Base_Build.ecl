IMPORT CustomerSupportFCRA;

#workunit('name','CS LOG NCF Transaction Log Report Code with KCD - 20241109');
product	       := 'log_ncf';
LogName        := 'log_ncf_transaction_log_report_code';
tableName	     := 'transaction_log_report_code';
RunSequence    := '20241109';
//FlagString     := '[{\'20240822c\', 20893}, {\'20240823\', 20893}]';
//UniXCount  := '20893';
CustomerSupportFCRA.Build_ncf_Transaction_Log_Report_Code('20241109').SprayBase_Build;
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString, product, tableName);
IMPORT CustomerSupport;

#workunit('name','CS CCFC Transaction logs Online - 20240414');
LogName        := 'CCFC_TRANO';
RunSequence    := '20240414';
//FlagString     := '[{\'20240409\', 87303}, {\'20240414\', 4148}]';
//UniXCount  := '91451';
sequential(CustomerSupport.Build_CCFC_Trans_Online('20240414').spray_data,CustomerSupport.Build_CCFC_Trans_Online('20240414').base_build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);
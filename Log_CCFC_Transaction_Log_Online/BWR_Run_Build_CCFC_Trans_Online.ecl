IMPORT CustomerSupport;

#workunit('name','CS CCFC Transaction logs Online - 20240125g');
LogName        := 'CCFC_TRANO';
RunSequence    := '20240125g';
//FlagString     := '[{\'20240124\', 127277}, {\'20240125\', 11701}]';
//UniXCount  := '138978';
sequential(CustomerSupport.Build_CCFC_Trans_Online('20240125g').spray_data,CustomerSupport.Build_CCFC_Trans_Online('20240125g').base_build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);

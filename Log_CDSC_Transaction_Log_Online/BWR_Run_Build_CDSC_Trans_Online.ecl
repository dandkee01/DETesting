IMPORT CustomerSupport;

#workunit('name','CDSC Transaction logs Online - 20240126g');
LogName        := 'CDSC_TRANO';
//RunSequence    := '20240126g';
//FlagString     := '[{\'20240125\', 12008}, {\'20240126g\', 1037}]';
//UniXCount  := '13045';
sequential(CustomerSupport.Build_CDSC_Trans_Online('20240126g').spray_data,CustomerSupport.Build_CDSC_Trans_Online('20240126g').base_build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);
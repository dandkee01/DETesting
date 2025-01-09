IMPORT CustomerSupport;

#workunit('name','CDSC Transaction logs Online - 20240414');
LogName        := 'CDSC_TRANO';
RunSequence    := '20240414';
//FlagString     := '[{\'20240409\', 12804}, {\'20240414\', 706}]';
//UniXCount  := '13510';
sequential(CustomerSupport.Build_CDSC_Trans_Online('20240414').spray_data,CustomerSupport.Build_CDSC_Trans_Online('20240414').base_build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);
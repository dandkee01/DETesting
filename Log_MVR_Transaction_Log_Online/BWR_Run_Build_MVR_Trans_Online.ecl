IMPORT CustomerSupportFCRA;

#workunit('name','CS FCRA MVR Tran Online Logs - 20240124d');
LogName        := 'mvr_trano';
RunSequence    := '20240124d';
//FlagString     := '[{\'20240120\', 288595}, {\'20240121\', 39504}]';
//UniXCount  := '328099';
sequential(CustomerSupportFCRA.Build_MVR_Trans_Online('20240124d').spray_data,CustomerSupportFCRA.Build_MVR_Trans_Online('20240124d').base_build,CustomerSupportFCRA.Build_MVR_Trans_Online('20240124d').Keys_Build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);
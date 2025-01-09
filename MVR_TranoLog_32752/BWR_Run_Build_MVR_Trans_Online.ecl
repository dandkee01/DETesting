IMPORT CustomerSupportFCRA;

#workunit('name','CS FCRA MVR Tran Online Logs - 20240421');
LogName        := 'mvr_trano';
RunSequence    := '20240421';
//FlagString     := '[{\'20240414\', 152287}, {\'20240421\', 39872}]';
//UniXCount  := '192159';
sequential(CustomerSupportFCRA.Build_MVR_Trans_Online('20240421').spray_data,CustomerSupportFCRA.Build_MVR_Trans_Online('20240421').base_build,CustomerSupportFCRA.Build_MVR_Trans_Online('20240421').Keys_Build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);
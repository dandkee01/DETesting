IMPORT CustomerSupportFCRA;

#workunit('name','FCRA CS CC Transaction Online logs - 20240128i')
LogName        := 'CC_TranO';
RunSequence    := '20240128i';
//FlagString     := '[{\'20240127\', 110171}, {\'20240128\', 24529}]';
//UniXCount  := '134700';
sequential(CustomerSupportFCRA.Build_CC_Trans_Online('20240128i').spray_data,CustomerSupportFCRA.Build_CC_Trans_Online('20240128i').base_build/*,CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString)*/);
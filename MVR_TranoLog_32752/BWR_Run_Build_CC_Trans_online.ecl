IMPORT CustomerSupportFCRA;

#workunit('name','FCRA CS CC Transaction Online logs - 20240415')
LogName        := 'CC_TranO';
RunSequence    := '20240415';
//FlagString     := '[{\'20240409\', 244867}, {\'20240415\', 36419}]';
//UniXCount  := '281286';
sequential(CustomerSupportFCRA.Build_CC_Trans_Online('20240415').spray_data,CustomerSupportFCRA.Build_CC_Trans_Online('20240415').base_build/*,CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString)*/);
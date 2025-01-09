IMPORT CustomerSupportFCRA;

#workunit('name','Clue MPO Transaction Log Online - 20240430');
LogName        := 'CLUEMPO_TO';
RunSequence    := '20240430';
//FlagString     := '[{\'20240424\', 700072}, {\'20240430\', 64294}]';
//UniXCount  := '764366';
sequential(CustomerSupportFCRA.Build_ClueMPO_Trans_online('20240430').spray_data,CustomerSupportFCRA.Build_ClueMPO_Trans_online('20240430').base_build/*,CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString)*/);
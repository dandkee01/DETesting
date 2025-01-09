IMPORT CustomerSupportFCRA;

#workunit('name','CS FCRA MBSI Transaction Online - 20240430');
LogName        := 'FCRA_MBSI_TranO';
RunSequence    := '20240430';
//FlagString     := '[{\'20240424\', 378522}, {\'20240430\', 38677}]';
//UniXCount  := '417199';
sequential(CustomerSupportFCRA.Build_FCRA_MBSi_Trans_Online('20240430').Spray_Data,CustomerSupportFCRA.Build_FCRA_MBSi_Trans_Online('20240430').Base_Build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);
IMPORT CustomerSupportFCRA;

#workunit('name','CS FCRA MBSI Transaction Online - 20241101');
LogName        := 'FCRA_MBSI_TranO';
RunSequence    := '20241101';
//FlagString     := '[{\'20241021\', 438820}, {\'20241022\', 56223}]';
//UniXCount  := '495043';
sequential(CustomerSupportFCRA.Build_FCRA_MBSi_Trans_Online('20241101').Spray_Data,CustomerSupportFCRA.Build_FCRA_MBSi_Trans_Online('20241101').Base_Build,CustomerSupportFCRA.Build_FCRA_MBSi_Trans_Online('20241101').Keys_Build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString); 
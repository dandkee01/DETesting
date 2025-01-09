#WORKUNIT('priority','high'); 
#WORKUNIT('priority',10); 

IMPORT CustomerSupportFCRA, CustomerSupportLogCounts;

#workunit('name','CS FCRA MVR Tran logs - 20240516b');
LogName        := 'mvr_tranl';
RunSequence    := '20240516b';
FlagString     := '[{\'20231009\', 2370137}, {\'20231010\', 88024}]';
UniXCount  := '2446862';
sequential(CustomerSupportFCRA.Build_MVR_Trans_Log('20231010').spray_data,CustomerSupportFCRA.Build_MVR_Trans_Log('20240516b').base_build,CustomerSupportFCRA.Build_MVR_Trans_Log('20240516b').Keys_Build);
CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);
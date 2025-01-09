#WORKUNIT('priority','high');
#WORKUNIT('priority',10); 
IMPORT CustomerSupport;

#workunit('name','MBSI Transaction Log Online - 20240430');
LogName        := 'mbsi_trano';
RunSequence    := '20240430';
//FlagString     := '[{\'20240424\', 437346}, {\'20240430\', 59786}]';
//UniXCount  := '497132';
sequential(CustomerSupport.Build_MBSi_Trans_Online('20240430').spray_data,CustomerSupport.Build_MBSi_Trans_Online('20240430').base_build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);
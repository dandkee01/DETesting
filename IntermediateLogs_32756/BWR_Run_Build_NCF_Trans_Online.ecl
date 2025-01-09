#WORKUNIT('priority','high');
#WORKUNIT('priority',10);      
IMPORT CustomerSupportFCRA;


#workunit('name','CS FCRA NCF Transaction Online - 20240430');
LogName        := 'NCF_TRANSO';
RunSequence    := '20240430';
//FlagString     := '[{\'20240424\', 646152}, {\'20240430\', 51126}]';
//UniXCount  := '697278';
sequential(CustomerSupportFCRA.Build_NCF_Trans_Online('20240430').Spray_Data,CustomerSupportFCRA.Build_NCF_Trans_Online('20240430').Base_Build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);
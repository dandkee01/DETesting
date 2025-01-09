IMPORT CustomerSupportFCRA;

#workunit('name','Dataenh Transaction Log Online - 20171030');
LogName        := 'FCRA_DE_TranO';
RunSequence    := '20171030';
//FlagString     := '[{\'20240430\', 996323}, {\'20171030\', 123763}]';
//UniXCount  := '1120086';
sequential(CustomerSupportFCRA.Build_DE_Transaction_Log_Online('20171030').Spray_Data,CustomerSupportFCRA.Build_DE_Transaction_Log_Online('20171030').Base_Build,/*CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString)*/);
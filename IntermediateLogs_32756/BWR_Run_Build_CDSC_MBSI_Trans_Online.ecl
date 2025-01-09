IMPORT CustomerSupport;

#workunit('name','CDSC Auto Customer Support logs - 20240520b');
LogName        := 'CDSCAUTO';
//RunSequence    := '20240520b';
//FlagString     := '[{\'20240414\', 9492}, {\'20240520b\', 2095}]';
//UniXCount  := '11587';
sequential(CustomerSupport.Build_CDSCAuto_InquiryHistory('20240520b').Spray_Data,CustomerSupport.Build_CDSCAuto_InquiryHistory('20240520b').Base_Build,CustomerSupport.Build_CDSCAuto_InquiryHistory('20240520b').Keys_Build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);
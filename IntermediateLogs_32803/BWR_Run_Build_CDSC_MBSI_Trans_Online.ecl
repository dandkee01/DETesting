IMPORT CustomerSupport;

#workunit('name','CDSC Auto Customer Support logs - 20240604a');
LogName        := 'CDSCAUTO';
//RunSequence    := '20240604a';
//FlagString     := '[{\'20240414\', 9492}, {\'20240604a\', 2095}]';
//UniXCount  := '11587';
sequential(CustomerSupport.Build_CDSCAuto_InquiryHistory('20240604a').Spray_Data,CustomerSupport.Build_CDSCAuto_InquiryHistory('20240604a').Base_Build,CustomerSupport.Build_CDSCAuto_InquiryHistory('20240604a').Keys_Build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);
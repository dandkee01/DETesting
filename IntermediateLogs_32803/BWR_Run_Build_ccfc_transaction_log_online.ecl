IMPORT CustomerSupport;

#workunit('name','Customer Support CCFC logs - 20240603a');
LogName        := 'CCFC';
//RunSequence    := '20240603a';
//FlagString     := '[{\'20240414\', 42655}, {\'20240603a\', 6964}]';
//UniXCount  := '49619';
sequential(CustomerSupport.Build_CCFC_InquiryHistory('20240603a').Spray_Data,CustomerSupport.Build_CCFC_InquiryHistory('20240603a').Base_Build,CustomerSupport.Build_CCFC_InquiryHistory('20240603a').Keys_Build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);
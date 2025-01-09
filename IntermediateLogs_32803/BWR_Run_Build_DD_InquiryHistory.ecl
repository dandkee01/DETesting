IMPORT CustomerSupport;

#workunit('name','DD Customer Support logs - 20240605a');
LogName        := 'dd';
//RunSequence    := '20240415';
//FlagString     := '[{\'20240414\', 1010965}, {\'20240415\', 301113}]';
//UniXCount  := '1312078';
sequential(CustomerSupport.Build_DD_InquiryHistory('20240605a').Spray_Data,CustomerSupport.Build_DD_InquiryHistory('20240605a').Base_Build,CustomerSupport.Build_DD_InquiryHistory('20240605a').Keys_Build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);
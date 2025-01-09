IMPORT CustomerSupport;

#workunit('name','DD Customer Support logs - 20240514b');
LogName        := 'dd';
//RunSequence    := '20240415';
//FlagString     := '[{\'20240414\', 1010965}, {\'20240415\', 301113}]';
//UniXCount  := '1312078';
sequential(CustomerSupport.Build_DD_InquiryHistory('20240514b').Spray_Data,CustomerSupport.Build_DD_InquiryHistory('20240514b').Base_Build,CustomerSupport.Build_DD_InquiryHistory('20240514b').Keys_Build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);
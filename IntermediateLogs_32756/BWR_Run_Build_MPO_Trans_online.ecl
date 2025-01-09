#WORKUNIT('priority','high');  
#WORKUNIT('priority',10);

import CustomerSupportFCRA;

#workunit('name','Customer Support MPO Intermediate Log - 20240519b');
LogName        := 'MPO';
//RunSequence    := '20240519b';
//FlagString     := '[{\'20240420\', 656436}, {\'20240519b\', 105399}]';
//UniXCount  := '761835';
sequential(CustomerSupportFCRA.Build_MPO_InquiryHistory('20240519b').spray_data,CustomerSupportFCRA.Build_MPO_InquiryHistory('20240519b').base_build,CustomerSupportFCRA.Build_MPO_InquiryHistory('20240519b').Keys_Build);
//CustomerSupportLogCounts.AddCountsToFile(LogName, RunSequence, UniXCount, FlagString);
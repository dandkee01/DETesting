IMPORT CustomerSupportFCRA;

#workunit('name','Customer Support Current Carrier Intermediate logs - 20240808');
LogName        := 'CURRCARR';
RunSequence    := '20240808';
FlagString     := '[{\'20240730\', 4607505}, {\'20240808\', 511042}]';
UniXCount  := '5118547';
//#workunit('priority','high');
sequential(CustomerSupportFCRA.Build_CC_InquiryHistory('20240808').spray_data,CustomerSupportFCRA.Build_CC_InquiryHistory('20240808').base_build,CustomerSupportFCRA.Build_CC_InquiryHistory('20240808').keys_build);
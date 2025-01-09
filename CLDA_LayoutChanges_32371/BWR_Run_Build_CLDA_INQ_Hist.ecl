IMPORT ClaimsDiscoveryAuto_InquiryHistory;
#WORKUNIT('priority','high');
#WORKUNIT('priority',10);  
#workunit('name','Claims Discovery Auto Inquiry History Daily Build');
ClaimsDiscoveryAuto_InquiryHistory.Build_InquiryHistory('20240322a');
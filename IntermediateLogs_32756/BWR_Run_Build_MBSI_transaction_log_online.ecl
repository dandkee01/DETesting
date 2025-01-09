IMPORT CustomerSupport;

#workunit('name','CS MBSI Intermediate logs - 20240611a')
sequential(CustomerSupport.Build_MBSi_InquiryHistory('20240611a').spray_data,CustomerSupport.Build_MBSi_InquiryHistory('20240611a').base_build,CustomerSupport.Build_MBSi_InquiryHistory('20240611a').keys_build/*,fileservices.despray('~thor_data400::out::csMbsi::scoring::complete',_control.IPAddress.prodlz,'/insdataops/mbsilogs/intermediatelog/flags/csMbsiComplete.flag',,,,true)*/);
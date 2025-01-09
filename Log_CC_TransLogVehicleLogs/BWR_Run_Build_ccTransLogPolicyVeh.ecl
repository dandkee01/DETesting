IMPORT CustomerSupportFCRA;
#WORKUNIT('priority','high');  
#WORKUNIT('priority',10);
#workunit('name','FCRA CS CC Transaction Policy Vehicle logs - 20240401a')
LogName        := 'CC_TranlPolicyveh';
RunSequence    := '20240401b';
//FlagString     := '[{\'20240331\', 916641}, {\'20240401\', 294797}]';
//UniXCount  := '1211438';
sequential(CustomerSupportFCRA.Build_CC_Translog_PolicyVehicle('20240401b').spray_data,CustomerSupportFCRA.Build_CC_Translog_PolicyVehicle('20240401b').base_build,CustomerSupportFCRA.Build_FCRA_Vehicle_Keys('20240401b').build_key_tranid);
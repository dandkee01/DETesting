IMPORT CustomerSupportFCRA, FCRA_Inquiry_History;
#Workunit('priority' ,'high');
#Workunit('priority',10);
#workunit('name','CS FCRA Delta Inquiry Hist - 20240506');

FCRA_Inquiry_History.Build_DeltaInqHist_DeltaKey('20240506').SprayBase_Build;
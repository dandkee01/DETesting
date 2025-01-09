#WORKUNIT('priority','high');  
#WORKUNIT('priority',10);      

IMPORT CustomerSupport;

rc_file1 := '~base::mbsi::inquiry_history::20240529a::id';    
base_ds1 := DATASET(rc_file1, CustomerSupport.Layouts.Layout_NCF_InquiryHistory_Data_new, THOR);

rc_file := '~base::mbsi::inquiry_history::20240611::id';  
base_ds2 := DATASET(rc_file, CustomerSupport.Layouts.Layout_NCF_InquiryHistory_Data_new, THOR);

newRecs := base_ds2-base_ds1;
OUTPUT(SORT(newRecs,record_sid), named('newRecs'));

RecordSid_set := SET(newRecs,record_sid);

OUTPUT(base_ds1(record_sid IN RecordSid_set),named('Common_RecordSid_Recs'));

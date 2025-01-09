#WORKUNIT('priority','high');  
#WORKUNIT('priority',10);      

IMPORT CustomerSupport;

rc_file1 := '~base::ccfc::inquiry_history::adhoc_kcd1::id';    
base_ds1 := DATASET(rc_file1, CustomerSupport.Layouts.Layout_InquiryHistory_CCFC_Data, THOR);

rc_file := '~base::ccfc::inquiry_history::20240515b::id';  
base_ds2 := DATASET(rc_file, CustomerSupport.Layouts.Layout_InquiryHistory_CCFC_Data, THOR);

newRecs := base_ds2-base_ds1;
OUTPUT(newRecs, named('newRecs'));

RecordSid_set := SET(newRecs,record_sid);

OUTPUT(base_ds1(record_sid IN RecordSid_set),named('Common_RecordSid_Recs'));

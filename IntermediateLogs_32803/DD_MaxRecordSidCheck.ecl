#WORKUNIT('priority','high');  
#WORKUNIT('priority',10);      

IMPORT CustomerSupport;

rc_file1 := '~base::dd::inquiry_history::20240514::id';    
base_ds1 := DATASET(rc_file1, CustomerSupport.Layouts.Layout_InquiryHistory_DD_Data, THOR);

rc_file := '~base::dd::inquiry_history::20240605::id';  
base_ds2 := DATASET(rc_file, CustomerSupport.Layouts.Layout_InquiryHistory_DD_Data, THOR);

newRecs := base_ds2-base_ds1;
OUTPUT(SORT(newRecs,-record_sid), named('MaxFirst_newRecs'));
//OUTPUT(SORT(newRecs,record_sid), named('MinFirst_newRecs'));

RecordSid_set := SET(newRecs,record_sid);

OUTPUT(base_ds1(record_sid IN RecordSid_set),named('Common_RecordSid_Recs'));

#WORKUNIT('priority','high');  
#WORKUNIT('priority',10);      

IMPORT CustomerSupport;

rc_file1 := '~base::cdscauto::inquiry_history::20240520b::id';    
base_ds1 := DATASET(rc_file1, CustomerSupport.Layouts.Layout_InquiryHistory_CDSC_Auto_Data, THOR);

rc_file := '~base::cdscauto::inquiry_history::20240604::id';  
base_ds2 := DATASET(rc_file, CustomerSupport.Layouts.Layout_InquiryHistory_CDSC_Auto_Data, THOR);

newRecs := base_ds2-base_ds1;
OUTPUT(SORT(newRecs,-record_sid), named('newRecs'));

Transactionid_set := SET(newRecs,TRIM(transaction_id,LEFT,RIGHT));

OUTPUT(base_ds1(TRIM(transaction_id,LEFT,RIGHT) IN Transactionid_set),named('Common_TransactionID_Recs'));

#WORKUNIT('priority','high');  
#WORKUNIT('priority',10);      

IMPORT CustomerSupport;

/*rc_file1 := '~base::ccfc::inquiry_history::20240603::id';    
base_ds1 := DATASET(rc_file1, CustomerSupport.Layouts.Layout_InquiryHistory_CCFC_Data, THOR);*/

rc_file := '~base::ccfc::inquiry_history::20240603a::id';  
base_ds2 := DATASET(rc_file, CustomerSupport.Layouts.Layout_InquiryHistory_CCFC_Data, THOR);

/*newRecs := base_ds2-base_ds1;
OUTPUT(SORT(newRecs,record_sid), named('newRecs'));

Transactionid_set := SET(newRecs,TRIM(transaction_id,LEFT,RIGHT));

OUTPUT(base_ds1(TRIM(transaction_id,LEFT,RIGHT) IN Transactionid_set),named('Common_TransactionID_Recs'));*/

COUNT(base_ds2);
COUNT(DEDUP(base_ds2, record_sid));
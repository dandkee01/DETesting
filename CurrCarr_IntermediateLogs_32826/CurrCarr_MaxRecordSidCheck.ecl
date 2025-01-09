#WORKUNIT('priority','high');  
#WORKUNIT('priority',10);      

IMPORT CustomerSupport;

base_ds1 := DATASET('~base::currcarr::inquiry_history::20240808::id',CustomerSupport.Layouts.Layout_InquiryHistory_CurrCarr_Data, THOR);

base_ds2 := DATASET('~base::currcarr::inquiry_history::adhoc_kcd0808::id',CustomerSupport.Layouts.Layout_InquiryHistory_CurrCarr_Data, THOR);

newRecs := base_ds1-base_ds2;
OUTPUT(SORT(newRecs,-record_sid), named('MaxFirst_newRecs'));
OUTPUT(SORT(newRecs,record_sid), named('MinFirst_newRecs'));

RecordSid_set := SET(newRecs,record_sid);

OUTPUT(base_ds2(record_sid IN RecordSid_set),named('Common_RecordSid_Recs'));

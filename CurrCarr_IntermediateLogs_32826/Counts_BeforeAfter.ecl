IMPORT CustomerSupport;

rc_file := '~base::currcarr::inquiry_history::slim_kcd::id';    //Remote copied file from Prod

base_ds := DATASET(rc_file, CustomerSupport.Layouts.Layout_InquiryHistory_CurrCarr_Data, THOR);

OUTPUT(COUNT(base_ds),named('Count_Before'));

rc_file1 := '~base::currcarr::inquiry_history::adhoc_kcd0808::id';    //Remote copied file from Prod

base_ds1 := DATASET(rc_file1, CustomerSupport.Layouts.Layout_InquiryHistory_CurrCarr_Data, THOR);

OUTPUT(COUNT(base_ds1),named('Count_After'));
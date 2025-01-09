IMPORT CustomerSupport;

rc_file := '~base::cdscauto::inquiry_history::20240520a::id';    //Remote copied file from Prod

base_ds := DATASET(rc_file, CustomerSupport.Layouts.Layout_InquiryHistory_CDSC_Auto_Data, THOR);
OUTPUT(COUNT(base_ds),named('Count_Before'));

rc_file2 := '~base::cdscauto::inquiry_history::adhoc::id';    //Remote copied file from Prod

base_ds1 := DATASET(rc_file2, CustomerSupport.Layouts.Layout_InquiryHistory_CDSC_Auto_Data, THOR);
OUTPUT(COUNT(base_ds1),named('Count_After'));
OUTPUT(max(base_ds1, record_sid),named('Max_recordsid'));

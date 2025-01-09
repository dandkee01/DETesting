IMPORT CustomerSupport;

rc_file := '~base::mbsi::inquiry_history::20240524b::id';    //Remote copied file from Prod

base_ds := DATASET(rc_file, CustomerSupport.Layouts.Layout_NCF_InquiryHistory_Data_new, THOR);
OUTPUT(COUNT(base_ds),named('Count_Before'));

rc_file2 := '~base::mbsi::inquiry_history::adhoc_kcd::id';    //Remote copied file from Prod

base_ds1 := DATASET(rc_file2, CustomerSupport.Layouts.Layout_NCF_InquiryHistory_Data_new, THOR);
OUTPUT(COUNT(base_ds1),named('Count_After'));
OUTPUT(max(base_ds1, record_sid),named('Max_recordsid'));

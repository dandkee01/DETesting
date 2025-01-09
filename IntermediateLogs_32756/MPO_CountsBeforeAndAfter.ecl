IMPORT CustomerSupport;

rc_file1 := '~base::mpo::inquiry_history::20240519b::id';    //Remote copied file from Prod

base_ds1 := DATASET(rc_file1, CustomerSupport.Layouts.Layout_InquiryHistory_MPO_Data, THOR);
OUTPUT(COUNT(base_ds1),named('Count_Before'));

rc_file2 := '~base::mpo::inquiry_history::adhoc::id';    

base_ds2 := DATASET(rc_file2, CustomerSupport.Layouts.Layout_InquiryHistory_MPO_Data, THOR);
OUTPUT(COUNT(base_ds2),named('Count_After'));

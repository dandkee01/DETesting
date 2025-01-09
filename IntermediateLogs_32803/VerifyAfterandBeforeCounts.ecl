IMPORT CustomerSupport;

rc_file1 := '~base::ccfc::inquiry_history::20240515_prod::id';    //Remote copied file from Prod

base_dsP := DATASET(rc_file1, CustomerSupport.Layouts.Layout_InquiryHistory_CCFC_Data, THOR);

rc_file2 := '~base::ccfc::inquiry_history::adhoc_kcd1::id';    //Remote copied file from Prod

base_dsD := DATASET(rc_file2, CustomerSupport.Layouts.Layout_InquiryHistory_CCFC_Data, THOR);

OUTPUT(COUNT(base_dsP),named('count_before'));
OUTPUT(COUNT(base_dsD),named('count_after'));
IMPORT CustomerSupport, std;

rc_file := '~base::dd::inquiry_history::qa::id';    //Remote copied file from Prod

base_ds := DATASET(rc_file, CustomerSupport.Layouts.Layout_InquiryHistory_DD_Data, THOR);
OUTPUT(COUNT(base_ds),named('Count_Before'));

// Sorted_ds := SORT(base_ds, transaction_id, product_id, date_added, process_type,processing_time, vendor_code, request_type, product_version, reference_number, -LENGTH(TRIM(CONTENT_DATA)));

Updated_Base := PROJECT (base_ds, TRANSFORM(CustomerSupport.Layouts.Layout_InquiryHistory_DD_Data, 
                                                       SELF.Record_Sid := COUNTER;
                                                       SELF.delta_ind := 1;
                                                       SELF.dt_effective_first := std.date.Today();
                                                       SELF := LEFT; 
                                                       SELF := [])):INDEPENDENT;
max(Updated_base, record_sid);

Distributed_ds := SORT(DISTRIBUTE(Updated_base, HASH(transaction_id,product_id,date_added, process_type)), 
                               transaction_id, product_id, date_added, process_type,processing_time, vendor_code, request_type, product_version, reference_number, -LENGTH(TRIM(CONTENT_DATA)), LOCAL);

filename := '~base::dd::inquiry_history::adhoc_kcd0510::id';                                                       
OUTPUT(Distributed_ds,, filename, overwrite, __compressed__, named('base_test'));
OUTPUT(COUNT(Distributed_ds),named('Count_After'));


base := '~base::dd::inquiry_history::qa::id';  
std.file.clearsuperfile(base);
std.file.addsuperfile(base, filename);
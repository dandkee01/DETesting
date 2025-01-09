#WORKUNIT('priority','high');  
#WORKUNIT('priority',10);  

IMPORT CustomerSupport, std;

rc_file := '~base::mpo::inquiry_history::20240519b::id';    //Remote copied file from Prod

base_ds := DATASET(rc_file, CustomerSupport.Layouts.Layout_InquiryHistory_MPO_Data, THOR);

//OUTPUT(COUNT(base_ds),named('Count_Before'));

// Sorted_ds := SORT(base_ds, transaction_id, product_id, date_added, process_type,processing_time, vendor_code, request_type, product_version, reference_number, -LENGTH(TRIM(CONTENT_DATA)));

Updated_Base := PROJECT (base_ds, TRANSFORM(CustomerSupport.Layouts.Layout_InquiryHistory_MPO_Data, 
                                                       SELF.Record_Sid := COUNTER;
                                                       SELF.delta_ind := 1;
                                                       SELF.dt_effective_first := std.date.Today();
                                                       SELF := LEFT; 
                                                       SELF := []));
//OUTPUT(max(Updated_base, record_sid),named('Max_RecordSid'));

Distributed_ds := SORT(DISTRIBUTE(Updated_base, HASH(transaction_id,product_id,date_added, process_type)), 
                               transaction_id, product_id, date_added, process_type,processing_time, vendor_code, request_type, product_version, reference_number, -LENGTH(TRIM(CONTENT_DATA)), LOCAL);
//OUTPUT(COUNT(Distributed_ds), named('Count_After'));
filename := '~base::mpo::inquiry_history::adhoc::id';                                                       
OUTPUT(Distributed_ds,, filename, overwrite, __compressed__, named('base_test'));

base := '~base::mpo::inquiry_history::qa::id';  
std.file.clearsuperfile(base);
std.file.addsuperfile(base, filename);
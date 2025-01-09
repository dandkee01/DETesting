IMPORT CustomerSupport, STD;

rc_file := '~base::currcarr::inquiry_history::qa::id';    //Remote copied file from Prod

base_ds := DATASET(rc_file, CustomerSupport.Layouts.Layout_InquiryHistory_CurrCarr_Data, THOR);

// Sorted_ds := SORT(base_ds, transaction_id, product_id, date_added, process_type,processing_time, vendor_code, request_type, product_version, reference_number, -LENGTH(TRIM(CONTENT_DATA)));

Updated_Base := PROJECT (base_ds, TRANSFORM(CustomerSupport.Layouts.Layout_InquiryHistory_CurrCarr_Data, 
                                                       SELF.Record_Sid := COUNTER;
                                                       SELF.delta_ind := 1;
                                                       SELF.dt_effective_first := std.date.Today();
                                                       SELF := LEFT; 
                                                       SELF := []));
OUTPUT(max(Updated_base, record_sid), named('Max_record_sid'));

Distributed_ds := SORT(DISTRIBUTE(Updated_base, HASH(transaction_id,product_id,date_added, process_type)), 
                               transaction_id, product_id, date_added, process_type,processing_time, vendor_code, request_type, product_version, reference_number, -LENGTH(TRIM(CONTENT_DATA)), LOCAL);

filename := '~base::currcarr::inquiry_history::adhoc_kcd0808::id';                                                       
OUTPUT(Distributed_ds,, filename, overwrite, __compressed__, named('base_test'));

base := '~base::currcarr::inquiry_history::qa::id';  
std.file.clearsuperfile(base);
std.file.addsuperfile(base, filename);
IMPORT CustomerSupport, STD;

rc_file := '~base::currcarr::inquiry_history::qa::id';    //Remote copied file from Prod

layout := RECORD
  string transaction_id;
  string11 product_id;
  string19 date_added;
  string4 process_type;
  string8 processing_time;
  string10 vendor_code;
  string20 request_type;
  string20 product_version;
  string15 reference_number;
  string content_data{blob, maxlength(2000000)};
  unsigned4 global_sid;
  unsigned8 record_sid;
 END;
 
base_ds := DATASET(rc_file,layout, THOR);


Slim_DS := CHOOSEN(SORT(base_ds,-date_added),10000);
max(Slim_DS, record_sid);

Distributed_ds := SORT(DISTRIBUTE(Slim_DS, HASH(transaction_id,product_id,date_added, process_type)), 
                               transaction_id, product_id, date_added, process_type,processing_time, vendor_code, request_type, product_version, reference_number, -LENGTH(TRIM(CONTENT_DATA)), LOCAL);

filename := '~base::currcarr::inquiry_history::slim_kcd::id';                                                       
OUTPUT(Distributed_ds,, filename, overwrite, __compressed__, named('base_test'));

base := '~base::currcarr::inquiry_history::qa::id';  
std.file.clearsuperfile(base,false);
std.file.addsuperfile(base, filename);

Key_subject := RECORD
  string16 transaction_id
  =>
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
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

Key   := INDEX(Key_subject,'~key::mbsi::inquiry_history::20240529a::trans_id');
OUTPUT(SORT(Key,-dt_effective_first),named('MBSI_Key_subject'));
OUTPUT(SORT(Key,dt_effective_first),named('MBSI_Key_subjectold'));

OUTPUT(COUNT(Key), named('key_total_recs'));
OUTPUT(sort(Key,-record_sid), named('key_records_sorted'));

output(count(key(record_sid<>0)),named('key_record_sid_notZero'));
output(count(key(record_sid=0)),named('key_record_sid_Zero'));
output(max(key,record_sid),named('max_record_sid'));

output(count(key(dt_effective_first<>0)),named('key_dt_effective_first_notZero'));
output(count(key(dt_effective_first=0)),named('key_dt_effective_first_Zero'));

output(count(key(dt_effective_last<>0)),named('key_dt_effective_last_notZero'));
output(count(key(dt_effective_last=0)),named('key_dt_effective_last_Zero'));

output(count(key(delta_ind=1)),named('key_delta_ind_one'));
output(count(key(delta_ind<>1)),named('key_delta_ind_notone'));


 

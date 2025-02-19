/*transid_Key := RECORD
  string30 lex_id
  =>
  string30 product_id;
  string19 inquiry_date;
  string20 transaction_id;
  string19 date_added;
  string5 customer_number;
  string9 customer_account;
  string9 ssn;
  string25 drivers_license_number;
  string2 drivers_license_state;
  string20 name_first;
  string20 name_last;
  string20 name_middle;
  string20 name_suffix;
  string90 addr_street;
  string25 addr_city;
  string2 addr_state;
  string5 addr_zip5;
  string4 addr_zip4;
  string10 dob;
  string20 transaction_location;
  string3 ppc;
  string1 internal_identifier;
  string5 eu1_customer_number;
  string9 eu1_customer_account;
  string5 eu2_customer_number;
  string9 eu2_customer_account;
  integer4 seq_num;
  string20 suppressionalerts;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;



Key   := INDEX(transid_Key,'~thor::key::fcra::delta_inq_hist::transid_Key::20250203k::lexid'); */

transid_Key := RECORD
  string20 transaction_id;
  string30 product_id
  =>
  string30 lex_id;
  string20 suppressionalerts;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;



Key   := INDEX(transid_Key,'~thor::key::fcra::delta_inq_hist::delta_key::20250203k::transid');



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
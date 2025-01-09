lay1 :=RECORD
  string3 subject_unit_number;
  string20 last_name;
  string20 first_name;
  string9 ssn;
  string8 dob;
  string9 house_number;
  string20 street_name;
  string2 state;
  string5 zip;
  string25 dl_number;
  string2 dl_state;
  string14 reference_number;
  string6 account_number;
  string3 account_suffix;
  string1 post_non_post_flag;
  string5 customer_number;
  string8 process_date;
  string40 account_name;
  string1 service_type;
  string60 quoteback;
  string19 date_added;
  string20 transaction_id;
  string1 post_non_post;
  string3 unit_number;
  unsigned8 lexid;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

base := DATASET('~thor::base::currentcarrier::20231227::delta_key.txt',lay1, THOR);


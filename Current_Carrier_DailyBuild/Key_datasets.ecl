ccorder_prod_ssn := RECORD
  string9 ssn;
  string5 customer_number
  =>
  string3 subject_unit_number;
  string20 last_name;
  string20 first_name;
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
 
 DS_ccorder_prod_ssn   := INDEX(ccorder_prod_ssn,'~thor::key::currentcarrier::ccorder_prod_ssn_qa');
 OUTPUT(SORT(DS_ccorder_prod_ssn,-dt_effective_first),named('DS_ccorder_prod_ssn'));;

ccorder_prod_name := RECORD
  string20 last_name;
  string20 first_name;
  string5 customer_number
  =>
  string3 subject_unit_number;
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

DS_ccorder_prod_name   := INDEX(ccorder_prod_name,'~thor::key::currentcarrier::ccorder_prod_name_qa');
OUTPUT(SORT(DS_ccorder_prod_name,-dt_effective_first),named('DS_ccorder_prod_name'));

ccorder_prod_address := RECORD
  string5 zip;
  string20 street_name;
  string9 house_number;
  string5 customer_number
  =>
  string3 subject_unit_number;
  string20 last_name;
  string20 first_name;
  string9 ssn;
  string8 dob;
  string2 state;
  string25 dl_number;
  string2 dl_state;
  string14 reference_number;
  string6 account_number;
  string3 account_suffix;
  string1 post_non_post_flag;
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

DS_ccorder_prod_address   := INDEX(ccorder_prod_address,'~thor::key::currentcarrier::ccorder_prod_address_qa');
OUTPUT(SORT(DS_ccorder_prod_address,-dt_effective_first),named('DS_ccorder_prod_address'));


ccorder_prod_dl := RECORD
  string25 dl_number;
  string2 dl_state;
  string5 customer_number
  =>
  string3 subject_unit_number;
  string20 last_name;
  string20 first_name;
  string9 ssn;
  string8 dob;
  string9 house_number;
  string20 street_name;
  string2 state;
  string5 zip;
  string14 reference_number;
  string6 account_number;
  string3 account_suffix;
  string1 post_non_post_flag;
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


DS_ccorder_prod_dl   := INDEX(ccorder_prod_dl,'~thor::key::currentcarrier::ccorder_prod_dl_qa');
OUTPUT(SORT(DS_ccorder_prod_dl,-dt_effective_first),named('DS_ccorder_prod_dl'));


ccorder_prod_lexid := RECORD
  unsigned8 lexid;
  string5 customer_number
  =>
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
  string8 process_date;
  string40 account_name;
  string1 service_type;
  string60 quoteback;
  string19 date_added;
  string20 transaction_id;
  string1 post_non_post;
  string3 unit_number;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

DS_ccorder_prod_lexid   := INDEX(ccorder_prod_lexid,'~thor::key::currentcarrier::ccorder_prod_lexid_qa');
OUTPUT(SORT(DS_ccorder_prod_lexid,-dt_effective_first),named('DS_ccorder_prod_lexid'));

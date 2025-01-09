ssn := RECORD
  string9 ssn;
  string5 customer_number;
  string1 type_of_report
  =>
  string20 transaction_id;
  string14 reference_number;
  string8 date_added;
  string30 full_last_name;
  string20 full_first_name;
  string20 last_name;
  string5 first_name;
  string8 dob;
  string9 spouse_ssn;
  string20 spouse_last_name;
  string20 spouse_first_name;
  string8 spouse_dob;
  string9 house_number;
  string20 street_name;
  string2 state;
  string2 rating_state;
  string5 zip;
  string4 zip4;
  string1 beacon;
  string1 safe_scan;
  string1 emperica;
  string1 hawk;
  string1 facs;
  string4 score_model_1;
  string4 score_model_2;
  string4 score_model_3;
  string4 score_model_4;
  string4 score_model_5;
  string4 score_model_6;
  string4 score_model_7;
  string4 score_model_8;
  string2 score_ind;
  string1 input_type;
  string1 test_prod_ind;
  string1 first_vendor;
  string1 second_vendor;
  string1 final_vendor;
  string8 order_date;
  string3 order_status;
  string1 model_version1;
  string1 model_version2;
  string1 dispute_flag;
  unsigned8 lexid;
  unsigned8 spouse_lexid;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

 
 DS_ssn   := INDEX(ssn,'~thor::key::ncf::20240208::delta_key.txt_ssn');
 OUTPUT(SORT(DS_ssn,-dt_effective_first),named('DS_ssn'));;

name := RECORD
  string20 last_name;
  string5 first_name;
  string5 customer_number;
  string1 type_of_report
  =>
  string20 transaction_id;
  string14 reference_number;
  string8 date_added;
  string9 ssn;
  string30 full_last_name;
  string20 full_first_name;
  string8 dob;
  string9 spouse_ssn;
  string20 spouse_last_name;
  string20 spouse_first_name;
  string8 spouse_dob;
  string9 house_number;
  string20 street_name;
  string2 state;
  string2 rating_state;
  string5 zip;
  string4 zip4;
  string1 beacon;
  string1 safe_scan;
  string1 emperica;
  string1 hawk;
  string1 facs;
  string4 score_model_1;
  string4 score_model_2;
  string4 score_model_3;
  string4 score_model_4;
  string4 score_model_5;
  string4 score_model_6;
  string4 score_model_7;
  string4 score_model_8;
  string2 score_ind;
  string1 input_type;
  string1 test_prod_ind;
  string1 first_vendor;
  string1 second_vendor;
  string1 final_vendor;
  string8 order_date;
  string3 order_status;
  string1 model_version1;
  string1 model_version2;
  string1 dispute_flag;
  unsigned8 lexid;
  unsigned8 spouse_lexid;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

DS_name   := INDEX(name,'~thor::key::ncf::20240208::delta_key.txt_name');
OUTPUT(SORT(DS_name,-dt_effective_first),named('DS_name'));

address := RECORD
  string5 zip;
  string20 street_name;
  string9 house_number;
  string5 customer_number;
  string1 type_of_report
  =>
  string20 transaction_id;
  string14 reference_number;
  string8 date_added;
  string9 ssn;
  string30 full_last_name;
  string20 full_first_name;
  string20 last_name;
  string5 first_name;
  string8 dob;
  string9 spouse_ssn;
  string20 spouse_last_name;
  string20 spouse_first_name;
  string8 spouse_dob;
  string2 state;
  string2 rating_state;
  string4 zip4;
  string1 beacon;
  string1 safe_scan;
  string1 emperica;
  string1 hawk;
  string1 facs;
  string4 score_model_1;
  string4 score_model_2;
  string4 score_model_3;
  string4 score_model_4;
  string4 score_model_5;
  string4 score_model_6;
  string4 score_model_7;
  string4 score_model_8;
  string2 score_ind;
  string1 input_type;
  string1 test_prod_ind;
  string1 first_vendor;
  string1 second_vendor;
  string1 final_vendor;
  string8 order_date;
  string3 order_status;
  string1 model_version1;
  string1 model_version2;
  string1 dispute_flag;
  unsigned8 lexid;
  unsigned8 spouse_lexid;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

DS_address   := INDEX(address,'~thor::key::ncf::20240208::delta_key.txt_address');
OUTPUT(SORT(DS_address,-dt_effective_first),named('DS_address'));

lexid := RECORD
  unsigned8 lexid;
  string5 customer_number;
  string1 type_of_report
  =>
  string20 transaction_id;
  string14 reference_number;
  string8 date_added;
  string9 ssn;
  string30 full_last_name;
  string20 full_first_name;
  string20 last_name;
  string5 first_name;
  string8 dob;
  string9 spouse_ssn;
  string20 spouse_last_name;
  string20 spouse_first_name;
  string8 spouse_dob;
  string9 house_number;
  string20 street_name;
  string2 state;
  string2 rating_state;
  string5 zip;
  string4 zip4;
  string1 beacon;
  string1 safe_scan;
  string1 emperica;
  string1 hawk;
  string1 facs;
  string4 score_model_1;
  string4 score_model_2;
  string4 score_model_3;
  string4 score_model_4;
  string4 score_model_5;
  string4 score_model_6;
  string4 score_model_7;
  string4 score_model_8;
  string2 score_ind;
  string1 input_type;
  string1 test_prod_ind;
  string1 first_vendor;
  string1 second_vendor;
  string1 final_vendor;
  string8 order_date;
  string3 order_status;
  string1 model_version1;
  string1 model_version2;
  string1 dispute_flag;
  unsigned8 spouse_lexid;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;
DS_lexid   := INDEX(lexid,'~thor::key::ncf::20240208::delta_key.txt_lexid');
OUTPUT(SORT(DS_lexid,-dt_effective_first),named('DS_lexid'));

delta_report := RECORD
  string20 transaction_id
  =>
  unsigned2 juliandate;
  unsigned4 remainingrefno;
  unsigned1 reportsource;
  unsigned2 linenumber;
  string230 edits;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;


DS_delta_report   := INDEX(delta_report,'~thor::key::ncf::20240208::delta_report.txt');
OUTPUT(SORT(DS_delta_report,-dt_effective_first),named('DS_delta_report'));

cs_delta_report := RECORD
  string20 transaction_id
  =>
  unsigned2 juliandate;
  unsigned4 remainingrefno;
  unsigned1 reportsource;
  unsigned2 linenumber;
  string230 edits;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;


DS_cs_delta_report   := INDEX(cs_delta_report,'~thor::key::ncf::20240208::cs_delta_report');
OUTPUT(SORT(DS_cs_delta_report,-dt_effective_first),named('DS_cs_delta_report'));



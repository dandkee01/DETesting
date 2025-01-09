Key_subject := RECORD
  string5 customer_no;
  string1 search_type;
  string1 secondary_report;
  string8 process_date
  =>
  string20 reference_no;
  string20 transaction_id;
  integer3 sequence;
  string8 order_date;
  string9 account_no;
  string8 policy_eff_date;
  string12 line_of_business;
  string120 business_name;
  string50 last_name;
  string50 first_name;
  string15 middle_name;
  string4 suffix_name;
  string8 dob;
  string25 drivers_license_no;
  string2 drivers_license_state;
  string1 address_ind;
  string9 house_no;
  string40 street_name;
  string5 apt_no;
  string30 city;
  string2 state;
  string5 zip5;
  string4 zip4;
  string25 prior_policy_no;
  string8 prior_policy_eff_date;
  string119 individual_name_key;
  string60 address_key;
  string33 prior_policy_key;
  string1 clda_ordered;
  string1 cldp_ordered;
  string1 secondary_report_clda;
  string1 secondary_report_cldp;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;


DS_Key_subject   := INDEX(Key_subject,'~thor::key::cclue::priorhist::kcd::20240901f::subject');
DS_Key_Subject(last_name<>'' AND first_name<>'');
// OUTPUT(SORT(DS_Key_subject,-dt_effective_first),named('DS_Key_subject'));
// OUTPUT(SORT(DS_Key_subject,dt_effective_first),named('DS_Key_subjectold'));
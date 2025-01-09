﻿#WORKUNIT('priority','high'); 
#WORKUNIT('priority',10);  

cleaned_data := RECORD
   string120 c_business_name;
   string50 c_last_name;
   string50 c_first_name;
   string15 c_middle_name;
   string4 c_suffix_name;
   string6 addr_error_code;
   string10 prim_range;
   string2 predir;
   string28 prim_name;
   string4 addr_suffix;
   string2 postdir;
   string10 unit_desig;
   string2 record_type;
   string8 sec_range;
   string30 c_city;
   string2 c_st;
   string5 c_zip5;
   string4 c_zip4;
  END;

layout := RECORD
  string20 transaction_id;
  integer3 sequence;
  string20 reference_no;
  string8 order_date;
  string8 process_date;
  string25 date_added;
  string9 account_no;
  string5 customer_no;
  string1 search_type;
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
  string1 secondary_report;
  integer3 count_business;
  integer3 count_individual;
  integer3 count_lob;
  integer3 count_prior_policy_no;
  integer3 count_address_primary;
  integer3 count_address_mailing;
  integer3 count_address_prior;
  integer3 count_address_total;
  string119 individual_name_key;
  string60 address_key;
  string33 prior_policy_key;
  string1 clda_ordered;
  string1 cldp_ordered;
  string1 secondary_report_clda;
  string1 secondary_report_cldp;
  cleaned_data clean_inq;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;
file1 := '~thor::base::cclue::priorhist::kcd::20240815a::subject'; // this data is copied from production - 
DS0 := DATASET(file1,layout,THOR);
DS1 := DISTRIBUTE(DS0, HASH32(reference_no,sequence));

file2 := '~thor::base::cclue::priorhist::kcd::20240815::subject';
DS2 := DATASET(file2,layout,THOR);
output(DS2(TRIM(transaction_id,left,right) = '17811831U1383285');
OUTPUT(COUNT(DS1), named('Prod_Count'));
Deduped_DS1 := DEDUP (SORT (DS1,reference_no,sequence,LOCAL),reference_no,sequence,LOCAL);
OUTPUT(COUNT(Deduped_DS1), named('Dedup_Prod_Count'));
OUTPUT(COUNT(DS2), named('Dev_Count'));
Deduped_DS2 := DEDUP (SORT (DS2,reference_no,sequence,LOCAL),reference_no,sequence,LOCAL);
OUTPUT(COUNT(Deduped_DS2), named('Dedup_Dev_Count'));



/*droppedrecs := DS1-DS2;
ref_Set := SET(droppedrecs,reference_no);
OUTPUT(droppedrecs, named('droppedrecs'));
OUTPUT(COUNT(DS1), named('Prod_Count'));
OUTPUT(COUNT(DEDUP(DS1)), named('Dedup_Prod_Count'));
OUTPUT(COUNT(DS2), named('Dev_Count'));
OUTPUT(COUNT(droppedrecs), named('droppedrecs_Count'));

ProdRecs := DS1(reference_no='24191004710502', sequence=1);      
OUTPUT(ProdRecs,named('prodRecs'));
DevRecs := DS2(reference_no='24191004710502', sequence=1);      
OUTPUT(DevRecs,named('DevRecs'));*/
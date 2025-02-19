﻿IMPORT ut;
lay := RECORD
  unsigned8 lex_id;
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
  unsigned6 did;
  integer2 xlink_weight;
  unsigned2 xlink_score;
  integer1 xlink_distance;
  unsigned8 address_id;
  string10 prim_range;
  string2 predir;
  string28 prim_name;
  string4 addr_suffix;
  string2 postdir;
  string10 unit_desig;
  string8 sec_range;
  string25 city;
  string2 st;
  string5 zip;
  string4 zip4;
  string4 error_code;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

prod_ds:= dataset('~thor::base::fcra::delta_inq_hist::20250212::delta_key',lay,thor); // father file version
Slim_prod_ds := CHOOSEN(SORT(prod_ds,-date_added),10000);
Dist_ProdDs  := DISTRIBUTE (Slim_prod_ds,HASH64(lex_id,transaction_id,product_id,date_added,seq_num));
output(Dist_ProdDs,,'~thor::base::fcra::delta_inq_hist::20250212k::delta_key',compressed,overwrite);





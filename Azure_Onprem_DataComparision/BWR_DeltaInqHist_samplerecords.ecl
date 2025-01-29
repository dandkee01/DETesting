IMPORT Std,_control;

Lay := RECORD
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
 END;



Azure_File := '~thor::base::azure::fcra::delta_inq_hist::20250122a::delta_key';

Azure_DS := SORT(DATASET(Azure_File,Lay,THOR),-transaction_id,product_id,customer_number,customer_account,seq_num);

//Azure_DS(transaction_id='18500963R566417');     

OnPrem_File := '~thor::base::onprem::fcra::delta_inq_hist::20250122op::delta_key';

OnPrem_DS := SORT(DATASET(OnPrem_File,Lay,THOR),-transaction_id,product_id,customer_number,customer_account,seq_num);



OUTPUT(Azure_DS(transaction_id IN ['PDW250121223315VW7U4','PDW250122011150ZKSVM','PDW250122001422EGHD6','PDW250121200455BJU2F','PDW250121200049SD9ZS']),named('Special_Charecters_Azure'));
OUTPUT(OnPrem_DS(transaction_id IN ['PDW250121223315VW7U4','PDW250122011150ZKSVM','PDW250122001422EGHD6','PDW250121200455BJU2F','PDW250121200049SD9ZS']),named('Special_Charecters_Onprem'));


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



Azure_File := '~thor::base::fcra_azure::delta_inq_hist::20241113a::delta_key';

Azure_DS := SORT(DATASET(Azure_File,Lay,THOR),-transaction_id,product_id,customer_number,customer_account,seq_num);

//Azure_DS(transaction_id='18500963R566417');     

OnPrem_File := '~thor::base::fcra_onperm::delta_inq_hist::20241113::delta_key';

OnPrem_DS := SORT(DATASET(OnPrem_File,Lay,THOR),-transaction_id,product_id,customer_number,customer_account,seq_num);


//*********** Records That exists only in Azure But not in Onprem *************************//

// Below are the transactions which has seq no 0 in azure and proper seq no in on prem   W20241202-161156
OUTPUT(Azure_DS(transaction_id IN ['18501633R899470','18501633R899552','18501643R857675','18501643R860934','18501723R854965','18501723R898440','18501973R853741','18501973R895120','18502013R894687','18502013R894786']),named('Only_Azure'));
OUTPUT(OnPrem_DS(transaction_id IN ['18501633R899470','18501633R899552','18501643R857675','18501643R860934','18501723R854965','18501723R898440','18501973R853741','18501973R895120','18502013R894687','18502013R894786']),named('Not_In_Onprem'));

//*********** Records That exists only in Onprem But not in Azure *************************//

//OUTPUT(OnPrem_DS(transaction_id IN ['23122002677384']));// repeated multiple times with diff record sid
OUTPUT(OnPrem_DS(transaction_id IN ['18501633R845371','18501633R846951','18501633R847028','23122002677473','18501633R851268','18501633R853088','18501633R854857','18501633R855095','18501633R855581','18501633R857621']),named('Only_Onprem'));
OUTPUT(Azure_DS(transaction_id IN ['18501633R845371','18501633R846951','18501633R847028','23122002677473','18501633R851268','18501633R853088','18501633R854857','18501633R855095','18501633R855581','18501633R857621']),named('Not_In_Azure'));

//***************** Records That exists in both *******************************//

OUTPUT(OnPrem_DS(transaction_id IN ['18812283R139082','18812313R132966','18812293R147468','18812283R130815','18812313R114026']),named('Both_OnPrem'));
OUTPUT(Azure_DS(transaction_id IN ['18812283R139082','18812313R132966','18812293R147468','18812283R130815','18812313R114026']),named('Both_Azure'));







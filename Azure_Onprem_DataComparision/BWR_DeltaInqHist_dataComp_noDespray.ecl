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

Azure_DS := SORT(DATASET(Azure_File,Lay,THOR),-transaction_id,customer_number,customer_account,seq_num,product_id);

OUTPUT(COUNT(Azure_DS),named('Azure_DS_cnt'));


OnPrem_File := '~thor::base::fcra_onperm::delta_inq_hist::20241113::delta_key';

OnPrem_DS := SORT(DATASET(OnPrem_File,Lay,THOR),-transaction_id,customer_number,customer_account,seq_num,product_id);

OUTPUT(COUNT(OnPrem_DS),named('OnPrem_DS_cnt'));

//***Verification for data difference************

DataDiff1 := Azure_DS-OnPrem_DS;
OUTPUT(SORT(DataDiff1,-transaction_id,customer_number,customer_account,seq_num,product_id),named('DataDiff1'));
OUTPUT(COUNT(DataDiff1),named('Count_DataDiff1'));
DataDiff2 := OnPrem_DS-Azure_DS;
OUTPUT(SORT(DataDiff2,-transaction_id,customer_number,customer_account,seq_num,product_id),named('DataDiff2'));
OUTPUT(COUNT(DataDiff2),named('Count_DataDiff2'));


OUTPUT(Azure_DS( customer_number IN [//'14106',
'10000'
//'10028',
//'10023',
//'98095',
//'91882'
]),named('AzureDS_SampleData'));
OUTPUT(OnPrem_DS( customer_number IN [//'14106',
'10000'
//'10028',
//'10023',
//'98095',
//'91882'
]),named('OnPrem_DS_SampleData'));

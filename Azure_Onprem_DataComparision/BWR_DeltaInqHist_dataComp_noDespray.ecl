/*
thor::base::op::fcra::delta_inq_hist::20250214::delta_key
 
thor::base::az::fcra::delta_inq_hist::20250214a::delta_key
 
thor::base::op::fcra::delta_inq_hist::20250213::delta_key
thor::base::az::fcra::delta_inq_hist::20250213a::delta_key
*/

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



Azure_File := '~thor::base::az::fcra::delta_inq_hist::20250214a::delta_key';

Azure_DS := SORT(DATASET(Azure_File,Lay,THOR),-transaction_id,customer_number,customer_account,seq_num,product_id);

OUTPUT(COUNT(Azure_DS),named('Azure_DS_cnt'));


OnPrem_File := '~thor::base::op::fcra::delta_inq_hist::20250214::delta_key';

OnPrem_DS := SORT(DATASET(OnPrem_File,Lay,THOR),-transaction_id,customer_number,customer_account,seq_num,product_id);

OUTPUT(COUNT(OnPrem_DS),named('OnPrem_DS_cnt'));

//***Verification for data difference************

AzureOnly := Azure_DS-OnPrem_DS;
OUTPUT(SORT(AzureOnly,-transaction_id,customer_number,customer_account,seq_num,product_id),named('AzureOnly'));
OUTPUT(COUNT(AzureOnly),named('Count_AzureOnly'));
OnPremOnly := OnPrem_DS-Azure_DS;
OUTPUT(SORT(OnPremOnly,-transaction_id,customer_number,customer_account,seq_num,product_id),named('OnPremOnly'));
OUTPUT(COUNT(OnPremOnly),named('Count_OnPremOnly'));


// OUTPUT(Azure_DS( customer_number IN [//'14106',
// '10000'
//'10028',
//'10023',
//'98095',
//'91882'
//]),named('AzureDS_SampleData'));
// OUTPUT(OnPrem_DS( customer_number IN [//'14106',
// '10000'
//'10028',
//'10023',
//'98095',
//'91882'
//]),named('OnPrem_DS_SampleData'));


//*********************************************************************************************************************

SlimLay := RECORD
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
  //string20 suppressionalerts;
  unsigned6 did;
  //integer2 xlink_weight;
  //unsigned2 xlink_score;
  //integer1 xlink_distance;
  //unsigned8 address_id;
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

Proj_Azure  := PROJECT(Azure_DS, SlimLay);
Proj_OnPrem := PROJECT(OnPrem_DS, SlimLay);

Proj_OnPrem_DataDiff := Proj_OnPrem-Proj_Azure;
OUTPUT(COUNT(Proj_OnPrem_DataDiff),named('cnt_Proj_OnPrem_DataDiff'));
OUTPUT(SORT(Proj_OnPrem_DataDiff,-transaction_id,customer_number,customer_account,seq_num,product_id),named('Proj_OnPrem_DataDiff'));
Proj_Azure_DataDiff := Proj_Azure-Proj_OnPrem;
OUTPUT(COUNT(Proj_Azure_DataDiff),named('cnt_Proj_Azure_DataDiff'));
OUTPUT(SORT(Proj_Azure_DataDiff,-transaction_id,customer_number,customer_account,seq_num,product_id),named('Proj_Azure_DataDiff'));


//**************************************************************
Trans_Lay := RECORD
      string20 transaction_id;
END;

ProjTrans_Azure  := PROJECT(Azure_DS, Trans_Lay);
ProjTrans_OnPrem := PROJECT(OnPrem_DS, Trans_Lay);

TransDedup_OnPrem := DEDUP(SORT(ProjTrans_OnPrem,transaction_id),transaction_id);       
TransDedup_Azure  := DEDUP(SORT(ProjTrans_Azure,transaction_id),transaction_id);     

Trans_OnlyOnPrem :=  TransDedup_OnPrem- TransDedup_Azure;
Trans_OnlyAzure  :=  TransDedup_Azure-TransDedup_OnPrem;

OUTPUT(Trans_OnlyOnPrem,named('Trans_OnlyOnPrem'));
OUTPUT(Trans_OnlyAzure,named('Trans_OnlyAzure'));

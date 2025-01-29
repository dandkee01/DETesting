IMPORT std,ut;

  
Base_Lay := RECORD
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


Prod_DS := DATASET(ut.foreign_prod+'thor::base::fcra::delta_inq_hist::20250116::delta_key', Base_Lay, THOR);
Prod_DevCopied_DS := DATASET('~thor::base::fcra::delta_inq_hist::20250116::delta_key', Base_Lay, THOR);
Dev_DS := DATASET('~thor::base::fcra::delta_inq_hist::20250117::delta_key', Base_Lay, THOR);

/*rec := RECORD
Dev_DS.lex_id;
Dev_DS.transaction_id;
Dev_DS.product_id;
Dev_DS.date_added;
Dev_DS.seq_num;
StCnt := COUNT(GROUP);
END;
DEV_DSTable := TABLE(Dev_DS,rec,lex_id,transaction_id,product_id,date_added,seq_num,FEW);

OUTPUT(DEV_DSTable(stCnt>1),named('DEV_DSTable_sample'));

rec1 := RECORD
Prod_DevCopied_DS.lex_id;
Prod_DevCopied_DS.transaction_id;
Prod_DevCopied_DS.product_id;
Prod_DevCopied_DS.date_added;
Prod_DevCopied_DS.seq_num;
StCnt := COUNT(GROUP);
END;
Prod_DevCopied_DSTable := TABLE(Prod_DevCopied_DS,rec1,lex_id,transaction_id,product_id,date_added,seq_num,FEW);
OUTPUT(Prod_DevCopied_DSTable(stCnt>1),named('Prod_DevCopied_DSTable_sample'));
*/
//**************************************************************************************************
//Difference records
//**************************************************************************************************

// 

Base_Lay_Proj := RECORD
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
  //integer2 xlink_weight;
  //unsigned2 xlink_score;
  //integer1 xlink_distance;
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
 
DevDs_Proj := PROJECT(Dev_DS,Base_Lay_Proj);
Prod_DevCopied_DS_Proj := PROJECT(Prod_DevCopied_DS,Base_Lay_Proj);

Diff_DS := DevDs_Proj - Prod_DevCopied_DS_Proj;
OUTPUT(Diff_DS,named('Diff_DS'));

Diff_DS1 := Prod_DevCopied_DS_Proj - DevDs_Proj;
OUTPUT(Diff_DS1,named('Diff_DS1'));


OUTPUT(Prod_DevCopied_DS_Proj(transaction_id IN ['PDW250115174823U9K3G','PDW250115160942UZ8LF']),named('NotExistInProd'));
OUTPUT(DevDs_Proj(transaction_id IN ['PDW250115174823U9K3G','PDW250115160942UZ8LF']),named('NotExistInProd_FromDevfile'));
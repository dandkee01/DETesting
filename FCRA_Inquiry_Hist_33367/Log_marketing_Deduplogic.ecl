
Lay :=   RECORD
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

    
    DeltaFile := DATASET('~thor::base::fcra::delta_inq_hist::20241217::delta_key',Lay,thor);   // 3rd run
    DeltaFile_DS := DeltaFile(transaction_location='Log_marketing');
    OUTPUT(COUNT(DeltaFile_DS), named('Before_Dedup_CNT_DeltaFile_DS'));
    OUTPUT(COUNT(DEDUP(SORT(DeltaFile_DS, lex_id,transaction_id,product_id,date_added,seq_num, LOCAL), lex_id,transaction_id,product_id,date_added,seq_num, LOCAL)),named('After_DEDUP_CNT_DeltaFile_DS'));
    
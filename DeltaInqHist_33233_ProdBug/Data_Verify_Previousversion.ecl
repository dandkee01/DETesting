IMPORT STD, _Control;
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

OnPrem_File := '~thor::base::fcra::delta_inq_hist::20240917::delta_key';

OnPrem_DS := DATASET(OnPrem_File,Lay,THOR);

OUTPUT(COUNT(OnPrem_DS),named('CNT_BeforeFix_OnPrem_DS'));

OUTPUT(OnPrem_DS(transaction_id='18156733R694294'),named('OnPrem_DS_trans94294'));


Today_File := '~thor::base::fcra::delta_inq_hist::20240925::delta_key';

Today_DS := DATASET(Today_File,Lay,THOR);

OUTPUT(COUNT(Today_DS),named('CNT_AfterFix_OnPrem_DS'));

OUTPUT(Today_DS(transaction_id='18156733R694294'),named('Today_DS_trans94294'));


rec := RECORD
Today_DS.transaction_id;
Cnt := COUNT(GROUP);
END;
Onprem_AfterFix  := TABLE(Today_DS,rec,lex_id,transaction_id,product_id,date_added,FEW);
OUTPUT(Onprem_AfterFix(cnt>1), named('Onprem_AfterFix_Transac_Count'));

rec1 := RECORD
OnPrem_DS.transaction_id;
Cnt := COUNT(GROUP);
END;
Onprem_BeforeFix := TABLE(OnPrem_DS,rec1,lex_id,transaction_id,product_id,date_added,FEW);
OUTPUT(Onprem_BeforeFix(cnt>1), named('Onprem_BeforeFix_Transac_Count'));

OUTPUT(SORT(OnPrem_DS(TRIM(transaction_id,LEFT,RIGHT) IN ['18156723R686244','18156723R696236','18156723R713131','18156723R719950','18156723R738118','18156723R740116','18156723R740771','18156733R719337','18156733R721600']),transaction_id,seq_num), named('SampleTrans_BeforeFix'));    
OUTPUT(SORT(Today_DS(TRIM(transaction_id,LEFT,RIGHT) IN ['18156723R686244','18156723R696236','18156723R713131','18156723R719950','18156723R738118','18156723R740116','18156723R740771','18156733R719337','18156733R721600']),transaction_id,seq_num), named('SampleTrans_AfterFix'));    
  

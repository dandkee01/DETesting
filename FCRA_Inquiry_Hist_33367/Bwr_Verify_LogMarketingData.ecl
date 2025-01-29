    IMPORT FCRA_Inquiry_History;
    
    MarketingSprayDS									 := FCRA_Inquiry_History.Files.read_Marketing_FCRA_Spray_File;
    FilterKeyDS				 				         := MarketingSprayDS(posting_status = 'R' and order_status_code IN [100,101]);
    
    OUTPUT(COUNT(FilterKeyDS), named('Cnt_MarketingSprayDS'));
    OUTPUT(FilterKeyDS, named('MarketingSprayDS'));
    
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

    
    //DeltaFile := DATASET('~thor::base::fcra::delta_inq_hist::20241215::delta_key',Lay,thor); // 1st run
    //DeltaFile := DATASET('~thor::base::fcra::delta_inq_hist::20241216::delta_key',Lay,thor);   // 2nd run
    //DeltaFile := DATASET('~thor::base::fcra::delta_inq_hist::20241217::delta_key',Lay,thor);   // 3rd run
    //DeltaFile := DATASET('~thor::base::fcra::delta_inq_hist::20241218::delta_key',Lay,thor);   // 4th run
    DeltaFile := DATASET('~thor::base::fcra::delta_inq_hist::20241219::delta_key',Lay,thor);   // 4th run
    
    OUTPUT(COUNT(DeltaFile(transaction_location='Log_marketing')),named('CNT_FCRA_DelaInqHist_LogMarketing'));
    OUTPUT(DeltaFile(transaction_location='Log_marketing'),named('FCRA_DelaInqHist_LogMarketing'));
    
    OUTPUT(FilterKeyDS(transaction_id IN['19030951N2410','19030891N100063','19030891N100081','19030891N10010','19030891N100118','19030891N100137','19030891N100172','19030891N100178','19030891N100186','19030891N100216']), named('sample_MarketingSprayDS'));       
    OUTPUT(DeltaFile(transaction_id IN['19030951N2410','19030891N100063','19030891N100081','19030891N10010','19030891N100118','19030891N100137','19030891N100172','19030891N100178','19030891N100186','19030891N100216']), named('sample_DelaInqHist_LogMarketing'));       
    
    DeltaFile_DidNotZero := DeltaFile(transaction_location='Log_marketing' and did<>0);
    
    rec := RECORD
     DeltaFile_DidNotZero.transaction_id;
     Trans_Cnt := COUNT(GROUP);
    END;
    Mytable := TABLE(DeltaFile_DidNotZero,rec,transaction_id,FEW);
    Mytable(Trans_Cnt > 1);
    Mytable(Trans_Cnt<=1);
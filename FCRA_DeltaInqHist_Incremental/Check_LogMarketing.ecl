IMPORT FCRA_Inquiry_History;

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

    
    DeltaFile := DATASET('~thor::base::fcra::delta_inq_hist::qa::delta_key',Lay,thor);   // 3rd run
    DeltaFile_DS := DeltaFile(transaction_location='Log_marketing');
    OUTPUT(COUNT(DeltaFile_DS), named('Cnt_LogMarketingRecs'));
    OUTPUT(COUNT(DeltaFile), named('Cnt_DeltaFile'));
    
    
    MarketingSprayDS												 := FCRA_Inquiry_History.Files.read_Marketing_FCRA_Spray_File;
    FilterKeyDS				 				         := MarketingSprayDS(posting_status = 'R' and order_status_code IN [100,101]);
    OUTPUT(COUNT(FilterKeyDS),named('Cnt_marketingFile'));
    
    newLay := RECORD
      string20 transaction_id;
      string20 transaction_location;
    END;  
        slimDs0 := DATASET('~thor::base::fcra::delta_inq_hist::20250212k::delta_key',Lay,thor); 
        slimDs := PROJECT(slimDs0,newLay);
        //SlimuniqueTransLoc := DEDUP(SORT(slimDs,transaction_id,transaction_location),transaction_id,transaction_location);
        SlimuniqueTransLoc := DEDUP(SORT(slimDs,transaction_location),transaction_location);
        OUTPUT(SlimuniqueTransLoc,named('SlimuniqueTransLoc'));
        
        DeltaFile0 := PROJECT(DeltaFile,newLay);
         //DeltauniqueTransLoc := DEDUP(SORT(DeltaFile0,transaction_id,transaction_location),transaction_id,transaction_location);
         DeltauniqueTransLoc := DEDUP(SORT(DeltaFile0,transaction_location),transaction_location);
        OUTPUT(DeltauniqueTransLoc,named('DeltauniqueTransLoc'));
  
  
  
    OUTPUT(COUNT(slimDs0(transaction_location='LOG_MVR')),named('SlimLOG_MVR'));
    OUTPUT(COUNT(DeltaFile(transaction_location='LOG_MVR')),named('LOG_MVR'));

    OUTPUT(COUNT(slimDs0(transaction_location='Log_marketing')),named('SlimLog_marketing'));
    OUTPUT(COUNT(DeltaFile(transaction_location='Log_marketing')),named('Log_marketing'));

    OUTPUT(COUNT(slimDs0(transaction_location='log_cc')),named('Slimlog_cc'));
    OUTPUT(COUNT(DeltaFile(transaction_location='log_cc')),named('log_cc'));


    OUTPUT(COUNT(slimDs0(transaction_location='log_clue')),named('Slimlog_clue'));
    OUTPUT(COUNT(DeltaFile(transaction_location='log_clue')),named('log_clue'));

    OUTPUT(COUNT(slimDs0(transaction_location='log_mbsi_fcra')),named('Slimlog_mbsi_fcra'));
    OUTPUT(COUNT(DeltaFile(transaction_location='log_mbsi_fcra')),named('log_mbsi_fcra'));

    OUTPUT(COUNT(slimDs0(transaction_location='log_mvr')),named('Slimlog_mvr'));
    OUTPUT(COUNT(DeltaFile(transaction_location='log_mvr')),named('log_mvr'));

    OUTPUT(COUNT(slimDs0(transaction_location='log_ncf')),named('Slimlog_ncf'));
    OUTPUT(COUNT(DeltaFile(transaction_location='log_ncf')),named('log_ncf'));

    
    

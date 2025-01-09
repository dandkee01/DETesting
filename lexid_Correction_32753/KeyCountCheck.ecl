#Workunit('priority' ,'high');
#Workunit('priority',10);

IMPORT STD, ut, FCRA_Inquiry_History, CustomerSupport;

BaseRec := RECORD
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


file1 :='~thor::base::fcra::delta_inq_hist::20240505a::delta_key';
file2 :='~thor::base::fcra::delta_inq_hist::20240506::delta_key';

Prod_DS := DATASET(file1,BaseRec,THOR);
Dev_DS  := DATASET(file2,BaseRec,THOR);


    EDate				    			:= ut.date_math((STRING8)Std.Date.Today(), -(FCRA_Inquiry_History.Constants('delta_inq_hist').CS_TRANS_REPORTING_DAYS));
    EarliestHyphened		  := EDate[1..4] + '-' + EDate[5..6] + '-' + EDate[7..8] : GLOBAL;
    FilterKeyDS				 		:= Dev_DS(date_added >= EarliestHyphened);
    CustomerSupport.mac_CleanFields(FilterKeyDS,KeyDS); 
    
    //Lex_id Key
    FiltLexID					:= PROJECT(KeyDS((unsigned4)lex_id <> 0),Transform(FCRA_Inquiry_History.layouts.delta_key_Layout,self.lex_id := (string30)left.lex_id, self:= left));
    cnt1 := COUNT(FiltLexID);
    OUTPUT(cnt1,named('LexidCount'));
    
    // Trans_id Key
    key_suppersionalert  := project(FiltLexID,transform(FCRA_Inquiry_History.layouts.Key_Layout_SuppressionAlerts,self.lex_id := (string30)left.lex_id, self:= left));
    cnt2 := COUNT(key_suppersionalert);    
    OUTPUT(cnt2,named('TransIdCount'));

    
Key_subject := RECORD
  string30 lex_id
  =>
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
  unsigned8 __internal_fpos__;
 END;



DS_Key_subject_P   := INDEX(Key_subject,'~thor::key::fcra::delta_inq_hist::delta_key::20240505a::lexid');
ProdPulledDS       := PULL(DS_Key_subject_P);
PVerKeyLexid       := COUNT(ProdPulledDS);

/*
Keyt_subject := RECORD
  string20 transaction_id;
  string30 product_id
  =>
  string30 lex_id;
  string20 suppressionalerts;
  unsigned8 __internal_fpos__;
 END;


DS_Key_subject_Pt   := INDEX(Keyt_subject,'~thor::key::fcra::delta_inq_hist::delta_key::20240501::transid');
ProdPulledDSTrans   := PULL(DS_Key_subject_Pt);
PVerKeyTransidid    := COUNT(ProdPulledDSTrans);

*/

lexidKey_CntDiff := cnt1-PVerKeyLexid;
OUTPUT(lexidKey_CntDiff,named('lexidKey_CntDiff'));
/*TransidKey_CntDiff := cnt2-PVerKeyTransidid;
OUTPUT(TransidKey_CntDiff,named('TransidKey_CntDiff'));
*/

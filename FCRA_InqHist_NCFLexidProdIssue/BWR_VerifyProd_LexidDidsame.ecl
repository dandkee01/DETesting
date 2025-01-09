IMPORT ut;
//#WORKUNIT('protect',true);
#WORKUNIT('name','FCRA_Inquiry History Telematics Lexid Correction - prod data verify');    
//#WORKUNIT('priority','high');  
//#WORKUNIT('priority',10);

lay:= RECORD
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
 

//prod_ds:= dataset(ut.foreign_prod +'thor::base::fcra::delta_inq_hist::20240909::delta_key',lay,thor):INDEPENDENT;
prod_ds:= dataset('~thor::base::fcra::delta_inq_hist::20240911::delta_key',lay,thor);
Telematic_prod_ds:= prod_ds(product_id = '109' );


Telelay := RECORD
  RECORDOF(Lay);
  BOOLEAN IsLexidDidsame;
END;
  
Telelay VerifyLexid(Telematic_prod_ds l) := TRANSFORM

  SELF.IsLexidDidsame := IF(l.lex_id=l.did, true,false);
  SELF := l;
END;
LexidVer_DS := PROJECT(Telematic_prod_ds, VerifyLexid(LEFT));
DS1 := LexidVer_DS(IsLexidDidsame=false and lex_id<>0);
OUTPUT(DS1,{lex_id,did,transaction_id,product_id},named('Different_LexidDid'));
//OUTPUT(LexidVer_DS(IsLexidDidsame=true),{lex_id,did,transaction_id,product_id},named('Different_LexidDid'));
//LexidVer_DS(IsLexidDidsame=true);

dev_ds:= dataset('~thor::base::fcra::delta_inq_hist::20240909k::delta_key',lay,thor);
Telematic_dev_ds:= dev_ds(product_id = '109' );


Set_Tele := SET(DS1,transaction_id);
OUTPUT(Telematic_dev_ds(transaction_id IN set_Tele),named('Dev_lexid_MustNotChange'));











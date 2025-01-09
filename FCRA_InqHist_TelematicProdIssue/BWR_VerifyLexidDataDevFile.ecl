IMPORT ut;
//#WORKUNIT('protect',true);
#WORKUNIT('name','FCRA_Inquiry History Telematics Lexid Correction');    
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
 

//prod_ds:= dataset(ut.foreign_prod +'thor::base::fcra::delta_inq_hist::20240911::delta_key',lay,thor):INDEPENDENT;
//prod_ds:= dataset('~thor::base::fcra::delta_inq_hist::20240909::delta_key',lay,thor);
prod_ds:= dataset('~thor::base::fcra::delta_inq_hist::20240911::delta_key',lay,thor);
Telematic_prod_ds:= prod_ds(product_id = '109' );
Other_prod_ds:= prod_ds-Telematic_prod_ds;

//Dist_ProdDs  := DISTRIBUTE(prod_ds,HASH64(lex_id,transaction_id));
//output(Dist_ProdDs,,'~thor::base::fcra::delta_inq_hist::20240911::delta_key',compressed,overwrite);



//dev_ds:= dataset('~thor::base::fcra::delta_inq_hist::20240909K::delta_key',lay,thor);
dev_ds:= dataset('~thor::base::fcra::delta_inq_hist::20240912d::delta_key',lay,thor);
Telematic_dev_ds:= dev_ds(product_id = '109' );
Other_dev_ds1:= dev_ds-Telematic_dev_ds;
Other_dev_ds := Other_dev_ds1(lex_id<>0);

Telelay := RECORD
  RECORDOF(Lay);
  BOOLEAN IsLexidDidsame;
END;
  
Telelay VerifyLexid(Telematic_dev_ds l) := TRANSFORM

  SELF.IsLexidDidsame := IF(l.lex_id=l.did, true,false);
  SELF := l;
END;
LexidVer_DS := PROJECT(Telematic_dev_ds, VerifyLexid(LEFT));
LexidVer_DS;


OUTPUT(COUNT(prod_ds),named('Count_prod_fullDS'));
OUTPUT(COUNT(dev_ds),named('Count_dev_fullDS'));

OUTPUT(COUNT(Telematic_prod_ds),named('Count_Telematic_prod_ds'));
OUTPUT(COUNT(Telematic_dev_ds),named('Count_Telematic_dev_ds'));

OUTPUT(Telematic_prod_ds,named('DS_BeforeChange_Telematic_ProdRecs'));
OUTPUT(Telematic_dev_ds,named('DS_AfterChange_Telematic_DevRecs'));

OUTPUT(other_prod_ds,named('DS_BeforeChange_other_ProdRecs'));
OUTPUT(Other_dev_ds,named('DS_AfterChange_other_DevRecs'));

OUTPUT(COUNT(Other_prod_ds),named('Cnt_BeforeChange_other_ProdRecs'));
OUTPUT(COUNT(Other_dev_ds1),named('Cnt_BeforeChange_other_DevRecs'));


OUTPUT(COUNT(Telematic_prod_ds(lex_id=0)),named('Cnt_BeforeChange_Tele_LexidZero'));
OUTPUT(COUNT(Telematic_prod_ds(lex_id!=0)),named('Cnt_BeforeChange_Tele_LexidNonZero'));
OUTPUT(COUNT(Telematic_dev_ds(lex_id=0)),named('Cnt_AfterChange_Tele_LexidZero'));
OUTPUT(COUNT(Telematic_dev_ds(lex_id!=0)),named('Cnt_AfterChange_Tele_LexidNonZero'));

OUTPUT(Telematic_prod_ds(lex_id=0),named('DS_BeforeChange_Tele_LexidZero'));
OUTPUT(Telematic_prod_ds(lex_id!=0),named('DS_BeforeChange_Tele_LexidNonZero'));
OUTPUT(Telematic_dev_ds(lex_id=0),named('DS_AfterChange_Tele_LexidZeroDS'));
OUTPUT(Telematic_dev_ds(lex_id!=0),named('DS_AfterChange_Tele_LexidNonZero'));

OUTPUT(COUNT(LexidVer_DS),named('DS_Lexid_Did_Comparision'));
OUTPUT(LexidVer_DS(IsLexidDidsame=false),named('Falsecases_Lexid_Did'));
OUTPUT(LexidVer_DS(IsLexidDidsame=true),named('Truecases_Lexid_Did'));

















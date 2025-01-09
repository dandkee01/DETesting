IMPORT ut;

#WORKUNIT('name','FCRA_Inquiry History Ncfs Lexid Correction');    
#WORKUNIT('priority','high');  
#WORKUNIT('priority',10);

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
 
prod_ds   := dataset(ut.foreign_prod+'thor::base::fcra::delta_inq_hist::20241008::delta_key',lay,thor);
// prod_ds   := dataset(ut.foreign_prod+'thor::base::fcra::delta_inq_hist::father_backup::delta_key',lay,thor);
Dist_Prod := DISTRIBUTE(prod_ds,HASH64(lex_id,transaction_id));
   
output(Dist_Prod,,'~thor::base::fcra::delta_inq_hist::20241008P::delta_key',compressed,overwrite);
//output(Dist_Prod,,'~thor::base::fcra::delta_inq_hist::20241006k::delta_key',compressed,overwrite);
Proddev_ds:= dataset('~thor::base::fcra::delta_inq_hist::20241008P::delta_key',lay,thor);


Ncf_prod_ds:= Proddev_ds(transaction_id in ['18814321R5758188',
      '18814321R5764437',
      '18814471R5735557',
      '11220116R7709128',
      '19277871R545741',
      '18814301R5773093',
      '18157133R431470',
      '11219826R7993779',
      '18157143R421771',
      '18157173R422448']  );
      
Other_prod_ds:= Proddev_ds(transaction_id not in ['18814321R5758188',
      '18814321R5764437',
      '18814471R5735557',
      '11220116R7709128',
      '19277871R545741',
      '18814301R5773093',
      '18157133R431470',
      '11219826R7993779',
      '18157143R421771',
      '18157173R422448']  );      
  



dev_ds:= dataset('~thor::base::fcra::delta_inq_hist::20241008d::delta_key',lay,thor);
NCF_dev_ds:= dev_ds(transaction_id in ['18814321R5758188',
      '18814321R5764437',
      '18814471R5735557',
      '11220116R7709128',
      '19277871R545741',
      '18814301R5773093',
      '18157133R431470',
      '11219826R7993779',
      '18157143R421771',
      '18157173R422448']  );
Other_dev_ds := dev_ds(transaction_id not in ['18814321R5758188',
      '18814321R5764437',
      '18814471R5735557',
      '11220116R7709128',
      '19277871R545741',
      '18814301R5773093',
      '18157133R431470',
      '11219826R7993779',
      '18157143R421771',
      '18157173R422448']  );

Ncflay := RECORD
  RECORDOF(Lay);
  BOOLEAN IsLexidDidsame;
END;
  
Ncflay VerifyLexid(dev_ds l) := TRANSFORM

  SELF.IsLexidDidsame := IF(l.lex_id=l.did, true,false);
  SELF := l;
END;
LexidVer_DS := PROJECT(dev_ds, VerifyLexid(LEFT));
LexidVer_DS;


OUTPUT(COUNT(proddev_ds),named('Count_prod_fullDS'));
OUTPUT(COUNT(dev_ds),named('Count_dev_fullDS'));

OUTPUT(COUNT(Ncf_prod_ds),named('Cnt_CC_Ncf_Trans_prod_ds'));
OUTPUT(COUNT(Ncf_dev_ds),named('Cnt_CC_Ncf_Trans_dev_ds'));

OUTPUT(Ncf_prod_ds,named('DS_CC_Ncf_Trans_ProdRecs'));
OUTPUT(Ncf_dev_ds,named('DS_CC_AfterChange_Ncf_Trans_DevRecs'));

OUTPUT(Ncf_prod_ds,{lex_id,product_id,transaction_id,did,seq_num,inquiry_date,date_added},named('DS_Slim_CC_Ncf_Trans_ProdRecs'));
OUTPUT(Ncf_dev_ds,{lex_id,product_id,transaction_id,did,seq_num,inquiry_date,date_added},named('DS_Slim_CC_AfterChange_Ncf_Trans_DevRecs'));

OUTPUT(other_prod_ds,named('DS_other_ProdRecs'));
OUTPUT(Other_dev_ds,named('DS_AfterChange_other_DevRecs'));

OUTPUT(COUNT(Other_prod_ds),named('TotalCnt_Other_Trans_ProdRecs'));
OUTPUT(COUNT(Other_dev_ds),named('TotalCnt_Other_Trans_DevRecs'));


OUTPUT(COUNT(Proddev_ds(lex_id=0)),named('TotalCnt_Prod_LexidZero'));
OUTPUT(COUNT(Proddev_ds(lex_id!=0)),named('TotalCnt_Prod_LexidNonZero'));
OUTPUT(COUNT(dev_ds(lex_id=0)),named('TotalCnt_Dev_AfterChange_LexidZero'));
OUTPUT(COUNT(dev_ds(lex_id!=0)),named('TotalCnt_Dev_AfterChange_LexidNonZero'));

OUTPUT(COUNT(Proddev_ds(TRIM(product_id, LEFT,RIGHT)='7' and lex_id=0)),named('TotalNCFCnt_Prod_LexidZero'));
OUTPUT(COUNT(Proddev_ds(TRIM(product_id, LEFT,RIGHT)='7' and lex_id!=0)),named('TotalNCFCnt_Prod_LexidNonZero'));
OUTPUT(COUNT(dev_ds(TRIM(product_id, LEFT,RIGHT)='7' and lex_id=0)),named('TotalNCFCnt_Dev_AfterChange_LexidZero'));
OUTPUT(COUNT(dev_ds(TRIM(product_id, LEFT,RIGHT)='7' and lex_id!=0)),named('TotalNCFCnt_Dev_AfterChange_LexidNonZero'));

OUTPUT(Proddev_ds(lex_id=0),named('DS_prod_LexidZero'));
OUTPUT(Proddev_ds(lex_id!=0),named('DS_prod_LexidNonZero'));
OUTPUT(dev_ds(lex_id=0),named('DS_dev_LexidZeroDS'));
OUTPUT(dev_ds(lex_id!=0),named('DS_dev_LexidNonZero'));

OUTPUT(Proddev_ds(TRIM(product_id, LEFT,RIGHT)='7' and lex_id=0),named('DS_NCF_prod_LexidZero'));
OUTPUT(Proddev_ds(TRIM(product_id, LEFT,RIGHT)='7' and lex_id!=0),named('DS_NCF_prod_LexidNonZero'));
OUTPUT(dev_ds(TRIM(product_id, LEFT,RIGHT)='7' and lex_id=0),named('DS_NCF_dev_LexidZeroDS'));
OUTPUT(dev_ds(TRIM(product_id, LEFT,RIGHT)='7' and lex_id!=0),named('DS_NCF_dev_LexidNonZero'));

OUTPUT(COUNT(LexidVer_DS),named('TotalCnt_Dev_Lexid_Did_Comparision'));
OUTPUT(LexidVer_DS(IsLexidDidsame=false),named('Falsecases_Dev_Lexid_Did'));
OUTPUT(LexidVer_DS(IsLexidDidsame=true),named('Truecases_Dev_Lexid_Did'));

















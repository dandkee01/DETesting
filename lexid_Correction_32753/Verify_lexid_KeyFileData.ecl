#Workunit('priority' ,'high');
#Workunit('priority',10);

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



DS_Key_subject_P   := INDEX(Key_subject,'~thor::key::fcra::delta_inq_hist::delta_key::20240501::lexid');
ProdPulledDS       := PULL(DS_Key_subject_P);
OUTPUT(ProdPulledDS,named('Prod_Lexid_Key_DS'));
OUTPUT(CHOOSEN(ProdPulledDS,500),named('Top500Prod_Lexid_Key_DS'));
OUTPUT(COUNT(ProdPulledDS),named('COUNT_Prod_Lexid_Key'));

DS_Key_subject_D   := INDEX(Key_subject,'~thor::key::fcra::delta_inq_hist::delta_key::20240502::lexid');
DevPulledDS        := PULL(DS_Key_subject_D);
OUTPUT(DevPulledDS,named('Dev_Lexid_Key_DS'));
OUTPUT(CHOOSEN(DevPulledDS,500),named('Top500Dev_Lexid_Key_DS'));
OUTPUT(COUNT(DevPulledDS),named('COUNT_Dev_Lexid_Key'));

Lexid_ChangedRecs := DevPulledDS-ProdPulledDS;
OUTPUT(Lexid_ChangedRecs,named('Lexid_ChangedRecs'));
OUTPUT(COUNT(Lexid_ChangedRecs),named('COUNT_Lexid_ChangedRecs'));
Lexid_notChangedRecs := DevPulledDS-Lexid_ChangedRecs;
OUTPUT(COUNT(Lexid_notChangedRecs),named('COUNT_Lexid_notChangedRecs'));

//---------------------------------------------------------------------------------------------------------------------------------------------------------
// Data Verification

DS1 := DISTRIBUTE(ProdPulledDS,HASH32(name_first,name_last,name_middle,name_suffix,addr_street,addr_city,addr_state,addr_zip5,addr_zip4,ssn,dob,drivers_license_number,drivers_license_state,product_id,transaction_id));
DS2 := DISTRIBUTE(DevPulledDS,HASH32(name_first,name_last,name_middle,name_suffix,addr_street,addr_city,addr_state,addr_zip5,addr_zip4,ssn,dob,drivers_license_number,drivers_license_state,product_id,transaction_id));
                    
OUTPUT(SORT(DS1,name_first,name_last,name_middle,name_suffix,addr_street,addr_city,addr_state,addr_zip5,addr_zip4,ssn,dob,drivers_license_number,drivers_license_state,product_id,transaction_id,LOCAL),named('sorted_DS1'));
OUTPUT(SORT(DS2,name_first,name_last,name_middle,name_suffix,addr_street,addr_city,addr_state,addr_zip5,addr_zip4,ssn,dob,drivers_license_number,drivers_license_state,product_id,transaction_id,LOCAL),named('sorted_DS2'));

NewRec := RECORD  
  string30 lex_id_Before;
  string30 lex_id_After;
  string30 lex_id;
  string20  name_first;
  string20  name_last;
  string20  name_middle;
  string20  name_suffix; 
  string25  addr_city;
  string2   addr_street;
  string2   addr_state;
  string5   addr_zip5;
  string5   addr_zip4;
  string9   ssn;
  string10  dob;
  string25  drivers_license_number;
  string2   drivers_license_state;
  string30   product_id;
  string20  transaction_id;
  string    Lexid_Changed;
END;
 

NewRec doJoin(DS2 L,DS1 R) := TRANSFORM
  SELF.Lex_id_Before := R.Lex_id;  
  SELF.Lex_id_After  := L.Lex_id; 
  isLexidChanged     := R.Lex_id=L.Lex_id;
  SELF.Lexid_Changed := IF(~isLexidChanged,'TRUE','FALSE');
  SELF := L;
END;
JoinedDS := DEDUP(SORT(JOIN(DS2, DS1,                   
                    LEFT.name_first=RIGHT.name_first AND
                    LEFT.name_last =RIGHT.name_last AND
                    LEFT.name_middle = RIGHT.name_middle AND
                    LEFT.name_suffix = RIGHT.name_suffix AND
                    LEFT.addr_street = RIGHT.addr_street AND
                    LEFT.addr_city = RIGHT.addr_city AND
                    LEFT.addr_city = RIGHT.addr_city AND
                    LEFT.addr_state = RIGHT.addr_state AND
                    LEFT.addr_zip5 = RIGHT.addr_zip5 AND
                    LEFT.addr_zip4 = RIGHT.addr_zip4 AND
                    LEFT.ssn = RIGHT.ssn AND
                    LEFT.dob = RIGHT.dob AND
                    LEFT.drivers_license_number = RIGHT.drivers_license_number AND
                    LEFT.drivers_license_state = RIGHT.drivers_license_state AND
                    LEFT.product_id = RIGHT.product_id AND
                    LEFT.transaction_id = RIGHT.transaction_id 
                    ,doJoin(LEFT, RIGHT),LEFT OUTER, LOCAL),name_first,name_last,name_middle,name_suffix,addr_street,addr_city,addr_state,addr_zip5,addr_zip4,ssn,dob,drivers_license_number,drivers_license_state,product_id,transaction_id),name_first,name_last,name_middle,name_suffix,addr_street,addr_city,addr_state,addr_zip5,addr_zip4,ssn,dob,drivers_license_number,drivers_license_state,product_id,transaction_id):INDEPENDENT;

//OUTPUT(JoinedDS(Did_Changed='TRUE'), named('DidChanged_Set'));
//OUTPUT(JoinedDS(Did_Changed='FALSE'), named('DidnotChanged_Set'));
OUTPUT(CHOOSEN(JoinedDS(Lexid_Changed='TRUE' AND lex_id_before<>'' ),500), named('LexidChanged_Set'));
OUTPUT(JoinedDS(Lexid_Changed='FALSE' AND lex_id_before<>''), named('LexidNotChanged_Set'));

OUTPUT(COUNT(JoinedDS), named('JoinedDS_Count'));
OUTPUT(JoinedDS, named('JoinedDS'));

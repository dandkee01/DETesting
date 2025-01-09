#WORKUNIT('name','FCRA DeltaInqHisLexCorr');
#WORKUNIT('priority','high');
#WORKUNIT('priority',10);      

IMPORT STD;

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


file1 :='~thor::base::fcra::delta_inq_hist::20240501::delta_key';
file2 :='~thor::base::fcra::delta_inq_hist::20240502::delta_key';

DS11 := DEDUP(SORT(DATASET(file1,BaseRec,THOR)/*(did IN [4398724] AND TRIM(transaction_id,LEFT,RIGHT) ='16394091R3425764' AND TRIM(product_id,LEFT,RIGHT)='7')*/,name_first,name_last,name_middle,prim_range,prim_name,sec_range,city,st,zip,ssn,dob,drivers_license_number,drivers_license_state,did,transaction_id,product_id),name_first,name_last,name_middle,prim_range,prim_name,sec_range,city,st,zip,ssn,dob,drivers_license_number,drivers_license_state,did,transaction_id,product_id);

DS22 := DEDUP(SORT(DATASET(file2,BaseRec,THOR)/*(did IN [4398724] AND TRIM(transaction_id,LEFT,RIGHT) ='16394091R3425764' AND TRIM(product_id,LEFT,RIGHT)='7')*/,name_first,name_last,name_middle,prim_range,prim_name,sec_range,city,st,zip,ssn,dob,drivers_license_number,drivers_license_state,did,transaction_id,product_id),name_first,name_last,name_middle,prim_range,prim_name,sec_range,city,st,zip,ssn,dob,drivers_license_number,drivers_license_state,did,transaction_id,product_id);

OUTPUT(DS11,named('DeltaKey_ThorProdVer'));
OUTPUT(DS22,named('DeltaKey_ChangesVer'));


inDate := STD.Date.Today();
adjustedDate := Std.Date.AdjustDate(inDate, -1, 0, 0);
FormatedDate := adjustedDate[1..4] + '-' + adjustedDate[5..6] + '-' + adjustedDate[7..8]:INDEPENDENT;

DS10 := DS11(date_added[1..10] > FormatedDate);// AND name_first<>'' AND name_last<> '' AND name_middle<> '' AND prim_range<>'' AND prim_name<>'' AND sec_range<>'' AND city<>'' AND st<>'' AND zip<>'' AND ssn<>'' AND dob<>'' AND drivers_license_number<>'' AND drivers_license_state<>'' AND did<>0):INDEPENDENT;
DS20 := DS22(date_added[1..10] > FormatedDate);// AND name_first<>'' AND name_last<> '' AND name_middle<> '' AND prim_range<>'' AND prim_name<>'' AND sec_range<>'' AND city<>'' AND st<>'' AND zip<>'' AND ssn<>'' AND dob<>'' AND drivers_license_number<>'' AND drivers_license_state<>'' AND did<>0): INDEPENDENT;


DS1 := DISTRIBUTE(DS10,HASH32(name_first,name_last,name_middle,prim_range,prim_name,sec_range,city,st,zip,ssn,dob,drivers_license_number,drivers_license_state,did,transaction_id,product_id));
DS2 := DISTRIBUTE(DS20,HASH32(name_first,name_last,name_middle,prim_range,prim_name,sec_range,city,st,zip,ssn,dob,drivers_license_number,drivers_license_state,did,transaction_id,product_id));
                    
OUTPUT(SORT(DS10,name_first,name_last,name_middle,prim_range,prim_name,sec_range,city,st,zip,ssn,dob,drivers_license_number,drivers_license_state,did,transaction_id,product_id,LOCAL),named('sorted_DS1'));
OUTPUT(SORT(DS20,name_first,name_last,name_middle,prim_range,prim_name,sec_range,city,st,zip,ssn,dob,drivers_license_number,drivers_license_state,did,transaction_id,product_id,LOCAL),named('sorted_DS2'));

NewRec := RECORD
  unsigned6 did_Before;
  unsigned6 did_After;
  unsigned8 lex_id_Before;
  unsigned8 lex_id_After; 
  unsigned8 lex_id;
  unsigned8 did;
  string20  name_first;
  string20  name_last;
  string20  name_middle;
  string10  prim_range;
  string28  prim_name;
  string8   sec_range;
  string25  city;
  string2   st;
  string5   zip;
  string9   ssn;
  string10  dob;
  string25  drivers_license_number;
  string2   drivers_license_state;
  string30 product_id;
  string20 transaction_id;
  string    Did_Changed;
  string    Lexid_Changed;
END;
 

NewRec doJoin(BaseRec L,BaseRec R) := TRANSFORM
  SELF.did_Before    := R.did;  
  SELF.did_After     := L.did; 
  SELF.Lex_id_Before := R.Lex_id;  
  SELF.Lex_id_After  := L.Lex_id; 
  isDidChanged       := R.did=L.did;
  SELF.Did_Changed   := IF(~isDidChanged,'TRUE','FALSE');
  isLexidChanged     := R.Lex_id=L.Lex_id;
  SELF.Lexid_Changed := IF(~isLexidChanged,'TRUE','FALSE');
  SELF := L;
END;
JoinedDS := DEDUP(SORT(JOIN(DS2, DS1,
                    LEFT.did=RIGHT.did AND
                    LEFT.transaction_id=RIGHT.transaction_id AND
                    LEFT.product_id=RIGHT.product_id AND
                    LEFT.name_first=RIGHT.name_first AND
                    LEFT.name_last =RIGHT.name_last AND
                    LEFT.name_middle = RIGHT.name_middle AND
                    LEFT.prim_range = RIGHT.prim_range AND
                    LEFT.prim_name = RIGHT.prim_name AND
                    LEFT.sec_range = RIGHT.sec_range AND
                    LEFT.city = RIGHT.city AND
                    LEFT.st = RIGHT.st AND
                    LEFT.zip = RIGHT.zip AND
                    LEFT.ssn = RIGHT.ssn AND
                    LEFT.dob = RIGHT.dob AND
                    LEFT.drivers_license_number = RIGHT.drivers_license_number AND
                    LEFT.drivers_license_state = RIGHT.drivers_license_state
                    ,doJoin(LEFT, RIGHT),LEFT OUTER, LOCAL),name_first,name_last,name_middle,prim_range,prim_name,sec_range,city,st,zip,ssn,dob,drivers_license_number,drivers_license_state,did,product_id,transaction_id),name_first,name_last,name_middle,prim_range,prim_name,sec_range,city,st,zip,ssn,dob,drivers_license_number,drivers_license_state,did,product_id,transaction_id):INDEPENDENT;

OUTPUT(JoinedDS(Did_Changed='TRUE'), named('DidChanged_Set'));
OUTPUT(JoinedDS(Did_Changed='FALSE'), named('DidnotChanged_Set'));
OUTPUT(JoinedDS(Lexid_Changed='TRUE' AND lex_id IN [4398724,5917754,5822356,9595510,16612511,19829982,24884639,33910890]), named('LexidChanged_Set'));
OUTPUT(JoinedDS(Lexid_Changed='FALSE'), named('LexidNotChanged_Set'));
OUTPUT(COUNT(DS1), named('DS1_Count'));
OUTPUT(COUNT(DS2), named('DS2_Count'));
OUTPUT(COUNT(JoinedDS), named('JoinedDS_Count'));
OUTPUT(JoinedDS, named('JoinedDS'));
OUTPUT(CHOOSEN(DS1,500),named('DS1_Top500'));
OUTPUT(CHOOSEN(DS2,500),named('DS2_Top500'));
JoinedDS(lex_id IN [4398724,5917754,5822356,9595510,16612511,19829982,24884639,33910890]);
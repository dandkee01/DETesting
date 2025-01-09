IMPORT STD, _Control, FCRA_Inquiry_History;
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

Father_File := '~thor::base::fcra::delta_inq_hist::20240909b::delta_key';

Father_DS := DATASET(Father_File,Lay,THOR);
//Father_DS := CHOOSEN(SORT(Father_DS1,transaction_id,seq_num),100);

OUTPUT(Father_DS,named('Father_DS'));

Today_File := '~thor::base::fcra::delta_inq_hist::20240925a::delta_key';

Today_DS := DATASET(Today_File,Lay,THOR);
//Today_DS := CHOOSEN(SORT(Today_DS1,transaction_id,seq_num),100);

OUTPUT(Today_DS,named('Today_DS'));
OUTPUT(COUNT(Today_DS),named('Cnt_Today_DS'));

//lex_id,transaction_id,product_id,date_added,seq_num,ssn,drivers_license_number,name_first,name_last,name_middle,dob


DS1 := DISTRIBUTE(Father_DS,HASH32(lex_id,transaction_id,product_id,date_added,seq_num,ssn,drivers_license_number,name_first,name_last,name_middle,dob));
DS2 := DISTRIBUTE(Today_DS,HASH32(lex_id,transaction_id,product_id,date_added,seq_num,ssn,drivers_license_number,name_first,name_last,name_middle,dob));

NewLay := RECORD
RECORDOF(Father_DS);
STRING SoureDataSet;
END;


NewLay doJoin(DS2 L,DS1 R) := TRANSFORM
  Cond := L.lex_id=R.lex_id AND L.transaction_id=R.transaction_id AND L.product_id=R.product_id AND L.date_added=R.date_added AND L.seq_num=R.seq_num;
  SELF.SoureDataSet := IF(Cond,'Old','New');
  SELF := L;
END;
JoinedDS := SORT(JOIN(DS2, DS1,
                    LEFT.lex_id=RIGHT.lex_id AND
                    LEFT.transaction_id=RIGHT.transaction_id AND
                    LEFT.product_id=RIGHT.product_id AND
                    LEFT.date_added=RIGHT.date_added AND
                    LEFT.seq_num =RIGHT.seq_num AND
                    LEFT.ssn =RIGHT.ssn AND
                    LEFT.drivers_license_number =RIGHT.drivers_license_number AND
                    LEFT.name_first =RIGHT.name_first AND
                    LEFT.name_last =RIGHT.name_last AND
                    LEFT.name_middle =RIGHT.name_middle AND
                    LEFT.dob =RIGHT.dob
                    ,doJoin(LEFT, RIGHT),LEFT OUTER, LOCAL),lex_id,transaction_id,product_id,date_added,seq_num,ssn,drivers_license_number,name_first,name_last,name_middle,dob);

OUTPUT(COUNT(JoinedDS),named('Cnt_JoinedDS'));
OUTPUT(JoinedDS,named('JoinedDS'));

Old_DS := JoinedDS(SoureDataSet='Old');
OUTPUT(COUNT(Old_DS),named('Cnt_Old_DS'));
OUTPUT(Old_DS,named('Old_DS'));
New_DS := JoinedDS(SoureDataSet='New');
OUTPUT(COUNT(New_DS),named('Cnt_New_DS'));
OUTPUT(New_DS,named('New_DS'));

//*********************************************************************************************************************************************************
// Spray File Validation
//*********************************************************************************************************************************************************

    STRING sProduct  := 'delta_inq_hist';
    STRING csProduct := 'cs_delta_inq_hist';
    STRING TableName:= 'delta_key';
    STRING build_date := '20240925';
    
dailies_inquiry_0   := FCRA_Inquiry_History.Files.read_delta_key_Spray(FCRA_Inquiry_History.Constants(sProduct,TableName,,).spray_File);
OUTPUT(dailies_inquiry_0,named('DS_dailies_inquiry_0'));
OUTPUT(COUNT(dailies_inquiry_0),named('CNT_dailies_inquiry_0'));

NewLay1 := RECORD
INTEGER lex_id;
STRING transaction_id;
STRING product_id;
STRING date_added;
INTEGER seq_num;
END;

daily_Proj := PROJECT(dailies_inquiry_0, Newlay1);
New_DS_Proj := PROJECT(New_DS, Newlay1);

OUTPUT(daily_Proj - New_DS_Proj, named('Dropped_recs'));


/*NewLay2 := RECORD
RECORDOF(Father_DS);
STRING SoureDataSet;
END;


NewLay2 doJoin1(dailies_inquiry_0 L,New_DS R) := TRANSFORM
  //Cond := L.lex_id=R.lex_id AND L.transaction_id=R.transaction_id AND L.product_id=R.product_id AND L.date_added=R.date_added AND L.seq_num=R.seq_num;
  Cond := L.transaction_id=R.transaction_id  AND L.seq_num=R.seq_num;
  SELF.SoureDataSet := IF(Cond,'Exists','NotExists');
  SELF := L;
END;
SprayJoinedDS := SORT(JOIN(dailies_inquiry_0, New_DS,
                    LEFT.lex_id=RIGHT.lex_id AND
                    LEFT.transaction_id=RIGHT.transaction_id AND
                    LEFT.product_id=RIGHT.product_id AND
                    LEFT.date_added=RIGHT.date_added AND
                    LEFT.seq_num =RIGHT.seq_num AND
                    LEFT.ssn =RIGHT.ssn AND
                    LEFT.drivers_license_number =RIGHT.drivers_license_number AND
                    LEFT.name_first =RIGHT.name_first AND
                    LEFT.name_last =RIGHT.name_last AND
                    LEFT.name_middle =RIGHT.name_middle 
                    //LEFT.dob =RIGHT.dob
                    ,doJoin1(LEFT, RIGHT),LEFT OUTER, LOCAL),lex_id,transaction_id,product_id,date_added,seq_num,ssn,drivers_license_number,name_first,name_last,name_middle);
 */                   
/*OUTPUT(SprayJoinedDS, named('SprayJoinedDS'));                    
OUTPUT(SprayJoinedDS(SoureDataSet='Exists'), named('Exists_SprayJoinedDS'));                    
OUTPUT(COUNT(SprayJoinedDS(SoureDataSet='Exists')), named('CNT_Exists_SprayJoinedDS'));                    
OUTPUT(SprayJoinedDS(SoureDataSet='NotExists'), named('NotExists_SprayJoinedDS'));                    
OUTPUT(COUNT(SprayJoinedDS(SoureDataSet='NotExists')), named('CNT_NotExists_SprayJoinedDS'));                    
OUTPUT(COUNT(SprayJoinedDS), named('CNT_SprayJoinedDS'));  
*/                  
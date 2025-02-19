
IMPORT STD;
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



Azure_File := '~thor::base::az::fcra::delta_inq_hist::20250213a::delta_key';

Azure_DS := DATASET(Azure_File,Lay,THOR);
//Azure_DS := Azure_DS1(~(lex_id=0 OR TRIM(addr_street)='' OR TRIM(addr_city)='' OR TRIM(addr_state) =''));
//Azure_DS := Azure_DS1//(transaction_id IN ['PDW250121223315VW7U4','PDW250122011150ZKSVM','PDW250122001422EGHD6','PDW250121200455BJU2F','PDW250121200049SD9ZS']);


OnPrem_File := '~thor::base::op::fcra::delta_inq_hist::20250213::delta_key';

OnPrem_DS := DATASET(OnPrem_File,Lay,THOR);

//*********************************************************************************************
// Project
//*********************************************************************************************

Proj_Lay := RECORD
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
  STRING500 Spec_Char_Columns;
 END;
 
specialCharPattern       := '^[a-zA-Z0-9 #\'-\\\\N]*$';  // Detects special characters 
allowedAddressPattern    := '^[a-zA-Z0-9 \\$&.,#\'-\\\\N]*$';  // Allows space, comma, period, hyphen, apostrophe in address field
State_specialCharPattern := '^[a-zA-Z \\\\N]*$'; 
City_specialCharPattern  := '^[a-zA-Z0-9 .\'-\\\\N]*$'; 
Zip_specialCharPattern := '^[a-zA-Z0-9 \\\\N]*$';
ssnRegEx               := '^[a-zA-Z0-9 ,|\\+-\\\\N]*$';



Proj_Lay FindSpecial(Azure_DS l) := TRANSFORM
  IsDriversLicNum  := REGEXFIND(specialCharPattern,TRIM(l.drivers_license_number,left,right));
  IS_name_first    := REGEXFIND(specialCharPattern,TRIM(l.name_first,left,right));
  IS_name_last     := REGEXFIND(specialCharPattern,TRIM(l.name_last,left,right));
  IS_name_middle   := REGEXFIND(specialCharPattern,TRIM(l.name_middle,left,right));
  IS_name_suffix   := REGEXFIND(specialCharPattern,TRIM(l.name_suffix,left,right));
  IS_addr_street   := REGEXFIND(allowedAddressPattern,TRIM(l.addr_street,left,right));
  IS_addr_city     := REGEXFIND(City_specialCharPattern,TRIM(l.addr_city,left,right));
  IS_addr_state    := REGEXFIND(State_specialCharPattern,TRIM(l.addr_state,left,right));
  IS_addr_zip5     := REGEXFIND(Zip_specialCharPattern,TRIM(l.addr_zip5,left,right));
  IS_addr_zip4     := REGEXFIND(Zip_specialCharPattern,TRIM(l.addr_zip4,left,right));
  IS_ssn           := REGEXFIND(ssnRegEx,TRIM(l.ssn,left,right));
  
  DriverLic   := IF(IsDriversLicNum,'', 'drivers_license_number ');
  NameFirst   := IF(IS_name_first,'', 'name_first ');
  NameLast    := IF(IS_name_last,'', 'name_last ');
  NameMiddle  := IF(IS_name_middle,'', 'name_middle ');
  NameSuffix  := IF(IS_name_suffix,'', 'name_suffix ');
  addr_street := IF(IS_addr_street,'', 'addr_street ');
  addr_city   := IF(IS_addr_city,'', 'addr_city ');
  addr_state  := IF(IS_addr_state,'', 'addr_state ');
  addr_zip5   := IF(IS_addr_zip5,'', 'addr_zip5 ');
  addr_zip4   := IF(IS_addr_zip4,'', 'addr_zip4 ');
  ssn         := IF(IS_ssn,'', 'ssn ');
 
 Totalstring := DriverLic+NameFirst+NameLast+NameMiddle+NameSuffix+addr_street+addr_city+addr_state+addr_zip5+addr_zip4+ssn;
 SELF.Spec_Char_Columns := STD.Str.CleanSpaces(Totalstring);
 SELF := l;
END;
SpecialChar_DS := PROJECT(Azure_DS, FindSpecial(LEFT));
SpecialChar_DS;
SpecialChar_DS(TRIM(Spec_Char_Columns)<>'' AND TRIM(Spec_Char_Columns,left,right)<>'addr_zip5' );                                                                                                                                                                                                                                                                                                                                     

//
namefirst_DS := SpecialChar_DS(TRIM(name_first)<>'');

namefirst_DS nameFir(namefirst_DS l) := TRANSFORM
  IsFound := STD.Str.FindWord(l.Spec_Char_Columns,'name_first');
  SELF.name_first := IF(IsFound,l.name_first,skip);
  SELF := l;
END;
Projnamefirst := PROJECT(namefirst_DS, nameFir(LEFT));
OUTPUT(Projnamefirst,named('firstname_specialChars'));

SpecialChar_DS(transaction_id ='PDW250122011150ZKSVM');

//**************************************************************************
namelast_DS := SpecialChar_DS(TRIM(name_last)<>'');
namelast_DS namelast(namelast_DS l) := TRANSFORM
  IsFound := STD.Str.FindWord(l.Spec_Char_Columns,'name_last');
  SELF.name_last := IF(IsFound,l.name_last,skip);
  SELF := l;
END;
Projnamelast := PROJECT(namelast_DS, namelast(LEFT));
OUTPUT(Projnamelast,named('lastname_specialChars'));

//**************************************************************************

DrivLisNum_DS := SpecialChar_DS(TRIM(drivers_license_number)<>'');
DrivLisNum_DS DrivLicNum(DrivLisNum_DS l) := TRANSFORM
  IsFound := STD.Str.FindWord(l.Spec_Char_Columns,'drivers_license_number');
  SELF.drivers_license_number := IF(IsFound,l.drivers_license_number,skip);
  SELF := l;
END;
ProjDrivLic := PROJECT(DrivLisNum_DS, DrivLicNum(LEFT));
OUTPUT(ProjDrivLic,named('DrivLic_specialChars'));

//**************************************************************************

NameMid_DS := SpecialChar_DS(TRIM(name_middle)<>'');
NameMid_DS NameMid(NameMid_DS l) := TRANSFORM
  IsFound := STD.Str.FindWord(l.Spec_Char_Columns,'name_middle');
  SELF.name_middle := IF(IsFound,l.name_middle,skip);
  SELF := l;
END;
ProjNameMid := PROJECT(NameMid_DS, NameMid(LEFT));
OUTPUT(ProjNameMid,named('NameMid_specialChars'));

//**************************************************************************

//**************************************************************************

AddrStreet_DS := SpecialChar_DS(TRIM(addr_street)<>'');
AddrStreet_DS AddrStreet(AddrStreet_DS l) := TRANSFORM
  IsFound := STD.Str.FindWord(l.Spec_Char_Columns,'addr_street');
  SELF.addr_street := IF(IsFound,l.addr_street,skip);
  SELF := l;
END;
ProjAddrStreet := PROJECT(AddrStreet_DS, AddrStreet(LEFT));
OUTPUT(ProjAddrStreet,named('AddrStreet_specialChars'));

//**************************************************************************

//**************************************************************************

City_DS := SpecialChar_DS(TRIM(addr_city)<>'');
City_DS City(City_DS l) := TRANSFORM
  IsFound := STD.Str.FindWord(l.Spec_Char_Columns,'addr_city');
  SELF.addr_city := IF(IsFound,l.addr_city,skip);
  SELF := l;
END;
ProjCity := PROJECT(City_DS, City(LEFT));
OUTPUT(ProjCity,named('City_specialChars'));

//*************************************************************************
//**************************************************************************

AddrState_DS := SpecialChar_DS(TRIM(addr_state)<>'');
AddrState_DS AddrState(AddrState_DS l) := TRANSFORM
  IsFound := STD.Str.FindWord(l.Spec_Char_Columns,'addr_state');
  SELF.addr_state := IF(IsFound,l.addr_state,skip);
  SELF := l;
END;
ProjAddrState := PROJECT(AddrState_DS, AddrState(LEFT));
OUTPUT(ProjAddrState,named('AddrState_specialChars'));

//*************************************************************************
//**************************************************************************

Zip5_DS := SpecialChar_DS(TRIM(addr_zip5)<>'');
Zip5_DS Zip5(Zip5_DS l) := TRANSFORM
  IsFound := STD.Str.FindWord(l.Spec_Char_Columns,'addr_zip5');
  SELF.addr_zip5 := IF(IsFound,l.addr_zip5,skip);
  SELF := l;
END;
ProjZip5 := PROJECT(Zip5_DS, Zip5(LEFT));
OUTPUT(ProjZip5,named('Zip5_specialChars'));

//*************************************************************************
//**************************************************************************

Zip4_DS := SpecialChar_DS(TRIM(addr_Zip4)<>'');
Zip4_DS Zip4(Zip4_DS l) := TRANSFORM
  IsFound := STD.Str.FindWord(l.Spec_Char_Columns,'addr_Zip4');
  SELF.addr_Zip4 := IF(IsFound,l.addr_Zip4,skip);
  SELF := l;
END;
ProjZip4 := PROJECT(Zip4_DS, Zip4(LEFT));
OUTPUT(ProjZip4,named('Zip4_specialChars'));

//*************************************************************************
//**************************************************************************

ssn_DS := SpecialChar_DS(TRIM(ssn)<>'');
ssn_DS SSN(ssn_DS l) := TRANSFORM
  IsFound := STD.Str.FindWord(l.Spec_Char_Columns,'ssn');
  SELF.ssn := IF(IsFound,l.ssn,skip);
  SELF := l;
END;
ProjSSN := PROJECT(ssn_DS, ssn(LEFT));
OUTPUT(ProjSSN,named('SSN_specialChars'));

CombinedDS := Projnamefirst + Projnamelast + ProjDrivLic + ProjNameMid + ProjAddrStreet + ProjCity + ProjAddrState + ProjZip5 + ProjZip4 + ProjSSN;
CombinedDS;


//**********************************************************
//Extracting the records from OnPremFile
//***********************************************************
// OnPremProj := Project(OnPrem_DS,TRANSFORM(Proj_Lay,SELF.Spec_Char_Columns:='',SELF:=LEFT));
// SetDS := [CombinedDS,OnPremProj];

// j2 := MERGEJOIN(SetDS,
                // STEPPED(LEFT.transaction_id=RIGHT.transaction_id),
                // SORTED(transaction_id));
// j2;


NewLay := RECORD
  unsigned8 lex_id;
  unsigned8 OP_lex_id;
  string30 product_id;
  string30 OP_product_id;
  string19 inquiry_date;
  string19 OP_inquiry_date;
  string20 transaction_id;
  string20 OP_transaction_id;
  string19 date_added;
  string19 OP_date_added;
  string5 customer_number;
  string5 OP_customer_number;
  string9 customer_account;
  string9 OP_customer_account;
  string9 ssn;
  string9 OP_ssn;
  string25 drivers_license_number;
  string25 OP_drivers_license_number;
  string2 drivers_license_state;
  string2 OP_drivers_license_state;
  string20 name_first;
  string20 OP_name_first;
  string20 name_last;
  string20 OP_name_last;
  string20 name_middle;
  string20 OP_name_middle;
  string20 name_suffix;
  string20 OP_name_suffix;
  string90 addr_street;
  string90 OP_addr_street;
  string25 addr_city;
  string25 OP_addr_city;
  string2 addr_state;
  string2 OP_addr_state;
  string5 addr_zip5;
  string5 OP_addr_zip5;
  string4 addr_zip4;
  string4 OP_addr_zip4;
  string10 dob;
  string10 OP_dob;
  integer4 seq_num;
  integer4 OP_seq_num;
  unsigned6 did;
  unsigned6 OP_did;
  STRING500 Spec_Char_Columns
  
END;
NewLay doJoin(CombinedDS l,OnPrem_DS r) := TRANSFORM
  SELF.OP_lex_id := r.lex_id;
  SELF.OP_product_id := r.product_id;
  SELF.OP_inquiry_date := r.inquiry_date;
  SELF.OP_transaction_id := r.transaction_id;
  SELF.OP_date_added := r.date_added;
  SELF.OP_customer_number := r.customer_number;
  SELF.OP_customer_account := r.customer_account;
  SELF.OP_ssn := r.ssn;
  SELF.OP_drivers_license_number := r.drivers_license_number;
  SELF.OP_drivers_license_state := r.drivers_license_state;
  SELF.OP_name_first := r.name_first;
  SELF.OP_name_last := r.name_last;
  SELF.OP_name_middle := r.name_middle;
  SELF.OP_name_suffix := r.name_suffix;
  SELF.OP_addr_street := r.addr_street;
  SELF.OP_addr_city := r.addr_city;
  SELF.OP_addr_state := r.addr_state;
  SELF.OP_addr_zip5 := r.addr_zip5;
  SELF.OP_addr_zip4 := r.addr_zip4;
  SELF.OP_dob := r.dob;
  SELF.OP_seq_num := r.seq_num;
  SELF.OP_did := r.did;
  SELF.Spec_Char_Columns := l.Spec_Char_Columns;
  SELF := l;
  
END;
MatchedDS := JOIN(CombinedDS, OnPrem_DS,
                    LEFT.lex_id=RIGHT.lex_id AND
                    LEFT.product_id=RIGHT.product_id AND
                    LEFT.transaction_id=RIGHT.transaction_id AND
                    LEFT.inquiry_date=RIGHT.inquiry_date AND
                    LEFT.date_added=RIGHT.date_added AND 
                    LEFT.seq_num=RIGHT.seq_num ,doJoin(LEFT,RIGHT));

OUTPUT(MatchedDS,named('matchedDs'));

// last good wuid : W20250128-221005

name := RECORD
   string28 lname;
   string20 fname;
   string15 mname;
   string3 sname;
  END;

cleaned_address := RECORD
   string2 record_type;
   string10 prim_range;
   string2 predir;
   string28 prim_name;
   string4 addr_suffix;
   string2 postdir;
   string10 unit_desig;
   string8 sec_range;
   string20 city;
   string2 st;
   string5 zip5;
   string4 zip4;
  END;

SubLay := RECORD
  string14 reference_no;
  string20 transaction_id;
  string5 customer_no;
  string9 account_no;
  string60 quoteback;
  string8 dateoforder;
  string8 process_date;
  string1 name_address_ind;
  string28 lname;
  string20 fname;
  string15 mname;
  string3 sname;
  string9 house_no;
  string20 street_name;
  string5 apt_no;
  string20 city;
  string2 state;
  string5 zip5;
  string4 zip4;
  string15 mortgagee_loan_num;
  string30 mortgagee_name;
  string20 policy_no;
  string20 policy_company;
  string2 policy_type;
  string9 ssn;
  string8 dob;
  string1 sex;
  string3 area_code;
  string7 tel_num;
  name cleanname;
  cleaned_address cleanaddress;
  unsigned8 source_rid;
  unsigned8 did;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

//Azure_File := '~thor::base::claimsdiscoveryproperty::az15a::qa::inqhist::subject';
Azure_File := '~thor::base::claimsdiscoveryproperty::az15a::20250116a::daily::inqhist::subject';

Azure_DS := DATASET(Azure_File,SubLay,THOR);

output(Azure_DS, named('Azure_DS'));
OUTPUT(COUNT(Azure_DS),named('Azure_DS_cnt'));


//OnPrem_File := '~thor::base::claimsdiscoveryproperty::onp15::qa::inqhist::subject';
OnPrem_File := '~thor::base::claimsdiscoveryproperty::onp15::20250116op::daily::inqhist::subject';

OnPrem_DS := DATASET(OnPrem_File,SubLay,THOR);

output(OnPrem_DS, named('OnPrem_DS'));
OUTPUT(COUNT(OnPrem_DS),named('OnPrem_DS_cnt'));

//***Verification for data difference************

DataDiff2 := OnPrem_DS-Azure_DS;
OUTPUT(CHOOSEN(DataDiff2,200),named('OnPrem_DataDiff'));

DataDiff1 := Azure_DS-OnPrem_DS;
OUTPUT(CHOOSEN(DataDiff1,200),named('Azure_DataDiff'));


//OUTPUT(Azure_DS( transaction_id IN ['18236783T000326','18236783T000937','18236783T000951']),named('AzureDS_SampleData'));
//OUTPUT(OnPrem_DS( transaction_id IN ['18236783T000326','18236783T000937','18236783T000951']),named('OnPrem_DS_SampleData'));



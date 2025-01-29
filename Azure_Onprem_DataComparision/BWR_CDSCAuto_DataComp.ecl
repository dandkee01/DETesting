
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
  string3 unit_no;
  string20 transaction_id;
  string5 customer_no;
  string9 account_no;
  string60 quoteback;
  string8 dateoforder;
  string8 process_date;
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
  string25 driverslicense_no;
  string2 driverslicense_state;
  string20 policy_no;
  string20 policy_company;
  string2 policy_type;
  string9 ssn;
  string8 dob;
  string1 sex;
  name cleanname;
  cleaned_address cleanaddress;
  unsigned8 source_rid;
  unsigned8 did;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;


Sub_Azure_File := '~thor::base::claimsdiscoveryauto::azu::20250124a::daily::inqhist::subject';

Sub_Azure_DS := DATASET(Sub_Azure_File,SubLay,THOR);

OUTPUT(COUNT(Sub_Azure_DS),named('Sub_Azure_DS_cnt'));


Sub_OnPrem_File := '~thor::base::claimsdiscoveryauto::onp::20250124::daily::inqhist::subject';

Sub_OnPrem_DS := DATASET(Sub_OnPrem_File,SubLay,THOR);

OUTPUT(COUNT(Sub_OnPrem_DS),named('Sub_OnPrem_DS_cnt'));

//***Verification for data difference************

Sub_DataDiff2 := Sub_OnPrem_DS-Sub_Azure_DS;
OUTPUT(Sub_DataDiff2,named('OnPrem_DataDiff'));
Sub_DataDiff1 := Sub_Azure_DS-Sub_OnPrem_DS;
OUTPUT(Sub_DataDiff1,named('Azure_DataDiff'));


//OUTPUT(Sub_Azure_DS( transaction_id IN ['18236783T000326','18236783T000937','18236783T000951']),named('AzureDS_SampleData'));
//OUTPUT(OnPrem_DS( transaction_id IN ['18236783T000326','18236783T000937','18236783T000951']),named('OnPrem_DS_SampleData'));


//Claim File

Claim_Lay := RECORD
  string14 reference_no;
  string3 unit_no;
  string25 claim_no;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

Claim_AzureFile := '~thor::base::claimsdiscoveryauto::azu::20250124a::daily::inqhist::claim';

Claim_Azure_DS := DATASET(Claim_AzureFile,Claim_Lay,THOR);

OUTPUT(COUNT(Claim_Azure_DS),named('Claim_Azure_DS_cnt'));


Claim_OnPrem_File := '~thor::base::claimsdiscoveryauto::onp::20250124::daily::inqhist::claim';

Claim_OnPrem_DS := DATASET(Claim_OnPrem_File,Claim_Lay,THOR);

OUTPUT(COUNT(Claim_OnPrem_DS),named('Claim_OnPrem_DS_cnt'));

//***Verification for data difference************

Claim_DataDiff2 := Claim_OnPrem_DS-Claim_Azure_Ds;
OUTPUT(Claim_DataDiff2,named('Claim_OnPrem_DataDiff'));
Claim_DataDiff1 := Claim_Azure_Ds-Claim_OnPrem_DS;
OUTPUT(Claim_DataDiff1,named('Claim_Azure_DataDiff'));




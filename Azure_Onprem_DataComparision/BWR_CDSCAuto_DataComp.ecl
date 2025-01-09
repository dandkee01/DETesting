
Lay := name := RECORD
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

 END;


Azure_File := '~thor::base::claimsdiscoveryauto::20240903a::inqhist::subject';

Azure_DS := DATASET(Azure_File,SubLay,THOR);

//OUTPUT(COUNT(Azure_DS),named('Azure_DS_cnt'));


OnPrem_File := '~thor::base::claimsdiscoveryauto::20240903::inqhist::subject';

OnPrem_DS := DATASET(OnPrem_File,SubLay,THOR);

//OUTPUT(COUNT(OnPrem_DS),named('OnPrem_DS_cnt'));

//***Verification for data difference************

DataDiff1 := Azure_DS-OnPrem_DS;
OUTPUT(CHOOSEN(DataDiff1,200),named('DataDiff1'));
DataDiff2 := OnPrem_DS-Azure_DS;
OUTPUT(CHOOSEN(DataDiff2,200),named('DataDiff2'));

OUTPUT(Azure_DS( transaction_id IN ['18236783T000326','18236783T000937','18236783T000951']),named('AzureDS_SampleData'));
OUTPUT(OnPrem_DS( transaction_id IN ['18236783T000326','18236783T000937','18236783T000951']),named('OnPrem_DS_SampleData'));


//**********************************************************************************************************************************************************

Lay2 := RECORD
  string20 transaction_id;
  string6 multi_report_sequence;
  string14 date_added;
  string20 reference_number;
  string14 order_date;
  string2 state_postal_code;
  string22 order_dln;
  string22 order_cleaned_dln;
  string22 result_cleaned_dln;
  string20 idl;
  string9 account;
  string14 response_date;
  string28 order_last_name;
  string20 order_first_name;
  string20 order_middle_name;
  string5 order_suffix_name;
  string8 order_dob;
  string1 order_sex;
  string9 order_ssn;
  string28 result_last_name;
  string20 result_first_name;
  string20 result_middle_name;
  string5 result_suffix_name;
  string8 result_dob;
  string1 result_sex;
  string9 result_ssn;
  string3 fulfilled_by;
  string10 business_line;
  string1 mode;
  string1 mvr_type;
  string1 private;
  string1 restricted;
  string1 amplified;
  string1 source;
  string1 mvr_status;
  string14 report_date;
  string16 unique_mvr_id;
  unsigned4 record_expires_date;
 END;

DeltaAzure_File := '~thor::base::mvr::20240902a::2024-09-032204062::delta_key.txt';

DisDeltaAzure_DS := DATASET(DeltaAzure_File,Lay2,THOR);


//OUTPUT(COUNT(DisDeltaAzure_DS),named('DeltaAzure_DS_cnt'));


DeltaOnPrem_File := '~thor::base::mvr::20240902::2024-09-032240042::delta_key.txt';

DisDeltaOnPrem_DS := DATASET(DeltaOnPrem_File,Lay2,THOR);



//OUTPUT(COUNT(DisDeltaOnPrem_DS),named('DeltaOnPrem_DS_cnt'));

//***Verification for data difference************

DeltaDataDiff1 := DisDeltaAzure_DS-DisDeltaOnPrem_DS;
OUTPUT(CHOOSEN(DeltaDataDiff1,200),named('DeltaDataDiff1'));
DeltaDataDiff2 := DisDeltaOnPrem_DS-DisDeltaAzure_DS;
OUTPUT(CHOOSEN(DeltaDataDiff2,200),named('DeltaDataDiff2'));

OUTPUT(DisDeltaAzure_DS( transaction_id IN ['18140073T000139','	18140073T000492','18235343T001283']),named('Delta_AzureDS_SampleData'));
OUTPUT(DisDeltaOnPrem_DS( transaction_id IN ['18140073T000139','	18140073T000492','18235343T001283']),named('DeltaOnPrem_DS_SampleData'));

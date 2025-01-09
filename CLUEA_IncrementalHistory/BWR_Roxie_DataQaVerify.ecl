#workunit('name','CLUEA Roxie Scenarios Verify Baseline');

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

Lay := RECORD
  string14 reference_no;
  string3 unit_no;
  string20 transaction_id;
  string5 customer_no;
  string9 account_no;
  string60 quoteback;
  string8 dateoforder;
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
  string1 service_type;
  string8 process_date;
  string5 spl_bill_id;
  string1 bill_as;
  string1 report_as;
  unsigned8 xlink_weight;
 END;  
  
  Baseline      := '~thor::base::clueauto::kcd::20240818::inqhist::subject';
  Baseline_DS		:= DATASET (Baseline,Lay,THOR);	
  
  //Baseline_DS( did IN [52458724414,352853888,7631362110,165843747217,1500991588,34547178264]);
  OUTPUT(SORT(Baseline_DS( did = 52458724414),-process_date),named('Sub_Calvin'));
  OUTPUT(SORT(Baseline_DS( did = 352853888),-process_date),named('Sub_Donna'));
  OUTPUT(SORT(Baseline_DS( did = 7631362110),-process_date),named('Sub_Jake'));
  OUTPUT(SORT(Baseline_DS( did = 165843747217),-process_date),named('Sub_Edin'));
  OUTPUT(SORT(Baseline_DS( did = 1500991588),-process_date),named('Sub_Elizabeth'));
  OUTPUT(SORT(Baseline_DS( did = 34547178264),-process_date),named('Sub_Doraelia'));
  
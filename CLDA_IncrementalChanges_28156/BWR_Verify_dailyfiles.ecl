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

SubDailyRec := RECORD
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



daily1   := '~thor::base::clueauto::kcd::20240613::daily::inqhist::subject';
 Daily1DS		:= DATASET (daily1,SubDailyRec,THOR);	
 //OUTPUT(Daily1DS/*(reference_no='11111111111001')*/,{transaction_id,reference_no,unit_no,source_rid,lname,fname,mname,record_sid,dt_effective_first,dt_effective_last,delta_ind},named('daily1_Subject'));
 OUTPUT(Daily1DS/*(reference_no='11111111111001')*/,named('daily1_Subject'));
 
 
 daily2   := '~thor::base::clueauto::kcd::20240614::daily::inqhist::subject';
 Daily2DS		:= DATASET (daily2,SubDailyRec,THOR);	
 OUTPUT(Daily2DS/*(reference_no='11111111111001')*/,named('daily2_Subject'));
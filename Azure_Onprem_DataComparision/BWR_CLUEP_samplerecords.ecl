IMPORT Std,_control;

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
  string20 transaction_id;
  string5 customer_no;
  string9 account_no;
  string60 quoteback;
  string8 dateoforder;
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
  string1 service_type;
  string8 process_date;
  string5 spl_bill_id;
  string1 account_class;
  string1 report_as;
  unsigned8 xlink_weight;
 END;


OnPrem_File := DATASET('~thor::base::clueproperty::op::20250129op::daily::inqhist::subject',Lay,THOR);

Azure_File := DATASET('~thor::base::clueproperty::az::20250129a::daily::inqhist::subject',Lay,THOR);


OUTPUT(Azure_File(reference_no IN ['25028045736055','25028066035294','25028076634062','25029001731308','25028098131889']),named('Azure_Sample'));
OUTPUT(OnPrem_File(reference_no IN ['25028045736055','25028066035294','25028076634062','25029001731308','25028098131889']),named('Onprem_Sample'));

OUTPUT(COUNT(OnPrem_File(delta_ind=3)),named('OnPrem_Delta3'));
OUTPUT(COUNT(OnPrem_File(delta_ind=2)),named('OnPrem_Delta2'));

OUTPUT(COUNT(Azure_File(delta_ind=3)),named('Azure_Delta3'));
OUTPUT(COUNT(Azure_File(delta_ind=2)),named('Azure_Delta2'));



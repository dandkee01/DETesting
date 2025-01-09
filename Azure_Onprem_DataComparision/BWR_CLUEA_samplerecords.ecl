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
 
 Sub_Layout := RECORD
   string20 transaction_id;
   string14 reference_no;
 END;
 

OnPrem_File := '~thor::base::clueauto::psb::20241113::daily::inqhist::subject';

OnPrem_DS       := DATASET(OnPrem_File,Lay,THOR);


Azure_File := '~thor::base::clueauto::psb::20241113a::daily::inqhist::subject';

Azure_DS := DATASET(Azure_File,Lay,THOR);

OUTPUT(OnPrem_DS(reference_no IN ['24316070836426','24316071339684','24316071739276']), named('OnPremOnly_Recs'));
OUTPUT(Azure_DS(reference_no IN ['24316070836426','24316071339684','24316071739276']), named('NotIn_Azure'));

OUTPUT(Azure_DS(reference_no in ['24317115639561','24317116839085','24317118038168']), named('AzureOnly_Recs'));
OUTPUT(OnPrem_DS(reference_no in ['24317115639561','24317116839085','24317118038168']), named('NotIn_OnPrem'));

OUTPUT(Azure_DS(reference_no in ['24317000233568	','24317000233569','24317000233570']), named('AzureExistBoth'));
OUTPUT(OnPrem_DS(reference_no in ['24317000233568	','24317000233569','24317000233570']), named('OnPremExistBoth'));

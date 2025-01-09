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

lay := RECORD
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



Daily1 := DATASET('~thor::base::claimsdiscoveryproperty::kcd::20240827::daily::inqhist::subject',lay,THOR);
Daily2 := DATASET('~thor::base::claimsdiscoveryproperty::kcd::20240828::daily::inqhist::subject',lay,THOR);
Daily3 := DATASET('~thor::base::claimsdiscoveryproperty::kcd::20240829::daily::inqhist::subject',lay,THOR);
Daily4 := DATASET('~thor::base::claimsdiscoveryproperty::kcd::20240830::daily::inqhist::subject',lay,THOR);
Daily5 := DATASET('~thor::base::claimsdiscoveryproperty::kcd::20240831::daily::inqhist::subject',lay,THOR);
Daily6 := DATASET('~thor::base::claimsdiscoveryproperty::kcd::20240902::daily::inqhist::subject',lay,THOR);
DailyDS := Daily1+Daily2+Daily3+Daily4+Daily5+Daily6;
OUTPUT(dailyDS(reference_no='11111111111111'),named('DailyDS'));
qa := '~thor::base::claimsdiscoveryproperty::kcd::20241013::inqhist::subject';
qaDS := DATASET(qa,lay,THOR);
OUTPUT(qaDS(reference_no='11111111111111'),named('qaDS'));
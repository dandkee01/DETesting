IMPORT CCLUE_PriorHistory;
//***************************************************************************

//before_project := DATASET('~thor::base::cclue::priorhist::20240102e::subject',CCLUE_PriorHistory.Layouts.delta_subject_clean, THOR);
//OUTPUT(COUNT(before_project),named('before_project'));


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

Daily1 := DATASET('~thor::base::claimsdiscoveryproperty::kcd::20241013::inqhist::subject',Lay, THOR);
OUTPUT(Daily1(did IN[	165082321737,165610272414,165729633940,165806561989]));
//OUTPUT(Daily1(lname='PERRY' and fname='DONNA'));
// OUTPUT(SORT(Daily1,reference_no), named('sorted_ref_Daily1'));
// OUTPUT(Daily1(reference_no='11111111111111'), named('refRec_Daily1'));
//OUTPUT(Daily1(, named('sorted_ref'));

// Daily2 := DATASET('~thor::base::claimsdiscoveryproperty::kcd::20240828::daily::inqhist::subject',Lay, THOR);
// OUTPUT(SORT(Daily2,reference_no), named('sorted_ref_Daily2'));
// OUTPUT(Daily2(reference_no='11111111111111'), named('refRec_Daily2'));

                                                       

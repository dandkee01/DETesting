IMPORT CCLUE_PriorHistory;
//***************************************************************************

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

subLay := RECORD
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


Sub_DS := DATASET('~thor::base::claimsdiscoveryauto::kcd::20240908::inqhist::subject',subLay, THOR);
OUTPUT(Sub_DS(did=243510411 and lname='BOTKIN' and fname='LEIF'));

//OUTPUT(COUNT(Sub_DS),named('Sub_DS'));
// OUTPUT(Sub_Ds(Delta_ind <>1),named('Sub_DS_Delta'));
// OUTPUT(Sub_Ds(dt_effective_first=0),named('Sub_DS_Dt_First'));
// OUTPUT(Sub_Ds(dt_effective_last <>0),named('Sub_DS_Dt_Last'));

// Baseline_DS := DATASET('~thor::base::claimsdiscoveryauto::kcd::20240712::inqhist::subject',subLay, THOR);
// Daily_Ds := Sub_DS-Baseline_DS;
// OUTPUT(SORT(Daily_Ds,reference_no,unit_no),named('DailySub_Recs_AfterRollup'));
                                                       
//*****************************************************************************************************************

// ClaimLay := RECORD
  // string14 reference_no;
  // string3 unit_no;
  // string25 claim_no;
  // unsigned8 record_sid;
  // unsigned4 dt_effective_first;
  // unsigned4 dt_effective_last;
  // unsigned1 delta_ind;
 // END;

// Claim_DS := DATASET('~thor::base::claimsdiscoveryauto::kcd::20240804::inqhist::claim',ClaimLay, THOR);
// OUTPUT(COUNT(Claim_DS),named('Claim_DS'));
// OUTPUT(Claim_Ds(Delta_ind <>1),named('Claim_DS_Delta'));
// OUTPUT(Claim_Ds(dt_effective_first=0),named('Claim_DS_Dt_First'));
// OUTPUT(Claim_Ds(dt_effective_last <>0),named('Claim_DS_Dt_Last'));

// ClaimBaseline_DS := DATASET('~thor::base::claimsdiscoveryauto::kcd::20240712::inqhist::claim',ClaimLay, THOR);
// ClaimDaily_Ds := Claim_DS-ClaimBaseline_DS;
// OUTPUT(SORT(ClaimDaily_Ds,reference_no,unit_no),named('DailyClaim_Recs_AfterRollup'));
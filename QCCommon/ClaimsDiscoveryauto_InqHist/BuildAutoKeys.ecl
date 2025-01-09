address := RECORD
  string28 prim_name;
  string10 prim_range;
  string2 st;
  unsigned4 city_code;
  string5 zip;
  string8 sec_range;
  string6 dph_lname;
  string20 lname;
  string20 pfname;
  string20 fname;
  unsigned8 states;
  unsigned4 lname1;
  unsigned4 lname2;
  unsigned4 lname3;
  unsigned4 lookups
  =>
  unsigned6 did;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;
 
 CityState := RECORD
  unsigned4 city_code;
  string2 st;
  string6 dph_lname;
  string20 lname;
  string20 pfname;
  string20 fname;
  integer4 dob;
  unsigned8 states;
  unsigned4 lname1;
  unsigned4 lname2;
  unsigned4 lname3;
  unsigned4 city1;
  unsigned4 city2;
  unsigned4 city3;
  unsigned4 rel_fname1;
  unsigned4 rel_fname2;
  unsigned4 rel_fname3;
  unsigned4 lookups
  =>
  unsigned6 did;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;
 
 name := RECORD
  string6 dph_lname;
  string20 lname;
  string20 pfname;
  string20 fname;
  string1 minit;
  unsigned2 yob;
  unsigned2 s4;
  integer4 dob;
  unsigned8 states;
  unsigned4 lname1;
  unsigned4 lname2;
  unsigned4 lname3;
  unsigned4 city1;
  unsigned4 city2;
  unsigned4 city3;
  unsigned4 rel_fname1;
  unsigned4 rel_fname2;
  unsigned4 rel_fname3;
  unsigned4 lookups
  =>
  unsigned6 did;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

policy := RECORD
  string20 policy_no;
  string14 reference_no;
  string3 unit_no
  =>
  unsigned6 did;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;
 
 DLNO := RECORD
  string25 dl_nbr;
  string14 reference_no;
  string3 unit_no
  =>
  unsigned6 did;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;
 
 ssn2 := RECORD
  string1 s1;
  string1 s2;
  string1 s3;
  string1 s4;
  string1 s5;
  string1 s6;
  string1 s7;
  string1 s8;
  string1 s9;
  string6 dph_lname;
  string20 pfname;
  unsigned6 did
  =>
  unsigned4 lookups;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;
 
 stname := RECORD
  string2 st;
  string6 dph_lname;
  string20 lname;
  string20 pfname;
  string20 fname;
  string1 minit;
  unsigned2 yob;
  unsigned2 s4;
  integer4 zip;
  integer4 dob;
  unsigned8 states;
  unsigned4 lname1;
  unsigned4 lname2;
  unsigned4 lname3;
  unsigned4 city1;
  unsigned4 city2;
  unsigned4 city3;
  unsigned4 rel_fname1;
  unsigned4 rel_fname2;
  unsigned4 rel_fname3;
  unsigned4 lookups
  =>
  unsigned6 did;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

Zip := RECORD
  integer4 zip;
  string6 dph_lname;
  string20 lname;
  string20 pfname;
  string20 fname;
  string1 minit;
  unsigned2 yob;
  unsigned2 s4;
  integer4 dob;
  unsigned8 states;
  unsigned4 lname1;
  unsigned4 lname2;
  unsigned4 lname3;
  unsigned4 city1;
  unsigned4 city2;
  unsigned4 city3;
  unsigned4 rel_fname1;
  unsigned4 rel_fname2;
  unsigned4 rel_fname3;
  unsigned4 lookups
  =>
  unsigned6 did;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;



 
 AddressDs   := INDEX(address,'~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::address_qa');
 CityStateDs := INDEX(CityState,'~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::citystname_qa');
 nameDs      := INDEX(name,'~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::name_qa');
 policyDs    := INDEX(policy,'~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::policy_qa');
 DLNODs      := INDEX(DLNO,'~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::dlno_qa');
 ssn2Ds      := INDEX(ssn2,'~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::ssn2_qa');
 stnameDs    := INDEX(stname,'~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::stname_qa');
 zipDs       := INDEX(Zip,'~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::zip_qa');
 
 OUTPUT(AddressDs,named('AddressDs'));
 OUTPUT(CityStateDs,named('CityStateDs'));
 OUTPUT(nameDs,named('nameDs'));
 OUTPUT(policyDs,named('policyDs'));
 OUTPUT(DLNODs,named('DLNODs'));
 OUTPUT(ssn2Ds,named('ssn2Ds'));
 OUTPUT(stnameDs,named('stnameDs'));
 OUTPUT(zipDs,named('zipDs'));
 


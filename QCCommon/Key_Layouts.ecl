EXPORT Key_Layouts := MODULE
  EXPORT cnsmr_did := RECORD
		unsigned8 did
  =>
  string14 reference_no;
  string3 unit_no;
  unsigned8 xlink_weight;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
	END;
  
  EXPORT refno_claim := RECORD
	string14 reference_no;
  string3 unit_no
  =>
  string25 claim_no;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
	END;
  
  EXPORT name := RECORD
   string28 lname;
   string20 fname;
   string15 mname;
   string3 sname;
  END;

EXPORT cleaned_address := RECORD
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
  
  EXPORT inquiry := RECORD
	string14 reference_no;
  string3 unit_no
  =>
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
  
  EXPORT inquiry_did := RECORD
  
  unsigned8 did
  =>
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
 
 EXPORT acctno := RECORD
  string9 account_no
  =>
  string40 account_name;
  string5 cust_no;
  string1 bill_as;
  string1 report_as;
  string40 cust_name;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;
 
 EXPORT cnsmr_address := RECORD
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
 
 EXPORT cnsmr_citystname := RECORD
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
 
 EXPORT cnsmr_name := RECORD
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
 
 EXPORT cnsmr_policy := RECORD
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
 
 EXPORT cnsmr_dlno := RECORD
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
 
 EXPORT cnsmr_ssn := RECORD
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
 
 EXPORT cnsmr_stname := RECORD
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
 
 EXPORT cnsmr_zip := RECORD
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

END;
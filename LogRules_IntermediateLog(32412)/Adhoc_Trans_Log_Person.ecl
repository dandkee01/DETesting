IMPORT STANDARD,Orbit4, CLUETrans_Build;


Lay := RECORD
  string20 transaction_id;
  string3 sequence;
  string20 first_name;
  string5 middle_name;
  string20 last_name;
  string3 suffix_name;
  string9 ssn;
  string2 current_dl_state;
  string25 current_dl_number;
  string2 prior_dl_state;
  string25 prior_dl_number;
  string20 prior_policy_number;
  string20 date_added;
  string14 reference_no;
  string3 unit_no;
  string5 customer_no;
  string60 quoteback;
  string8 order_date;
  string9 current_house_no;
  string20 current_street_name;
  string5 current_apt_no;
  string20 current_city;
  string2 current_state;
  string5 current_zip;
  string4 current_zip_ext;
  string9 former_house_no;
  string20 former_street_name;
  string5 former_apt_no;
  string20 former_city;
  string2 former_state;
  string5 former_zip;
  string4 former_zip_ext;
  string8 dob;
  string1 sex;
  string1 service_type;
  string20 spl_bill_id;
  string11 product_id;
  string3 telephone_area_code;
  string3 telephone_exchange;
  string4 telephone_number;
  string1 subject_process_stat_code;
  string15 mortgage_no;
  unsigned6 lex_id;
  string1 potentialcorruption;
 END;
 
 Lay1 := RECORD
  string20 transaction_id;
  string3 sequence;
  string20 first_name;
  string5 middle_name;
  string20 last_name;
  string3 suffix_name;
  string9 ssn;
  string2 current_dl_state;
  string25 current_dl_number;
  string2 prior_dl_state;
  string25 prior_dl_number;
  string20 prior_policy_number;
  string20 date_added;
  string14 reference_no;
  string3 unit_no;
  string5 customer_no;
  string60 quoteback;
  string8 order_date;
  string9 current_house_no;
  string20 current_street_name;
  string5 current_apt_no;
  string20 current_city;
  string2 current_state;
  string5 current_zip;
  string4 current_zip_ext;
  string9 former_house_no;
  string20 former_street_name;
  string5 former_apt_no;
  string20 former_city;
  string2 former_state;
  string5 former_zip;
  string4 former_zip_ext;
  string8 dob;
  string1 sex;
  string1 service_type;
  string20 spl_bill_id;
  string11 product_id;
  string3 telephone_area_code;
  string3 telephone_exchange;
  string4 telephone_number;
  string1 subject_process_stat_code;
  string15 mortgage_no;
  unsigned6 lex_id;
  string1 potentialcorruption;
	STANDARD.LAYOUTS.LAYOUT_ORBIT;
 END;
 
base := dataset('~thor::base::clue::qa::transaction_log_person.txt',Lay,Thor);

global_source_id :=  Orbit4.get_glb_srcid_from_orbit(CLUETrans_Build.orbitIConstants('transaction_log_person.txt').datasetname, CLUETrans_Build.Constants('').QC_email_target);
OUTPUT(COUNT(base),named('before_project_cnt'));																	
																		
Updated_Base := PROJECT (base, TRANSFORM(lay1, 
                                                       SELF.Record_Sid := COUNTER; 
                                                       SELF.global_sid := global_source_id; 
																											 SELF := LEFT;
                                                       SELF := []));
																											 
Base_dist := Distribute (Updated_Base,HASH32(transaction_id));																											 
OUTPUT(COUNT(Base_dist),named('after_project_cnt'));																	
max(Base_dist, record_sid);

OUTPUT(Base_dist,,'~thor::base::clue::20240313a::transaction_log_person.txt', overwrite, __compressed__); 
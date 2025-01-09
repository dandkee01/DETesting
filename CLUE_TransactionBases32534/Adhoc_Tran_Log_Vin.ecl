IMPORT STANDARD,Orbit4, CLUETrans_Build;
#workunit('priority', 'high');
#workunit('priority', '10');
Lay := RECORD
  string20 transaction_id;
  string14 reference_no;
  string3 unit_no;
  string8 order_date;
  string25 vin;
  string4 model_year;
  string40 make_model;
  string20 date_added;
  string1 vin_proc_stat_code;
  string1 potentialcorruption;
 END;
 
 Lay1 := RECORD
  string20 transaction_id;
  string14 reference_no;
  string3 unit_no;
  string8 order_date;
  string25 vin;
  string4 model_year;
  string40 make_model;
  string20 date_added;
  string1 vin_proc_stat_code;
  string1 potentialcorruption;
	STANDARD.LAYOUTS.LAYOUT_ORBIT;
 END;
 
 base := dataset('~thor::base::clue::qa::transaction_log_vin.txt',Lay,Thor);

global_source_id :=  Orbit4.get_glb_srcid_from_orbit(CLUETrans_Build.orbitIConstants('transaction_log_vin.txt').datasetname, CLUETrans_Build.Constants('').QC_email_target);
OUTPUT(COUNT(base),named('before_project_cnt'));																	
																		
Updated_Base := PROJECT (base, TRANSFORM(lay1, 
                                                       SELF.Record_Sid := COUNTER; 
                                                       SELF.global_sid := global_source_id; 
																											 SELF := LEFT;
                                                       SELF := []));
																											 
Base_dist := Distribute (Updated_Base,HASH32(transaction_id));																											 
OUTPUT(COUNT(Base_dist),named('after_project_cnt'));																	
max(Base_dist, record_sid);

OUTPUT(Base_dist,,'~thor::base::clue::20240313a::transaction_log_vin.txt', overwrite, __compressed__); 
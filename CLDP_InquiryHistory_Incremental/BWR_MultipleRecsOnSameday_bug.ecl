IMPORT CCLUE_PriorHistory, Delta_Macro, Data_Services; 

Spray_Lay := RECORD
  string20 transaction_id;
  integer3 sequence;
  string20 reference_no;
  string8 order_date;
  string8 process_date;
  string25 date_added;
  string9 account_no;
  string5 customer_no;
  string1 search_type;
  string8 policy_eff_date;
  string12 line_of_business;
  string120 business_name;
  string50 last_name;
  string50 first_name;
  string15 middle_name;
  string4 suffix_name;
  string8 dob;
  string25 drivers_license_no;
  string2 drivers_license_state;
  string1 address_ind;
  string9 house_no;
  string40 street_name;
  string5 apt_no;
  string30 city;
  string2 state;
  string5 zip5;
  string4 zip4;
  string25 prior_policy_no;
  string8 prior_policy_eff_date;
  string1 secondary_report;
  integer3 count_business;
  integer3 count_individual;
  integer3 count_lob;
  integer3 count_prior_policy_no;
  integer3 count_address_primary;
  integer3 count_address_mailing;
  integer3 count_address_prior;
  integer3 count_address_total;
  string119 individual_name_key;
  string60 address_key;
  string33 prior_policy_key;
  string1 clda_ordered;
  string1 cldp_ordered;
  string1 secondary_report_clda;
  string1 secondary_report_cldp;
 END;

 Daily_0602_Spray   := '~thor::base::cclue::priorhist::20240602::delta_subject';
 Daily_0602_SprayDS		:= DATASET (Daily_0602_Spray,Spray_Lay,THOR);	
 OUTPUT(SORT(Daily_0602_SprayDS,reference_no,date_added),named('Sprayed_Ds'));
 Set_Ref := SET(Daily_0602_SprayDS, reference_no);
 
 Daily_0602   := '~thor::base::cclue::priorhist::20240602::daily::subject';
 Daily_0602_DS		:= DATASET (Daily_0602,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);	
 OUTPUT(Daily_0602_DS(reference_no IN Set_Ref),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Daily_0602'));
 	
 Sub_0602   := '~thor::base::cclue::priorhist::20240321::subject';
 Sub_0602_DS		:= DATASET (Sub_0602,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);	
 OUTPUT(Sub_0602_DS(reference_no IN Set_Ref),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Sub_0602'));



 Prod_Spray       := 'thor::base::cclue::priorhist::qa::delta_subject';
 Prod_SprayF      := 'thor::base::cclue::priorhist::father::delta_subject';
 Prod_SprayGF     := 'thor::base::cclue::priorhist::grandfather::delta_subject';
 Prod_SprayDS		  := DATASET (Data_Services.foreign_prod+Prod_Spray,Spray_Lay,THOR);	
 Prod_SprayDSF		:= DATASET (Data_Services.foreign_prod+Prod_SprayF,Spray_Lay,THOR);	
 Prod_SprayDSGF		:= DATASET (Data_Services.foreign_prod+Prod_SprayGF,Spray_Lay,THOR);	

 Full_Prod_SprayDS := Prod_SprayDS + Prod_SprayDSF + Prod_SprayDSGF;
 
 rec := RECORD
    Full_Prod_SprayDS.reference_no;
    refCnt := COUNT(GROUP);
 END;
 Ref_table := TABLE(Full_Prod_SprayDS,rec,reference_no,sequence);
 OUTPUT(Ref_table(refCnt>1), named('Ref_table'));
 
 
 FullSpRefset := SET(Ref_table(refCnt>1), reference_no);
 OUTPUT(SORT(Full_Prod_SprayDS(reference_no IN FullSpRefset),reference_no,sequence), named('Full_Prod_SprayDS'));
 

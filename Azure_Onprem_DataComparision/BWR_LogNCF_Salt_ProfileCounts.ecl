IMPORT Insurview_SALT_Project, salt23;

lay := RECORD
  unsigned2 juliandate;
  unsigned4 remainingrefno;
  unsigned1 reportsource;
  unsigned2 linenumber;
  string230 edits;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

     
inqhist_ds := dataset('~thor::base::ncf::20241113::master_archive_report', lay, thor);
                
saltDS1 := Insurview_SALT_Project.mac_profile(inqhist_ds);

//Iheader := OUTPUT(saltDS1,, '~thor::base::kcd::logncf::saltprofile::onprem', overwrite, __compressed__, named('salt_onprem'));


inqhist_ds1 := dataset('~thor::base::ncf::20241113a::master_archive_report', lay, thor);
                
saltDS2 := Insurview_SALT_Project.mac_profile(inqhist_ds1);

//Iheader := OUTPUT(saltDS2,, '~thor::base::kcd::logncf::saltprofile::azure', overwrite, __compressed__, named('salt_azure'));


DataDiff := saltDS1-saltDS2;
OUTPUT(DataDiff,named('Onprem_MasterArc_DataDiff'));

DataDiff1 := saltDS2-saltDS1;
OUTPUT(DataDiff1,named('Azure_MasterArc_DataDiff'));


//***********************************************


lay2 := RECORD
  string20 transaction_id;
  string14 reference_number;
  string8 date_added;
  string5 customer_number;
  string9 ssn;
  string30 full_last_name;
  string20 full_first_name;
  string20 last_name;
  string5 first_name;
  string8 dob;
  string9 spouse_ssn;
  string20 spouse_last_name;
  string20 spouse_first_name;
  string8 spouse_dob;
  string9 house_number;
  string20 street_name;
  string2 state;
  string2 rating_state;
  string5 zip;
  string4 zip4;
  string1 beacon;
  string1 safe_scan;
  string1 emperica;
  string1 hawk;
  string1 facs;
  string4 score_model_1;
  string4 score_model_2;
  string4 score_model_3;
  string4 score_model_4;
  string4 score_model_5;
  string4 score_model_6;
  string4 score_model_7;
  string4 score_model_8;
  string2 score_ind;
  string1 input_type;
  string1 test_prod_ind;
  string1 first_vendor;
  string1 second_vendor;
  string1 final_vendor;
  string8 order_date;
  string3 order_status;
  string1 model_version1;
  string1 model_version2;
  string1 dispute_flag;
  string1 type_of_report;
  unsigned8 lexid;
  unsigned8 spouse_lexid;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

     
 Deltainqhist_ds := dataset('~thor::base::ncf::20241113::delta_key.txt', lay2, thor);
                
DS1 := Insurview_SALT_Project.mac_profile(Deltainqhist_ds);

Deltainqhistazure_ds := dataset('~thor::base::ncf::20241113a::delta_key.txt', lay2, thor);
                
DS2 := Insurview_SALT_Project.mac_profile(Deltainqhistazure_ds);


DataDifdDelta := Ds1-Ds2;
OUTPUT(DataDifdDelta, named('Onprem_DeltaKey_datadiff'));

DataDifdDelta2 := Ds2-Ds1;
OUTPUT(DataDifdDelta2, named('Azure_DeltaKey_datadiff'));
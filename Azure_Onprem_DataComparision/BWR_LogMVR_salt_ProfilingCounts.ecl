IMPORT Insurview_SALT_Project, SALT23, STD, _Control;

lay := RECORD
  string20 transaction_id;
  string6 multi_report_sequence;
  string14 date_added;
  string20 reference_number;
  string14 order_date;
  string2 state_postal_code;
  string22 order_dln;
  string22 order_cleaned_dln;
  string22 result_cleaned_dln;
  string20 idl;
  string9 account;
  string14 response_date;
  string28 order_last_name;
  string20 order_first_name;
  string20 order_middle_name;
  string5 order_suffix_name;
  string8 order_dob;
  string1 order_sex;
  string9 order_ssn;
  string28 result_last_name;
  string20 result_first_name;
  string20 result_middle_name;
  string5 result_suffix_name;
  string8 result_dob;
  string1 result_sex;
  string9 result_ssn;
  string3 fulfilled_by;
  string10 business_line;
  string1 mode;
  string1 mvr_type;
  string1 private;
  string1 restricted;
  string1 amplified;
  string1 source;
  string1 mvr_status;
  string14 report_date;
  string16 unique_mvr_id;
  unsigned4 record_expires_date;
 END;


     
inqhist_ds := dataset('~thor::base::mvr::20240916a::2024-09-162227421::delta_report.txt', lay, thor);
                
Azure_saltDS1 := Insurview_SALT_Project.mac_profile(inqhist_ds);

inqhist_ds2 := dataset('~thor::base::mvr::20240916o::2024-09-162200231::delta_report.txt',lay, thor);
                
Onprem_saltDS2 := Insurview_SALT_Project.mac_profile(inqhist_ds2);

DataDiff1 := Azure_saltDS1-Onprem_saltDS2;
OUTPUT(DataDiff1, named('DataDiff1'));

DataDiff2 := Onprem_saltDS2-Azure_saltDS1;
OUTPUT(DataDiff2, named('DataDiff2'));

DesprayFun(STRING file, STRING fname) := FUNCTION

   DateToday             := (STRING)STD.date.Today();
   fileName              := fname+DateToday+'.csv';
   LandingZone_File_Dir  := '/data/DandKe01/AzureOnPrem/';
   lzFilePathBaseFile    := LandingZone_File_Dir + fileName; 
   LandingZoneIP         := _control.IPAddress.unixland;//10.194.72.227//
   TempCSV               := file;

/*---------------------------------------------------------------------------------*/
 deSprayCSV        := STD.File.DeSpray(TempCSV,LandingZoneIP,lzFilePathBaseFile,-1,,,TRUE);
 
 delCSV := NOTHOR(FileServices.DeleteLogicalFile(TempCSV));
 Actions := SEQUENTIAL(deSprayCSV,delCSV);
 RETURN Actions;
 
END;

//************************************************************************************************************************************************

AzureDataDiff1 := OUTPUT(DataDiff1,,'~thor::base::salt::Azure::LogMVR::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure := DesprayFun('~thor::base::salt::Azure::LogMVR::KCD::CSV','AzureSalt_Datadiff_LogMVR');

Actions := SEQUENTIAL(AzureDataDiff1, DespryAzure);

Actions;

//*************************************************************************************************************************************************

AzureDataDiff2 := OUTPUT(DataDiff2,,'~thor::base::salt::Onprem::LogMVR::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure1 := DesprayFun('~thor::base::salt::OnPrem::LogMVR::KCD::CSV','OnPremSalt_Datadiff_LogMVR');

Actions1 := SEQUENTIAL(AzureDataDiff2, DespryAzure1);

Actions1;


//**********************************************************************************************************************************************************

Lay2 := RECORD
  string20 transaction_id;
  string6 multi_report_sequence;
  string14 date_added;
  string20 reference_number;
  string14 order_date;
  string2 state_postal_code;
  string22 order_dln;
  string22 order_cleaned_dln;
  string22 result_cleaned_dln;
  string20 idl;
  string9 account;
  string14 response_date;
  string28 order_last_name;
  string20 order_first_name;
  string20 order_middle_name;
  string5 order_suffix_name;
  string8 order_dob;
  string1 order_sex;
  string9 order_ssn;
  string28 result_last_name;
  string20 result_first_name;
  string20 result_middle_name;
  string5 result_suffix_name;
  string8 result_dob;
  string1 result_sex;
  string9 result_ssn;
  string3 fulfilled_by;
  string10 business_line;
  string1 mode;
  string1 mvr_type;
  string1 private;
  string1 restricted;
  string1 amplified;
  string1 source;
  string1 mvr_status;
  string14 report_date;
  string16 unique_mvr_id;
  unsigned4 record_expires_date;
 END;

Delta_Inqhist_DS := dataset('~thor::base::mvr::20240916a::2024-09-162227421::delta_key.txt', lay2, thor);
Azure_DeltasaltDS1 := Insurview_SALT_Project.mac_profile(Delta_Inqhist_DS);
OUTPUT(COUNT(Azure_DeltasaltDS1),named('DeltaAzure_DS_cnt'));


Delta_Inqhist_DS2 := dataset('~thor::base::mvr::20240916o::2024-09-162200231::delta_report.txt', lay2, thor);
Onprem_DeltasaltDS1 := Insurview_SALT_Project.mac_profile(Delta_Inqhist_DS2);
OUTPUT(COUNT(Onprem_DeltasaltDS1),named('DeltaOnprem_DS_cnt'));


//***Verification for data difference************

DeltaDataDiff1 := Azure_DeltasaltDS1-Onprem_DeltasaltDS1;
OUTPUT(COUNT(DeltaDataDiff1),named('Cnt_DeltaDataDiff1'));
OUTPUT(CHOOSEN(DeltaDataDiff1,200),named('DeltaDataDiff1'));
DeltaDataDiff2 := Onprem_DeltasaltDS1-Azure_DeltasaltDS1;
OUTPUT(COUNT(DeltaDataDiff2),named('Cnt_DeltaDataDiff2'));

OUTPUT(CHOOSEN(DeltaDataDiff2,200),named('DeltaDataDiff2'));



//************************************************************************************************************************************************

AzureDeltaDataDiff1 := OUTPUT(DeltaDataDiff1,,'~thor::base::salt::Azure::LogMVR::Delta::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure3 := DesprayFun('~thor::base::salt::Azure::LogMVR::Delta::KCD::CSV','Azure_saltDeltaDatadiff_LogMVR');

Actions3 := SEQUENTIAL(AzureDeltaDataDiff1, DespryAzure3);

Actions3;

//*************************************************************************************************************************************************

AzureDeltaDataDiff2 := OUTPUT(DeltaDataDiff2,,'~thor::base::salt::Onprem::LogMVR::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure4 := DesprayFun('~thor::base::salt::OnPrem::LogMVR::KCD::CSV','OnPrem_saltDeltaDatadiff_LogMVR');

Actions4 := SEQUENTIAL(AzureDeltaDataDiff2, DespryAzure4);

Actions4;

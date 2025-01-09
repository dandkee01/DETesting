IMPORT Std,_control;

cleaned_data := RECORD
   string120 c_business_name;
   string50 c_last_name;
   string50 c_first_name;
   string15 c_middle_name;
   string4 c_suffix_name;
   string6 addr_error_code;
   string10 prim_range;
   string2 predir;
   string28 prim_name;
   string4 addr_suffix;
   string2 postdir;
   string10 unit_desig;
   string2 record_type;
   string8 sec_range;
   string30 c_city;
   string2 c_st;
   string5 c_zip5;
   string4 c_zip4;
  END;

Lay := RECORD
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
  cleaned_data clean_inq;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;



Azure_File := '~thor::base::cclue::priorhist::20240916a::subject';

Azure_DS := SORT(DATASET(Azure_File,Lay,THOR),transaction_id,sequence);

OUTPUT(COUNT(Azure_DS),named('Azure_DS_cnt'));


OnPrem_File := '~thor::base::cclue::priorhist::20240916::subject';

OnPrem_DS := SORT(DATASET(OnPrem_File,Lay,THOR),transaction_id,sequence);

OUTPUT(COUNT(OnPrem_DS),named('OnPrem_DS_cnt'));

//***Verification for data difference************

DataDiff1 := SORT(Azure_DS-OnPrem_DS,transaction_id,sequence);
OUTPUT(CHOOSEN(DataDiff1,200),named('DataDiff1'));
OUTPUT(COUNT(DataDiff1),named('Cnt_DataDiff1'));
DataDiff2 := SORT(OnPrem_DS-Azure_DS,transaction_id,sequence);
OUTPUT(CHOOSEN(DataDiff2,200),named('DataDiff2'));
OUTPUT(COUNT(DataDiff2),named('Cnt_DataDiff2'));

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

AzureDataDiff1 := OUTPUT(DataDiff1,,'~thor::base::Azure::LogCCLUE::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure := DesprayFun('~thor::base::Azure::LogCCLUE::KCD::CSV','Azure_Datadiff_LogCCLUE');

Actions := SEQUENTIAL(AzureDataDiff1, DespryAzure);

Actions;

//*************************************************************************************************************************************************

AzureDataDiff2 := OUTPUT(DataDiff2,,'~thor::base::Onprem::LogCCLUE::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure1 := DesprayFun('~thor::base::OnPrem::LogCCLUE::KCD::CSV','OnPrem_Datadiff_LogCCLUE');

Actions1 := SEQUENTIAL(AzureDataDiff2, DespryAzure1);

Actions1;




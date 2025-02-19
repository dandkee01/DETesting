/*ONPREM : thor::base::cclue::priorhist::op::qa::subject
 
thor::base::cclue::priorhist::op::20250204::daily::subject
thor::base::cclue::priorhist::op::20250205::daily::subject
 
AZURE : thor::base::cclue::priorhist::az::qa::subject
 
thor::base::cclue::priorhist::az::20250204a::daily::subject
thor::base::cclue::priorhist::az::20250205a::daily::subject

*/
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

ProjLay := RECORD
  Lay AND NOT [record_sid]
 END;


OnPrem_File := '~thor::base::cclue::priorhist::op::20250205::daily::subject';

OnPrem_DS := SORT(DATASET(OnPrem_File,Lay,THOR),transaction_id,reference_no);

OUTPUT(COUNT(OnPrem_DS),named('OnPrem_DS_cnt'));


Azure_File := '~thor::base::cclue::priorhist::az::20250205a::daily::subject';

Azure_DS := SORT(DATASET(Azure_File,Lay,THOR),transaction_id,reference_no);

OUTPUT(COUNT(Azure_DS),named('Azure_DS_cnt'));




//***Verification for data difference************
Proj_OnPrem_DS := PROJECT( OnPrem_DS,ProjLay);
Proj_Azure_DS := PROJECT( Azure_DS,ProjLay);

OP_DataDiff := SORT(Proj_OnPrem_DS-Proj_Azure_DS,transaction_id,reference_no);
OUTPUT(CHOOSEN(OP_DataDiff,200),named('OP_DataDiff'));
OUTPUT(COUNT(OP_DataDiff),named('Cnt_OP_DataDiff'));

AZ_DataDiff := SORT(Proj_Azure_DS-Proj_OnPrem_DS,transaction_id,reference_no);
OUTPUT(CHOOSEN(AZ_DataDiff,200),named('AZ_DataDiff'));
OUTPUT(COUNT(AZ_DataDiff),named('Cnt_AZ_DataDiff'));


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

AzureAZ_DataDiff := OUTPUT(AZ_DataDiff,,'~thor::base::Azure::CLUEP::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure := DesprayFun('~thor::base::Azure::CLUEP::KCD::CSV','Azure_Datadiff_CLUEP');

Actions := SEQUENTIAL(AzureAZ_DataDiff, DespryAzure);

//Actions;

//*************************************************************************************************************************************************
OP_DataDiff2 := OUTPUT(OP_DataDiff,,'~thor::base::Onprem::CLUEP::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DesprayOnPrem := DesprayFun('~thor::base::OnPrem::CLUEP::KCD::CSV','OnPrem_Datadiff_CLUEP');

Actions1 := SEQUENTIAL(OP_DataDiff2, DesprayOnPrem);

//Actions1;


Trans_Lay := RECORD
      string20 transaction_id;
END;

ProjTrans_Azure  := PROJECT(Azure_DS, Trans_Lay);
ProjTrans_OnPrem := PROJECT(OnPrem_DS, Trans_Lay);

TransDedup_OnPrem := DEDUP(SORT(ProjTrans_OnPrem,transaction_id),transaction_id);       
TransDedup_Azure  := DEDUP(SORT(ProjTrans_Azure,transaction_id),transaction_id);     

Trans_OnlyOnPrem :=  TransDedup_OnPrem- TransDedup_Azure;
Trans_OnlyAzure  :=  TransDedup_Azure-TransDedup_OnPrem;

OUTPUT(Trans_OnlyOnPrem,named('Trans_OnlyOnPrem'));
OUTPUT(Trans_OnlyAzure,named('Trans_OnlyAzure'));

OUTPUT(TransDedup_OnPrem,named('TransDedup_OnPrem'));
OUTPUT(TransDedup_Azure,named('TransDedup_Azure'));


OnPrem_UnqTrans := OUTPUT(TransDedup_OnPrem,,'~thor::base::Onprem::CCLUE::Unique_transactions::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('\t'),NOTRIM),OVERWRITE);
   
DespryAzure5 := DesprayFun('~thor::base::Onprem::CCLUE::Unique_transactions::KCD::CSV','CCLUE_UnqTrans_OnPrem');

Actions5 := SEQUENTIAL(OnPrem_UnqTrans, DespryAzure5);

Actions5;


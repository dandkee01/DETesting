IMPORT Std,_control;

Lay := RECORD
 string20 transaction_id, string14 date_added, string content{blob, maxlength(1000000)} ;

 END;


Azure_File := '~thor::base::mvr::20240916a::2024-09-162227421::delta_report.txt';

Azure_DS := SORT(DATASET(Azure_File,Lay,THOR),transaction_id);

OUTPUT(COUNT(Azure_DS),named('Azure_DS_cnt'));


OnPrem_File := '~thor::base::mvr::20240916o::2024-09-162200231::delta_report.txt';

OnPrem_DS := SORT(DATASET(OnPrem_File,Lay,THOR),transaction_id);

OUTPUT(COUNT(OnPrem_DS),named('OnPrem_DS_cnt'));

//***Verification for data difference************

DataDiff1 := SORT(Azure_DS-OnPrem_DS,transaction_id);
OUTPUT(CHOOSEN(DataDiff1,200),named('DataDiff1'));
OUTPUT(COUNT(DataDiff1),named('Cnt_DataDiff1'));
DataDiff2 := SORT(OnPrem_DS-Azure_DS,transaction_id);
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

AzureDataDiff1 := OUTPUT(DataDiff1,,'~thor::base::Azure::LogMVR::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure := DesprayFun('~thor::base::Azure::LogMVR::KCD::CSV','Azure_Datadiff_LogMVR');

Actions := SEQUENTIAL(AzureDataDiff1, DespryAzure);

Actions;

//*************************************************************************************************************************************************

AzureDataDiff2 := OUTPUT(DataDiff2,,'~thor::base::Onprem::LogMVR::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure1 := DesprayFun('~thor::base::OnPrem::LogMVR::KCD::CSV','OnPrem_Datadiff_LogMVR');

Actions1 := SEQUENTIAL(AzureDataDiff2, DespryAzure1);

Actions1;



OUTPUT(Azure_DS( transaction_id IN ['18236783T000326','18236783T000937','18236783T000951']),named('AzureDS_SampleData'));
OUTPUT(OnPrem_DS( transaction_id IN ['18236783T000326','18236783T000937','18236783T000951']),named('OnPrem_DS_SampleData'));


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

DeltaAzure_File := '~thor::base::mvr::20240916a::2024-09-162227421::delta_key.txt';

DisDeltaAzure_DS := SORT(DATASET(DeltaAzure_File,Lay2,THOR),transaction_id,reference_number,multi_report_sequence);


OUTPUT(COUNT(DisDeltaAzure_DS),named('DeltaAzure_DS_cnt'));


DeltaOnPrem_File := '~	thor::base::mvr::20240916o::2024-09-162200231::delta_key.txt';

DisDeltaOnPrem_DS := SORT(DATASET(DeltaOnPrem_File,Lay2,THOR),transaction_id,reference_number,multi_report_sequence);



OUTPUT(COUNT(DisDeltaOnPrem_DS),named('DeltaOnPrem_DS_cnt'));

//***Verification for data difference************

DeltaDataDiff1 := SORT(DisDeltaAzure_DS-DisDeltaOnPrem_DS,transaction_id,reference_number,multi_report_sequence);
OUTPUT(COUNT(DeltaDataDiff1),named('Cnt_DeltaDataDiff1'));
OUTPUT(CHOOSEN(DeltaDataDiff1,200),named('DeltaDataDiff1'));
DeltaDataDiff2 := SORT(DisDeltaOnPrem_DS-DisDeltaAzure_DS,transaction_id,reference_number,multi_report_sequence);
OUTPUT(COUNT(DeltaDataDiff2),named('Cnt_DeltaDataDiff2'));

OUTPUT(CHOOSEN(DeltaDataDiff2,200),named('DeltaDataDiff2'));

OUTPUT(DisDeltaAzure_DS( transaction_id IN ['18140073T000139','	18140073T000492','18235343T001283']),named('Delta_AzureDS_SampleData'));
OUTPUT(DisDeltaOnPrem_DS( transaction_id IN ['18140073T000139','	18140073T000492','18235343T001283']),named('DeltaOnPrem_DS_SampleData'));

//************************************************************************************************************************************************

AzureDeltaDataDiff1 := OUTPUT(DeltaDataDiff1,,'~thor::base::Azure::LogMVR::Delta::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure3 := DesprayFun('~thor::base::Azure::LogMVR::Delta::KCD::CSV','Azure_DeltaDatadiff_LogMVR');

Actions3 := SEQUENTIAL(AzureDeltaDataDiff1, DespryAzure3);

Actions3;

//*************************************************************************************************************************************************

AzureDeltaDataDiff2 := OUTPUT(DeltaDataDiff2,,'~thor::base::Onprem::LogMVR::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure4 := DesprayFun('~thor::base::OnPrem::LogMVR::KCD::CSV','OnPrem_DeltaDatadiff_LogMVR');

Actions4 := SEQUENTIAL(AzureDeltaDataDiff2, DespryAzure4);

Actions4;
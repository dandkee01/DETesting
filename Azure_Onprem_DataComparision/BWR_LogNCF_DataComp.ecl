IMPORT STD, _control;

Lay := RECORD
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





OnPrem_File := '~thor::base::ncf::20241113::master_archive_report';

OnPrem_DS := DATASET(OnPrem_File,Lay,THOR);

OUTPUT(COUNT(OnPrem_DS),named('OnPrem_DS_cnt'));

Azure_File := '~thor::base::ncf::20241113a::master_archive_report';

Azure_DS := DATASET(Azure_File,Lay,THOR);

OUTPUT(COUNT(Azure_DS),named('Azure_DS_cnt'));

//***Verification for data difference************


MA_DataDiff2 := OnPrem_DS-Azure_DS;
OUTPUT(MA_DataDiff2,named('MA_DataDiff2'));

MA_DataDiff1 := Azure_DS-OnPrem_DS;
OUTPUT(MA_DataDiff1,named('MA_DataDiff1'));

OUTPUT(Azure_DS( record_sid between 5000 and 5010),named('AzureDS_SampleData'));
OUTPUT(OnPrem_DS( record_sid between 5000 and 5010),named('OnPrem_DS_SampleData'));

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

AzureMA_DataDiff1 := OUTPUT(MA_DataDiff1,,'~thor::base::Azure::LogNCF::MasterArchive::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure := DesprayFun('~thor::base::Azure::LogNCF::MasterArchive::KCD::CSV','Azure_Datadiff_LogNCF_MasterArchive');

Actions := SEQUENTIAL(AzureMA_DataDiff1, DespryAzure);

Actions;

//*************************************************************************************************************************************************

AzureMA_DataDiff2 := OUTPUT(MA_DataDiff2,,'~thor::base::Onprem::LogNCF::MasterArchive::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure1 := DesprayFun('~thor::base::OnPrem::LogNCF::MasterArchive::KCD::CSV','OnPrem_Datadiff_LogNCF_MasterArchive');

Actions1 := SEQUENTIAL(AzureMA_DataDiff2, DespryAzure1);

Actions1;


//**********************************************************************************************************************************************************

Lay2 := RECORD
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


DeltaOnPrem_File := '~thor::base::ncf::20241113::delta_key.txt';

DisDeltaOnPrem_DS := DATASET(DeltaOnPrem_File,Lay2,THOR);

OUTPUT(COUNT(DisDeltaOnPrem_DS),named('DeltaOnPrem_DS_cnt'));


DeltaAzure_File := '~thor::base::ncf::20241113a::delta_key.txt';

DisDeltaAzure_DS := DATASET(DeltaAzure_File,Lay2,THOR);

OUTPUT(COUNT(DisDeltaAzure_DS),named('DeltaAzure_DS_cnt'));



//***Verification for data difference************
DK_DataDiff2 := DisDeltaOnPrem_DS-DisDeltaAzure_DS;
OUTPUT(DK_DataDiff2,named('DeltaDataDiff2'));

DK_DataDiff1 := DisDeltaAzure_DS-DisDeltaOnPrem_DS;
OUTPUT(DK_DataDiff1,named('DeltaDataDiff1'));


OUTPUT(DisDeltaAzure_DS( transaction_id IN ['18157073R252186','	18157073R253220','18157073R253348']),named('Delta_AzureDS_SampleData'));
OUTPUT(DisDeltaOnPrem_DS( transaction_id IN ['18157073R252186','	18157073R253220','18157073R253348']),named('DeltaOnPrem_DS_SampleData'));

//************************************************************************************************************************************************

AzureDK_DataDiff1 := OUTPUT(DK_DataDiff1,,'~thor::base::Azure::LogNCF::DeltaKey::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DK_DesprayAzure := DesprayFun('~thor::base::Azure::LogNCF::DeltaKey::KCD::CSV','Azure_Datadiff_LogNCF_DeltaKey');

Actions3 := SEQUENTIAL(AzureDK_DataDiff1, DK_DesprayAzure);

Actions3;

//*************************************************************************************************************************************************

AzureDK_DataDiff2 := OUTPUT(DK_DataDiff2,,'~thor::base::Onprem::LogNCF::DeltaKey::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DK_DespryAzure1 := DesprayFun('~thor::base::OnPrem::LogNCF::DeltaKey::KCD::CSV','OnPrem_Datadiff_LogNCF_DeltaKey');

Actions4 := SEQUENTIAL(AzureDK_DataDiff2, DK_DespryAzure1);

Actions4;
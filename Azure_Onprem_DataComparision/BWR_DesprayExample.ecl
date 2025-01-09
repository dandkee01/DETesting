IMPORT STD, _control;

Lay := RECORD
 string20 transaction_id, string14 date_added, string content{blob, maxlength(1000000)} ;

 END;


Azure_File := '~thor::base::mvr::20240902a::2024-09-032204062::delta_report.txt';

Azure_DS := SORT(DATASET(Azure_File,Lay,THOR),transaction_id);

//OUTPUT(COUNT(Azure_DS),named('Azure_DS_cnt'));


OnPrem_File := '~thor::base::mvr::20240902::2024-09-032240042::delta_report.txt';

OnPrem_DS := SORT(DATASET(OnPrem_File,Lay,THOR),transaction_id);

//OUTPUT(COUNT(OnPrem_DS),named('OnPrem_DS_cnt'));

//***Verification for data difference************

DataDiff1 := CHOOSEN(SORT(Azure_DS-OnPrem_DS,transaction_id),200);
//OUTPUT(CHOOSEN(DataDiff1,200),named('DataDiff1'));
//OUTPUT(COUNT(DataDiff1,200),named('DataDiff1'));
DataDiff2 := CHOOSEN(SORT(OnPrem_DS-Azure_DS,transaction_id),200);
//OUTPUT(CHOOSEN(DataDiff2,200),named('DataDiff2'));



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



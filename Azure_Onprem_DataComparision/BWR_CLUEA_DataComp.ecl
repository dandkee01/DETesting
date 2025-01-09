IMPORT Std,_control;

name := RECORD
   string28 lname;
   string20 fname;
   string15 mname;
   string3 sname;
  END;

cleaned_address := RECORD
   string2 record_type;
   string10 prim_range;
   string2 predir;
   string28 prim_name;
   string4 addr_suffix;
   string2 postdir;
   string10 unit_desig;
   string8 sec_range;
   string20 city;
   string2 st;
   string5 zip5;
   string4 zip4;
  END;

Lay := RECORD
  string14 reference_no;
  string3 unit_no;
  string20 transaction_id;
  string5 customer_no;
  string9 account_no;
  string60 quoteback;
  string8 dateoforder;
  string28 lname;
  string20 fname;
  string15 mname;
  string3 sname;
  string9 house_no;
  string20 street_name;
  string5 apt_no;
  string20 city;
  string2 state;
  string5 zip5;
  string4 zip4;
  string25 driverslicense_no;
  string2 driverslicense_state;
  string20 policy_no;
  string20 policy_company;
  string2 policy_type;
  string9 ssn;
  string8 dob;
  string1 sex;
  name cleanname;
  cleaned_address cleanaddress;
  unsigned8 source_rid;
  unsigned8 did;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
  string1 service_type;
  string8 process_date;
  string5 spl_bill_id;
  string1 bill_as;
  string1 report_as;
  unsigned8 xlink_weight;
 END;

OnPrem_File := '~thor::base::clueauto::psb::20241113::daily::inqhist::subject';

OnPrem_DS := SORT(DATASET(OnPrem_File,Lay,THOR),transaction_id,reference_no);

OUTPUT(COUNT(OnPrem_DS),named('OnPrem_DS_cnt'));


Azure_File := '~thor::base::clueauto::psb::20241113a::daily::inqhist::subject';

Azure_DS := SORT(DATASET(Azure_File,Lay,THOR),transaction_id,reference_no);

OUTPUT(COUNT(Azure_DS),named('Azure_DS_cnt'));




//***Verification for data difference************
DataDiff2 := SORT(OnPrem_DS-Azure_DS,transaction_id,reference_no);
OUTPUT(CHOOSEN(DataDiff2,200),named('DataDiff2'));
OUTPUT(COUNT(DataDiff2),named('Cnt_DataDiff2'));

DataDiff1 := SORT(Azure_DS-OnPrem_DS,transaction_id,reference_no);
OUTPUT(CHOOSEN(DataDiff1,200),named('DataDiff1'));
OUTPUT(COUNT(DataDiff1),named('Cnt_DataDiff1'));


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

AzureDataDiff1 := OUTPUT(DataDiff1,,'~thor::base::Azure::CLUEA::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure := DesprayFun('~thor::base::Azure::CLUEA::KCD::CSV','Azure_Datadiff_CLUEA');

Actions := SEQUENTIAL(AzureDataDiff1, DespryAzure);

//Actions;

//*************************************************************************************************************************************************

AzureDataDiff2 := OUTPUT(DataDiff2,,'~thor::base::Onprem::CLUEA::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure1 := DesprayFun('~thor::base::OnPrem::CLUEA::KCD::CSV','OnPrem_Datadiff_CLUEA');

Actions1 := SEQUENTIAL(AzureDataDiff2, DespryAzure1);

//Actions1;





//**********************************************************************************************************************************************************

Lay2 := RECORD
  string14 reference_no;
  string3 unit_no;
  string25 claim_no;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;


DeltaOnPrem_File := '~thor::base::clueauto::psb::20241113::daily::inqhist::claim';

DisDeltaOnPrem_DS := SORT(DATASET(DeltaOnPrem_File,Lay2,THOR),reference_no);



OUTPUT(COUNT(DisDeltaOnPrem_DS),named('ClaimOnPrem_DS_cnt'));

DeltaAzure_File := '~thor::base::clueauto::psb::20241113a::daily::inqhist::claim';

DisDeltaAzure_DS := SORT(DATASET(DeltaAzure_File,Lay2,THOR),reference_no);


OUTPUT(COUNT(DisDeltaAzure_DS),named('ClaimAzure_DS_cnt'));




//***Verification for data difference************

DeltaDataDiff2 := SORT(DisDeltaOnPrem_DS-DisDeltaAzure_DS,reference_no);
OUTPUT(COUNT(DeltaDataDiff2),named('Cnt_ClaimDataDiff2'));

DeltaDataDiff1 := SORT(DisDeltaAzure_DS-DisDeltaOnPrem_DS,reference_no);
OUTPUT(COUNT(DeltaDataDiff1),named('Cnt_ClaimDataDiff1'));

OUTPUT(CHOOSEN(DeltaDataDiff1,200),named('ClaimDataDiff1'));




//************************************************************************************************************************************************

AzureDeltaDataDiff1 := OUTPUT(DeltaDataDiff1,,'~thor::base::Azure::CLUEA::claim::Delta::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure3 := DesprayFun('~thor::base::Azure::CLUEA::claim::Delta::KCD::CSV','Azure_DeltaDatadiff_CLUEA');

Actions3 := SEQUENTIAL(AzureDeltaDataDiff1, DespryAzure3);

Actions3;

//*************************************************************************************************************************************************

AzureDeltaDataDiff2 := OUTPUT(DeltaDataDiff2,,'~thor::base::Onprem::CLUEA::claim::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure4 := DesprayFun('~thor::base::OnPrem::CLUEA::claim::KCD::CSV','OnPrem_DeltaDatadiff_CLUEA');

Actions4 := SEQUENTIAL(AzureDeltaDataDiff2, DespryAzure4);

Actions4;
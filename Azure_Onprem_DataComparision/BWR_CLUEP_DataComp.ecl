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
  string20 transaction_id;
  string5 customer_no;
  string9 account_no;
  string60 quoteback;
  string8 dateoforder;
  string1 name_address_ind;
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
  string15 mortgagee_loan_num;
  string30 mortgagee_name;
  string20 policy_no;
  string20 policy_company;
  string2 policy_type;
  string9 ssn;
  string8 dob;
  string1 sex;
  string3 area_code;
  string7 tel_num;
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
  string1 account_class;
  string1 report_as;
  unsigned8 xlink_weight;
 END;

ProjLay := RECORD
  Lay AND NOT [source_rid, record_sid]
 END;


OnPrem_File := '~thor::base::clueproperty::op::20250130::daily::inqhist::subject';

OnPrem_DS := SORT(DATASET(OnPrem_File,Lay,THOR),transaction_id,reference_no);

OUTPUT(COUNT(OnPrem_DS),named('OnPrem_DS_cnt'));


Azure_File := '~thor::base::clueproperty::az::20250130a::daily::inqhist::subject';

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





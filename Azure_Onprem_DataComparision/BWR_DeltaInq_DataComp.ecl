IMPORT STD, _Control;
Lay := RECORD
  unsigned8 lex_id;
  string30 product_id;
  string19 inquiry_date;
  string20 transaction_id;
  string19 date_added;
  string5 customer_number;
  string9 customer_account;
  string9 ssn;
  string25 drivers_license_number;
  string2 drivers_license_state;
  string20 name_first;
  string20 name_last;
  string20 name_middle;
  string20 name_suffix;
  string90 addr_street;
  string25 addr_city;
  string2 addr_state;
  string5 addr_zip5;
  string4 addr_zip4;
  string10 dob;
  string20 transaction_location;
  string3 ppc;
  string1 internal_identifier;
  string5 eu1_customer_number;
  string9 eu1_customer_account;
  string5 eu2_customer_number;
  string9 eu2_customer_account;
  integer4 seq_num;
  string20 suppressionalerts;
  unsigned6 did;
  integer2 xlink_weight;
  unsigned2 xlink_score;
  integer1 xlink_distance;
  unsigned8 address_id;
  string10 prim_range;
  string2 predir;
  string28 prim_name;
  string4 addr_suffix;
  string2 postdir;
  string10 unit_desig;
  string8 sec_range;
  string25 city;
  string2 st;
  string5 zip;
  string4 zip4;
  string4 error_code;
 END;



Azure_File := '~thor::base::azure::fcra::delta_inq_hist::20250122a::delta_key';

Azure_DS := SORT(DATASET(Azure_File,Lay,THOR),-transaction_id,product_id,customer_number,customer_account,seq_num);

OUTPUT(COUNT(Azure_DS),named('Azure_DS_cnt'));


OnPrem_File := '~thor::base::onprem::fcra::delta_inq_hist::20250122op::delta_key';

OnPrem_DS := SORT(DATASET(OnPrem_File,Lay,THOR),-transaction_id,product_id,customer_number,customer_account,seq_num);

OUTPUT(COUNT(OnPrem_DS),named('OnPrem_DS_cnt'));

//***Verification for data difference************

//OnPremOnly := CHOOSEN(OnPrem_DS-Azure_DS,300);
OnPremOnly := OnPrem_DS-Azure_DS;
OUTPUT(SORT(OnPremOnly(lex_id<>0),-transaction_id,product_id,customer_number,customer_account,seq_num),named('OnPremOnly'));
OUTPUT(COUNT(OnPremOnly),named('Count_OnPremOnly'));

//AzureOnly := CHOOSEN(Azure_DS-OnPrem_DS,300);
AzureOnly := Azure_DS-OnPrem_DS;
OUTPUT(SORT(AzureOnly(lex_id<>0),-transaction_id,product_id,customer_number,customer_account,seq_num),named('AzureOnly'));
OUTPUT(COUNT(AzureOnly),named('Count_AzureOnly'));


AzurmatchDS := Azure_DS-AzureOnly;
OUTPUT(AzurmatchDS, named('AzurmatchDS'));
OnpremmatchDS := OnPrem_DS-OnPremOnly;
OUTPUT(OnpremmatchDS, named('OnpremmatchDS'));

/*
DesprayFun(STRING file, STRING fname) := FUNCTION

   DateToday             := (STRING)STD.date.Today();
   fileName              := fname+DateToday+'.csv';
   LandingZone_File_Dir  := '/data/DandKe01/AzureOnPrem/';
   lzFilePathBaseFile    := LandingZone_File_Dir + fileName; 
   LandingZoneIP         := _control.IPAddress.unixland;//10.194.72.227//
   TempCSV               := file;

/*---------------------------------------------------------------------------------*/
/* deSprayCSV        := STD.File.DeSpray(TempCSV,LandingZoneIP,lzFilePathBaseFile,-1,,,TRUE);
 
 delCSV := NOTHOR(FileServices.DeleteLogicalFile(TempCSV));
 Actions := SEQUENTIAL(deSprayCSV,delCSV);
 RETURN Actions;
 
END;

//************************************************************************************************************************************************

AzureAzureOnly := OUTPUT(AzureOnly,,'~thor::base::Azure::DeltaInqHist::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure := DesprayFun('~thor::base::Azure::DeltaInqHist::KCD::CSV','Azure_Datadiff_DeltaInqHist');

Actions := SEQUENTIAL(AzureAzureOnly, DespryAzure);

//Actions;

//*************************************************************************************************************************************************

AzureOnPremOnly := OUTPUT(OnPremOnly,,'~thor::base::Onprem::DeltaInqHist::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure1 := DesprayFun('~thor::base::OnPrem::DeltaInqHist::KCD::CSV','OnPrem_Datadiff_DeltaInqHist');

Actions1 := SEQUENTIAL(AzureOnPremOnly, DespryAzure1);

//Actions1;




// OUTPUT(Azure_DS( transaction_id IN ['18156783R504690','18156783R504721','18156783R504784','18156783R505069']),named('AzureDS_SampleData'));
// OUTPUT(OnPrem_DS( transaction_id IN ['18156783R504690','18156783R504721','18156783R504784','18156783R505069']),named('OnPrem_DS_SampleData'));

AzureDS_sample := CHOOSEN(Azure_DS( customer_number IN ['10000'] and Lex_id<>0),100);
OUTPUT( AzureDS_sample,named('AzureDS_SampleData'));

OnpremDS_sample := CHOOSEN(Onprem_DS( customer_number IN ['10000'] and Lex_id<>0),100);
OUTPUT( OnpremDS_sample,named('OnPremDS_SampleData'));


AzureSAzureOnly := OUTPUT(AzureDS_sample,,'~thor::base::Azure::DeltaInqHist::sample::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzureS := DesprayFun('~thor::base::Azure::DeltaInqHist::sample::KCD::CSV','Azure_sample_DeltaInqHist');

Actions5 := SEQUENTIAL(AzureSAzureOnly, DespryAzureS);

Actions5;

//*************************************************************************************************************************************************

AzureSOnPremOnly := OUTPUT(OnpremDS_sample,,'~thor::base::Onprem::DeltaInqHist::sample::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryOnpremS := DesprayFun('~thor::base::OnPrem::DeltaInqHist::sample::KCD::CSV','OnPrem_sample_DeltaInqHist');

Actions6 := SEQUENTIAL(AzureSOnPremOnly, DespryOnpremS);

Actions6;

*/
//*******************************************************
/*
OUTPUT(AzureOnly(lex_id=0),named('AzureOnly_LexZero'));
OUTPUT(COUNT(AzureOnly(lex_id=0)),named('Count_AzureOnly_LexZero'));

OUTPUT(OnPremOnly(lex_id=0),named('OnPremOnly_LexZero'));
OUTPUT(COUNT(OnPremOnly(lex_id=0)),named('Count_OnPremOnly_LexZero'));


//*******************************************************
/*638567265                             	2024-09-02 00:00:00	PDW240902055948R7ESJ
192665625087	                             	2024-09-02 00:00:00	PDW240902055948KC576
1085793356	                           	2024-09-02 00:00:00	PDW240902055941RFT7C*/

// Azure_DS(lex_id =638567265 AND transaction_id ='PDW240902055948R7ESJ');
// OnPrem_DS(lex_id =638567265 AND transaction_id ='PDW240902055948R7ESJ');



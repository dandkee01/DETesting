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



Azure_File := '~thor::base::fcra_azure::delta_inq_hist::20241113a::delta_key';

Azure_DS := SORT(DATASET(Azure_File,Lay,THOR),-transaction_id,product_id,customer_number,customer_account,seq_num);

OUTPUT(COUNT(Azure_DS),named('cnt_Azure_Ds'));
//Azure_DS(transaction_id='18500963R566417');     

OnPrem_File := '~thor::base::fcra_onperm::delta_inq_hist::20241113::delta_key';

OnPrem_DS := SORT(DATASET(OnPrem_File,Lay,THOR),-transaction_id,product_id,customer_number,customer_account,seq_num);

OUTPUT(COUNT(OnPrem_DS),named('cnt_OnPrem_Ds'));


OnPrem_Dist := DISTRIBUTE(OnPrem_DS,HASH32(transaction_id,product_id,customer_number,customer_account,seq_num));
Azure_Dist := DISTRIBUTE(Azure_DS,HASH32(transaction_id,product_id,customer_number,customer_account,seq_num));


OnPrem_Dist doJoin(OnPrem_Dist L,Azure_Dist R) := TRANSFORM
  SELF := L;
END;
JoinedDS := SORT(JOIN(OnPrem_Dist, Azure_Dist,
                    LEFT.transaction_id=RIGHT.transaction_id AND
                    LEFT.product_id=RIGHT.product_id AND
                    LEFT.customer_number=RIGHT.customer_number AND
                    LEFT.customer_account =RIGHT.customer_account AND
                    //LEFT.seq_num =RIGHT.seq_num 
                    LEFT.did =RIGHT.did 
                    ,doJoin(LEFT, RIGHT),LEFT ONLY, LOCAL),transaction_id,product_id,customer_number,customer_account,seq_num);
                    
 OUTPUT(JoinedDS, named('Recs_Exist_Only_On_Prem')); 
OUTPUT(COUNT(JoinedDS),named('Cnt_Recs_Exist_Only_On_Prem'));

Onprem_Common :=  OnPrem_DS - JoinedDS;
OUTPUT( Count(Onprem_Common),named('cnt_Onprem_Common'));   


OnPrem_Dist doJoinAzure(Azure_Dist L,OnPrem_Dist R) := TRANSFORM
  SELF := L;
END;
AzureJoinedDS := SORT(JOIN(Azure_Dist,OnPrem_Dist,
                    LEFT.transaction_id=RIGHT.transaction_id AND
                    LEFT.product_id=RIGHT.product_id AND
                    LEFT.customer_number=RIGHT.customer_number AND
                    LEFT.customer_account =RIGHT.customer_account AND
                    //LEFT.seq_num =RIGHT.seq_num 
                    LEFT.did =RIGHT.did 
                    ,doJoinAzure(LEFT, RIGHT),LEFT ONLY, LOCAL),transaction_id,product_id,customer_number,customer_account,seq_num);
                    
OUTPUT(AzureJoinedDS, named('Recs_Exist_Only_Azure')); 
OUTPUT(COUNT(AzureJoinedDS),named('Cnt_Recs_Exist_Only_Azure'));

Azure_Common :=  Azure_Dist - AzureJoinedDS;
OUTPUT( Count(Azure_Common),named('cnt_Azure_Common'));   


//***Verification for data difference************

//DataDiff1 := CHOOSEN(Onprem_Common-Azure_DS,300);
DataDiff1 := Onprem_Common-Azure_Common;
SORTED_DataDiff1 := CHOOSEN(SORT(DataDiff1(lex_id<>0 and seq_num =3),-transaction_id,lex_id,product_id,customer_number,customer_account),100);
OUTPUT(SORTED_DataDiff1, named('SORTED_DataDiff1'));
transid_set := set(SORTED_DataDiff1, transaction_id);

OUTPUT(SORT(DataDiff1(transaction_id IN transid_set),-transaction_id,lex_id,product_id,customer_number,customer_account),named('DataDiff1'));
OUTPUT(COUNT(DataDiff1),named('Cnt_AzureDataDiff1'));

//DataDiff2 := CHOOSEN(Azure_Common-Onprem_Common,300);
DataDiff2 := Azure_Common-Onprem_Common;
OUTPUT(SORT(DataDiff2(transaction_id IN transid_set),-transaction_id,lex_id,product_id,customer_number,customer_account),named('DataDiff2'));
OUTPUT(COUNT(DataDiff2),named('Cnt_AzureDataDiff2'));

DataDiff := DataDiff1+DataDiff2;

OnpremmatchDS := Onprem_Common-DataDiff2;
OUTPUT(OnpremmatchDS, named('OnpremmatchDS'));
AzurmatchDS := Azure_Common-DataDiff1;
OUTPUT(AzurmatchDS, named('AzurmatchDS'));


rec := RECORD
DataDiff.transaction_id;
StCnt := COUNT(GROUP);
END;
Mytable := TABLE(DataDiff,rec,transaction_id,FEW);
Mytable(StCnt=1);

OnPrem_Dist doJoinextra(OnpremmatchDS L,AzurmatchDS R) := TRANSFORM
  SELF := L;
END;
ExtraRecsJoinedDS := SORT(JOIN(OnpremmatchDS,AzurmatchDS,
                    LEFT.transaction_id=RIGHT.transaction_id AND
                    LEFT.product_id=RIGHT.product_id AND
                    LEFT.customer_number=RIGHT.customer_number AND
                    LEFT.customer_account =RIGHT.customer_account AND
                    LEFT.seq_num =RIGHT.seq_num 
                    ,doJoinextra(LEFT, RIGHT),LEFT ONLY, LOCAL),transaction_id,product_id,customer_number,customer_account,seq_num);
ExtraRecsJoinedDS;
/*
 DesprayFun(STRING file, STRING fname) := FUNCTION

   DateToday             := (STRING)STD.date.Today();
   fileName              := fname+DateToday+'.csv';
   LandingZone_File_Dir  := '/data/DandKe01/AzureOnPrem/';
   lzFilePathBaseFile    := LandingZone_File_Dir + fileName; 
   LandingZoneIP         := _control.IPAddress.unixland;//10.194.72.227//
   TempCSV               := file;

//---------------------------------------------------------------------------------
 deSprayCSV        := STD.File.DeSpray(TempCSV,LandingZoneIP,lzFilePathBaseFile,-1,,,TRUE);
 
 delCSV := NOTHOR(FileServices.DeleteLogicalFile(TempCSV));
 Actions := SEQUENTIAL(deSprayCSV,delCSV);
 RETURN Actions;
 
END;

//************************************************************************************************************************************************

AzureDataDiff1 := OUTPUT(DataDiff1,,'~thor::base::Azure::DeltaInqHist::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure := DesprayFun('~thor::base::Azure::DeltaInqHist::KCD::CSV','Azure_Datadiff_DeltaInqHist');

Actions := SEQUENTIAL(AzureDataDiff1, DespryAzure);

Actions;

//*************************************************************************************************************************************************

AzureDataDiff2 := OUTPUT(DataDiff2,,'~thor::base::Onprem::DeltaInqHist::KCD::CSV',CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR('|'),NOTRIM),OVERWRITE);
   
DespryAzure1 := DesprayFun('~thor::base::OnPrem::DeltaInqHist::KCD::CSV','OnPrem_Datadiff_DeltaInqHist');

Actions1 := SEQUENTIAL(AzureDataDiff2, DespryAzure1);
Actions1;

*/

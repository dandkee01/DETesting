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


OnPrem_File := '~thor::base::clueproperty::psb::20241113::daily::inqhist::subject';

OnPrem_DS := SORT(DATASET(OnPrem_File,Lay,THOR),transaction_id,reference_no);

OUTPUT(COUNT(OnPrem_DS),named('OnPrem_DS_cnt'));
//OnPrem_DS_Chsn := CHOOSEN(OnPrem_DS,100);



Azure_File := '~thor::base::clueproperty::psb::20241113a::daily::inqhist::subject';

Azure_DS := SORT(DATASET(Azure_File,Lay,THOR),transaction_id,reference_no);

OUTPUT(COUNT(Azure_DS),named('Azure_DS_cnt'));


Azure_DS doJoin(Azure_DS l,OnPrem_DS R) := TRANSFORM
  SELF := l;
END;
AzureOnlyRecs := JOIN(Azure_DS, OnPrem_DS,
                    LEFT.reference_no=RIGHT.reference_no
                    AND LEFT.transaction_id=RIGHT.transaction_id
                    AND LEFT.dateoforder=RIGHT.dateoforder
                    AND LEFT.customer_no=RIGHT.customer_no
                    AND LEFT.account_no=RIGHT.account_no
                    //AND LEFT.did=RIGHT.did
                    ,doJoin(LEFT, RIGHT),LEFT ONLY );

OUTPUT(AzureOnlyRecs, named('AzureOnlyRecs'));   //  These recs exists only in azure
OUTPUT(COUNT(AzureOnlyRecs), named('Cnt_AzureOnlyRecs'));   

AzureRecs := Azure_DS - AzureOnlyRecs;
OUTPUT(AzureRecs, named('AzureRecs'));
OUTPUT(COUNT(AzureRecs), named('Cnt_AzureRecs'));
AzureRecs_srt := SORT(AzureRecs,transaction_id,reference_no);

//***********************************************************************************************************

Azure_DS doJoin1(Azure_DS l,OnPrem_DS R) := TRANSFORM
  SELF := l;
END;
OnPremOnlyRecs := JOIN( OnPrem_DS,Azure_DS,
                    LEFT.reference_no=RIGHT.reference_no
                    AND LEFT.transaction_id=RIGHT.transaction_id
                    AND LEFT.dateoforder=RIGHT.dateoforder
                    AND LEFT.customer_no=RIGHT.customer_no
                    AND LEFT.account_no=RIGHT.account_no
                    //AND LEFT.did=RIGHT.did
                    ,doJoin1(LEFT, RIGHT),LEFT ONLY );

OUTPUT(DEDUP(SORT(OnPremOnlyRecs,reference_no),reference_no), named('OnPremOnlyRecs'));   //  These recs exists only in azure
OUTPUT(COUNT(OnPremOnlyRecs), named('Cnt_OnPremOnlyRecs'));   
OUTPUT(COUNT(OnPremOnlyRecs(reference_no='')), named('Dedup_Cnt_OnPremOnlyRecs'));   
OUTPUT(COUNT(OnPrem_DS(reference_no='')), named('Dedup_Cnt_OnPremDS'));   

OnPremRecs := OnPrem_DS - OnPremOnlyRecs;
OUTPUT(OnPremRecs, named('OnPremRecs'));
OUTPUT(COUNT(OnPremRecs), named('Cnt_OnPremRecs'));
OnPremRecs_srt := SORT(OnPremRecs,transaction_id,reference_no);




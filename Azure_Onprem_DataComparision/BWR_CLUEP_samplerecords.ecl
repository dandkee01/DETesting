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


OnPrem_File := DATASET('~thor::base::clueproperty::psb::20241113::daily::inqhist::subject',Lay,THOR);

Azure_File := DATASET('~thor::base::clueproperty::psb::20241113a::daily::inqhist::subject',Lay,THOR);

//*********** Records That exists only in Azure But not in Onprem *************************//

OUTPUT(Azure_File(reference_no IN ['24318000630857','24318003331539','24318003332309','24318003831914','24318004336198','24318004630001','24318004630004','24318004630018','24318004630028','24318004630033']),named('Only_Azure'));
OUTPUT(OnPrem_File(reference_no IN ['24318000630857','24318003331539','24318003332309','24318003831914','24318004336198','24318004630001','24318004630004','24318004630018','24318004630028','24318004630033']),named('Not_In_Onprem'));

//*********** Records That exists only in Onprem But not in Azure *************************//

OUTPUT(OnPrem_File(reference_no IN ['23122002677384']));// repeated multiple times with diff record sid
OUTPUT(OnPrem_File(reference_no IN ['23122002677385','23122002677386','23122002677387','23122002677473','23122002677478','23122002677483','23122002677485','23122002677493','23122002677495','23122002677505']),named('Only_Onprem'));
OUTPUT(Azure_File(reference_no IN ['23122002677385','23122002677386','23122002677387','23122002677473','23122002677478','23122002677483','23122002677485','23122002677493','23122002677495','23122002677505']),named('Not_In_Azure'));

//***************** Records That exists in both *******************************//

OUTPUT(OnPrem_File(reference_no IN ['24317001710005','24317004110000','24317004110001','24317025930178','24317025930182','24317025930187','24317025930189','24317025930220','24317025930236','24317025930244','24317025930249','24317025930257','24317025930260','24317025930262']),named('Both_OnPrem'));
OUTPUT(Azure_File(reference_no IN ['24317001710005','24317004110000','24317004110001','24317025930178','24317025930182','24317025930187','24317025930189','24317025930220','24317025930236','24317025930244','24317025930249','24317025930257','24317025930260','24317025930262']),named('Both_Azure'));




// OUTPUT(COUNT(DEDUP(OnPrem_File,reference_no,transaction_id,customer_no,account_no,dateoforder,did)),named('OnPrem_File_Dedup'));
// OUTPUT(COUNT(OnPrem_File),named('OnPrem_File_Cnt'));

// OUTPUT(Azure_File(reference_no IN ['24317001510005','23122002677384','24317004110000','24317025930178','24317025930182']));
// OUTPUT(COUNT(DEDUP(Azure_File,reference_no,transaction_id,customer_no,account_no,dateoforder,did)),named('Azure_File_Dedup'));
// OUTPUT(COUNT(Azure_File),named('Azure_File_cnt'));


// Ref_Set := SET(CHOOSEN(DEDUP(OnPrem_File,reference_no),500), reference_no): INDEPENDENT;
// OUTPUT(SORT(Azure_File(reference_no IN Ref_Set),reference_no),named('Azure_recs'));
// OUTPUT(SORT(OnPrem_File(reference_no IN Ref_Set),reference_no),named('OnPrem_recs'));




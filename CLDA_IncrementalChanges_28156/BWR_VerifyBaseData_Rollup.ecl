	IMPORT CCLUE_PriorHistory;
  
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
  
  
  Hist_SubFile      := '~thor::base::Claimsdiscoveryauto::kcd::20240712::inqhist::subject';
  Hist_SubFile_DS		:= DATASET (Hist_SubFile,Lay,THOR);	
  
  FaSubFile      := '~thor::base::Claimsdiscoveryauto::kcd::father::inqhist::subject';
  FaSubFile_DS1	 := DATASET (FaSubFile,Lay,THOR);
  FaSubFile_DS   := SORT(FaSubFile_DS1-Hist_SubFile_DS,reference_no,-dt_effective_first);
  
  OUTPUT(FaSubFile_DS,named('FaSubFile_DS'));
  Ref_noSET := SET(FaSubFile_DS, reference_no);
  OUTPUT(Ref_noSET,named('Ref_noSET'));
  
  
  QaSubFile      := '~thor::base::Claimsdiscoveryauto::kcd::qa::inqhist::subject';
  QaSubFile_DS		:= DATASET (QaSubFile,Lay,THOR);

  DailyDS := QaSubFile_DS(reference_no IN Ref_noSET);
  OUTPUT(DailyDS,named('DailyDS'));
  
  OUTPUT(QaSubFile_DS(TRIM(reference_no,LEFT,RIGHT)='77777777777777'),  {transaction_id,reference_no,lname,fname,mname,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Qa_777'));
  OUTPUT(FaSubFile_DS(TRIM(reference_no,LEFT,RIGHT)='77777777777777'),{transaction_id,reference_no,lname,fname,mname,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Fa_777'));

  
/*
// Verify latest updated record is kept and remaining are deleted in rollup
  OUTPUT(QaSubFile_DS(reference_no='66666666666660'),  {transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Qa_660'));
  OUTPUT(FaSubFile_DS(reference_no='66666666666660'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Fa_660'));

// Verify all the records with delta_ind=3 are deleted. FRANKLIN

  OUTPUT(QaSubFile_DS(reference_no='66666666666660', last_name='FRANKLIN'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Check_Franklin_ExistsQA'));
  OUTPUT(FaSubFile_DS(reference_no='66666666666660'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Check_Franklin_ExistsFA'));
 
 // Verify the records with delta_ind=2 and early dt_effective_first are removed in rollup. PRANKLIN

  OUTPUT(QaSubFile_DS(reference_no='66666666666660', last_name='SRANKLIN'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Check_Sranklin_ExistsQA'));
  OUTPUT(FaSubFile_DS(reference_no='66666666666660'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Check_Pranklin_ExistsFA'));
  
// Verify all the records with delta_ind=1 are kept  
  OUTPUT(QaSubFile_DS(reference_no='77777777777700'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Qa_7700'));
  OUTPUT(FaSubFile_DS(reference_no='77777777777700'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Fa_7700'));

 
  OUTPUT(COUNT(QaSubFile_DS),named('Total_cnt_Qa'));
  OUTPUT(COUNT(Hist_SubFile_DS),named('Total_cnt_baseline'));
  OUTPUT(COUNT(QaSubFile_DS(delta_ind<>1)),named('COUNT_Delta_not1'));
  OUTPUT(COUNT(QaSubFile_DS(delta_ind=1)),named('COUNT_Delta_1'));
  OUTPUT(COUNT(QaSubFile_DS(dt_effective_first=0)),named('COUNT_DtEfffirst_notEmpty'));
  OUTPUT(COUNT(QaSubFile_DS(dt_effective_last=0)),named('COUNT_DtEfflast_notEmpty'));
  OUTPUT(COUNT(QaSubFile_DS(record_sid<>0)),named('COUNT_recordsid_notEmpty'));
  OUTPUT(MAX(QaSubFile_DS,record_sid),named('Max_recordSid'));
  OUTPUT(MAX(Hist_SubFile_DS,record_sid),named('Max_recordSid_BaseLine'));

*/


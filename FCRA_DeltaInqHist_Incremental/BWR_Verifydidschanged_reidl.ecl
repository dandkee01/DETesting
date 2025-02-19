#WORKUNIT('name','CLUEA_didchecks');
#WORKUNIT('priority','high');
#WORKUNIT('priority',10);      

IMPORT STD;

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

BaseRec := RECORD
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



file1 :='~thor::base::clueauto::kcd::20240707::inqhist::subject';
file2 :='~thor::base::clueauto::kcd::20240715::inqhist::subject';

DS11 := DATASET(file1,BaseRec,THOR);

DS12 := DATASET(file2,BaseRec,THOR);

OUTPUT(DS11,named('DeltaKey_ThorProdVer'));
OUTPUT(DS12,named('DeltaKey_ChangesVer'));

Subject_JoinConditionAll := 'LEFT.transaction_id= RIGHT.transaction_id and '+
                                   'LEFT.reference_no= RIGHT.reference_no and '+
																	 'LEFT.unit_no=RIGHT.unit_no and '+
																	 'LEFT.customer_no=RIGHT.customer_no and '+
																	 'LEFT.account_no=RIGHT.account_no and '+
																	 'LEFT.dateoforder=RIGHT.dateoforder and '+
																	 'LEFT.lname=RIGHT.lname and '+ 
																	 'LEFT.fname=RIGHT.fname and '+
																	 'LEFT.mname=RIGHT.mname and '+
																	 'LEFT.sname=RIGHT.sname and '+
																	 'LEFT.house_no=RIGHT.house_no and '+
																	 'LEFT.street_name=RIGHT.street_name and '+
																	 'LEFT.apt_no=RIGHT.apt_no and '+
																	 'LEFT.city=RIGHT.city and '+
																	 'LEFT.state=RIGHT.state and '+
																	 'LEFT.zip5=RIGHT.zip5 and '+
																	 'LEFT.zip4=RIGHT.zip4 and '+
																	 'LEFT.driverslicense_no=RIGHT.driverslicense_no and '+
																	 'LEFT.driverslicense_state=RIGHT.driverslicense_state and '+
																	 'LEFT.policy_no=RIGHT.policy_no and '+
																	 'LEFT.ssn=RIGHT.ssn and '+
																	 'LEFT.dob=RIGHT.dob and '+
																	 'LEFT.sex=RIGHT.sex and '+
																	 'LEFT.service_type=RIGHT.service_type and '+
																	 'LEFT.process_date=RIGHT.process_date and '+
																	 'LEFT.spl_bill_id=RIGHT.spl_bill_id and '+
																	 'LEFT.bill_as=RIGHT.bill_as and '+
																	 'LEFT.report_as=RIGHT.report_as';


DS1 := DISTRIBUTE(DS11,HASH32(transaction_id,reference_no ,unit_no,customer_no,account_no,dateoforder,lname,fname,mname,sname,house_no,street_name,apt_no,city ,state,zip5,zip4,driverslicense_no,driverslicense_state,policy_no
			    ,ssn,dob,sex,service_type,process_date	));
DS2 := DISTRIBUTE(DS12,HASH32(transaction_id,reference_no ,unit_no,customer_no,account_no,dateoforder,lname,fname,mname,sname,house_no,street_name,apt_no,city ,state,zip5,zip4,driverslicense_no,driverslicense_state,policy_no
			    ,ssn,dob,sex,service_type,process_date	));
                    
//OUTPUT(SORT(DS10,name_first,name_last,name_middle,prim_range,prim_name,sec_range,city,st,zip,ssn,dob,drivers_license_number,drivers_license_state,did,transaction_id,product_id,LOCAL),named('sorted_DS1'));
//OUTPUT(SORT(DS20,name_first,name_last,name_middle,prim_range,prim_name,sec_range,city,st,zip,ssn,dob,drivers_license_number,drivers_license_state,did,transaction_id,product_id,LOCAL),named('sorted_DS2'));

NewRec := RECORD
  unsigned6 did_Before;
  unsigned6 did_After;
  string14 reference_no;
  string3 unit_no;
  string20 transaction_id;
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
  string9 ssn;
  string8 dob;
  string1 sex;
  string8 process_date;
  unsigned8 did;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
  string    Did_Changed;
  
END;
 

NewRec doJoin(BaseRec L,BaseRec R) := TRANSFORM
  SELF.did_Before    := R.did;  
  SELF.did_After     := L.did; 
  isDidChanged       := R.did=L.did;
  SELF.Did_Changed   := IF(~isDidChanged,'TRUE','FALSE');
  SELF := L;
END;
JoinedDS := DEDUP(SORT(JOIN(DS2, DS1,#expand(Subject_JoinConditionAll),doJoin(LEFT, RIGHT),LEFT OUTER, LOCAL),transaction_id,reference_no ,dateoforder,lname,fname,mname,sname,house_no,street_name,apt_no,city ,state,zip5,zip4,driverslicense_no,driverslicense_state,policy_no
			    ,ssn,dob,process_date)):INDEPENDENT;

OUTPUT(JoinedDS(Did_Changed='TRUE'), named('DidChanged_Set'));
OUTPUT(JoinedDS(Did_Changed='FALSE'), named('DidnotChanged_Set'));
// OUTPUT(COUNT(DS1), named('DS1_Count'));
// OUTPUT(COUNT(DS2), named('DS2_Count'));
// OUTPUT(COUNT(JoinedDS), named('JoinedDS_Count'));
// OUTPUT(JoinedDS, named('JoinedDS'));
// OUTPUT(CHOOSEN(DS1,500),named('DS1_Top500'));
// OUTPUT(CHOOSEN(DS2,500),named('DS2_Top500'));
// JoinedDS(lex_id IN [4398724,5917754,5822356,9595510,16612511,19829982,24884639,33910890]);
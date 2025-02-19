/*
thor::base::currentcarrier::op::20250204::delta_key.txt       W20250212-134233
thor::base::currentcarrier::az::20250204a::delta_key.txt

thor::base::currentcarrier::op::20250205::delta_key.txt
thor::base::currentcarrier::az::20250205a::delta_key.txt
 
*/


Lay := RECORD
  string3 subject_unit_number;
  string20 last_name;
  string20 first_name;
  string9 ssn;
  string8 dob;
  string9 house_number;
  string20 street_name;
  string2 state;
  string5 zip;
  string25 dl_number;
  string2 dl_state;
  string14 reference_number;
  string6 account_number;
  string3 account_suffix;
  string1 post_non_post_flag;
  string5 customer_number;
  string8 process_date;
  string40 account_name;
  string1 service_type;
  string60 quoteback;
  string19 date_added;
  string20 transaction_id;
  string1 post_non_post;
  string3 unit_number;
  unsigned8 lexid;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

ProjLay := RECORD
  Lay AND NOT [ record_sid]
 END;


OnPrem_File := '~thor::base::currentcarrier::op::20250205::delta_key.txt';

OnPrem_DS := SORT(DATASET(OnPrem_File,Lay,THOR),transaction_id,reference_number);

OUTPUT(COUNT(OnPrem_DS),named('OnPrem_DS_cnt'));


Azure_File := '~thor::base::currentcarrier::az::20250205a::delta_key.txt';

Azure_DS := SORT(DATASET(Azure_File,Lay,THOR),transaction_id,reference_number);

OUTPUT(COUNT(Azure_DS),named('Azure_DS_cnt'));




//***Verification for data difference************
Proj_OnPrem_DS := PROJECT( OnPrem_DS,ProjLay);
Proj_Azure_DS := PROJECT( Azure_DS,ProjLay);

OP_DataDiff := SORT(Proj_OnPrem_DS-Proj_Azure_DS,transaction_id,reference_number);
OUTPUT(CHOOSEN(OP_DataDiff,200),named('OP_DataDiff'));
OUTPUT(COUNT(OP_DataDiff),named('Cnt_OP_DataDiff'));

AZ_DataDiff := SORT(Proj_Azure_DS-Proj_OnPrem_DS,transaction_id,reference_number);
OUTPUT(CHOOSEN(AZ_DataDiff,200),named('AZ_DataDiff'));
OUTPUT(COUNT(AZ_DataDiff),named('Cnt_AZ_DataDiff'));
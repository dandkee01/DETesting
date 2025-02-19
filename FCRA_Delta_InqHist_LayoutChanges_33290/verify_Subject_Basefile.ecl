IMPORT ClaimsDiscoveryAuto_InquiryHistory;

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
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

after_project :=  DATASET ('~thor::base::fcra::delta_inq_hist::20250203k::delta_key', Lay ,THOR);

OUTPUT(COUNT(after_project),named('Total_Recs_Count'));
                                                       
OUTPUT(COUNT(after_project(Record_Sid<>0 AND delta_ind<>0 )),named('newfields_populated'));
OUTPUT(COUNT(after_project(Record_Sid=0)),named('Record_sid_data'));
OUTPUT(COUNT(after_project(delta_ind=0 )),named('delta_ind_Zero'));
OUTPUT(COUNT(after_project(delta_ind<>1 )),named('delta_ind_datanot1'));
OUTPUT(MIN(after_project,record_sid),named('Min_Record_sid'));
OUTPUT(MAX(after_project,record_sid),named('Max_Record_sid'));

//**************************************************************************

Cnt1 := COUNT(after_project(dt_effective_first<>0));
OUTPUT(Cnt1,named('dt_effective_first_notzero'));
Cnt2 := COUNT(after_project(dt_effective_first=0));
OUTPUT(Cnt2,named('dt_effective_first_zero'));
total_cnt := cnt1+cnt2;
OUTPUT(total_cnt,named('total_cnt'));

OUTPUT(COUNT(after_project(dt_effective_last=0)),named('dt_effective_last_zero'));
OUTPUT(COUNT(after_project(dt_effective_last<>0)),named('dt_effective_last_notzero'));

OUTPUT(choosen(after_project(dt_effective_first<>0),10),named('first10recs'));
OUTPUT(choosen(after_project(dt_effective_first=0),10),named('first10recszero'));

OUTPUT(SORT(after_project,-dt_effective_first), named('Max_Dt_effective_first'));                                        
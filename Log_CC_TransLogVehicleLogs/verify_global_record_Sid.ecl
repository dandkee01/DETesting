import ut,std;
 
 import ut,std,STANDARD, Orbit3, CustomerSupport;

lay := RECORD
  string20 transaction_id;
  string4 type;
  string request_data{blob, maxlength(2000000)};
  string response_data{blob, maxlength(3000000)};
  string9 request_format;
  string9 response_format;
  string22 date_added;
  unsigned4 global_sid;
  unsigned8 record_sid;
 END;


 mvr := dataset('~base::mvr_trano::transaction_log_online::qa::trans_online_id', lay, thor);
 OUTPUT(mvr,named('mvr_records')); 
 OUTPUT(COUNT(mvr),named('Total_Recs'));
 
 OUTPUT(COUNT(mvr(global_sid=2202)),named('globalSid_2202'));
 OUTPUT(COUNT(mvr(global_sid<>2202)),named('globalSid_Not2202'));

 OUTPUT(COUNT(mvr(record_sid=0)),named('record_sid_Zero'));
 OUTPUT(COUNT(mvr(record_sid<>0)),named('record_sid_notZero'));
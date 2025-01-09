import ut,std;
 
 import ut,std,STANDARD, Orbit3, CustomerSupport;

Lay :=RECORD
  string20 transaction_id;
  string4 type;
  string request_data{blob, maxlength(2000000)};
  string response_data{blob, maxlength(3000000)};
  string9 request_format;
  string9 response_format;
  string22 date_added;
		STANDARD.LAYOUTS.LAYOUT_ORBIT;
END;

 cdsc := dataset('~base::ccfc_trano::transaction_log_online::qa::trans_online_id', lay, thor);
 OUTPUT(cdsc,named('cdsc_records')); 
 OUTPUT(COUNT(cdsc),named('Total_Recs'));
 
 OUTPUT(COUNT(cdsc(global_sid=2152)),named('globalSid_2152'));
 OUTPUT(COUNT(cdsc(global_sid<>2152)),named('globalSid_Not2152'));

 OUTPUT(COUNT(cdsc(record_sid=0)),named('record_sid_Zero'));
 OUTPUT(COUNT(cdsc(record_sid<>0)),named('record_sid_notZero'));
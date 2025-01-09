import ut,std, STANDARD;

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

 cc := dataset( '~base::cc_trano::transaction_log_online::qa::trans_online_id', lay, thor);
 OUTPUT(cc,named('cc_records')); 
 OUTPUT(COUNT(cc),named('Total_Recs'));
 
 OUTPUT(COUNT(cc(global_sid=2162)),named('globalSid_2162'));
 OUTPUT(COUNT(cc(global_sid<>2162)),named('globalSid_Not2162'));

 OUTPUT(COUNT(cc(record_sid=0)),named('record_sid_Zero'));
 OUTPUT(COUNT(cc(record_sid<>0)),named('record_sid_notZero'));
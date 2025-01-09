Lay1 := RECORD
  string transaction_id;
  string11 product_id;
  string19 date_added;
  string4 process_type;
  string8 processing_time;
  string10 vendor_code;
  string20 request_type;
  string20 product_version;
  string15 reference_number;
  string content_data{blob, maxlength(2000000)};
  string6 process_status;
  unsigned4 global_sid;
  unsigned8 record_sid;
 END;

cc := dataset('~base::ncf::inquiry_history::qa::id',Lay1,Thor);
 OUTPUT(cc,named('cc_records')); 
 OUTPUT(COUNT(cc),named('Total_Recs'));
 
 OUTPUT(COUNT(cc(global_sid=1792)),named('globalSid_1792'));
 OUTPUT(COUNT(cc(global_sid<>1792)),named('globalSid_Not1792'));

 OUTPUT(COUNT(cc(record_sid=0)),named('record_sid_Zero'));
 OUTPUT(COUNT(cc(record_sid<>0)),named('record_sid_notZero'));
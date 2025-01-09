//***************************************************************************


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
  unsigned4 global_sid;
  unsigned8 record_sid;
 END;

after_project := DATASET('~base::dataenh::inquiry_history::qa::id',Lay1, THOR);
 OUTPUT(COUNT(after_project),named('Total_Recs'));
 
 OUTPUT(COUNT(after_project(global_sid=1972)),named('globalSid_1972'));
 OUTPUT(COUNT(after_project(global_sid<>1972)),named('globalSid_Not1972'));

 OUTPUT(COUNT(after_project(record_sid=0)),named('record_sid_Zero'));
 OUTPUT(COUNT(after_project(record_sid<>0)),named('record_sid_notZero'));
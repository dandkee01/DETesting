Key_subject := RECORD
  string16 transaction_id
  =>
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
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

DS_Key_subject   := INDEX(Key_subject,'~key::ccfc::inquiry_history::20240603::trans_id');
OUTPUT(SORT(DS_Key_subject,-record_sid),named('DS_Key_subjectLatest'));
OUTPUT(SORT(DS_Key_subject,record_sid),named('DS_Key_subjectold'));
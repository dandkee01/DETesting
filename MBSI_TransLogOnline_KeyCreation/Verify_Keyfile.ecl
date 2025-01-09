Key_lay := RECORD
  string16 transaction_id
  =>
  string4 transaction_type;
  string request_data{blob, maxlength(2000000)};
  string response_data{blob, maxlength(3000000)};
  string9 request_format;
  string9 response_format;
  string22 date_added;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

DS_Key_subject   := INDEX(Key_lay,'~key::fcra_mbsi_trano::transaction_log_online::20241030::trans_online_id');

DS_Key_subject(TRIM(transaction_id,left,right) = '18501363U577835');
IMPORT ut, CustomerSupport;

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

DS_Key_subject   := INDEX(Key_lay,'~key::fcra_mbsi_trano::transaction_log_online::20241101::trans_online_id');
OUTPUT(COUNT(DS_Key_subject), named('key_Count'));
OUTPUT(SORT(DS_Key_subject, -dt_effective_first), named('DS_Key'));

sProduct    := 'FCRA_MBSI_TranO';
EarlyDate := ut.date_math(ut.getdate, - (CustomerSupport.Constants(sProduct).CS_TRANS_REPORTING_DAYS));
EarliestHyphened 	:= EarlyDate[1..4] + '-' + EarlyDate[5..6] + '-' + EarlyDate[7..8] : global;

File := '~base::fcra_mbsi_trano::transaction_log_online::20241101::trans_online_id'; // 1st run

fcrambsi_DS := DATASET(File,CustomerSupport.Layouts.Layout_transaction_log_online_trano,THOR,OPT);
OUTPUT(COUNT(fcrambsi_DS(date_added >= EarliestHyphened)),named('Base_Count'));

OUTPUT(SORT(fcrambsi_DS,-date_added), named('DS_Base'));
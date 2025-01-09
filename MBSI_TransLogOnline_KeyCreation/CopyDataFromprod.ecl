IMPORT ut;
sub_lay := RECORD
  string transaction_id;
  string4 transaction_type;
  string request_data{blob, maxlength(2000000)};
  string response_data{blob, maxlength(3000000)};
  string9 request_format;
  string9 response_format;
  string22 date_added;
  unsigned4 global_sid;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;



prod_ds:= dataset(ut.foreign_prod +'thor_anr_storage::base::fcra_mbsi_trano::transaction_log_online::20241023::trans_online_id',sub_lay,thor); // father file version

Dist_ProdDs  := DISTRIBUTE (prod_ds,HASH32(transaction_id));
output(Dist_ProdDs,,'~base::fcra_mbsi_trano::transaction_log_online::20241023p::trans_online_id',compressed,overwrite);


// Slim_prod_ds := CHOOSEN(SORT(prod_ds,-process_date),100000);
// Slim_Dist_ProdDsD  := DISTRIBUTE (Slim_prod_ds,HASH32(Reference_No));
// output(slim_Dist_ProdDsD,,'~thor::base::clueproperty::20240916b::inqhist::subject',compressed,overwrite);
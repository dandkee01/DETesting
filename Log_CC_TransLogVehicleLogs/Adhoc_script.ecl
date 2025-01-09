IMPORT CustomerSupport, STD;

rc_file := '~base::cc_tranlpolicyveh::transaction_log_policyvehicle::qa::trans_log_id';    //Remote copied file from Prod

base_ds := DATASET(rc_file, CustomerSupport.Layouts.transaction_log_policy_vehicle, THOR);

Sorted_ds := SORT(base_ds, transaction_id,policy_sequence,sequence,date_added);
OUTPUT(COUNT(Sorted_ds), named('Cnt_Before_Project'));

Updated_Base := PROJECT (sorted_ds, TRANSFORM(CustomerSupport.Layouts.transaction_log_policy_vehicle, 
                                                       SELF.Record_Sid := COUNTER;
                                                       SELF.delta_ind := 1;
                                                       SELF.dt_effective_first := std.date.Today();
                                                       SELF := LEFT; 
                                                       SELF := []));
max(Updated_base, record_sid);

Distributed_ds := DISTRIBUTE(Updated_base, HASH64(transaction_id));
OUTPUT(COUNT(Distributed_ds), named('Cnt_after_Project'));

/*
filename := '~base::cc_tranlpolicyveh::transaction_log_policyvehicle::adhoc_kcd::trans_log_id';                                                       
OUTPUT(Distributed_ds,, filename, overwrite, __compressed__, named('base_test'));

base := '~base::cc_tranlpolicyveh::transaction_log_policyvehicle::qa::trans_log_id';  
std.file.clearsuperfile(base);
std.file.addsuperfile(base, filename);

*/
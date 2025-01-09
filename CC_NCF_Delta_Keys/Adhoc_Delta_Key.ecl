IMPORT NCF, std, ut;
#workunit('priority', 'high');
#workunit('priority', '10');

base := 'thor::base::ncf::qa::delta_key.txt';

base_ds := DATASET(ut.foreign_prod + base, NCF.Layout_DeltaKey, THOR);

Sorted_ds := SORT(base_ds, reference_number);

Updated_Base := PROJECT (sorted_ds, TRANSFORM(NCF.Layout_DeltaKey, 
                                                       SELF.Record_Sid := COUNTER;
                                                       SELF.delta_ind := 1;
                                                       SELF.dt_effective_first := std.date.Today();
                                                       SELF := LEFT; 
                                                       SELF := []));
max(Updated_base, record_sid);

Distributed_ds := DISTRIBUTE(Updated_base, HASH32(reference_number));

filename := '~thor::base::ncf::kcd::adhoc_test_0312::delta_key.txt';                                                       
OUTPUT(Distributed_ds,, filename, overwrite, __compressed__, named('base_test'));



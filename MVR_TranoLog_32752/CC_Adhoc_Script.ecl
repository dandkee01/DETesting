IMPORT CustomerSupport, STD;

EXPORT Adhoc_Script(qafile, layout, pName) := FUNCTIONMACRO

rfile  := DATASET(qafile, layout, THOR);
OUTPUT(COUNT(rfile),named('Count_Before'));
sfile  := SORTED(DISTRIBUTED(rfile, hash64(transaction_id)),transaction_id,type,date_added);

ufile  := PROJECT(sfile, TRANSFORM(layout,SELF.Record_Sid := COUNTER; 
                                          SELF.delta_ind := 1;
                                          SELF.dt_effective_first := STD.Date.Today();
                                          SELF := LEFT; 
                                          SELF := [];));

// Max Record count of QA Base FIle
Output(MAX(ufile, record_sid),named('max_record_sid'));

dfile  := SORT(DISTRIBUTE(ufile, hash64(transaction_id)), transaction_id,type,date_added,local);
OUTPUT(COUNT(dfile),named('Count_After'));

subfile  := '~base::' + pName + '::transaction_log_online::adhoc_kcd::trans_online_id';
OUTPUT(dfile,, subfile, overwrite, __compressed__, named('base_test'));

superfile  := '~base::' + pName + '::transaction_log_online::qa::trans_online_id';

creating_SF  := SEQUENTIAL(IF(~ STD.File.SuperFileExists(superfile),
                                STD.File.CreateSuperFile(superfile)),
                                STD.File.StartSuperFileTransaction(),
                                STD.File.ClearSuperFile(superfile),
                                STD.File.AddSuperFile(superfile, subfile),
                                STD.File.FinishSuperFileTransaction());

RETURN creating_SF;
ENDMACRO;

// cc trano
cc_trano  := Adhoc_Script('~base::cc_trano::transaction_log_online::qa::trans_online_id', CustomerSupport.NonStandard_Layouts.Layout_transaction_log_online, 'CC_TranO');
cc_trano;
#WORKUNIT('priority','high'); 
#WORKUNIT('priority',10); 
IMPORT CustomerSupport, STD;

EXPORT  Adhoc_Script(qafile, layout, pName, distfield, sortedfields) := FUNCTIONMACRO

rfile  := DATASET(qafile, layout, THOR);

sfile  := SORTED(DISTRIBUTED(rfile, #expand(distfield)), #expand(sortedfields));
OUTPUT(COUNT(sfile),named('Count_Before'));

ufile  := PROJECT(sfile, TRANSFORM(layout,SELF.Record_Sid := COUNTER;
                                          SELF.delta_ind := 1;
                                          SELF.dt_effective_first := STD.Date.Today();
                                          SELF := LEFT; 
                                          SELF := []));
                                                
// Max Record count of QA Base FIle
Output(MAX(ufile, record_sid),named('Max_Recordsid'));

dfile  := SORT(DISTRIBUTE(ufile, #expand(distfield)), #expand(sortedfields), LOCAL);
OUTPUT(COUNT(dfile),named('Count_After'));

subfile  := '~base::' + pName + '::transaction_log_online::adhoc_kcd::trans_online_id';
FileWrite := OUTPUT(dfile,, subfile, overwrite, __compressed__, named('base_test'));

superfile  := '~base::' + pName + '::transaction_log_online::qa::trans_online_id';

creating_SF  := SEQUENTIAL(FileWrite,IF(~ STD.File.SuperFileExists(superfile),
                                STD.File.CreateSuperFile(superfile)),
                                STD.File.StartSuperFileTransaction(),
                                STD.File.ClearSuperFile(superfile),
                                STD.File.AddSuperFile(superfile, subfile),
                                STD.File.FinishSuperFileTransaction());
RETURN creating_SF;
ENDMACRO;

//fcra_mbsi_trano
fcra_mbsi_trano  := Adhoc_Script('~base::fcra_mbsi_trano::transaction_log_online::qa::trans_online_id',
                                 CustomerSupport.Layouts.Layout_transaction_log_online_trano, 'FCRA_MBSI_TranO',
                                 'hash32(transaction_id)','transaction_id,transaction_type,date_added');
fcra_mbsi_trano;
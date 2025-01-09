IMPORT STD;


actions2 := OUTPUT(STD.File.SuperFileContents('~base::mvr_trano::transaction_log_online::qa::trans_online_id'));
//actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::currentcarrier::qa::transaction_log_person.txt'));
//actions2;

actions := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.ClearSuperFile('~base::mvr_trano::transaction_log_online::qa::trans_online_id'), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.FinishSuperFileTransaction()
);
//actions;



MySuperFile := '~base::cc_tranlpolicyveh::transaction_log_policyvehicle::qa::trans_log_id';
MySubFile   := '~base::cc_tranlpolicyveh::transaction_log_policyvehicle::20240401::trans_log_id';
actions3 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.AddSuperFile(MySuperFile,MySubFile),
 STD.File.FinishSuperFileTransaction()
);

actions3;

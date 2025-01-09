IMPORT STD;


actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::clue::qa::transaction_log.txt'));


actions := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.ClearSuperFile('~thor::base::clue::qa::transaction_log.txt'), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.FinishSuperFileTransaction()
);
//actions;



 MySuperFile := '~thor::base::log_rules::qa::intermediate_log';
 MySubFile   := '~thor::base::log_rules::20240327::intermediate_log';

actions3 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.AddSuperFile(MySuperFile,MySubFile),
 STD.File.FinishSuperFileTransaction()
);

actions3;

// action := SEQUENTIAL(actions2,actions,actions3,actions2);
//actions;

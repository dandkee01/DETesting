IMPORT STD;


actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::clue::qa::transaction_log.txt'));
//actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::clue::qa::transaction_log_person.txt'));
//actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::clue::qa::transaction_log_vin.txt'));
//actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::clue::qa::transaction_log_claim.txt'));
//actions2;

actions := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.ClearSuperFile('~thor::base::clue::qa::transaction_log.txt'), // it just remove subfile from superfile,it wont be deleted from memory
 //STD.File.ClearSuperFile('~thor::base::clue::qa::transaction_log_person.txt'), // it just remove subfile from superfile,it wont be deleted from memory
 //STD.File.ClearSuperFile('~thor::base::clue::qa::transaction_log_vin.txt'), // it just remove subfile from superfile,it wont be deleted from memory
 //STD.File.ClearSuperFile('~thor::base::clue::qa::transaction_log_claim.txt'), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.FinishSuperFileTransaction()
);
//actions;



 MySuperFile := '~thor::base::clue::qa::transaction_log.txt';
 MySubFile   := '~thor::base::clue::20240310ab::transaction_log.txt';
// MySuperFile := '~thor::base::clue::qa::transaction_log_person.txt';
// MySubFile   := '~thor::base::clue::20240310ab::transaction_log_person.txt';
// MySuperFile := '~thor::base::clue::qa::transaction_log_vin.txt';
// MySubFile   := '~thor::base::clue::20240310ab::transaction_log_vin.txt';
// MySuperFile := '~thor::base::clue::qa::transaction_log_claim.txt';
// MySubFile   := '~thor::base::clue::20240310ab::transaction_log_claim.txt';
actions3 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.AddSuperFile(MySuperFile,MySubFile),
 STD.File.FinishSuperFileTransaction()
);

//actions3;

// action := SEQUENTIAL(actions2,actions,actions3,actions2);
actions;

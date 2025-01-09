IMPORT STD;


actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::currentcarrier::qa::delta_key.txt'));
//actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::currentcarrier::qa::transaction_log_person.txt'));
actions2;

actions := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.ClearSuperFile('~thor::base::currentcarrier::qa::delta_key.txt'), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.FinishSuperFileTransaction()
);
actions;



MySuperFile := '~thor::base::currentcarrier::qa::delta_key.txt';
MySubFile   := '~thor::base::currentcarrier::20231228::delta_key.txt';
actions3 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.AddSuperFile(MySuperFile,MySubFile),
 STD.File.FinishSuperFileTransaction()
);

actions3;

IMPORT STD;


actions2 := OUTPUT(STD.File.SuperFileContents('~base::dataenh::inquiry_history::qa::id'));
//actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::currentcarrier::qa::transaction_log_person.txt'));
//actions2;

actions := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.ClearSuperFile('~base::dataenh::inquiry_history::qa::id'), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.FinishSuperFileTransaction()
);
//actions;



MySuperFile := '~base::dataenh::inquiry_history::qa::id';
MySubFile   := '~base::dataenh::inquiry_history::20240227::id';
actions3 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.AddSuperFile(MySuperFile,MySubFile),
 STD.File.FinishSuperFileTransaction()
);

action := SEQUENTIAL(actions2,actions,actions3,actions2);
//action := SEQUENTIAL(actions2,actions3,actions2);
//action := SEQUENTIAL(actions3);
action;
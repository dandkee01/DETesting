IMPORT STD;


actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::cclue::priorhist::qa::subject'));
//actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::cclue::priorhist::qa::delta_subject'));
//actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::cclue::priorhist::qa::deltadate'));
//actions2 := OUTPUT(STD.File.SuperFileContents('~thor::key::cclue::priorhist::subject_qa'));
//actions2 := OUTPUT(STD.File.SuperFileContents('~thor::key::cclue::priorhist::deltadate_qa'));
//actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::currentcarrier::qa::transaction_log_person.txt'));

actions := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 //STD.File.ClearSuperFile('~thor::base::cclue::priorhist::qa::subject'), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.ClearSuperFile('~thor::key::cclue::priorhist::subject_qa'), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.FinishSuperFileTransaction()
);



//MySuperFile := '~thor::base::cclue::priorhist::qa::subject';
MySuperFile := '~thor::base::cclue::priorhist::qa::subject';
//MySubFile   := '~thor::key::cclue::priorhist::20240228cd::subject';
MySubFile1   := '~thor::base::cclue::priorhist::20240816a::subject';
actions3 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 //STD.File.AddSuperFile(MySuperFile,MySubFile),
 STD.File.AddSuperFile(MySuperFile,MySubFile1),
 STD.File.FinishSuperFileTransaction()
);

//action := SEQUENTIAL(actions2,actions,actions3,actions2);
action := SEQUENTIAL(actions3);
action;
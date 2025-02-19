IMPORT STD;


//actions21 := OUTPUT(STD.File.SuperFileContents('~thor::base::cclue::priorhist::qa::subject'));
//actions22 := OUTPUT(STD.File.SuperFileContents('~thor::base::cclue::priorhist::qa::delta_subject'));
//actions23 := OUTPUT(STD.File.SuperFileContents('~thor::base::cclue::priorhist::qa::deltadate'));
//actions2 := OUTPUT(STD.File.SuperFileContents('~thor::key::cclue::priorhist::subject_qa'));
actions2 := OUTPUT(STD.File.SuperFileContents('~thor::key::cclue::priorhist::deltadate_qa'));
//actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::currentcarrier::qa::transaction_log_person.txt'));
//actions2;

actions := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.ClearSuperFile('~thor::key::cclue::priorhist::deltadate_qa'), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.FinishSuperFileTransaction()
);
//actions;



//MySuperFile := '~thor::base::cclue::priorhist::qa::subject';
MySuperFile := '~thor::base::fcra::delta_inq_hist::qa::delta_key';
MySubFile   := '~thor::base::fcra::delta_inq_hist::20250131::delta_key';
actions3 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.AddSuperFile(MySuperFile,MySubFile),
 STD.File.FinishSuperFileTransaction()
);

action := SEQUENTIAL(actions3);
action;
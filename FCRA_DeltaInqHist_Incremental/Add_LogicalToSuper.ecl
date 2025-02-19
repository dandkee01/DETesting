IMPORT STD;

/*thor::base::fcra::delta_inq_hist::qa::delta_key
thor::key::claimsdiscoveryauto::inqhist::kcd::20240715d::did
thor::key::claimsdiscoveryauto::inqhist::kcd::20240716d::did
thor::key::claimsdiscoveryauto::inqhist::kcd::20240718d::did
thor::key::claimsdiscoveryauto::inqhist::kcd::20240719d::did
thor::key::claimsdiscoveryauto::inqhist::kcd::20240722d::did
*/

actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::fcra::delta_inq_hist::qa::delta_key'));

actions := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 //STD.File.ClearSuperFile('~thor::base::cclue::priorhist::qa::subject'), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.ClearSuperFile('~thor::base::fcra::delta_inq_hist::qa::delta_key',false), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.FinishSuperFileTransaction()
);



MySuperFile := '~thor::base::fcra::delta_inq_hist::qa::delta_key';
MySubFile   := '~thor::base::fcra::delta_inq_hist::20250212::delta_key';

actions3 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.AddSuperFile(MySuperFile,MySubFile),
 /*STD.File.AddSuperFile(MySuperFile,MySubFile1),
 STD.File.AddSuperFile(MySuperFile,MySubFile2),
 STD.File.AddSuperFile(MySuperFile,MySubFile3),
 STD.File.AddSuperFile(MySuperFile,MySubFile4),
 STD.File.AddSuperFile(MySuperFile,MySubFile5),*/
 STD.File.FinishSuperFileTransaction()
);

action := SEQUENTIAL(actions2,actions,actions3,actions2);
//action := SEQUENTIAL(actions3);
action;
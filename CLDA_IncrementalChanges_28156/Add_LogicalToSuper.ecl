IMPORT STD;

/*thor::key::claimsdiscoveryauto::inqhist::kcd::20240712::did
thor::key::claimsdiscoveryauto::inqhist::kcd::20240715d::did
thor::key::claimsdiscoveryauto::inqhist::kcd::20240716d::did
thor::key::claimsdiscoveryauto::inqhist::kcd::20240718d::did
thor::key::claimsdiscoveryauto::inqhist::kcd::20240719d::did
thor::key::claimsdiscoveryauto::inqhist::kcd::20240722d::did
*/

actions2 := OUTPUT(STD.File.SuperFileContents('~thor::key::claimsdiscoveryauto::inqhist::kcd::did_qa'));

actions := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 //STD.File.ClearSuperFile('~thor::base::cclue::priorhist::qa::subject'), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.ClearSuperFile('~thor::key::claimsdiscoveryauto::inqhist::kcd::did_qa',false), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.FinishSuperFileTransaction()
);



//MySuperFile := '~thor::base::cclue::priorhist::qa::subject';
MySuperFile := '~thor::key::claimsdiscoveryauto::inqhist::kcd::did_qa';
MySubFile   := '~thor::key::claimsdiscoveryauto::inqhist::kcd::20240712::did';
/*MySubFile1   := '~thor::key::claimsdiscoveryauto::inqhist::kcd::20240715d::did';
MySubFile2   := '~thor::key::claimsdiscoveryauto::inqhist::kcd::20240716d::did';
MySubFile3   := '~thor::key::claimsdiscoveryauto::inqhist::kcd::20240718d::did';
MySubFile4   := '~thor::key::claimsdiscoveryauto::inqhist::kcd::20240719d::did';
MySubFile5   := '~thor::key::claimsdiscoveryauto::inqhist::kcd::20240722d::did';*/

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

//action := SEQUENTIAL(actions2,actions,actions3,actions2);
action := SEQUENTIAL(actions3);
action;
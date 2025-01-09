IMPORT STD;


actions2 := OUTPUT(STD.File.SuperFileContents('~thor::key::clueauto::inqhist::kcd::acctno_qa'));

actions := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.ClearSuperFile('~thor::key::clueauto::inqhist::kcd::acctno_qa',false), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.FinishSuperFileTransaction()
);




MySuperFile := '~thor::key::clueauto::inqhist::kcd::acctno_qa';
//MySubFile1   := '~thor::key::clueauto::inqhist::kcd::20240612::acctno';
//MySubFile2   := '~thor::key::clueauto::inqhist::kcd::20240811d::acctno';
//MySubFile2   := '~thor::key::clueauto::inqhist::kcd::20240812d::acctno';
//MySubFile2   := '~thor::key::clueauto::inqhist::kcd::20240813d::acctno';
//MySubFile2   := '~thor::key::clueauto::inqhist::kcd::20240815f::acctno';
MySubFile2   := '~thor::key::clueauto::inqhist::kcd::20240818f::acctno';

//thor::key::clueauto::inqhist::kcd::20240612::acctno
//thor::key::clueauto::inqhist::kcd::qa::inqhist::subject
//thor::key::clueauto::inqhist::kcd::qa::inqhist::claim

actions3 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 //STD.File.AddSuperFile(MySuperFile,MySubFile1),
 STD.File.AddSuperFile(MySuperFile,MySubFile2),
 STD.File.FinishSuperFileTransaction()
);

//action := SEQUENTIAL(actions2,actions,actions3,actions2);
action := SEQUENTIAL(actions,actions3);
//action := actions3;
action;
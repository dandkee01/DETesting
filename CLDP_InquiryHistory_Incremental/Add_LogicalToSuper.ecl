IMPORT STD;


actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::clueauto::kcd::qa::inqhist:'));

actions := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.ClearSuperFile('~thor::base::clueauto::kcd::qa::account::requirements',false), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.FinishSuperFileTransaction()
);




MySuperFile := '~thor::base::clueauto::kcd::qa::account::requirements';
//MySubFile1   := '~thor::base::clueauto::kcd::20240612::account::requirements';
//MySubFile2   := '~thor::base::clueauto::kcd::20240811::daily::account::requirements';
//MySubFile2   := '~thor::base::clueauto::kcd::20240812::daily::account::requirements';
//MySubFile2   := '~thor::base::clueauto::kcd::20240813::daily::account::requirements';
//MySubFile2   := '~thor::base::clueauto::kcd::20240815::account::requirements';
MySubFile2   := '~thor::base::clueauto::kcd::20240818::account::requirements';

//thor::base::clueauto::kcd::20240612::account::requirements
//thor::base::clueauto::kcd::qa::inqhist::subject
//thor::base::clueauto::kcd::qa::inqhist::claim

actions3 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 //STD.File.AddSuperFile(MySuperFile,MySubFile1),
 STD.File.AddSuperFile(MySuperFile,MySubFile2),
 STD.File.FinishSuperFileTransaction()
);

//action := SEQUENTIAL(actions2,actions,actions3,actions2);
action := SEQUENTIAL(actions,actions3);
action;
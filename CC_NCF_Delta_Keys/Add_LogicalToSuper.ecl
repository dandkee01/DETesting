IMPORT STD;


actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::ncf::kcd::qa::master_archive_report'));
//actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::currentcarrier::qa::transaction_log_person.txt'));

actions := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.ClearSuperFile('~thor::base::ncf::kcd::qa::master_archive_report'), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.FinishSuperFileTransaction()
);



MySuperFile := '~thor::base::ncf::kcd::qa::master_archive_report';
MySubFile   := '~thor::base::ncf::kcd::adhoc_run_k0306::master_archive_report';
actions3 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.AddSuperFile(MySuperFile,MySubFile),
 STD.File.FinishSuperFileTransaction()
);

a := SEQUENTIAL(actions,actions3,actions2);
//a= SEQUENTIAL(actions2,actions);

a;



/*
actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::ncf::kcd::qa::delta_key.txt'));
//actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::currentcarrier::qa::transaction_log_person.txt'));

actions := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.ClearSuperFile('~thor::base::ncf::kcd::qa::delta_key.txt'), // it just remove subfile from superfile,it wont be deleted from memory
 STD.File.FinishSuperFileTransaction()
);



MySuperFile := '~thor::base::ncf::kcd::qa::delta_key.txt';
MySubFile   := '~thor::base::ncf::kcd::adhoc_test_k::delta_key.txt';
actions3 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.AddSuperFile(MySuperFile,MySubFile),
 STD.File.FinishSuperFileTransaction()
);


a := SEQUENTIAL(actions,actions3,actions2);
//a= SEQUENTIAL(actions2,actions);

a;

*/
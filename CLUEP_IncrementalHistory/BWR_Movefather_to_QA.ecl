IMPORT STD; 

Action1 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.SwapSuperFile('~thor::base::clueauto::kcd::qa::inqhist::subject','~thor::base::clueauto::kcd::grandfather::inqhist::subject'),
 STD.File.FinishSuperFileTransaction()
);

Action2 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.SwapSuperFile('~thor::base::clueauto::kcd::qa::inqhist::claim','~thor::base::clueauto::kcd::grandfather::inqhist::claim'),
 STD.File.FinishSuperFileTransaction()
);

Action3 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.SwapSuperFile('~thor::base::clueauto::inqhs::kcd::qa::bogus::name','~thor::base::clueauto::inqhs::kcd::father::bogus::name'),
 STD.File.FinishSuperFileTransaction()
);

Action4 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.SwapSuperFile('~thor::base::clueauto::inqhs::kcd::qa::bogus::address','~thor::base::clueauto::inqhs::kcd::father::bogus::address'),
 STD.File.FinishSuperFileTransaction()
);

Action5 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.SwapSuperFile('~thor::base::clueauto::inqhs::kcd::qa::bogus::ssn','~thor::base::clueauto::inqhs::kcd::father::bogus::ssn'),
 STD.File.FinishSuperFileTransaction()
);

Action6 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.SwapSuperFile('~thor::base::clueauto::inqhs::kcd::qa::bogus::dl','~thor::base::clueauto::inqhs::kcd::father::bogus::dl'),
 STD.File.FinishSuperFileTransaction()
);

Action7 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.SwapSuperFile('~thor::base::clueauto::inqhs::kcd::qa::bogus::policy','~thor::base::clueauto::inqhs::kcd::father::bogus::policy'),
 STD.File.FinishSuperFileTransaction()
);

Action8 := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.SwapSuperFile('~thor::key::clueauto::inqhist::kcd::autokey::ssn2_qa','~thor::key::clueauto::inqhist::kcd::autokey::ssn2_father'),
 STD.File.FinishSuperFileTransaction()
);

// Actions := PARALLEL(Action1,Action2,Action3,Action4,Action5,Action6,Action7,Action8);
// Actions;
Action1;
Action2;Action4;Action8;
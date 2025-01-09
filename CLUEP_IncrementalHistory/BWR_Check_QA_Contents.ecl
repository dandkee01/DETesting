IMPORT STD;

f1 := '~thor::base::clueauto::kcd::qa::inqhist::subject';
f2 := '~thor::base::clueauto::kcd::qa::inqhist::claim';
f3 := '~thor::base::clueauto::kcd::qa::account::requirements';
f4 := '~thor::base::clueauto::inqhs::kcd::qa::bogus::policy';
f5 := '~thor::base::clueauto::inqhs::kcd::qa::bogus::dl';
f6 := '~thor::base::clueauto::inqhs::kcd::qa::bogus::ssn';
f7 := '~thor::base::clueauto::inqhs::kcd::qa::bogus::address';
f8 := '~thor::base::clueauto::inqhs::kcd::qa::bogus::name';

OUTPUT(STD.File.SuperFileContents(f1));
OUTPUT(STD.File.SuperFileContents(f2));
OUTPUT(STD.File.SuperFileContents(f3));
OUTPUT(STD.File.SuperFileContents(f4));
OUTPUT(STD.File.SuperFileContents(f5));
OUTPUT(STD.File.SuperFileContents(f6));
OUTPUT(STD.File.SuperFileContents(f7));
OUTPUT(STD.File.SuperFileContents(f8));
IMPORT STD;
OUTPUT(STD.File.SuperFileContents('~thor::base::cclue::priorhist::kcd::qa::subject'));

a := STD.File.ClearSuperFile('~thor::base::cclue::priorhist::kcd::father::subject',false);
a;
OUTPUT(STD.File.SuperFileContents('~thor::base::cclue::priorhist::kcd::father::subject'));




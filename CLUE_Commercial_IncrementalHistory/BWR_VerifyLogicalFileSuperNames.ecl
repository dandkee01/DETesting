IMPORT STD;

OUTPUT(STD.File.SuperFileContents('~thor::base::cclue::priorhist::kcd::qa::daily::subject'),named('Dailybase_Subject_contents'));
OUTPUT(STD.File.SuperFileContents('~thor::base::cclue::priorhist::kcd::qa::subject'),named('Base_subject_contents'));
OUTPUT(STD.File.SuperFileContents('~thor::key::cclue::priorhist::kcd::daily::subject_qa'),named('DailyKey_Subject_contents'));
OUTPUT(STD.File.SuperFileContents('~thor::key::cclue::priorhist::kcd::subject_qa'),named('BaseKey_Subject_contents'));


IMPORT STD;

OUTPUT(STD.File.SuperFileContents('~thor::key::claimsdiscoveryproperty::inqhist::kcd::daily::did_qa'),named('Key_Daily_Did_Contents'));
OUTPUT(STD.File.SuperFileContents('~thor::key::claimsdiscoveryproperty::inqhist::kcd::did_qa'),named('Key_Did_Contents'));

OUTPUT(STD.File.SuperFileContents('~thor::base::claimsdiscoveryproperty::kcd::qa::inqhist::subject'),named('Base_Inqhist_subject'));
OUTPUT(STD.File.SuperFileContents('~thor::base::claimsdiscoveryproperty::kcd::qa::daily::inqhist::subject'),named('Base_daily_Inqhist_subject'));

OUTPUT(STD.File.SuperFileContents('~thor::base::claimsdiscoveryproperty::kcd::qa::account::requirements'),named('Base_account_requirements'));
OUTPUT(STD.File.SuperFileContents('~thor::base::claimsdiscoveryproperty::kcd::qa::daily::account::requirements'),named('Base_daily_account_requirements'));
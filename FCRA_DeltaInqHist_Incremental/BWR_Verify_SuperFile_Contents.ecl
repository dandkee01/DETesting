IMPORT STD;

OUTPUT(STD.File.SuperFileContents('~thor::key::claimsdiscoveryauto::inqhist::kcd::daily::did_qa'),named('Key_Daily_Did_Contents'));
OUTPUT(STD.File.SuperFileContents('~thor::key::claimsdiscoveryauto::inqhist::kcd::did_qa'),named('Key_Did_Contents'));

OUTPUT(STD.File.SuperFileContents('~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::subject'),named('Base_Inqhist_subject'));
OUTPUT(STD.File.SuperFileContents('~thor::base::claimsdiscoveryauto::kcd::qa::daily::inqhist::subject'),named('Base_daily_Inqhist_subject'));

OUTPUT(STD.File.SuperFileContents('~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::claim'),named('Base_Inqhist_claim'));
OUTPUT(STD.File.SuperFileContents('~thor::base::claimsdiscoveryauto::kcd::qa::daily::inqhist::claim'),named('Base_daily_Inqhist_claim'));

OUTPUT(STD.File.SuperFileContents('~thor::base::claimsdiscoveryauto::kcd::qa::account::requirements'),named('Base_Inqhist_acctReq'));
OUTPUT(STD.File.SuperFileContents('~thor::base::claimsdiscoveryauto::kcd::qa::daily::account::requirements'),named('Base_daily_Inqhist_acctReq'));

OUTPUT(STD.File.SuperFileContents('~thor::key::claimsdiscoveryauto::inqhist::kcd::custno_qa'),named('Key_Inqhist_acctReq'));
OUTPUT(STD.File.SuperFileContents('~thor::key::claimsdiscoveryauto::inqhist::kcd::daily::custno_qa'),named('Key_daily_Inqhist_acctReq'));
IMPORT STD; 

Layout := RECORD
       STRING Filename;
       STRING LogFilename;
   END;    




/*SuperFileDS := DATASET([{'~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::subject','~thor::base::claimsdiscoveryauto::kcd::20240712::inqhist::subject'},
                              {'~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::subject','~thor::base::claimsdiscoveryauto::kcd::20240715::daily::inqhist::subject'},
                              {'~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::subject','~thor::base::claimsdiscoveryauto::kcd::20240716::daily::inqhist::subject'},
                              {'~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::subject','~thor::base::claimsdiscoveryauto::kcd::20240718::daily::inqhist::subject'},
                              {'~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::subject','~thor::base::claimsdiscoveryauto::kcd::20240719::daily::inqhist::subject'},
                              {'~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::subject','~thor::base::claimsdiscoveryauto::kcd::20240722::daily::inqhist::subject'}], Layout);*/
                              
/*SuperFileDS := DATASET([{'~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::claim','~thor::base::claimsdiscoveryauto::kcd::20240712::inqhist::claim'},
                              {'~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::claim','~thor::base::claimsdiscoveryauto::kcd::20240715::daily::inqhist::claim'},
                              {'~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::claim','~thor::base::claimsdiscoveryauto::kcd::20240716::daily::inqhist::claim'},
                              {'~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::claim','~thor::base::claimsdiscoveryauto::kcd::20240718::daily::inqhist::claim'},
                              {'~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::claim','~thor::base::claimsdiscoveryauto::kcd::20240719::daily::inqhist::claim'},
                              {'~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::claim','~thor::base::claimsdiscoveryauto::kcd::20240722::daily::inqhist::claim'}], Layout); */
                              
//SuperFileDS := DATASET([{'~thor::base::claimsdiscoveryauto::kcd::qa::account::requirements','~thor::base::claimsdiscoveryauto::kcd::20240712::account::requirements'}], Layout);
SuperFileDS := DATASET([{'~thor::key::claimsdiscoveryauto::inqhist::kcd::did_qa','~thor::key::claimsdiscoveryauto::inqhist::kcd::20240908f::did'},
                        {'~thor::key::claimsdiscoveryauto::inqhist::kcd::did_qa','~thor::key::claimsdiscoveryauto::inqhist::kcd::20241001d::did'},
                        {'~thor::key::claimsdiscoveryauto::inqhist::kcd::did_qa','~thor::key::claimsdiscoveryauto::inqhist::kcd::20241002d::did'},
                        {'~thor::key::claimsdiscoveryauto::inqhist::kcd::did_qa','~thor::key::claimsdiscoveryauto::inqhist::kcd::20241003d::did'},
                        {'~thor::key::claimsdiscoveryauto::inqhist::kcd::did_qa','~thor::key::claimsdiscoveryauto::inqhist::kcd::20241004d::did'},
                        {'~thor::key::claimsdiscoveryauto::inqhist::kcd::did_qa','~thor::key::claimsdiscoveryauto::inqhist::kcd::20241005d::did'}
                        ], Layout);

AddQAContents( STRING MySuperFile, STRING MySubFile) := FUNCTION
		
    doClear   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    //STD.File.ClearSuperFile(MySuperFile,false),
                    STD.File.AddSuperFile(MySuperFile,MySubFile),
                    STD.File.FinishSuperFileTransaction()
      		);
   RETURN IF(STD.File.FileExists(MySuperFile),doClear,OUTPUT(MySuperFile+'doesnt exists'));
	 
END;
AddContents := NOTHOR(APPLY(SuperFileDS, AddQAContents(filename,LogFilename)));

Actions := AddContents;

Actions;






/*
STD.File.SuperFileContents('~thor::base::clueauto::kcd::qa::inqhist::subject');
STD.File.SuperFileContents('~thor::base::clueauto::kcd::qa::inqhist::claim');


STD.File.SuperFileContents('~thor::base::clueauto::kcd::qa::account::requirements');

clearfather := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.ClearSuperFile('~thor::base::clueauto::kcd::father::inqhist::subject'),
 STD.File.ClearSuperFile('~thor::base::clueauto::kcd::grandfather::inqhist::subject'),
 STD.File.ClearSuperFile('~thor::base::clueauto::kcd::father::inqhist::claim'),
 STD.File.ClearSuperFile('~thor::base::clueauto::kcd::grandfather::inqhist::claim'),
 STD.File.ClearSuperFile('~thor::base::clueauto::kcd::father::account::requirements'),
 STD.File.ClearSuperFile('~thor::base::clueauto::kcd::grandfather::account::requirements'),
 STD.File.FinishSuperFileTransaction()
);

//clearfather;

*/
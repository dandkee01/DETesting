IMPORT STD; 

Layout := RECORD
       STRING Filename;
       STRING LogFilename;
   END;    




// SuperFileDS := DATASET([{'~thor::base::claimsdiscoveryproperty::kcd::qa::inqhist::subject','~thor::base::claimsdiscoveryproperty::kcd::20240822::inqhist::subject'}
                             // ], Layout);
                              
// SuperFileDS := DATASET([{'~thor::base::claimsdiscoveryproperty::kcd::qa::account::requirements','~thor::base::claimsdiscoveryproperty::kcd::20240822::account::requirements'}
                             // ], Layout); 
                             
SuperFileDS := DATASET([{'~thor::key::claimsdiscoveryproperty::inqhist::kcd::did_qa','~thor::key::claimsdiscoveryproperty::inqhist::kcd::20241014d::did'},
                        {'~thor::key::claimsdiscoveryproperty::inqhist::kcd::inquiry_qa','~thor::key::claimsdiscoveryproperty::inqhist::kcd::20241014d::inquiry'}
                             ], Layout); 



AddQAContents(STRING MySuperFile, STRING MySubFile) := FUNCTION
		
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

// STD.File.SuperFileContents('~thor::base::clueauto::kcd::qa::inqhist::subject');
// STD.File.SuperFileContents('~thor::base::clueauto::kcd::qa::inqhist::claim');


// STD.File.SuperFileContents('~thor::base::clueauto::kcd::qa::account::requirements');

// clearfather := SEQUENTIAL(
 // STD.File.StartSuperFileTransaction(),
 // STD.File.ClearSuperFile('~thor::base::clueauto::kcd::father::inqhist::subject'),
 // STD.File.ClearSuperFile('~thor::base::clueauto::kcd::grandfather::inqhist::subject'),
 // STD.File.ClearSuperFile('~thor::base::clueauto::kcd::father::inqhist::claim'),
 // STD.File.ClearSuperFile('~thor::base::clueauto::kcd::grandfather::inqhist::claim'),
 // STD.File.ClearSuperFile('~thor::base::clueauto::kcd::father::account::requirements'),
 // STD.File.ClearSuperFile('~thor::base::clueauto::kcd::grandfather::account::requirements'),
 // STD.File.FinishSuperFileTransaction()
// );

//clearfather;
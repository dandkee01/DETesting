IMPORT STD; 

Layout := RECORD
       STRING Filename;
       STRING LogFilename;
   END;    

// thor::base::cclue::priorhist::kcd::20240710::subject
// thor::base::cclue::priorhist::kcd::20240711::daily::subject
// thor::base::cclue::priorhist::kcd::20240712::daily::subject
// thor::base::cclue::priorhist::kcd::20240715::daily::subject
// thor::base::cclue::priorhist::kcd::20240716::daily::subject
// thor::base::cclue::priorhist::kcd::20240717::daily::subject
// thor::base::cclue::priorhist::kcd::20240804::daily::subject
// thor::base::cclue::priorhist::kcd::20240811::daily::subject





/*SuperFileDS := DATASET([{'~thor::base::cclue::priorhist::kcd::qa::subject','~thor::base::cclue::priorhist::kcd::20240901::subject'},
                        {'~thor::base::cclue::priorhist::kcd::qa::subject','~thor::base::cclue::priorhist::kcd::20240711::daily::subject'},
                        {'~thor::base::cclue::priorhist::kcd::qa::subject','~thor::base::cclue::priorhist::kcd::20240712::daily::subject'},
                        {'~thor::base::cclue::priorhist::kcd::qa::subject','~thor::base::cclue::priorhist::kcd::20240715::daily::subject'},
                        {'~thor::base::cclue::priorhist::kcd::qa::subject','~thor::base::cclue::priorhist::kcd::20240716::daily::subject'},
                        {'~thor::base::cclue::priorhist::kcd::qa::subject','~thor::base::cclue::priorhist::kcd::20240717::daily::subject'},
                        {'~thor::base::cclue::priorhist::kcd::qa::subject','~thor::base::cclue::priorhist::kcd::20240804::daily::subject'},
                        {'~thor::base::cclue::priorhist::kcd::qa::subject','~thor::base::cclue::priorhist::kcd::20240811::daily::subject'}
                       ], Layout); */
                       
SuperFileDS := DATASET([{'~thor::key::cclue::priorhist::kcd::subject_qa','~thor::key::cclue::priorhist::kcd::20240901f::subject'}/*,
                        {'~thor::key::cclue::priorhist::kcd::subject_qa','~thor::key::cclue::priorhist::kcd::20240711d::subject'},
                        {'~thor::key::cclue::priorhist::kcd::subject_qa','~thor::key::cclue::priorhist::kcd::20240712d::subject'},
                        {'~thor::key::cclue::priorhist::kcd::subject_qa','~thor::key::cclue::priorhist::kcd::20240715d::subject'},
                        {'~thor::key::cclue::priorhist::kcd::subject_qa','~thor::key::cclue::priorhist::kcd::20240716d::subject'},
                        {'~thor::key::cclue::priorhist::kcd::subject_qa','~thor::key::cclue::priorhist::kcd::20240717d::subject'}*/
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

// STD.File.SuperFileContents('~thor::base::cclue::priorhist::father::subject');
// STD.File.SuperFileContents('~thor::key::cclue::priorhist::subject_father');


// STD.File.SuperFileContents('~thor::base::cclue::priorhist::qa::subject');
// STD.File.SuperFileContents('~thor::key::cclue::priorhist::subject_qa');

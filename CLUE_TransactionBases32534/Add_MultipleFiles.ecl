IMPORT STD; 

Layout := RECORD
       STRING Filename;
       STRING LogFilename;
   END;    
   
SuperFileDS := DATASET([{'~thor::base::clue::qa::transaction_log.txt','~thor::base::clue::20240313a::transaction_log.txt'},
                              {'~thor::base::clue::qa::transaction_log_person.txt','~thor::base::clue::20240313a::transaction_log_person.txt'},
                              {'~thor::base::clue::qa::transaction_log_vin.txt','~thor::base::clue::20240313a::transaction_log_vin.txt'},
                             {'~thor::base::clue::qa::transaction_log_claim.txt','~thor::base::clue::20240313a::transaction_log_claim.txt'}], Layout);

AddQAContents(STRING MySuperFile, STRING MySubFile) := FUNCTION
		
    doClear   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    STD.File.ClearSuperFile(MySuperFile),
                    STD.File.AddSuperFile(MySuperFile,MySubFile),
                    STD.File.FinishSuperFileTransaction()
      		);
   RETURN IF(STD.File.FileExists(MySuperFile),doClear,OUTPUT(MySuperFile+'doesnt exists'));
	 
END;
AddContents := NOTHOR(APPLY(SuperFileDS, AddQAContents(filename,LogFilename)));

Actions := AddContents;

Actions;
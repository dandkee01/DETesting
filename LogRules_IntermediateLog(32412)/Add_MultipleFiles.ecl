IMPORT STD; 

Layout := RECORD
       STRING Filename;
       STRING LogFilename;
   END;    
   
SuperFileDS := DATASET([{'~thor::base::log_rules::qa::intermediate_log','~thor::base::log_rules::20240327ab::intermediate_log'}/*,
                              {'~thor::base::clue::qa::transaction_log_person.txt','~thor::base::clue::20240313a::transaction_log_person.txt'},
                              {'~thor::base::clue::qa::transaction_log_vin.txt','~thor::base::clue::20240313a::transaction_log_vin.txt'},
                             {'~thor::base::clue::qa::transaction_log_claim.txt','~thor::base::clue::20240313a::transaction_log_claim.txt'}*/], Layout);

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
IMPORT STD; 
 Layout := RECORD
       STRING Filename;
   END;    
   
SuperFileDS := DATASET([{'~thor::base::clue::qa::transaction_log.txt'},
                              {'~thor::base::clue::qa::transaction_log_person.txt'},
                              {'~thor::base::clue::qa::transaction_log_vin.txt'},
                              {'~thor::base::clue::qa::transaction_log_claim.txt'}], Layout);


QAContents(STRING MySuperFile) := FUNCTION

		
		
    Contents   := SEQUENTIAL(
      							OUTPUT(STD.File.SuperFileContents(MySuperFile))
      		        );
   RETURN IF(STD.File.FileExists(MySuperFile),Contents,OUTPUT(MySuperFile+'doesnt exists'));
	 
END;
FileContents := NOTHOR(APPLY(SuperFileDS,QAContents(filename)));



ClearQAContents(STRING MySuperFile) := FUNCTION

		
		
    doClear   := SEQUENTIAL(
      							fileservices.StartSuperFileTransaction(),
      							fileservices.ClearSuperFile(MySuperFile),
      						  fileservices.FinishSuperFileTransaction()
      		);
   RETURN IF(STD.File.FileExists(MySuperFile),doClear,OUTPUT(MySuperFile+'doesnt exists'));
	 
END;
ClearContents := NOTHOR(APPLY(SuperFileDS, ClearQAContents(filename)));

//Actions := FileContents;
Actions := ClearContents;

Actions;
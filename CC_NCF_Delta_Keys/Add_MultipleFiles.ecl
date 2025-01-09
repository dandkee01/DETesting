IMPORT STD; 

Layout := RECORD
       STRING Filename;
       STRING LogFilename;
   END;    
   
SuperFileDS := DATASET([{'~thor::base::ncf::kcd::qa::delta_key.txt','~thor::base::ncf::kcd::adhoc_test_0312::delta_key.txt'},
                              {'~thor::base::ncf::kcd::qa::master_archive_report','~thor::base::ncf::kcd::adhoc_run_0312::master_archive_report'}], Layout);

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

//Actions;


actions1 := OUTPUT(STD.File.SuperFileContents('~thor::base::ncf::kcd::qa::delta_key.txt'));
actions2 := OUTPUT(STD.File.SuperFileContents('~thor::base::ncf::kcd::qa::master_archive_report'));

PARALLEL(actions1,actions2);

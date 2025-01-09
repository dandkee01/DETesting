IMPORT STD; 

Layout := RECORD
       STRING Filename;
       STRING LogFilename;
   END;  

lf1 := '~base::fcra_mbsi_trano::transaction_log_online::20241023p::trans_online_id';
f1  := '~base::fcra_mbsi_trano::transaction_log_online::qa::trans_online_id';


 SuperFileDS := DATASET([{f1,lf1}], Layout);

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


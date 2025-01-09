IMPORT STD; 

Layout := RECORD
       STRING Filename;
       STRING LogFilename;
   END;    
   
SuperFileDS := DATASET([/*{'~base::cdsc_trano::transaction_log_online::qa::trans_online_id','~base::cdsc_trano::transaction_log_online::20240410a::trans_online_id'},
                              {'~base::ccfc_trano::transaction_log_online::qa::trans_online_id','~base::ccfc_trano::transaction_log_online::20240410a::trans_online_id'},*/
                              {'~thor::base::fcra_delta_inq_hist::qa::prodiheaderversion','~thor::base::fcra_delta_inq_hist::20240417b::prodiheaderversion'}
                             /*{'~thor::base::clue::qa::transaction_log_claim.txt','~thor::base::clue::20240313a::transaction_log_claim.txt'}*/], Layout);

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
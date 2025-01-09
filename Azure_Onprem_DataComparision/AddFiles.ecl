IMPORT STD; 

Layout := RECORD
       STRING Filename;
       STRING LogFilename;
   END;  
   
f1 := '~thor::base::fcra::delta_inq_hist::qa::delta_key';
lf1 := '~thor::base::fcra::delta_inq_hist::20240909b::delta_key';
//lf1 := '~thor::base::fcra::delta_inq_hist::20240925::delta_key';

 SuperFileDS := DATASET([{f1,lf1}], Layout);

AddQAContents(STRING MySuperFile, STRING MySubFile) := FUNCTION
		
    doClear   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    STD.File.ClearSuperFile(MySuperFile,false),
                    STD.File.AddSuperFile(MySuperFile,MySubFile),
                    STD.File.FinishSuperFileTransaction()
      		);
   RETURN IF(STD.File.FileExists(MySuperFile),doClear,OUTPUT(MySuperFile+'doesnt exists'));
	 
END;
AddContents := NOTHOR(APPLY(SuperFileDS, AddQAContents(filename,LogFilename)));

Actions := AddContents;

Actions;


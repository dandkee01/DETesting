// thor::base::cclue::priorhist::kcd::20240710::delta_subject
// thor::base::cclue::priorhist::kcd::20240710::deltadate
// thor::key::cclue::priorhist::kcd::20240710::deltadate



IMPORT STD;

str :='thor::base::cclue::priorhist::kcd::*::subject*';
LogDS := STD.File.LogicalFileList(str);
LogDS;


UnProtectBaseKey(STRING MySubFile) := FUNCTION
		
    //doProtect   := STD.File.ProtectLogicalFile(MySubFile);         
    doProtect   := STD.File.ProtectLogicalFile('~'+TRIM(MySubFile,LEFT,RIGHT),FALSE);  //unprotect       
      		
   RETURN IF(STD.File.FileExists('~'+TRIM(MySubFile,LEFT,RIGHT)),doProtect,OUTPUT('~'+TRIM(MySubFile,LEFT,RIGHT)+'doesnt exists'));
	 
END;
//ProectFiles := NOTHOR(APPLY(LogDS, UnProtectBaseKey(name)));
ProectFiles := APPLY(LogDS, UnProtectBaseKey(name));

Actions := ProectFiles;

Actions;

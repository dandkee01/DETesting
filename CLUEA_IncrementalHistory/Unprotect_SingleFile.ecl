IMPORT STD;

//LF_DS_base := STD.File.LogicalFileList('*base*clueauto*kcd*20240701*');
LF_DS_base := STD.File.LogicalFileList('*base*clueauto*kcd*');
OUTPUT(LF_DS_base);
//LF_DS_key := STD.File.LogicalFileList('*key*clueauto*kcd*20240701*');
LF_DS_key := STD.File.LogicalFileList('*key*clueauto*kcd*');
OUTPUT(LF_DS_key);


Unprotect(STRING MySubFile) := FUNCTION
		output('~'+MySubFile);
    unpro   := STD.File.ProtectLogicalFile('~'+MySubFile, FALSE);
      		
   RETURN IF(STD.File.FileExists('~'+MySubFile),unpro,OUTPUT('~'+MySubFile+'doesnt exists'));
	 
END;
//AddContents_base := NOTHOR(APPLY(LF_DS_base, Unprotect(name)));
AddContents_keys := NOTHOR(APPLY(LF_DS_key, Unprotect(name)));

Actions := AddContents_keys ;

Actions;
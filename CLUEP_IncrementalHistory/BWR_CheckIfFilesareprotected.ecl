IMPORT STD;

 AllFiles := NOTHOR(STD.File.LogicalFileList('*clueproperty*202409*', TRUE,TRUE)(modified[1..10] <= '2024-09-30' and owner IN [ 'Mandlip01','dandke01']  and cluster IN ['hthor__dev_eclagent_1','thor400_198', 'thor20_167_dev','thor400_126','thor20_166_sta']));

AllFiles;
//OUTPUT(STD.File.GetLogicalFileAttribute(file,'protected'),NAMED('protected'));

IsFileProtected(STRING name) := FUNCTION
		
     CheckProtect := OUTPUT(STD.File.GetLogicalFileAttribute('~'+name,'protected'),NAMED('protected'));
   RETURN IF(STD.File.FileExists(name),CheckProtect,OUTPUT(name+'doesnt exists'));
	 
END;
AddContents := NOTHOR(APPLY(AllFiles, IsFileProtected(name)));

Actions := AddContents;

Actions;

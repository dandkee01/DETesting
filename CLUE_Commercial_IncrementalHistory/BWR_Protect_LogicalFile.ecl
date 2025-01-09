IMPORT STD;
IMPORT _control;

//STRING WU := 'W20240710-145140'; //Baseline run
//STRING WU := 'W20240711-230857'; //daily1 // CLUECOMMERCIAL WUIDS
//STRING WU := 'W20240712-133628'; //daily2
//STRING WU := 'W20240715-103418'; //daily3
//STRING WU := 'W20240716-222549'; //daily4
//STRING WU := 'W20240717-155133'; //daily5
//STRING WU := 'W20240718-215321'; //1st sunday
//STRING WU := 'W20240730-113703'; //Not a sunday Scenario
//STRING WU := 'W20240812-150619-3'; //1st sunday Scenario
//STRING WU := 'W20241011-171409'; //Roxie1
//STRING WU := 'W20241012-150141'; //Roxie2
//STRING WU := 'W20241013-085239'; //Roxie3
STRING WU := 'W20241013-102242'; //Roxie4
ds := STD.System.Workunit.WorkunitFilesWritten(WU);
OUTPUT(ds);
WsFileRead := RECORD
  STRING name{MAXLENGTH(256)};
  STRING10 graph;
  STRING cluster{MAXLENGTH(64)};
  UNSIGNED4 kind;
  STRING IsBaseOrKey;
  STRING ProdFile;
END;

WsFileRead WUFileReads(RECORDOF(ds) l) := TRANSFORM
   IsBase := STD.Str.StartsWith(l.name,'thor::base');
   initialCheck := STD.Str.FindWord(l.name,'kcd',TRUE); 

   //IsBase := STD.Str.StartsWith(l.name,'base');   
   IsKey := STD.Str.StartsWith(l.name,'thor::key');
   IsBorK := (IsBase AND initialCheck)  OR IsKey;
  //SELF.IsBaseOrKey := IF(IsBorK,'TRUE','FALSE');
  SELF.IsBaseOrKey := MAP(IsBase=true=>'Base',IsKey=true=>'key','');
  SELF.name := '~'+l.name;
  SELF := [];
END;
FileBaseorKey := PROJECT(ds, WUFileReads(LEFT));
OnlyBaseorKey := FileBaseorKey(IsBaseOrKey IN['Base','key']);

WsFileRead RemUnwanted(RECORDOF(OnlyBaseorKey) l) := TRANSFORM
  isTxtFileFound   := STD.Str.FindWord(l.name,'.txt',TRUE); 
  isWUlogFileFound := STD.Str.FindWord(l.name,'wulog',TRUE); 
  IsStatFile       := STD.Str.FindWord(l.name,'::stats::',TRUE); 
  IsDeltaFile      := STD.Str.wildmatch(l.name, '*delta*', false); 
  IsFound          := isTxtFileFound OR isWUlogFileFound OR IsStatFile OR IsDeltaFile;
  SELF.name        := IF(~IsFound,l.name,SKIP);
  SELF := l;
END;
RemovedUnwanted := PROJECT(OnlyBaseorKey, RemUnwanted(LEFT));

OUTPUT(RemovedUnwanted);

ProtectBaseKey(STRING MySubFile) := FUNCTION
		
    doProtect   := STD.File.ProtectLogicalFile(MySubFile);         
    //doProtect   := STD.File.ProtectLogicalFile(MySubFile,FALSE);  //unprotect       
      		
   RETURN IF(STD.File.FileExists(MySubFile),doProtect,OUTPUT(MySubFile+'doesnt exists'));
	 
END;
//ProectFiles := NOTHOR(APPLY(RemovedUnwanted, ProtectBaseKey(name)));
ProectFiles := APPLY(RemovedUnwanted, ProtectBaseKey(name));

Actions := ProectFiles;

Actions;
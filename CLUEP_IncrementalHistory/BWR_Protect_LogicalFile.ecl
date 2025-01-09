IMPORT STD;
IMPORT _control;


//STRING WU := 'W20240813-133404'; //acct req 1st daily
//STRING WU := 'W20240813-150619'; //acct req 2nd daily
//STRING WU := 'W20240816-145205'; //acct req 3rd daily
//STRING WU := 'W20240816-161504'; //acct req Did corrections roll up
//STRING WU := 'W20240818-002346'; //acct req reidl corrections roll up
//STRING WU := 'W20240819-114750'; //1st sunday roll up

//*****************************************************************
//STRING WU := 'W20240905-074308'; // Roxie 1st Daily
//STRING WU := 'W20240905-224011'; // Roxie 2nd Daily
//STRING WU := 'W20240906-092013'; // Roxie 3rd Daily
  STRING WU := 'W20240906-115740'; // Roxie 4th Daily


//--------------------------Dops WUIDs---------------------------------
//STRING WU := 'W20240829-164319'; //Daily Scenario
//STRING WU := 'W20240829-120806'; //Roll Up Scenario

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
  //IsAccountFile    := STD.Str.wildmatch(l.name, '*account::requirements*', false); 
  IsxdlFile    := STD.Str.wildmatch(l.name, '*updatedxdlsubject*', false); 
  IsmergeFile    := STD.Str.wildmatch(l.name, '*mergesubjectincremental*', false); 
  IsFound          := isTxtFileFound OR isWUlogFileFound OR IsStatFile OR IsDeltaFile OR IsxdlFile OR IsmergeFile;
  SELF.name        := IF(~IsFound,l.name,SKIP);
  SELF := l;
END;
RemovedUnwanted := PROJECT(OnlyBaseorKey, RemUnwanted(LEFT));

OUTPUT(RemovedUnwanted, named('filestobeprotected'));

ProtectBaseKey(STRING MySubFile) := FUNCTION
		
    doProtect   := STD.File.ProtectLogicalFile(MySubFile);         
    //doProtect   := STD.File.ProtectLogicalFile(MySubFile,FALSE);  //unprotect       
      		
   RETURN IF(STD.File.FileExists(MySubFile),doProtect,OUTPUT(MySubFile+'doesnt exists'));
	 
END;
//ProectFiles := NOTHOR(APPLY(RemovedUnwanted, ProtectBaseKey(name)));
ProectFiles := APPLY(RemovedUnwanted, ProtectBaseKey(name));

Actions := ProectFiles;

Actions;
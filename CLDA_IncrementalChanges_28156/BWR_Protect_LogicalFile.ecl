IMPORT STD;
IMPORT _control;

//STRING WU := 'W20240715-132320'; //daily 1 // CLDA WUIDS
//STRING WU := 'W20240716-184510'; //daily 2 // CLDA WUIDS
//STRING WU := 'W20240718-133824'; //daily 3 // CLDA WUIDS
//STRING WU := 'W20240719-214737'; //daily 4 // CLDA WUIDS
//STRING WU := 'W20240722-113810'; //daily 5 // CLDA WUIDS
//STRING WU := 'W20240712-160336'; //Thorprod
//STRING WU := 'W20240723-203551'; //1st sunday  //got bug here
//STRING WU := 'W20240825-110121'; //Acct Req 1 Daily
//STRING WU := 'W20240825-210937'; //Acct Req 2 Daily
//STRING WU := 'W20240826-120822'; //Acct Req 3 Daily
//STRING WU := 'W20240829-074349'; //Acct Req 1st Sunday base
//STRING WU := 'W20240829-101647'; //Acct Req 1st Sunday keys
//STRING WU := 'W20240830-125305'; //did corrections
//STRING WU := 'W20240904-162455'; //reidl corrections
//STRING WU := 'W20241001-230046'; //Roxie 1
//STRING WU := 'W20241002-121746'; //Roxie 1
//STRING WU := 'W20241002-134942'; //Roxie 3
//STRING WU := 'W20241002-153815'; //Roxie 4
STRING WU := 'W20241011-102818'; //Roxie 5

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
  IsAccountFile    := STD.Str.wildmatch(l.name, '*account::requirements*', false); 
  IsxdlFile    := STD.Str.wildmatch(l.name, '*updatedxdlsubject*', false); 
  IsmergeFile    := STD.Str.wildmatch(l.name, '*mergesubjectincremental*', false); 
  IsFound          := isTxtFileFound OR isWUlogFileFound OR IsStatFile OR IsDeltaFile OR IsAccountFile OR IsxdlFile OR IsmergeFile;
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
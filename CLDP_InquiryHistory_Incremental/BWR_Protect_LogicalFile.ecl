IMPORT STD;
IMPORT _control;


//STRING WU := 'W20240822-225109'; //Baseline run
//STRING WU := 'W20240827-152724'; //1st daily
//STRING WU := 'W20240828-222202'; //2nd daily
//STRING WU := 'W20240829-225918'; //3rd daily
//STRING WU := 'W20240904-121959'; //4th daily
//STRING WU := 'W20241008-132201'; //5th daily
//STRING WU := 'W20241009-091200'; //6th daily
//STRING WU := 'W20241009-142920'; //1st sunday
//STRING WU := 'W20241009-170159'; //did corrections
//STRING WU := 'W20241011-125316'; //reidl corrections
//STRING WU := 'W20241013-115922'; //Roxie1
//STRING WU := 'W20241014-092613'; //Roxie2
//STRING WU := 'W20241014-154141'; //Roxie3
STRING WU := 'W20241014-172519'; //Roxie4
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
  IsFound          := isTxtFileFound OR isWUlogFileFound OR IsStatFile OR IsDeltaFile  OR IsxdlFile OR IsmergeFile;
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
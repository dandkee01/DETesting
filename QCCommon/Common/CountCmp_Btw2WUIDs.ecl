
IMPORT STD;
IMPORT _control;

EXPORT CountCmp_Btw2WUIDs(STRING WUI, STRING build_version) := FUNCTION	

//***************************************************************************************************************************
// rerplace Initials with your initials.
// WU is wuid of your build
// set IsFileWUTimStmp as TRUE if 
Initials := 'kcd';
//STRING WU := 'W20230509-161039';
STRING WU := WUI;
FilteredWU := STD.Str.FilterOut(WU, 'W-');
FileWUunit:= FilteredWU[1..10];
//OUTPUT(FileWUunit);

ds := STD.System.Workunit.WorkunitFilesWritten(WU);

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
   //IsBase := STD.Str.StartsWith(l.name,'base');   
   IsKey := STD.Str.StartsWith(l.name,'thor::key');
   IsBorK := IsBase OR IsKey;
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
  IsFound          := isTxtFileFound OR isWUlogFileFound;
  SELF.name        := IF(~IsFound,l.name,SKIP);
  SELF := l;
END;
RemovedUnwanted := PROJECT(OnlyBaseorKey, RemUnwanted(LEFT));

//OUTPUT(RemovedUnwanted,named('RemovedUnwanted'));
FinalLayout := RECORD
  STRING    File;
  UNSIGNED8 RecCount;
  STRING Filteredname;
END;

FinalLayout CompLayout(RECORDOF(RemovedUnwanted) l) := TRANSFORM
   ComparedDS        := fun_LayoutCompare(l.name);
   SELF.File         := ComparedDS[1].file;
   SELF.RecCount     := ComparedDS[1].RecCount;
   isFound           := STD.Str.FindWord(ComparedDS[1].File, build_version, true);
   SELF.Filteredname := IF(isFound,STD.Str.FindReplace(ComparedDS[1].File,build_version,''),STD.Str.FilterOut(ComparedDS[1].File, '0123456789'));

END;
finalds := PROJECT(RemovedUnwanted, CompLayout(LEFT));
output(finalds);
OUTPUT(ds);
OUTPUT(FileBaseorKey);
//OUTPUT(OnlyBaseorKey, named('OnlyBaseorKey1'));



RETURN finalds ;

END;

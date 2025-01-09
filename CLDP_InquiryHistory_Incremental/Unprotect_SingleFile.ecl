//~thor::base::claimsdiscoveryauto_inqhist::updatedxdlsubject__p424228675
//~thor::base::claimsdiscoveryauto_inqhist::mergesubjectincremental__p2590722799
IMPORT STD;

str :='*thor::base::claimsdiscoveryproperty::kcd::*account::requirements*';
//str :='*thor::key::claimsdiscoveryauto*kcd*acctno*';
ds := STD.File.LogicalFileList(str);
ds;
WsFileRead := RECORD
  STRING name;  
  BOOLEAN superfile;
  UNSIGNED8 size;
  UNSIGNED8 rowcount;
  STRING19 modified;
  STRING owner;
  STRING cluster;
  STRING IsBaseOrKey;
  //STRING ProdFile;
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
  IsSprayFile    := STD.Str.wildmatch(l.name, '*spray*', false); 
  //IsFound          := isTxtFileFound OR isWUlogFileFound OR IsStatFile OR IsDeltaFile OR IsAccountFile OR IsxdlFile OR IsmergeFile OR IsSprayFile;
  IsFound          := isTxtFileFound OR isWUlogFileFound OR IsStatFile OR IsDeltaFile OR IsxdlFile OR IsmergeFile OR IsSprayFile;
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
IMPORT STD;
IMPORT _control;

//***************************************************************************************************************************
// rerplace Initials with your initials.
// WU is wuid of your build
// set IsFileWUTimStmp as TRUE if 
//Initials := 'prls';
STRING WU := 'W20240311-160956';
FilteredWU := STD.Str.FilterOut(WU, 'W-');
//FileWUunit:= FilteredWU[1..10];
FileWUunit:= '20240310ab';
OUTPUT(FileWUunit);

ds := STD.System.Workunit.WorkunitFilesWritten(WU);
OUTPUT(ds,named('wu_files_written'));

WsFileRead := RECORD
  STRING name{MAXLENGTH(256)};
  STRING10 graph;
  STRING cluster{MAXLENGTH(64)};
  UNSIGNED4 kind;
  STRING IsBaseOrKey;
  STRING ProdFile;
END;
/*
WsFileRead WUFileReads(RECORDOF(ds) l) := TRANSFORM
   IsBase := STD.Str.StartsWith(l.name,'thor::base');   
   IsKey := STD.Str.StartsWith(l.name,'thor::key');
   IsBorK := IsBase OR IsKey;
  //SELF.IsBaseOrKey := IF(IsBorK,'TRUE','FALSE');
  SELF.IsBaseOrKey := MAP(IsBase=true=>'Base',IsKey=true=>'key','');
  SELF := l;
  SELF := [];
END;
*/
WsFileRead WUFileReads(RECORDOF(ds) l) := TRANSFORM
   IsBase := STD.Str.StartsWith(l.name,'thor::base');   
   IsKey := STD.Str.StartsWith(l.name,'thor::key');
   IsBorK := IsBase OR IsKey;
  //SELF.IsBaseOrKey := IF(IsBorK,'TRUE','FALSE');
  SELF.IsBaseOrKey := MAP(IsBase=true=>'Base',IsKey=true=>'key','');
  SELF := l;
  SELF := [];
END;
FileBaseorKey := PROJECT(ds, WUFileReads(LEFT));
//OUTPUT(FileBaseorKey);
OnlyBaseorKey := FileBaseorKey(IsBaseOrKey IN['Base','key']);
OUTPUT(OnlyBaseorKey, named('OnlyBaseorKey'));

BaseFiles := OnlyBaseorKey(IsBaseOrKey='Base');
KeyFiles  := OnlyBaseorKey(IsBaseOrKey='key');

// uncomment below code if you pass initials into your code
/*WsFileRead ReplaceBaseFiles(RECORDOF(BaseFiles) l) := TRANSFORM
   
  RemIn1 := STD.Str.FindReplace(l.name, '::'+Initials+'::'+FileWUunit+'::','::qa::');
  //RemIn1 := STD.Str.FindReplace(l.name, '::reg::20221212::','::qa::');
  RemIn2 := STD.Str.FindReplace(RemIn1, '::'+Initials+'::','::');
  RemIn3 := STD.Str.FindReplace(RemIn2, '::'+FileWUunit+'::','::qa::');
  SELF.ProdFile := RemIn3;
  SELF.name := '~'+l.name;
  SELF := l;
  SELF := [];
END;
*/
WsFileRead ReplaceBaseFiles(RECORDOF(BaseFiles) l) := TRANSFORM
   
  //RemIn1 := STD.Str.FindReplace(l.name, '::'+Initials+'::'+FileWUunit+'::','::qa::');
  //RemIn1 := STD.Str.FindReplace(l.name, '::reg::20221212::','::qa::');
  //RemIn2 := STD.Str.FindReplace(RemIn1, '::'+Initials+'::','::');
  RemIn3 := STD.Str.FindReplace(l.name, '::'+FileWUunit+'::','::qa::');
  SELF.ProdFile := RemIn3;
  SELF.name := '~'+l.name;
  SELF := l;
  SELF := [];
END;
ReplaceBase := PROJECT(BaseFiles, ReplaceBaseFiles(LEFT));
OUTPUT(ReplaceBase,named('ReplaceBase'));

/*WsFileRead ReplaceKeyFiles(RECORDOF(BaseFiles) l) := TRANSFORM
   
  RemIn1 := STD.Str.FindReplace(l.name, '::'+Initials+'::','::');
  RemIn2 := STD.Str.FindReplace(RemIn1, '::'+FileWUunit+'::','::');
  RemIn3 := RemIn2+'_qa';
  SELF.ProdFile := RemIn3;
  SELF.name := '~'+l.name;
  SELF := l;
  SELF := [];
END;
*/

WsFileRead ReplaceKeyFiles(RECORDOF(BaseFiles) l) := TRANSFORM
   
  RemIn2 := STD.Str.FindReplace(l.name, '::'+FileWUunit+'::','::');
  //RemIn2 := STD.Str.FindReplace(l.name, '::'+FileWUunit+'::','::qa::');
  RemIn3 := RemIn2+'_qa';
  //RemIn3 := RemIn2;
  SELF.ProdFile := RemIn3;
  SELF.name := '~'+l.name;
  SELF := l;
  SELF := [];
END;
ReplaceKey := PROJECT(KeyFiles, ReplaceKeyFiles(LEFT));
OUTPUT(ReplaceKey,named('ReplaceKey'));

FullReplaced := ReplaceBase + ReplaceKey;
OUTPUT(FullReplaced, named('FullReplaced'));

WsFileRead RemUnwanted(RECORDOF(FullReplaced) l) := TRANSFORM
  //isTxtFileFound   := STD.Str.FindWord(l.name,'.txt',TRUE); 
  isWUlogFileFound := STD.Str.FindWord(l.name,'wulog',TRUE); 
  //IsFound          := isTxtFileFound OR isWUlogFileFound;
  IsFound          := isWUlogFileFound;
  SELF.name        := IF(~IsFound,l.name,SKIP);
  SELF := l;
END;
RemovedUnwanted := PROJECT(FullReplaced, RemUnwanted(LEFT));

OUTPUT(RemovedUnwanted, named('RemovedUnwanted'));

FinalLayout := RECORD
  STRING    DevFile;
  STRING    DevLayout;
  STRING    IsNewFieldExistDev;
  UNSIGNED8 DevRecCount;
  STRING    ProdFile;
  STRING    ProdLayout;
  STRING    IsNewFieldExistProd;
  UNSIGNED8 ProdRecCount;
END;

FinalLayout CompLayout(RECORDOF(RemovedUnwanted) l) := TRANSFORM
   ComparedDS        := fun_LayoutCompare(l.name,l.prodfile);
   SELF.DevFile      := ComparedDS[1].file;
   SELF.DevLayout    := ComparedDS[1].Layout;
   SELF.DevRecCount  := ComparedDS[1].RecCount;
   SELF.ProdFile     := ComparedDS[2].file;
   SELF.ProdLayout   := ComparedDS[2].Layout;
   SELF.ProdRecCount := ComparedDS[2].RecCount;
   SELF := []
END;
ComparedLayoutDS := PROJECT(RemovedUnwanted, CompLayout(LEFT));
OUTPUT(ComparedLayoutDS,named('ComparedLayoutDS'));

FinalLayout NewExist(RECORDOF(ComparedLayoutDS) l) := TRANSFORM
 
  Isrecord_sid    := REGEXFIND('record_sid',l.DevLayout,NOCASE); 
  Isglobal_sid    := REGEXFIND('global_sid',l.DevLayout,NOCASE); 
  //Isdt_effective_last    := REGEXFIND('dt_effective_last',l.DevLayout,NOCASE); 
  //Isdelta_ind  := REGEXFIND('delta_ind',l.DevLayout,NOCASE);  
  //IsFieldsExist := Isglobal_sid OR Isrecord_sid OR Isdt_effective_last OR Isdelta_ind;
  IsFieldsExist := Isglobal_sid OR Isrecord_sid ;
  SELF.IsNewFieldExistDev := IF(IsFieldsExist,'TRUE','FALSE');
  
  Isrecord_sidp    := REGEXFIND('record_sid',l.ProdLayout,NOCASE); 
  Isglobal_sidp    := REGEXFIND('global_sid',l.ProdLayout,NOCASE); 
  //Isdt_effective_lastp    := REGEXFIND('dt_effective_last',l.ProdLayout,NOCASE); 
  //Isdelta_indp  := REGEXFIND('delta_ind',l.ProdLayout,NOCASE);  
  //IsFieldsExistp := Isglobal_sidp OR Isdt_effective_firstp OR Isdt_effective_lastp OR Isdelta_indp;
  IsFieldsExistp := Isglobal_sidp OR Isrecord_sidp;
  SELF.IsNewFieldExistProd := IF(IsFieldsExistp,'TRUE','FALSE');
  SELF:= l;
END;
DS_NewExist := PROJECT(ComparedLayoutDS, NewExist(LEFT));
OUTPUT(DS_NewExist,Named('DS_NewExist'));
OUTPUT(DS_NewExist(IsNewFieldExistDev='TRUE'),Named('DS_NewExistIsNewFieldExistDev'));

//******************************************************************************************************************************************************
//DESPRAY

   DateToday             := (STRING)STD.date.Today();
   fileName              := 'ExistNewFieldsCLDAContri'+DateToday+'.csv';
   LandingZone_File_Dir  := '/data/DandKe01/LayoutCmp/';
   lzFilePathBaseFile    := LandingZone_File_Dir; 
   LandingZoneIP         := _control.IPAddress.unixland;//10.194.72.227//
   TempCSV               := '~thor::base::Trans_Log_Person::KCD::CSV';

//---------------------------------------------------------------------------------
 outputBaseAsCSV   := OUTPUT(DS_NewExist,,TempCSV,CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR(','),NOTRIM),OVERWRITE);
 //outputBaseAsCSV;    
 
 //desprayResult := clda.bwr_Despray(TempCSV,lzFilePathBaseFile,fileName);
 //desprayResult;

IMPORT STD;

WU := 'W20240321-155948';
ds := STD.System.Workunit.WorkunitFilesWritten(WU);

ds;

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
   IsKey := STD.Str.StartsWith(l.name,'thor::key');
   IsBorK := IsBase OR IsKey;
   SELF.IsBaseOrKey := MAP(IsBase=true=>'Base',IsKey=true=>'key','');
   SELF := l;
   SELF := [];
END;
FileBaseorKey := PROJECT(ds, WUFileReads(LEFT));
FileBaseorKey;


OnlyBaseorKey := FileBaseorKey(IsBaseOrKey IN['Base','key']);
OUTPUT(OnlyBaseorKey, named('OnlyBaseorKey'));

BaseFiles := OnlyBaseorKey(IsBaseOrKey='Base');
KeyFiles  := OnlyBaseorKey(IsBaseOrKey='key');
OUTPUT(KeyFiles, named('KeyFiles'));

FinalLayout := RECORD
  STRING    File;
  STRING    Layout;
END;

fun_GetLayout(STRING file) := FUNCTION
    
   Dev_DS := DATASET([{STD.File.GetLogicalFileAttribute('~'+file,'ECL'),file}], {STRING Layout,STRING file});
   RETURN Dev_DS;
 
 END; 
FinalLayout GetLayout(RECORDOF(KeyFiles) l) := TRANSFORM
   LayoutDS          := fun_GetLayout(l.name);
   SELF.File         := LayoutDS[1].file;
   SELF.Layout       := LayoutDS[1].Layout;
   
END;
LayoutDS := PROJECT(KeyFiles, GetLayout(LEFT));
OUTPUT(LayoutDS,named('LayoutDS'));

Layout1 := LayoutDS[1].Layout : STORED('layout');
File1 := LayoutDS[1].File;

#CONSTANT('layout',LayoutDS[1].Layout);

#CONSTANT('layout',Layout1);
#CONSTANT('file',File1);

Key1 := INDEX(layout,File);
Key1;

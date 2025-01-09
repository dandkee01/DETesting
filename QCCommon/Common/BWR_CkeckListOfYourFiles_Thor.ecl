IMPORT STD;
AllFiles := NOTHOR(STD.File.LogicalFileList('*', TRUE,TRUE)(modified[1..10] <= '2024-08-15' and owner IN [ 'DandKe01','Dandke01','dandke01']  and cluster IN ['hthor__dev_eclagent_1','thor400_198', 'thor20_167_dev','thor400_126','thor20_166_sta']));
SORT(AllFiles,-size);
/*NewRec := RECORD
  RECORDOF(AllFiles);
  STRING NoVersion;
END;

NewRec RemoveVersion(AllFiles l) := TRANSFORM
  SELF.NoVersion := STD.Str.FilterOut(l.name, '0123456789') ;
  SELF := l;
END;
NoVersionDS := PROJECT(AllFiles,RemoveVersion(LEFT));
OUTPUT(NoVersionDS,named('NoVersionDS'));

LatestFileFirstDS :=SORT(NoVersionDS,name,-modified);
OUTPUT(LatestFileFirstDS,named('latest_modified_first'));

latest_file := CHOOSEN(LatestFileFirstDS,1);

//Keeplatest := AllFiles-latest_file;

//Keeplatest;

*/
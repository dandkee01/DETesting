
IMPORT STD;

VerifyFileCount(STRING File,string date) := FUNCTION

  AllFiles := NOTHOR(STD.File.LogicalFileList(file, TRUE,TRUE)(modified[1..8] <= date/*'20240226'*/ and owner IN [ /*'DandKe01','Dandke01',*/'dandke01']  and cluster IN ['hthor__dev_eclagent_1','thor400_198', 'thor20_167_dev','thor400_126','thor20_166_sta']));
  RETURN AllFiles;

END;

VerifyFileCount('*thor::base::clue::20240307::*','20240308');
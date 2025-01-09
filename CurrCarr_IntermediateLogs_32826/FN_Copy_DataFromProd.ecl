IMPORT _control, ut, Data_Services, STD;



 EXPORT FN_Copy_DataFromProd(string sname,string version, STRING Suffix) := FUNCTION
					

		ALPHAPROD		:= DATA_SERVICES.FOREIGN_PROD;
    TILT :='~';


    QA     := sname;
    isKeyFile := STD.Str.FindWord(sname,'key',TRUE); // true  - with case ignored word is found
    QAreplaced := STD.Str.FindReplace(sname, '_qa','');
    suffixreplace := STD.Str.FindReplace(QAreplaced,Suffix,'');
    KeyFile := suffix+version+'::'+suffixreplace;
    QA_Dev := IF(~isKeyFile,STD.Str.FindReplace(sname, '::qa::','::'+version+'::'),KeyFile);
    output(QA_Dev);
    QA_Prod := STD.File.GetSuperFileSubName(ALPHAPROD+QA, 1);
    output(QA_Prod);
    CopyData := STD.FILE.COPY(ALPHAPROD + QA_Prod ,'THOR400_126',TILT + QA_Dev,,,,,TRUE,,,,,,);
    ifExist := STD.File.SuperFileExists(TILT+QA);
    CreateSF := IF(~ifExist,STD.FILE.CREATESUPERFILE(TILT+QA));		
    AddSF    := STD.FILE.ADDSUPERFILE(TILT+QA,TILT+QA_Dev);
    Actions := sequential(CopyData,CreateSF,AddSF);
    Return Actions;
END;
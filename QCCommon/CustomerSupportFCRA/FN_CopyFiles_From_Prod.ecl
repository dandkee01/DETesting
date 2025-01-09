IMPORT _control, ut, Data_Services, STD;

//EXPORT FN_CopyFiles_From_Prod := 'todo';


	//EXPORT Copy_Files(string sname,string version) := FUNCTION
					

		ALPHAPROD		:= DATA_SERVICES.FOREIGN_PROD;
    TILT :='~';


    transaction_log_person_qa     := 'base::cc_tranlperson::transaction_log_person::qa::trans_log_id';
    transaction_log_person_qa_Dev     := 'base::cc_tranlperson::transaction_log_person::20231109a::trans_log_id';
    
    transaction_log_person_qa_prod := STD.File.GetSuperFileSubName(ALPHAPROD+transaction_log_person_qa, 1);
    output(transaction_log_person_qa_prod);
    CopyData := STD.FILE.COPY(ALPHAPROD + transaction_log_person_qa ,'THOR400_126',TILT + transaction_log_person_qa_Dev,,,,,TRUE,,,,,,);
    ifExist := STD.File.SuperFileExists(TILT+transaction_log_person_qa);
    CreateSF := IF(~ifExist,STD.FILE.CREATESUPERFILE(TILT+transaction_log_person_qa));		
    AddSF    := STD.FILE.ADDSUPERFILE(TILT+transaction_log_person_qa,TILT+transaction_log_person_qa_Dev);
    Actions := sequential(CopyData,CreateSF,AddSF);
    Actions;
//END;
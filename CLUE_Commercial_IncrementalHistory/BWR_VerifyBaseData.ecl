	IMPORT CCLUE_PriorHistory;
  
  Daily_SubjectSF   := '~thor::base::cclue::priorhist::kcd::20240710::subject';
  DailySubject_DS		:= DATASET (Daily_SubjectSF,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);	
  
  qaSubFile      := '~thor::base::cclue::priorhist::kcd::qa::subject';
  qaSubFile_DS1		:= DATASET (qaSubFile,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);
  qaSubFile_DS := qaSubFile_DS1-DailySubject_DS;
  
  qaSubFile_DS(TRIM(transaction_id,LEFT,RIGHT)='1116651111110');
	



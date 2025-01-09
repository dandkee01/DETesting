	IMPORT CCLUE_PriorHistory;
  
  Daily_SubjectSF   := '~thor::base::cclue::priorhist::20240310::daily::subject';
  DailySubject_DS		:= DATASET (Daily_SubjectSF,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);	
  
  qaSubFile      := '~thor::base::cclue::priorhist::qa::subject';
  qaSubFile_DS1		:= DATASET (qaSubFile,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);
  qaSubFile_DS := qaSubFile_DS1-DailySubject_DS;
  
	OUTPUT(MAX(qaSubFile_DS,record_sid), named('Max_record_sid_HistSub'));
  OUTPUT(SORT(DailySubject_DS,reference_no),named('DailySubject_DS'));
  OUTPUT(SORT(DailySubject_DS,reference_no),{transaction_id,sequence,reference_no,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('DailySubject_DS_reqFields'));
  OUTPUT(MIN(DailySubject_DS,record_sid), named('Min_record_sid_DailySub_DS'));
  OUTPUT(MAX(DailySubject_DS,record_sid), named('Max_record_sid_DailySub_DS'));
  OUTPUT(COUNT(DailySubject_DS),named('COUNT_DailySub_DS'));
  OUTPUT(COUNT(DailySubject_DS(delta_ind=1)),named('Cnt_non_Updated_Recs'));
  OUTPUT(DailySubject_DS(delta_ind=1),{transaction_id,sequence,reference_no,record_sid,dt_effective_first,dt_effective_last,delta_ind},named('non_Updated_Recs'));
  OUTPUT(COUNT(DailySubject_DS(delta_ind<>1)),named('COUNT_Delta_2and3_DS'));
  OUTPUT(SORT(DailySubject_DS(delta_ind<>1),reference_no),named('Updated_Recs'));
  OUTPUT(SORT(DailySubject_DS(delta_ind<>1),reference_no),{transaction_id,sequence,reference_no,record_sid,dt_effective_first,dt_effective_last,delta_ind},named('Updated_Recs_req_Fields'));
  OUTPUT(COUNT(DailySubject_DS(dt_effective_first<>0)),named('COUNT_DtEfffirst_notEmpty_DS'));
  OUTPUT(COUNT(DailySubject_DS(dt_effective_last<>0)),named('COUNT_DtEfflast_notEmpty_DS'));
  OUTPUT(DailySubject_DS(dt_effective_last<>0),{transaction_id,sequence,reference_no,record_sid,dt_effective_first,dt_effective_last,delta_ind},named('DtEfflast_notEmpty_DS'));
  OUTPUT(COUNT(DailySubject_DS(record_sid<>0)),named('COUNT_recordsid_notEmpty_DS'));




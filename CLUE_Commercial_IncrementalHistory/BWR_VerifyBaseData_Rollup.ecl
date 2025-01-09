	IMPORT CCLUE_PriorHistory;
  
  Hist_SubFile      := '~thor::base::cclue::priorhist::kcd::20240710::subject';
  Hist_SubFile_DS		:= DATASET (Hist_SubFile,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);	
  
  QaSubFile      := '~thor::base::cclue::priorhist::kcd::qa::subject';
  QaSubFile_DS1	 := DATASET (QaSubFile,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);
  
  DailyRecs      :=   QaSubFile_DS1 - Hist_SubFile_DS;
  OUTPUT(DailyRecs, named('DailyRecs'));
  
  FaSubFile      := '~thor::base::cclue::priorhist::kcd::father::subject';
  FaSubFile_DS1	 := DATASET (FaSubFile,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);
  OUTPUT(FaSubFile_DS1(TRIM(reference_no,LEFT,RIGHT)='11111111111110'),named('refno_From_Dailies'));      
  OUTPUT(QaSubFile_DS1(TRIM(reference_no,LEFT,RIGHT)='11111111111110'),named('refno_From_qaAfterRollup'));      

  
  // OUTPUT(COUNT(QaSubFile_DS),named('Total_cnt_Qa'));
  // OUTPUT(COUNT(Hist_SubFile_DS),named('Total_cnt_baseline'));
  // OUTPUT(COUNT(QaSubFile_DS(delta_ind<>1)),named('COUNT_Delta_not1'));
  // OUTPUT(COUNT(QaSubFile_DS(delta_ind=1)),named('COUNT_Delta_1'));
  // OUTPUT(COUNT(QaSubFile_DS(dt_effective_first=0)),named('COUNT_DtEfffirst_notEmpty'));
  // OUTPUT(COUNT(QaSubFile_DS(dt_effective_last=0)),named('COUNT_DtEfflast_notEmpty'));
  // OUTPUT(COUNT(QaSubFile_DS(record_sid<>0)),named('COUNT_recordsid_notEmpty'));
  // OUTPUT(MAX(QaSubFile_DS,record_sid),named('Max_recordSid'));
  // OUTPUT(MAX(Hist_SubFile_DS,record_sid),named('Max_recordSid_BaseLine'));




	IMPORT CCLUE_PriorHistory;
  
  Hist_SubFile      := '~thor::base::cclue::priorhist::20240223a::subject';
  Hist_SubFile_DS		:= DATASET (Hist_SubFile,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);	
  
  FaSubFile      := '~thor::base::cclue::priorhist::father::subject';
  FaSubFile_DS1	 := DATASET (FaSubFile,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);
  FaSubFile_DS   := SORT(FaSubFile_DS1-Hist_SubFile_DS,reference_no,-dt_effective_first);
  
  OUTPUT(FaSubFile_DS,named('FaSubFile_DS'));
  Ref_noSET := SET(FaSubFile_DS, reference_no);
  OUTPUT(Ref_noSET,named('Ref_noSET'));
  
  
  QaSubFile      := '~thor::base::cclue::priorhist::qa::subject';
  QaSubFile_DS		:= DATASET (QaSubFile,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);

  DailyDS := QaSubFile_DS(reference_no IN Ref_noSET);
  OUTPUT(DailyDS,named('DailyDS'));

// Verify latest updated record is kept and remaining are deleted in rollup
  OUTPUT(QaSubFile_DS(reference_no='66666666666660'),  {transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Qa_660'));
  OUTPUT(FaSubFile_DS(reference_no='66666666666660'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Fa_660'));

// Verify all the records with delta_ind=3 are deleted. FRANKLIN

  OUTPUT(QaSubFile_DS(reference_no='66666666666660', last_name='FRANKLIN'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Check_Franklin_ExistsQA'));
  OUTPUT(FaSubFile_DS(reference_no='66666666666660'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Check_Franklin_ExistsFA'));
 
 // Verify the records with delta_ind=2 and early dt_effective_first are removed in rollup. PRANKLIN

  OUTPUT(QaSubFile_DS(reference_no='66666666666660', last_name='SRANKLIN'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Check_Sranklin_ExistsQA'));
  OUTPUT(FaSubFile_DS(reference_no='66666666666660'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Check_Pranklin_ExistsFA'));
  
// Verify all the records with delta_ind=1 are kept  
  OUTPUT(QaSubFile_DS(reference_no='77777777777700'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Qa_7700'));
  OUTPUT(FaSubFile_DS(reference_no='77777777777700'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Fa_7700'));

 
  OUTPUT(COUNT(QaSubFile_DS),named('Total_cnt_Qa'));
  OUTPUT(COUNT(Hist_SubFile_DS),named('Total_cnt_baseline'));
  OUTPUT(COUNT(QaSubFile_DS(delta_ind<>1)),named('COUNT_Delta_not1'));
  OUTPUT(COUNT(QaSubFile_DS(delta_ind=1)),named('COUNT_Delta_1'));
  OUTPUT(COUNT(QaSubFile_DS(dt_effective_first=0)),named('COUNT_DtEfffirst_notEmpty'));
  OUTPUT(COUNT(QaSubFile_DS(dt_effective_last=0)),named('COUNT_DtEfflast_notEmpty'));
  OUTPUT(COUNT(QaSubFile_DS(record_sid<>0)),named('COUNT_recordsid_notEmpty'));
  OUTPUT(MAX(QaSubFile_DS,record_sid),named('Max_recordSid'));
  OUTPUT(MAX(Hist_SubFile_DS,record_sid),named('Max_recordSid_BaseLine'));




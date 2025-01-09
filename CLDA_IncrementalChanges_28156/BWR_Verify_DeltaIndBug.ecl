IMPORT CCLUE_PriorHistory, Delta_Macro; 
 
 Daily_0304   := '~thor::base::cclue::priorhist::20240304::daily::subject';
 Daily_0304_DS		:= DATASET (Daily_0304,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);	
 OUTPUT(Daily_0304_DS(reference_no='66666666666660'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Daily_0304'));
 
 Daily_0310   := '~thor::base::cclue::priorhist::20240310::daily::subject';
 Daily_0310_DS		:= DATASET (Daily_0310,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);	
 OUTPUT(Daily_0310_DS(reference_no='66666666666660'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Daily_0310'));

 Daily_0407   := '~thor::base::cclue::priorhist::20240407::daily::subject';
 Daily_0407_DS		:= DATASET (Daily_0407,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);	
 OUTPUT(Daily_0407_DS(reference_no='66666666666660'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Daily_0407'));

 Daily_0505   := '~thor::base::cclue::priorhist::20240505::daily::subject';
 Daily_0505_DS		:= DATASET (Daily_0505,CCLUE_PriorHistory.Layouts.delta_subject_clean,THOR);	
 OUTPUT(Daily_0505_DS(reference_no='66666666666660'),{transaction_id,sequence,reference_no,last_name,record_sid,dt_effective_first,dt_effective_last,delta_ind}, named('Daily_0505'));


FullDs := Daily_0304_DS+Daily_0310_DS+Daily_0407_DS + Daily_0505_DS;
OUTPUT(FullDs,named('FullDs'));
field1 := Delta_Macro.constants.Clue_Commercial_subject_fields;
Sorted_FullDs := sort(FullDs,#expand(field1),-dt_effective_first,dt_effective_last,delta_ind);
OUTPUT(Sorted_FullDs,named('Sorted_FullDs'));



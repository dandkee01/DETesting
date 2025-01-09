IMPORT CCLUE_PriorHistory, std;

base := '~thor::base::cclue::priorhist::qa::subject';

base_CCLUE := DATASET(base, CCLUE_PriorHistory.Layouts.delta_subject_clean, THOR);

Sorted_ds := SORT(Base_CCLUE, reference_no, sequence);

Updated_Base_CCLUE := PROJECT (Sorted_ds, TRANSFORM(CCLUE_PriorHistory.Layouts.delta_subject_clean, 
                                                       SELF.Record_Sid := COUNTER; 
                                                       SELF.delta_ind := 1;
                                                       SELF := LEFT; 
                                                       SELF := []));
max(Updated_base_CCLUE, record_sid);
OUTPUT(Updated_Base_CCLUE,named('Updated_Base_CCLUE'));

filename := '~thor::base::cclue::priorhist::20240103::subject';                                                       
OUTPUT(Updated_Base_CCLUE,, filename, overwrite, __compressed__, named('base_test'));
//output(base_CCLUE,, '~thor::base::cclue::priorhist::qa::subject_dup', overwrite, __compressed__);

std.file.clearsuperfile(base);
std.file.addsuperfile(base, '~thor::base::cclue::priorhist::20240103::subject');

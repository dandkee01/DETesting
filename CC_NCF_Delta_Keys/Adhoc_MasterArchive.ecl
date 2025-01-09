IMPORT NCF, std,ut;
#workunit('priority', 'high');
#workunit('priority', '10');

master_archieve := 'thor::base::ncf::qa::master_archive_report';

base_master_archieve := DATASET(ut.foreign_prod + master_archieve, NCF.Layout_EditsArchive, THOR);

Sorted_ds := SORT (base_master_archieve, JulianDate,RemainingRefNo,ReportSource,LineNumber);

Updated_Base := PROJECT (Sorted_ds, TRANSFORM(NCF.Layout_EditsArchive, 
                                                       SELF.Record_Sid := COUNTER;
                                                       SELF.delta_ind := 1;
                                                       SELF.dt_effective_first := std.date.Today();
                                                       SELF := LEFT; 
                                                       SELF := []));
max(Updated_base, record_sid);

Distributed_ds := DISTRIBUTE (Updated_Base, HASH32 (NCF.ConvertRefNo(JulianDate,RemainingRefNo,ReportSource)));

filename := '~thor::base::ncf::kcd::adhoc_run_0312::master_archive_report';                                                       
OUTPUT(Distributed_ds,, filename, overwrite, __compressed__, named('base_test'));


// output(base_CCLUE,, '~thor::base::cclue::priorhist::qa::subject_dup', overwrite, __compressed__);

//std.file.clearsuperfile(master_archieve);
//std.file.addsuperfile(master_archieve, filename);
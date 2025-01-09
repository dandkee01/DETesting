IMPORT NCF, std;
//#workunit('priority', 'high');

master_archieve := '~thor::base::ncf::qa::master_archive_report';

after_project := DATASET(master_archieve, NCF.Layout_EditsArchive, THOR);

OUTPUT(COUNT(after_project),named('total_rec_count'));
Cnt1 := COUNT(after_project(dt_effective_first<>0));
OUTPUT(Cnt1,named('dt_effective_first_notzero'));
Cnt2 := COUNT(after_project(dt_effective_first=0));
OUTPUT(Cnt2,named('dt_effective_first_zero'));

OUTPUT(COUNT(after_project(dt_effective_last=0)),named('dt_effective_last_zero'));
OUTPUT(COUNT(after_project(dt_effective_last<>0)),named('dt_effective_last_notzero'));

total_cnt := cnt1+cnt2;
OUTPUT(total_cnt,named('total_cnt'));

OUTPUT(COUNT(after_project(record_sid<>0)),named('record_sid_notZero'));
OUTPUT(COUNT(after_project(record_sid=0)),named('record_sid_Zero'));

OUTPUT(COUNT(after_project(delta_ind<>1)),named('delta_ind_notOne'));
OUTPUT(COUNT(after_project(delta_ind=1)),named('delta_ind_One'));

OUTPUT(SORT(after_project,-record_sid), named('record_sid_sorted'));
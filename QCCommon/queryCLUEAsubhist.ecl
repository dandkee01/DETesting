import CLUEAuto_Delta;
ds := DATASET('~thor::base::cluea::kcd::testdata::qa::deltakeysubject',CLUEAuto_Delta.Layouts.Delta_Subject,THOR);
output(choosen(ds,10));

rec := RECORD
ds.reference_number;
ds.transaction_id;
ds.subject_last_name;
ds.subject_first_name;
ds.subject_dob;
Cnt := COUNT(GROUP);
END;
Mytable := TABLE(ds,rec,reference_number,transaction_id,subject_last_name,subject_first_name,subject_dob);
//Mytable;
//Mytable(Cnt!= 1); // 23017121301269
ds(reference_number='23017121301269');
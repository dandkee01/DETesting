IMPORT STD;

 Clear := STD.File.ClearSuperFile('~thor::base::fcra::delta_inq_hist::qa::delta_key',false);
 Add   := STD.File.AddSuperFile('~thor::base::fcra::delta_inq_hist::qa::delta_key','~thor::base::fcra::delta_inq_hist::20241217::delta_key');
 
Actions := SEQUENTIAL(Clear,Add);
Actions;
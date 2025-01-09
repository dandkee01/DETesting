IMPORT STD;
file := '~spray::fcra::delta_inq_hist::delta_key::w20240925-150252';

//STD.File.ProtectLogicalFile(file);    
//STD.File.ClearSuperFile('~spray::fcra::delta_inq_hist::delta_key',false);   
STD.File.SuperFileContents('~spray::fcra::delta_inq_hist::delta_key');   
//STD.File.ProtectLogicalFile(file, FALSE);  //unprotect
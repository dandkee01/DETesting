
IMPORT STD;

 f1 := '~thor::base::fcra::delta_inq_hist::20250116::delta_key';

 f2 := '~thor::base::fcra::delta_inq_hist::20250117::delta_key';
		
doProtect   := PARALLEL(STD.File.ProtectLogicalFile(f2),   
                        STD.File.ProtectLogicalFile(f2)        
                        // STD.File.ProtectLogicalFile(f3),        
                        // STD.File.ProtectLogicalFile(f4)        
                        // STD.File.ProtectLogicalFile(f5),        
                        // STD.File.ProtectLogicalFile(f6),        
                        // STD.File.ProtectLogicalFile(f7),        
                        // STD.File.ProtectLogicalFile(f8)
                        );       
doProtect;


//STD.File.ProtectLogicalFile(file);         //protect
//STD.File.ProtectLogicalFile(file, FALSE);  //unprotect

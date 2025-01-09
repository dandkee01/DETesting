
IMPORT STD;

// f1 := '~thor::base::ncf::20241101::master_archive_report';

// f2 := '~thor::base::ncf::20241101::delta_key.txt';

// f3 := '~thor::base::ncf::20241101a::master_archive_report';

// f4 := '~thor::base::ncf::20241101a::delta_key.txt';

 //f1 := '~thor::base::clueauto::psb::20241113a::daily::inqhist::subject';
 // f1 := '~thor::base::clueproperty::psb::20241113a::daily::inqhist::subject';
  f2 := '~thor::base::clueproperty::psb::20241113::daily::inqhist::subject';
 
 // f1 := '~thor::base::fcra_azure::delta_inq_hist::20241113a::delta_key';
 // f2 := '~thor::base::fcra_onperm::delta_inq_hist::20241113::delta_key';

// f5 := '~thor::base::ncf::20240902::master_archive_report';

// f6 := '~thor::base::ncf::20240902::delta_key.txt';

// f7 := '~thor::base::ncf::20240903::master_archive_report';

// f8 := '~thor::base::ncf::20240903::delta_key.txt';

// f1 := '~thor::base::fcra::delta_inq_hist::20240917a::delta_key';
// f2 := '~thor::base::fcra::delta_inq_hist::20240917::delta_key';
// f2 := '~thor::base::fcra::delta_inq_hist::20240925::delta_key';


// f1 := '~thor::base::claimsdiscoveryauto::20241101::inqhist::subject';
// f2 := '~thor::base::claimsdiscoveryauto::20241101::inqhist::claim';
// f3 := '~thor::base::claimsdiscoveryauto::20240903::inqhist::subject';
// f4 := '~thor::base::claimsdiscoveryauto::20240903::inqhist::claim';



		
doProtect   := PARALLEL(STD.File.ProtectLogicalFile(f2) 
                        //STD.File.ProtectLogicalFile(f2)        
                        // STD.File.ProtectLogicalFile(f3),        
                        // STD.File.ProtectLogicalFile(f4)        
                        // STD.File.ProtectLogicalFile(f5),        
                        // STD.File.ProtectLogicalFile(f6),        
                        // STD.File.ProtectLogicalFile(f7),        
                        // STD.File.ProtectLogicalFile(f8)
                        );       
doProtect;
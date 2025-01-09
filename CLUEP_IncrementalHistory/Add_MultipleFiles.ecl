IMPORT STD; 

Layout := RECORD
       STRING Filename;
       STRING LogFilename;
   END;  
   
f1 := '~thor::base::deltamacro::clue_property::qa::prodheaderversion';
//f2 := '~thor::base::clueproperty::qa::inqhist::subject';
// f3 := '~thor::base::clueauto::kcd::qa::account::requirements';
// f4 := '~thor::base::clueauto::inqhs::kcd::qa::bogus::policy';
// f5 := '~thor::base::clueauto::inqhs::kcd::qa::bogus::dl';
// f6 := '~thor::base::clueauto::inqhs::kcd::qa::bogus::ssn';
// f7 := '~thor::base::clueauto::inqhs::kcd::qa::bogus::address';
// f8 := '~thor::base::clueauto::inqhs::kcd::qa::bogus::name';


lf1 := '~thor::base::deltamacro::clue_property::20240927pm::prodheaderversion';
//lf2 := '~thor::base::clueproperty::20240916b::inqhist::subject';
// lf3 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::20240818f::zip';
// lf4 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::20240818f::name';
// lf5 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::20240818f::policy';
// lf6 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::20240818f::address';
// lf7 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::20240818f::dlno';
// lf8 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::20240818f::citystname';
// lf9 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::20240818f::payload';
// lf10 := '~thor::key::clueauto::inqhist::kcd::autokey::20240818f::ssn2';
// lf11 := '~thor::key::clueauto::inqhist::kcd::autokey::20240818f::stname';
// lf12 := '~thor::key::clueauto::inqhist::kcd::autokey::20240818f::zip';
// lf13 := '~thor::key::clueauto::inqhist::kcd::autokey::20240818f::name';
// lf14 := '~thor::key::clueauto::inqhist::kcd::autokey::20240818f::policy';
// lf15 := '~thor::key::clueauto::inqhist::kcd::autokey::20240818f::address';
// lf16 := '~thor::key::clueauto::inqhist::kcd::autokey::20240818f::dlno';
// lf17 := '~thor::key::clueauto::inqhist::kcd::autokey::20240818f::citystname';
// lf18 := '~thor::key::clueauto::inqhist::kcd::autokey::20240818f::payload';
// lf19 := '~thor::key::clueauto::inqhist::kcd::20240818f::did';
// lf20 := '~thor::key::clueauto::inqhist::kcd::20240818f::inquiry';
// lf21 := '~thor::key::clueauto::inqhist::kcd::20240818f::cnsmr::did';
// lf22 := '~thor::key::clueauto::inqhist::kcd::20240818f::refno::claim';
// lf23 := '~thor::key::clueauto::inqhist::kcd::20240818f::inquiry::did';
// lf24 := '~thor::key::clueauto::inqhist::kcd::20240818f::bogus::name';
// lf25 := '~thor::key::clueauto::inqhist::kcd::20240818f::bogus::address';
// lf26 := '~thor::key::clueauto::inqhist::kcd::20240818f::bogus::ssn';
// lf27 := '~thor::key::clueauto::inqhist::kcd::20240818f::bogus::driverslicenseno';
// lf28 := '~thor::key::clueauto::inqhist::kcd::20240818f::bogus::policyno';



// f1 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::ssn2_qa';
// f2 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::stname_qa';
// f3 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::zip_qa';
// f4 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::name_qa';
// f5 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::policy_qa';
// f6 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::address_qa';
// f7 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::dlno_qa';
// f8 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::citystname_qa';
// f9 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::payload_qa';
// f10 := '~thor::key::clueauto::inqhist::kcd::autokey::ssn2_qa';
// f11 := '~thor::key::clueauto::inqhist::kcd::autokey::stname_qa';
// f12 := '~thor::key::clueauto::inqhist::kcd::autokey::zip_qa';
// f13 := '~thor::key::clueauto::inqhist::kcd::autokey::name_qa';
// f14 := '~thor::key::clueauto::inqhist::kcd::autokey::policy_qa';
// f15 := '~thor::key::clueauto::inqhist::kcd::autokey::address_qa';
// f16 := '~thor::key::clueauto::inqhist::kcd::autokey::dlno_qa';
// f17 := '~thor::key::clueauto::inqhist::kcd::autokey::citystname_qa';
// f18 := '~thor::key::clueauto::inqhist::kcd::autokey::payload_qa';
// f19 := '~thor::key::clueauto::inqhist::kcd::did_qa';
// f20 := '~thor::key::clueauto::inqhist::kcd::inquiry_qa';
// f21 := '~thor::key::clueauto::inqhist::kcd::cnsmr::did_qa';
// f22 := '~thor::key::clueauto::inqhist::kcd::refno::claim_qa';
// f23 := '~thor::key::clueauto::inqhist::kcd::inquiry::did_qa';
// f24 := '~thor::key::clueauto::inqhist::kcd::bogus::name_qa';
// f25 := '~thor::key::clueauto::inqhist::kcd::bogus::address_qa';
// f26 := '~thor::key::clueauto::inqhist::kcd::bogus::ssn_qa';
// f27 := '~thor::key::clueauto::inqhist::kcd::bogus::driverslicenseno_qa';
// f28 := '~thor::key::clueauto::inqhist::kcd::bogus::policyno_qa';



// String version1 := '20240818';
// String version2 := '20240905';
// String version3 := '20240906';
// String version4 := '20240612a';

// lf1 := '~thor::base::clueauto::kcd::'+version+'::inqhist::subject';
// lf2 := '~thor::base::clueauto::kcd::'+version+'::inqhist::claim';
// lf3 := '~thor::base::clueauto::kcd::'+version+'::account::requirements';
// lf4 := '~thor::base::clueauto::inqhs::kcd::'+version+'::bogus::policy';
// lf5 := '~thor::base::clueauto::inqhs::kcd::'+version+'::bogus::dl';
// lf6 := '~thor::base::clueauto::inqhs::kcd::'+version+'::bogus::ssn';
// lf7 := '~thor::base::clueauto::inqhs::kcd::'+version+'::bogus::address';
// lf8 := '~thor::base::clueauto::inqhs::kcd::'+version+'::bogus::name';


// SuperFileDS := DATASET([{f1,'~thor::base::clueauto::kcd::'+version1+'::inqhist::subject'},
                        // {f1,'~thor::base::clueauto::kcd::'+version2+'::daily::inqhist::subject'},
                        // {f1,'~thor::base::clueauto::kcd::'+version3+'::daily::inqhist::subject'},
                        // {f2,'~thor::base::clueauto::kcd::'+version1+'::inqhist::claim'},
                        // {f2,'~thor::base::clueauto::kcd::'+version2+'::daily::inqhist::claim'},
                        // {f2,'~thor::base::clueauto::kcd::'+version3+'::daily::inqhist::claim'},
                        // {f3,'~thor::base::clueauto::kcd::'+version4+'::account::requirements'},
                        // {f3,'~thor::base::clueauto::kcd::'+version2+'::daily::account::requirements'},
                        // {f3,'~thor::base::clueauto::kcd::'+version3+'::daily::account::requirements'}], Layout);
                        
 SuperFileDS := DATASET([{f1,lf1}],
                         //{f2,lf2}],
                         /*{f3,lf3},
                         {f4,lf4},
                         {f5,lf5},
                         {f6,lf6},
                         {f7,lf7},
                         {f8,lf8},
                         {f9,lf9},
                         {f10,lf10},
                         {f11,lf11},
                         {f12,lf12},
                         {f13,lf13},
                         {f14,lf14},
                         {f15,lf15},
                         {f16,lf16},
                         {f17,lf17},
                         {f18,lf18},
                         {f19,lf19},
                         {f20,lf20},
                         {f21,lf21},
                         {f22,lf22},
                         {f23,lf23},
                         {f24,lf24},
                         {f25,lf25},
                         {f26,lf26},
                         {f27,lf27},
                         {f28,lf28}],*/ Layout);

AddQAContents(STRING MySuperFile, STRING MySubFile) := FUNCTION
		
    doClear   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    STD.File.ClearSuperFile(MySuperFile,false),
                    STD.File.AddSuperFile(MySuperFile,MySubFile),
                    STD.File.FinishSuperFileTransaction()
      		);
   RETURN IF(STD.File.FileExists(MySuperFile),doClear,OUTPUT(MySuperFile+'doesnt exists'));
	 
END;
AddContents := NOTHOR(APPLY(SuperFileDS, AddQAContents(filename,LogFilename)));

Actions := AddContents;

Actions;


#WORKUNIT('priority','high');
#WORKUNIT('priority',10); 
#WORKUNIT('name','Change Hearder Versions For Lexid Corrections'); 

IMPORT did_add,delta_macro, STD; 
	
		HdrFileVersionReIDL := did_add.get_EnvVariable(delta_macro.constants.iHEADER_PACKAGE_ENV_VARIABLE, delta_macro.constants.HEADER_ROXIE_VIP);
	  DS_Delta_HEADER_BUILD_VERSION := DATASET(delta_macro.Files.Delta_PREFIX + '::clue_auto::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX,  delta_macro.layouts.IHDR_layouts, THOR, OPT);
	  LexIDAppendVersion := DS_Delta_HEADER_BUILD_VERSION()[1].DeltaLexIDAppendVersion;
	  IsReadyForReIDL := LexIDAppendVersion <> HdrFileVersionReIDL;
		
    LexidVerChged :=  PROJECT(DS_Delta_HEADER_BUILD_VERSION,TRANSFORM(RECORDOF(DS_Delta_HEADER_BUILD_VERSION),SELF.DeltaLexIDAppendVersion := '20240627',SELF :=LEFT));
    //LexidVerChged :=  PROJECT(DS_Delta_HEADER_BUILD_VERSION,TRANSFORM(RECORDOF(DS_Delta_HEADER_BUILD_VERSION),SELF.DeltaLexIDAppendVersion := '20240527',SELF :=LEFT));
   
    OUTPUT(HdrFileVersionReIDL, named('HdrFileVersionReIDL'));
    OUTPUT(IsReadyForReIDL, named('IsReadyForReIDL'));
    Iheader := OUTPUT(LexidVerChged,, '~thor::base::deltamacro::clue_auto::20241121kcd::prodheaderversion', overwrite, __compressed__, named('LexidVersion'));
   
   doClearI   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    IF(~STD.File.SuperFileExists('~thor::base::deltamacro::clue_auto::qa::prodheaderversion'),STD.File.CreateSuperFile('~thor::base::deltamacro::clue_auto::qa::prodheaderversion',,1));
                    STD.File.ClearSuperFile('~thor::base::deltamacro::clue_auto::qa::prodheaderversion'),
                    STD.File.AddSuperFile('~thor::base::deltamacro::clue_auto::qa::prodheaderversion','~thor::base::deltamacro::clue_auto::20241121kcd::prodheaderversion'),
                    STD.File.FinishSuperFileTransaction()
      		);
          
   Actions := SEQUENTIAL( Iheader,doClearI);
   Actions;
   
   
   /*Iheader := OUTPUT(LexidVerChged,, '~thor::base::deltamacro::kcd::clue_auto::20240819kcd::prodheaderversion', overwrite, __compressed__, named('LexidVersion'));
   
   doClearI   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    IF(~STD.File.SuperFileExists('~thor::base::deltamacro::kcd::clue_auto::qa::prodheaderversion'),STD.File.CreateSuperFile('~thor::base::deltamacro::kcd::clue_auto::qa::prodheaderversion',,1));
                    STD.File.ClearSuperFile('~thor::base::deltamacro::kcd::clue_auto::qa::prodheaderversion'),
                    STD.File.AddSuperFile('~thor::base::deltamacro::kcd::clue_auto::qa::prodheaderversion','~thor::base::deltamacro::kcd::clue_auto::20240819kcd::prodheaderversion'),
                    STD.File.FinishSuperFileTransaction()
      		);
          
   Actions := SEQUENTIAL( Iheader,doClearI);
   Actions;*/
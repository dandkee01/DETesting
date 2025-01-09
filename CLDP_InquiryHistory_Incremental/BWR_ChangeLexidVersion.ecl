#WORKUNIT('priority','high');
#WORKUNIT('priority',10); 
#WORKUNIT('name','Change Hearder Versions For Lexid Corrections'); 

IMPORT did_add,delta_macro, STD; 
	
		HdrFileVersionReIDL := did_add.get_EnvVariable(delta_macro.constants.iHEADER_PACKAGE_ENV_VARIABLE, delta_macro.constants.HEADER_ROXIE_VIP);
  OUTPUT(HdrFileVersionReIDL, named('HdrFileVersionReidl'));		
  DS_Delta_HEADER_BUILD_VERSION := DATASET(delta_macro.Files.Delta_PREFIX + '::claimsdiscovery_property::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX,  delta_macro.layouts.IHDR_layouts, THOR, OPT);
  //DS_Delta_HEADER_BUILD_VERSION := DATASET('~thor::base::deltamacro::claimsdiscovery_property::qa::prodheaderversion',  delta_macro.layouts.IHDR_layouts, THOR, OPT);
	LexIDAppendVersion := DS_Delta_HEADER_BUILD_VERSION()[1].DeltaLexIDAppendVersion;
  OUTPUT(delta_macro.Files.Delta_PREFIX + '::claimsdiscovery_property::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX, named('Reidl_LexIDAppendVersion_Fname'));	
	OUTPUT(LexIDAppendVersion, named('LexIDAppendVersion'));		
  IsReadyForReIDL := LexIDAppendVersion <> HdrFileVersionReIDL;
	ReIDLCheck := IsReadyForReIDL:independent;
  OUTPUT(ReIDLCheck, named('IsreadyforReidl'));
		
    LexidVerChged :=  PROJECT(DS_Delta_HEADER_BUILD_VERSION,TRANSFORM(RECORDOF(DS_Delta_HEADER_BUILD_VERSION),SELF.DeltaLexIDAppendVersion := '20240912',SELF :=LEFT));
    //LexidVerChged :=  PROJECT(DS_Delta_HEADER_BUILD_VERSION,TRANSFORM(RECORDOF(DS_Delta_HEADER_BUILD_VERSION),SELF.DeltaLexIDAppendVersion := '20240527',SELF :=LEFT));
   
    Iheader := OUTPUT(LexidVerChged,, '~thor::base::deltamacro::claimsdiscovery_property::20241017k::prodheaderversion', overwrite, __compressed__, named('LexidVersion'));
   
   doClearI   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    IF(~STD.File.SuperFileExists('~thor::base::deltamacro::claimsdiscovery_property::qa::prodheaderversion'),STD.File.CreateSuperFile('~thor::base::deltamacro::claimsdiscovery_property::qa::prodheaderversion',,1));
                    STD.File.ClearSuperFile('~thor::base::deltamacro::claimsdiscovery_property::qa::prodheaderversion'),
                    STD.File.AddSuperFile('~thor::base::deltamacro::claimsdiscovery_property::qa::prodheaderversion','~thor::base::deltamacro::claimsdiscovery_property::20241017k::prodheaderversion'),
                    STD.File.FinishSuperFileTransaction()
      		);
    //Iheader := OUTPUT(LexidVerChged,, '~thor::base::deltamacro::claimsdiscovery_property::20241017k::prodheaderversion', overwrite, __compressed__, named('LexidVersion'));
   
   // doClearI   := SEQUENTIAL(
      							// STD.File.StartSuperFileTransaction(),
                    // IF(~STD.File.SuperFileExists('~thor::base::deltamacro::kcd::claimsdiscovery_property::qa::prodheaderversion'),STD.File.CreateSuperFile('~thor::base::deltamacro::kcd::claimsdiscovery_property::qa::prodheaderversion',,1));
                    // STD.File.ClearSuperFile('~thor::base::deltamacro::kcd::claimsdiscovery_property::qa::prodheaderversion'),
                    // STD.File.AddSuperFile('~thor::base::deltamacro::kcd::claimsdiscovery_property::qa::prodheaderversion','~thor::base::deltamacro::kcd::claimsdiscovery_property::20241010::prodheaderversion'),
                    // STD.File.FinishSuperFileTransaction()
      		// );
                
   Actions := SEQUENTIAL( Iheader,doClearI);
   Actions;
IMPORT did_add,CLUEAuto_InquiryHistory, STD, Delta_Macro;

  HdrFileVersionReIDL := did_add.get_EnvVariable(Delta_Macro.constants.iHEADER_PACKAGE_ENV_VARIABLE, Delta_Macro.constants.HEADER_ROXIE_VIP);
  OUTPUT(HdrFileVersionReIDL, named('HdrFileVersionREIDL'));	
  DS_Delta_HEADER_BUILD_VERSION := DATASET(Delta_Macro.Files.Delta_PREFIX + '::claimsdiscovery_auto::QA::' + Delta_Macro.Files.HEADER_BUILD_VERSION_SUFFIX,  Delta_Macro.layouts.IHDR_layouts, THOR, OPT);
  OUTPUT(Delta_Macro.Files.Delta_PREFIX + '::claimsdiscovery_auto::QA::' + Delta_Macro.Files.HEADER_BUILD_VERSION_SUFFIX, named('LexidAppendVersion_Fname'));	
  
  didVerChged :=  PROJECT(DS_Delta_HEADER_BUILD_VERSION,TRANSFORM(RECORDOF(DS_Delta_HEADER_BUILD_VERSION),SELF.deltalexidappendversion := '20240912',SELF :=LEFT));
  //didVerChged :=  PROJECT(DS_Delta_HEADER_BUILD_VERSION,TRANSFORM(RECORDOF(DS_Delta_HEADER_BUILD_VERSION),SELF.deltalexidappendversion := '20240627',SELF :=LEFT));
   
    
    Iheader := OUTPUT(didVerChged,,'~THOR::BASE::DELTAMACRO::claimsdiscovery_auto::20241017k::PRODHEADERVERSION', overwrite, __compressed__, named('LexidVersion'));
   
   doClearI   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    IF(~STD.File.SuperFileExists('~THOR::BASE::DELTAMACRO::claimsdiscovery_auto::QA::PRODHEADERVERSION'),STD.File.CreateSuperFile('~THOR::BASE::DELTAMACRO::claimsdiscovery_auto::QA::PRODHEADERVERSION',,1));
                    STD.File.ClearSuperFile('~THOR::BASE::DELTAMACRO::claimsdiscovery_auto::QA::PRODHEADERVERSION',),
                    STD.File.AddSuperFile('~THOR::BASE::DELTAMACRO::claimsdiscovery_auto::QA::PRODHEADERVERSION','~THOR::BASE::DELTAMACRO::claimsdiscovery_auto::20241017k::PRODHEADERVERSION'),
                    STD.File.FinishSuperFileTransaction()
      		);
   /* Iheader := OUTPUT(didVerChged,,'~THOR::BASE::DELTAMACRO::KCD::claimsdiscovery_auto::20241017k::PRODHEADERVERSION', overwrite, __compressed__, named('LexidVersion'));
   
   doClearI   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    IF(~STD.File.SuperFileExists('~THOR::BASE::DELTAMACRO::KCD::claimsdiscovery_auto::QA::PRODHEADERVERSION'),STD.File.CreateSuperFile('~THOR::BASE::DELTAMACRO::KCD::claimsdiscovery_auto::QA::PRODHEADERVERSION',,1));
                    STD.File.ClearSuperFile('~THOR::BASE::DELTAMACRO::KCD::claimsdiscovery_auto::QA::PRODHEADERVERSION',),
                    STD.File.AddSuperFile('~THOR::BASE::DELTAMACRO::KCD::claimsdiscovery_auto::QA::PRODHEADERVERSION','~THOR::BASE::DELTAMACRO::KCD::claimsdiscovery_auto::20241010::PRODHEADERVERSION'),
                    STD.File.FinishSuperFileTransaction()
      		);
    */            
   Actions := SEQUENTIAL( Iheader,doClearI);
   Actions;
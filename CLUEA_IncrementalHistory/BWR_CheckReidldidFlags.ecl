IMPORT did_add, delta_macro,CLUEAuto_InquiryHistory;	
  
  HdrFileVersion             := did_add.get_EnvVariable(CLUEAuto_InquiryHistory.Constants.iHEADER_PACKAGE_ENV_VARIABLE, CLUEAuto_InquiryHistory.Constants.iHEADER_ROXIE_VIP);
  OUTPUT(HdrFileVersion,named('HdrFileVersion'));
  ClueLexIDAppendVersion 		 := IF(fileservices.fileexists(CLUEAuto_InquiryHistory.Files.FILE_CLUE_INQHIST_BASE_HEADER_BUILD_VERSION), CLUEAuto_InquiryHistory.Files.DS_CLUE_INQHIST_BASE_HEADER_BUILD_VERSION()[1].CLUELexIDAppendVersion, 'NoVersion');
  OUTPUT(CLUEAuto_InquiryHistory.Files.FILE_CLUE_INQHIST_BASE_HEADER_BUILD_VERSION,named('HdrBuildfilenaName'));

  IsReadyForDidCorrections  		 :=  ClueLexIDAppendVersion <> HdrFileVersion;
	
	/*Check to see if ReIDL happens*/
	HdrFileVersionReIDL := did_add.get_EnvVariable(delta_macro.constants.iHEADER_PACKAGE_ENV_VARIABLE, delta_macro.constants.HEADER_ROXIE_VIP);
  OUTPUT(HdrFileVersionReIDL,named('HdrFileVersionReIDL'));
  DS_Delta_HEADER_BUILD_VERSION := DATASET(delta_macro.Files.Delta_PREFIX + '::clue_auto::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX,  delta_macro.layouts.IHDR_layouts, THOR, OPT);
  OUTPUT(delta_macro.Files.Delta_PREFIX + '::clue_auto::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX,named('Reidl_BuildfilenaName'));
  LexIDAppendVersion := DS_Delta_HEADER_BUILD_VERSION()[1].DeltaLexIDAppendVersion;
	IsReadyForReIDL := LexIDAppendVersion <> HdrFileVersionReIDL;
	ReIDLCheck := IsReadyForReIDL:independent;
  
  OUTPUT(IsReadyForDidCorrections, named('IsReadyForDidCorrections'));
  OUTPUT(ReIDLCheck, named('ReIDLCheck'));
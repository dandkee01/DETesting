IMPORT did_add,CLUEAuto_InquiryHistory, delta_macro;

/*Check to see if header variable has changed for LexID Corrections*/
	HdrFileVersion             := did_add.get_EnvVariable(CLUEAuto_InquiryHistory.Constants.iHEADER_PACKAGE_ENV_VARIABLE, CLUEAuto_InquiryHistory.Constants.iHEADER_ROXIE_VIP);
  OUTPUT(HdrFileVersion, named('HdrFileVersion'));	
  ClueLexIDAppendVersion 		 := IF(fileservices.fileexists(CLUEAuto_InquiryHistory.Files.FILE_CLUE_INQHIST_BASE_HEADER_BUILD_VERSION), CLUEAuto_InquiryHistory.Files.DS_CLUE_INQHIST_BASE_HEADER_BUILD_VERSION()[1].CLUELexIDAppendVersion, 'NoVersion');
  OUTPUT(ClueLexIDAppendVersion,named('ClueLexIDAppendVersion'));  
  OUTPUT(CLUEAuto_InquiryHistory.Files.FILE_CLUE_INQHIST_BASE_HEADER_BUILD_VERSION,named('ClueLexid_filename'));  
  IsReadyForDidCorrections  		 :=  ClueLexIDAppendVersion <> HdrFileVersion;
	OUTPUT(IsReadyForDidCorrections,named('IsReadyForDidCorrections'));
	/*Check to see if ReIDL happens*/
	HdrFileVersionReIDL := did_add.get_EnvVariable(delta_macro.constants.iHEADER_PACKAGE_ENV_VARIABLE, delta_macro.constants.HEADER_ROXIE_VIP);
  OUTPUT(HdrFileVersionReIDL, named('HdrFileVersionReIDL'));
  DS_Delta_HEADER_BUILD_VERSION := DATASET(delta_macro.Files.Delta_PREFIX + '::clue_auto::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX,  delta_macro.layouts.IHDR_layouts, THOR, OPT);
	LexIDAppendVersion := DS_Delta_HEADER_BUILD_VERSION()[1].DeltaLexIDAppendVersion;
  OUTPUT(LexIDAppendVersion, named('LexIDAppendVersion'));
  OUTPUT(delta_macro.Files.Delta_PREFIX + '::clue_auto::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX, named('LexIDAppendVersion_name'));
	IsReadyForReIDL := LexIDAppendVersion <> HdrFileVersionReIDL;
	ReIDLCheck := IsReadyForReIDL:independent;
  
  OUTPUT(ReIDLCheck,named('ReIDLCheck'));

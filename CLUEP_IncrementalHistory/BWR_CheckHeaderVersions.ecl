IMPORT did_add,CLUEProperty_InquiryHistory, delta_macro;

	/*Check to see if header variable has changed*/
	HdrFileVersion             := did_add.get_EnvVariable(CLUEProperty_InquiryHistory.Constants.iHEADER_PACKAGE_ENV_VARIABLE, CLUEProperty_InquiryHistory.Constants.iHEADER_ROXIE_VIP);
	ClueLexIDAppendVersion 		 := IF(fileservices.fileexists(CLUEProperty_InquiryHistory.Files.FILE_CLUP_INQHIST_BASE_HEADER_BUILD_VERSION),CLUEProperty_InquiryHistory.Files.DS_CLUP_INQHIST_BASE_HEADER_BUILD_VERSION()[1].CLUELexIDAppendVersion, 'NoVersion');
	IsReadyForDidCorrections  		 := ClueLexIDAppendVersion <> HdrFileVersion;
  OUTPUT(IsReadyForDidCorrections, named('IsReadyForDidCorrections'));
  OUTPUT(ClueLexIDAppendVersion, named('ClueLexIDAppendVersion'));
  OUTPUT(HdrFileVersion, named('HdrFileVersion'));
  OUTPUT( CLUEProperty_InquiryHistory.Files.FILE_CLUP_INQHIST_BASE_HEADER_BUILD_VERSION, named('LexidAppend_filename'));
	/*Check to see if ReIDL happens*/
	HdrFileVersionReIDL := did_add.get_EnvVariable(delta_macro.constants.iHEADER_PACKAGE_ENV_VARIABLE, delta_macro.constants.HEADER_ROXIE_VIP);
	DS_Delta_HEADER_BUILD_VERSION := DATASET(delta_macro.Files.Delta_PREFIX + '::clue_property::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX,  delta_macro.layouts.IHDR_layouts, THOR, OPT);
	LexIDAppendVersion := DS_Delta_HEADER_BUILD_VERSION()[1].DeltaLexIDAppendVersion;
	IsReadyForReIDL := LexIDAppendVersion <> HdrFileVersionReIDL;
	ReIDLCheck := IsReadyForReIDL;
  
  OUTPUT(ReIDLCheck, named('IsReadyForReIDL'));
  OUTPUT(LexIDAppendVersion, named('LexIDAppendVersion'));
  OUTPUT(HdrFileVersionReIDL, named('HdrFileVersionReIDL'));
  OUTPUT( delta_macro.Files.Delta_PREFIX + '::clue_property::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX, named('ReidlAppend_filename'));

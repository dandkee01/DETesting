IMPORT did_add, ClaimsDiscoveryAuto_InquiryHistory,CLUEAuto_InquiryHistory;
IMPORT delta_macro;

/* Check to see if header environment variable has changed */
	HdrFileVersion             := did_add.get_EnvVariable(CLUEAuto_InquiryHistory.Constants.iHEADER_PACKAGE_ENV_VARIABLE, CLUEAuto_InquiryHistory.Constants.iHEADER_ROXIE_VIP);
  OUTPUT(	HdrFileVersion,named('HdrFileVersion'));
  ClueLexIDAppendVersion 		 := IF(fileservices.fileexists(ClaimsDiscoveryAuto_InquiryHistory.Files.FILE_CD_INQHIST_BASE_HEADER_BUILD_VERSION), ClaimsDiscoveryAuto_InquiryHistory.Files.DS_CD_INQHIST_BASE_HEADER_BUILD_VERSION()[1].CLUELexIDAppendVersion, 'NoVersion');
  OUTPUT(	ClueLexIDAppendVersion,named('ClueLexIDAppendVersion'));
	
  IsReadyForDidCorrections  		 := ClueLexIDAppendVersion <> HdrFileVersion;
  OUTPUT(IsReadyForDidCorrections,named('IsReadyForDidCorrections'));
	
	/*Check to see if ReIDL happens*/
	HdrFileVersionReIDL := did_add.get_EnvVariable(delta_macro.constants.iHEADER_PACKAGE_ENV_VARIABLE, delta_macro.constants.HEADER_ROXIE_VIP);
  OUTPUT(HdrFileVersionReIDL,named('HdrFileVersionReIDL'));	
  DS_Delta_HEADER_BUILD_VERSION := DATASET(delta_macro.Files.Delta_PREFIX + '::claimsdiscovery_auto::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX,  delta_macro.layouts.IHDR_layouts, THOR, OPT);
	LexIDAppendVersion := DS_Delta_HEADER_BUILD_VERSION()[1].DeltaLexIDAppendVersion;
  OUTPUT(LexIDAppendVersion, named('LexIDAppendVersion'));
	IsReadyForReIDL := LexIDAppendVersion <> HdrFileVersionReIDL;
	ReIDLCheck := IsReadyForReIDL:independent;
  
  OUTPUT(ReIDLCheck,named('ReIDLCheck'));
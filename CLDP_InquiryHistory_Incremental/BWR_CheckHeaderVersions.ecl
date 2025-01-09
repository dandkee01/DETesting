IMPORT did_add,ClaimsDiscoveryProperty_InquiryHistory,CLUEProperty_InquiryHistory, delta_macro;

/*Check to see if header variable has changed for LexID Corrections*/
	HdrFileVersion             := did_add.get_EnvVariable(CLUEProperty_InquiryHistory.Constants.iHEADER_PACKAGE_ENV_VARIABLE, CLUEProperty_InquiryHistory.Constants.iHEADER_ROXIE_VIP);
  OUTPUT(HdrFileVersion, named('HdrFileVersion'));	
  ClueLexIDAppendVersion 		 := IF(fileservices.fileexists(ClaimsDiscoveryProperty_InquiryHistory.Files.FILE_CDSCP_INQHIST_BASE_HEADER_BUILD_VERSION), ClaimsDiscoveryProperty_InquiryHistory.Files.DS_CDSCP_INQHIST_BASE_HEADER_BUILD_VERSION()[1].CLUELexIDAppendVersion, 'NoVersion');
	OUTPUT(ClaimsDiscoveryProperty_InquiryHistory.Files.FILE_CDSCP_INQHIST_BASE_HEADER_BUILD_VERSION, named('ClueLexIDAppendVersion_Fname'));	
	OUTPUT(ClueLexIDAppendVersion, named('ClueLexIDAppendVersion'));	
  IsReadyForDidCorrections  		 := ClueLexIDAppendVersion <> HdrFileVersion;
  OUTPUT(IsReadyForDidCorrections, named('IsReadyForDidCorrections'));


	/*Check to see if ReIDL happens*/
	HdrFileVersionReIDL := did_add.get_EnvVariable(delta_macro.constants.iHEADER_PACKAGE_ENV_VARIABLE, delta_macro.constants.HEADER_ROXIE_VIP);
  OUTPUT(HdrFileVersionReIDL, named('HdrFileVersionReidl'));		
  DS_Delta_HEADER_BUILD_VERSION := DATASET(delta_macro.Files.Delta_PREFIX + '::claimsdiscovery_property::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX,  delta_macro.layouts.IHDR_layouts, THOR, OPT);
	LexIDAppendVersion := DS_Delta_HEADER_BUILD_VERSION()[1].DeltaLexIDAppendVersion;
  OUTPUT(delta_macro.Files.Delta_PREFIX + '::claimsdiscovery_property::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX, named('Reidl_LexIDAppendVersion_Fname'));	
	OUTPUT(LexIDAppendVersion, named('LexIDAppendVersion'));		
  IsReadyForReIDL := LexIDAppendVersion <> HdrFileVersionReIDL;
	ReIDLCheck := IsReadyForReIDL:independent;
  OUTPUT(ReIDLCheck, named('IsreadyforReidl'));



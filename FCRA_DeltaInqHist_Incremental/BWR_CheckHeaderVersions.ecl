IMPORT did_add, CLUEAuto_InquiryHistory, ClaimsDiscoveryAuto_InquiryHistory;
IMPORT Delta_Macro;  
  
  HdrFileVersion                 := did_add.get_EnvVariable(CLUEAuto_InquiryHistory.Constants.iHEADER_PACKAGE_ENV_VARIABLE, CLUEAuto_InquiryHistory.Constants.iHEADER_ROXIE_VIP);
  OUTPUT(HdrFileVersion, named('HdrFileVersion'));	
  ClueLexIDAppendVersion 		     := IF(fileservices.fileexists(ClaimsDiscoveryAuto_InquiryHistory.Files.FILE_CD_INQHIST_BASE_HEADER_BUILD_VERSION), ClaimsDiscoveryAuto_InquiryHistory.Files.DS_CD_INQHIST_BASE_HEADER_BUILD_VERSION()[1].CLUELexIDAppendVersion, 'NoVersion');
  OUTPUT(ClaimsDiscoveryAuto_InquiryHistory.Files.FILE_CD_INQHIST_BASE_HEADER_BUILD_VERSION, named('CLUELexidAppendVersion_Fname'));	
  OUTPUT(ClueLexIDAppendVersion, named('ClueLexIDAppendVersion'));	
  IsReadyForDidCorrections  		 := ClueLexIDAppendVersion <> HdrFileVersion;
  OUTPUT(IsReadyForDidCorrections,NAMED('IsReadyForDidCorrections'));
  
	/*Check to see if ReIDL happens*/
	HdrFileVersionReIDL := did_add.get_EnvVariable(Delta_Macro.constants.iHEADER_PACKAGE_ENV_VARIABLE, Delta_Macro.constants.HEADER_ROXIE_VIP);
  OUTPUT(HdrFileVersionReIDL, named('HdrFileVersionREIDL'));	
  DS_Delta_HEADER_BUILD_VERSION := DATASET(Delta_Macro.Files.Delta_PREFIX + '::claimsdiscovery_auto::QA::' + Delta_Macro.Files.HEADER_BUILD_VERSION_SUFFIX,  Delta_Macro.layouts.IHDR_layouts, THOR, OPT);
  OUTPUT(Delta_Macro.Files.Delta_PREFIX + '::claimsdiscovery_auto::QA::' + Delta_Macro.Files.HEADER_BUILD_VERSION_SUFFIX, named('LexidAppendVersion_Fname'));	
  OUTPUT(DS_Delta_HEADER_BUILD_VERSION, named('DS_Delta_HEADER_BUILD_VERSION'));	
	LexIDAppendVersion := DS_Delta_HEADER_BUILD_VERSION()[1].DeltaLexIDAppendVersion;
	IsReadyForReIDL    := LexIDAppendVersion <> HdrFileVersionReIDL;
	ReIDLCheck         := IsReadyForReIDL:independent;
  OUTPUT(ReIDLCheck,NAMED('ReIDLCheck'));

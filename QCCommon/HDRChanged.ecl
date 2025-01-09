IMPORT did_add,CLUEAuto_InquiryHistory, delta_macro;
IMPORT Std, ut;
	
	/*Check to see if header variable has changed for LexID Corrections*/
	HdrFileVersion             := did_add.get_EnvVariable(CLUEAuto_InquiryHistory.Constants.iHEADER_PACKAGE_ENV_VARIABLE, CLUEAuto_InquiryHistory.Constants.iHEADER_ROXIE_VIP);
	ClueLexIDAppendVersion 		 := IF(fileservices.fileexists(CLUEAuto_InquiryHistory.Files.FILE_CLUE_INQHIST_BASE_HEADER_BUILD_VERSION), CLUEAuto_InquiryHistory.Files.DS_CLUE_INQHIST_BASE_HEADER_BUILD_VERSION()[1].CLUELexIDAppendVersion, 'NoVersion');
  IsReadyForDidCorrections  		 := ClueLexIDAppendVersion <> HdrFileVersion;
  output(HdrFileVersion,named('HdrFileVersion'));
  output(ClueLexIDAppendVersion,named('ClueLexIDAppendVersion'));
  output(IsReadyForDidCorrections,named('IsReadyForDidCorrections'));
  
	/*Check to see if ReIDL happens*/
	HdrFileVersionReIDL := did_add.get_EnvVariable(delta_macro.constants.iHEADER_PACKAGE_ENV_VARIABLE, delta_macro.constants.HEADER_ROXIE_VIP);
  output(HdrFileVersionReIDL,named('HdrFileVersionReIDL'));
	DS_Delta_HEADER_BUILD_VERSION := DATASET(delta_macro.Files.Delta_PREFIX + '::clue_auto::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX,  delta_macro.layouts.IHDR_layouts, THOR, OPT);
	LexIDAppendVersion := DS_Delta_HEADER_BUILD_VERSION()[1].DeltaLexIDAppendVersion;
  output(LexIDAppendVersion,named('LexIDAppendVersion'));
	IsReadyForReIDL := LexIDAppendVersion <> HdrFileVersionReIDL;
  output(IsReadyForReIDL,named('IsReadyForReIDL'));
	ReIDLCheck := IsReadyForReIDL:independent;
  output(ReIDLCheck,named('ReIDLCheck'));

	pDate := (STRING8)Std.Date.Today();
	CheckFirstSunday_OR_ReIDL := ut.Weekday((integer)pDate) = 'SUNDAY' and (((string)pdate)[7..8] in ['01','02','03','04','05','06','07'] or ReIDLCheck);
	IsSunday := CheckFirstSunday_OR_ReIDL or IsReadyForDidCorrections:independent;
	
	
	
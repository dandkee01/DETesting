IMPORT Delta_Macro,ut,roxiekeybuild, did_add,CLUEAuto_InquiryHistory,ClaimsDiscoveryAuto_InquiryHistory;
/*
//DS_Delta_BASE_HEADER_BUILD_VERSION:= dataset('~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::prodheaderversion',delta_macro.layouts.IHDR_layouts, THOR, OPT);
DS_Delta_BASE_HEADER_BUILD_VERSION:= dataset('~thor::base::claimsdiscoveryauto::qa::inqhist::prodheaderversion',delta_macro.layouts.IHDR_layouts, THOR, OPT);
OUTPUT(DS_Delta_BASE_HEADER_BUILD_VERSION);

RECORDOF(DS_Delta_BASE_HEADER_BUILD_VERSION) ChanVer(DS_Delta_BASE_HEADER_BUILD_VERSION l) := TRANSFORM
  SELF.deltalexidappendversion := '20230217i';
  SELF := l;
END;
ChangedRecs := PROJECT(DS_Delta_BASE_HEADER_BUILD_VERSION, ChanVer(LEFT));
startDate := (integer)ut.getdate;
//roxiekeybuild.Mac_SF_BuildProcess_V2(ChangedRecs, '~thor::base::claimsdiscoveryauto::kcd', 'inqhist::prodheaderversion', startDate, NewDeltaBaseHdrBuildVersion, 3, FALSE);
roxiekeybuild.Mac_SF_BuildProcess_V2(ChangedRecs, '~thor::base::claimsdiscoveryauto', 'inqhist::prodheaderversion', startDate, NewDeltaBaseHdrBuildVersion, 3, FALSE);
NewDeltaBaseHdrBuildVersion;
*/

HdrFileVersion             := did_add.get_EnvVariable(CLUEAuto_InquiryHistory.Constants.iHEADER_PACKAGE_ENV_VARIABLE, CLUEAuto_InquiryHistory.Constants.iHEADER_ROXIE_VIP);
ClueLexIDAppendVersion 		 := IF(fileservices.fileexists(ClaimsDiscoveryAuto_InquiryHistory.Files.FILE_CD_INQHIST_BASE_HEADER_BUILD_VERSION), ClaimsDiscoveryAuto_InquiryHistory.Files.DS_CD_INQHIST_BASE_HEADER_BUILD_VERSION()[1].CLUELexIDAppendVersion, 'NoVersion');
IsReadyForDidCorrections  		 := ClueLexIDAppendVersion <> HdrFileVersion;
OUTPUT(IsReadyForDidCorrections);
	
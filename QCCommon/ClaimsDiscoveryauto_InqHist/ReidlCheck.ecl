IMPORT did_add, delta_macro, ut, roxiekeybuild;  
  
  HdrFileVersionReIDL := did_add.get_EnvVariable(delta_macro.constants.iHEADER_PACKAGE_ENV_VARIABLE, delta_macro.constants.HEADER_ROXIE_VIP);
	DS_Delta_HEADER_BUILD_VERSION := DATASET(Insurance.delta_macro.Files.Delta_PREFIX + '::claimsdiscovery_auto::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX,  delta_macro.layouts.IHDR_layouts, THOR, OPT);
  DS_Delta_HEADER_BUILD_VERSION; 
/*	
  RECORDOF(DS_Delta_HEADER_BUILD_VERSION) ChanVer(DS_Delta_HEADER_BUILD_VERSION l) := TRANSFORM
  SELF.deltalexidappendversion := '20230217i';
  SELF := l;
END;
ChangedRecs := PROJECT(DS_Delta_HEADER_BUILD_VERSION, ChanVer(LEFT));
startDate := (integer)ut.getdate;
//roxiekeybuild.Mac_SF_BuildProcess_V2(ChangedRecs, '~thor::base::claimsdiscoveryauto::kcd', 'inqhist::prodheaderversion', startDate, NewDeltaBaseHdrBuildVersion, 3, FALSE);
roxiekeybuild.Mac_SF_BuildProcess_V2(ChangedRecs, '~thor::base::deltamacro::claimsdiscovery_auto', 'prodheaderversion', startDate, NewDeltaBaseHdrBuildVersion, 3, FALSE);
NewDeltaBaseHdrBuildVersion;

//~thor::base::deltamacro::claimsdiscovery_auto::qa::prodheaderversion
*/  
LexIDAppendVersion := DS_Delta_HEADER_BUILD_VERSION()[1].DeltaLexIDAppendVersion;
IsReadyForReIDL := LexIDAppendVersion <> HdrFileVersionReIDL;
ReIDLCheck := IsReadyForReIDL;
OUTPUT(ReIDLCheck,named('ReIDLCheck'));
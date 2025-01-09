IMPORT Delta_Macro,ut,roxiekeybuild;

DS_Delta_BASE_HEADER_BUILD_VERSION:= dataset(Delta_Macro.Files.delta_prefix +'::'+trim('clue_auto',all)+'::qa::'+ Delta_Macro.Files.HEADER_BUILD_VERSION_SUFFIX,delta_macro.layouts.IHDR_layouts, THOR, OPT);
OUTPUT(DS_Delta_BASE_HEADER_BUILD_VERSION);

RECORDOF(DS_Delta_BASE_HEADER_BUILD_VERSION) ChanVer(DS_Delta_BASE_HEADER_BUILD_VERSION l) := TRANSFORM
  SELF.deltalexidappendversion := '20230217i';
  SELF := l;
END;
ChangedRecs := PROJECT(DS_Delta_BASE_HEADER_BUILD_VERSION, ChanVer(LEFT));
startDate := (integer)ut.getdate;
roxiekeybuild.Mac_SF_BuildProcess_V2(ChangedRecs, delta_macro.files.Delta_PREFIX +'::'+trim('clue_auto',all), delta_macro.files.HEADER_BUILD_VERSION_SUFFIX, startDate, NewDeltaBaseHdrBuildVersion, 3, FALSE);
NewDeltaBaseHdrBuildVersion;

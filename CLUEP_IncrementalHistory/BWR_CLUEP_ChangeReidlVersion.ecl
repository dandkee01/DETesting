#WORKUNIT('priority','high');
#WORKUNIT('priority',10); 
#WORKUNIT('name','Change Hearder Versions For Reidl Corrections'); 

IMPORT did_add,delta_macro, STD; 
	
	/*Check to see if ReIDL happens*/
	HdrFileVersionReIDL := did_add.get_EnvVariable(delta_macro.constants.iHEADER_PACKAGE_ENV_VARIABLE, delta_macro.constants.HEADER_ROXIE_VIP);
	DS_Delta_HEADER_BUILD_VERSION := DATASET(delta_macro.Files.Delta_PREFIX + '::clue_property::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX,  delta_macro.layouts.IHDR_layouts, THOR, OPT);
	ReidlAppendVersion := DS_Delta_HEADER_BUILD_VERSION()[1].deltalexidappendversion;
	IsReadyForReIDL := ReidlAppendVersion <> HdrFileVersionReIDL;
	ReIDLCheck := IsReadyForReIDL;
  
  OUTPUT(ReIDLCheck, named('IsReadyForReIDL'));
  OUTPUT(ReidlAppendVersion, named('ReidlAppendVersion'));
  OUTPUT(HdrFileVersionReIDL, named('HdrFileVersionReIDL'));
  OUTPUT( delta_macro.Files.Delta_PREFIX + '::clue_property::QA::' + delta_macro.Files.HEADER_BUILD_VERSION_SUFFIX, named('ReidlAppend_filename'));
		
    //ReidlVerChged :=  PROJECT(DS_Delta_HEADER_BUILD_VERSION,TRANSFORM(RECORDOF(DS_Delta_HEADER_BUILD_VERSION),SELF.deltalexidappendversion := '20240812',SELF :=LEFT));
    ReidlVerChged :=  PROJECT(DS_Delta_HEADER_BUILD_VERSION,TRANSFORM(RECORDOF(DS_Delta_HEADER_BUILD_VERSION),SELF.deltalexidappendversion := '20240712',SELF :=LEFT));
   
    Iheader := OUTPUT(ReidlVerChged,, '~thor::base::deltamacro::clue_property::20241113kcd::prodheaderversion', overwrite, __compressed__, named('ReidlVersion'));
   
   doClearI   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    IF(~STD.File.SuperFileExists('~thor::base::deltamacro::clue_property::qa::prodheaderversion'),STD.File.CreateSuperFile('~thor::base::deltamacro::clue_property::qa::prodheaderversion',,1));
                    STD.File.ClearSuperFile('~thor::base::deltamacro::clue_property::qa::prodheaderversion'),
                    STD.File.AddSuperFile('~thor::base::deltamacro::clue_property::qa::prodheaderversion','~thor::base::deltamacro::clue_property::20241113kcd::prodheaderversion'),
                    STD.File.FinishSuperFileTransaction()
      		);
          
   Actions := SEQUENTIAL( Iheader,doClearI);
   Actions;
   
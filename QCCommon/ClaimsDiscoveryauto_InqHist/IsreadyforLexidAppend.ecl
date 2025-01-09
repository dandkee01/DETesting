IMPORT did_add,delta_macro;  
  Case1 := did_add.get_EnvVariable(delta_macro.constants.iHEADER_PACKAGE_ENV_VARIABLE, delta_macro.constants.HEADER_ROXIE_VIP);
	 
  DS_Delta_BASE_HEADER_BUILD_VERSION:= dataset(Delta_Macro.Files.delta_prefix +'::'+trim('claimsdiscovery_auto',all)+'::qa::'+ Delta_Macro.Files.HEADER_BUILD_VERSION_SUFFIX,delta_macro.layouts.IHDR_layouts, THOR, OPT);
	
	CDSCLexIDAppendVersion := DS_Delta_BASE_HEADER_BUILD_VERSION()[1].DeltaLexIDAppendVersion;
	
	isReadyForLexIDAppend  := CDSCLexIDAppendVersion <> Case1 and true;	
  output( isReadyForLexIDAppend,named('isReadyForLexIDAppend'));
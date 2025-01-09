IMPORT ut,did_add;

EXPORT Update_Files(pDataset,field1='',Have_did = FALSE,product = '',IHDRreidl='',PREFIX_NAME='',SUFFIX_NAME='',Adhoc_job = FALSE) := functionmacro
﻿﻿IMPORT ut,did_add, delta_macro, RoxieKeyBuild;

  //startDate := (integer)ut.getdate;
  startDate := 20230430;
	
	Case1 := did_add.get_EnvVariable(delta_macro.constants.iHEADER_PACKAGE_ENV_VARIABLE, delta_macro.constants.HEADER_ROXIE_VIP);
	 
  DS_Delta_BASE_HEADER_BUILD_VERSION:= dataset(Delta_Macro.Files.delta_prefix +'::'+trim(product,all)+'::qa::'+ Delta_Macro.Files.HEADER_BUILD_VERSION_SUFFIX,delta_macro.layouts.IHDR_layouts, THOR, OPT);
	
	CDSCLexIDAppendVersion := DS_Delta_BASE_HEADER_BUILD_VERSION()[1].DeltaLexIDAppendVersion;
	
	isReadyForLexIDAppend  := CDSCLexIDAppendVersion <> Case1 and Have_did;	
  output( isReadyForLexIDAppend,named('isReadyForLexIDAppend'));
	
	DSDELTABaseHdrBuildVersion := DATASET([{case1}], delta_macro.layouts.IHDR_Layouts);
	
	roxiekeybuild.Mac_SF_BuildProcess_V2(DSDELTABaseHdrBuildVersion, delta_macro.files.Delta_PREFIX +'::'+trim(product,all), delta_macro.files.HEADER_BUILD_VERSION_SUFFIX, startDate, NewDeltaBaseHdrBuildVersion, 3, FALSE);
	
	
  Case3 := ut.Weekday(startDate) = 'SUNDAY' and ((string)startdate)[7..8] in ['01','02','03','04','05','06','07'];

	//Case3 := STD.Date.MonthWeekNumFromDate(startDate,2) in [1,2] and ut.Weekday(startDate) = 'SUNDAY';
	
//every sunday append all files
  add_on_sunday:= pDataset;
	

//monthly updates and insurance headers 
	//Iheader_changed := dedup(sort(pDataset,field1,field2,-dt_effective_first,-dt_effective_last,delta_ind),field1,field2,keep(1));
		Iheader_changed := dedup(sort(pDataset,#expand(field1),-dt_effective_first,dt_effective_last,delta_ind),#expand(field1),keep(1));

	//filtering out delta indicator 3

	filterout := Iheader_changed(delta_ind != 3);
	defaulting_fields := PROJECT(filterout,transform(recordof(filterout),self.dt_effective_first:= 0,
	                                                                    self.dt_effective_last:= 0,
																																	    self.delta_ind:= 1,
																																			self:= left));

	
	//Reidl process
	Reidl := #expand(IHDRreidl)(defaulting_fields);
	             
	
	result := if(isReadyForLexIDAppend and ut.Weekday((integer)startDate) = 'SUNDAY' ,reidl,defaulting_fields);
	              //case2 => add_on_sunday,
								//case3 => filterout,
								//add_on_sunday
								//);
	
			
	RoxieKeyBuild.Mac_SF_BuildProcess_V2(result,
																			 PREFIX_NAME, 
																			 SUFFIX_NAME, 
																			 startDate,results, 3,,,true);	
																			 
	RoxieKeyBuild.Mac_SF_BuildProcess_V2(add_on_sunday,
																			 PREFIX_NAME, 
																			 SUFFIX_NAME, 
																			 startDate,adhoc_Run, 3,,,true);	
																			 
	Final_Results := if(Adhoc_job = TRUE ,add_on_sunday,result);
	                            //if(isReadyForLexIDAppend,NewDeltaBaseHdrBuildVersion));
	
//Final_Results := if(Adhoc_job = TRUE ,adhoc_Run,results);

return   Final_Results ;

endmacro;
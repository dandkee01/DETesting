IMPORT ClaimsDiscoveryAuto_InquiryHistory,_Control, ClaimsDiscoveryAuto_Delta, STD;
IMPORT RoxieKeyBuild;

STRING Dest_Cluster := Thorlib.group();
Date := STD.Date.CurrentDate();
//time := STD.Date.CurrentTime(True);
filedate := Date;

sprayDeltaSubject := FileServices.SprayVariable(
																					_Control.IPAddress.unixland,  	// landing zone 
																					'/data/orbittesting/deltaclue/process/dandke01/CLDA/'+'delta_key_subject*', 	// input file
																					2000048,                                       										// max rec
																					'\t',                                          										// field sep
																					,                                              										// rec sep (use default)
																					,                                              										// quote
																					Dest_Cluster,                         														// destination group
																					'~thor::base::CLDA::KCDsprayed::delta_key_subject',   	          // destination logical name
																					-1,                                            										// time
																					ClaimsDiscoveryAuto_InquiryHistory.Constants.EspPortIp,          	// esp server IP port
																					,                                              										// max connections
																					TRUE,                                          										// overwrite
																					FALSE,                                         										// replicate
																					TRUE );                                         									// compress
                                          
sprayDeltaClaim := FileServices.SprayVariable(
																					_Control.IPAddress.unixland,		// landing zone 
																					'/data/orbittesting/deltaclue/process/dandke01/CLDA/'+'delta_claim*', 				// input file
																					2000048,                                       										// max rec
																					'\t',                                          										// field sep
																					,                                              										// rec sep (use default)
																					,                                              										// quote
																					Dest_Cluster,                         														// destination group
																					'~thor::base::CLDA::KCDsprayed::delta_claim',    	// destination logical name
																					-1,                                            										// time
																					ClaimsDiscoveryAuto_InquiryHistory.Constants.EspPortIp,          	// esp server IP port
																					,                                              										// max connections
																					TRUE,                                          										// overwrite
																					FALSE,                                         										// replicate
																					TRUE );                                         									// compress   
                                          
//Delta_Subject := ClaimsDiscoveryAuto_Delta.ReadSubjectFile(ClaimsDiscoveryAuto_InquiryHistory.Files.DeltaSubject_Sprayed_DS);
Delta_Subject := DATASET ('~thor::base::CLDA::KCDsprayed::delta_key_subject',ClaimsDiscoveryAuto_Delta.Layouts.Delta_Subject,CSV(SEPARATOR('\t'),TERMINATOR(['\n','\r\n','\n\r'])));

//Delta_Claim := ClaimsDiscoveryAuto_Delta.ReadClaimFile(ClaimsDiscoveryAuto_InquiryHistory.Files.DeltaClaim_Sprayed_DS); 
Delta_Claim := DATASET ('~thor::base::CLDA::KCDsprayed::delta_claim',ClaimsDiscoveryAuto_Delta.Layouts.Delta_Claim,CSV(SEPARATOR('\t'),TERMINATOR(['\n','\r\n','\n\r']),MAXLENGTH(2000048)));                                         

//output(Delta_Subject,ClaimsDiscoveryAuto_Delta.Layouts.Delta_Subject,'~thor::base::CLDA::KCDInput::delta_key_subject',COMPRESSED,OVERWRITE);
//output(delta_claim,ClaimsDiscoveryAuto_Delta.Layouts.Delta_Claim,'~thor::base::CLDA::KCDInput::delta_claim',COMPRESSED,OVERWRITE);

RoxieKeyBuild.Mac_SF_BuildProcess_V2(Delta_Subject,
																			 '~THOR::BASE::CLDA::kcd::TestData', 
																			 'delta_key_subject', 
																			 fileDate,DeltaSubj, 3,,,true);	
	
RoxieKeyBuild.Mac_SF_BuildProcess_V2(Delta_Claim,
																			 '~THOR::BASE::CLDA::kcd::TestData', 
																			 'delta_claim', 
																			 fileDate,DeltaClaim, 3,,,true);	
                                       
//DeltaSubDS   := DATASET('~THOR::BASE::CLDA::kcd::TestData::QA::delta_key_subject',ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject,thor);
DeltaSubDS   := DATASET('~THOR::BASE::CLDA::kcd::TestData::QA::delta_key_subject',ClaimsDiscoveryAuto_Delta.Layouts.Delta_Subject,thor);
//DeltaClaimDS := DATASET('~THOR::BASE::CLDA::kcd::TestData::QA::delta_claim',ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim,thor);
DeltaClaimDS := DATASET('~THOR::BASE::CLDA::kcd::TestData::QA::delta_claim',ClaimsDiscoveryAuto_Delta.Layouts.Delta_Claim,thor);
OutSubDs   := output(DeltaSubDS);
OutClaimDs := OUTPUT(DeltaClaimDS);

SEQUENTIAL( sprayDeltaSubject,sprayDeltaClaim,DeltaSubj,DeltaClaim,OutSubDs,OutClaimDs);                                      
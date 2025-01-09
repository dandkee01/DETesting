IMPORT STD,_Control,RoxieKeyBuild;
IMPORT CLUEAuto_InquiryHistory, CLUEAuto_Delta;


DeltaFile := '~thor::base::clua::sprayed::kcd::deltaClaim';
fileDate := STD.Date.CurrentDate();
sprayDeltaClaim := FileServices.SprayVariable(
																					_Control.IPAddress.unixland,  	// landing zone 
																					'/data/orbittesting/deltaclue/process/dandke01/process/' + 'deltaclaim_NV.txt', 	// input file
																					2000048,                                       				// max rec
																					'\t',                                          				// field sep
																					,                                              				// rec sep (use default)
																					,                                              				// quote
																					Thorlib.group(),                         								// destination group
																					DeltaFile,   // destination logical name
																					-1,                                            				// time
																					CLUEAuto_InquiryHistory.Constants.EspPortIp,          // esp server IP port
																					,                                              				// max connections
																					TRUE,                                          				// overwrite
																					FALSE,                                         				// replicate
																					TRUE );                                         			// compress
sprayDeltaClaim;

deltaClaimSprayDS := DATASET (DeltaFile,CLUEAuto_Delta.Layouts.Delta_Claim,CSV(SEPARATOR('\t'),TERMINATOR(['\n','\r\n','\n\r']),QUOTE('"'),MAXLENGTH(2000048)));
RoxieKeyBuild.Mac_SF_BuildProcess_V2(deltaClaimSprayDS,
																			 '~THOR::BASE::CLUEA::kcd::TestData', 
																			 'deltaclaim', 
																			 fileDate,DeltaSubj, 3,,,true);
DeltaSubj;                                       

//thor::base::cluea::kcd::testdata::qa::deltaclaim superfile name format

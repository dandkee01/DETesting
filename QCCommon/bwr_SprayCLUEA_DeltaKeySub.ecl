IMPORT STD,_Control,RoxieKeyBuild;
IMPORT CLUEAuto_InquiryHistory, CLUEAuto_Delta;


DeltaFile := '~thor::base::clua::sprayed::kcd::deltakeysub';
fileDate := STD.Date.CurrentDate();
sprayDeltaSubject := FileServices.SprayVariable(
																					_Control.IPAddress.unixland,  	// landing zone 
																					'/data/orbittesting/deltaclue/process/dandke01/process/' + 'detlakeysubj_NV.txt', 	// input file
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
//sprayDeltaSubject;
deltasubSprayDS := DATASET(DeltaFile,CLUEAuto_Delta.Layouts.Delta_Subject,CSV(SEPARATOR('\t'),TERMINATOR(['\n','\r\n','\n\r']),QUOTE('"')));
RoxieKeyBuild.Mac_SF_BuildProcess_V2(deltasubSprayDS,
																			 '~THOR::BASE::CLUEA::kcd::TestData', 
																			 'deltakeysubject', 
																			 fileDate,DeltaSubj, 3,,,true);
//DeltaSubj;                                       

//thor::base::cluea::kcd::testdata::qa::deltakeysubject superfile name format


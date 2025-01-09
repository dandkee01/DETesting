IMPORT ut, std, RoxieKeyBuild, _Control, ClaimsDiscoveryAuto_InquiryHistory, CLUEAuto_Delta, did_add;

EXPORT DidCorrections(fileDate=(STRING8)Std.Date.Today(),field1='') := FUNCTIONMACRO
IMPORT ClaimsDiscoveryAuto_InquiryHistory,STD,ut,RoxieKeyBuild;
	createFiles := ClaimsDiscoveryAuto_InquiryHistory.SuperFiles.createHdrVersionFile;

	Iheader_changed0 := dedup(sort(ClaimsDiscoveryAuto_InquiryHistory.Files.InqSubj_DS,#expand(field1),-dt_effective_first,dt_effective_last,delta_ind),#expand(field1),keep(1));

//**********************************************************************************************************************************************************
RECORDOF(Iheader_changed0) ChangeDid(Iheader_changed0 l) := TRANSFORM
  //SELF.did := (INTEGER)INTFORMAT(l.did,5,1);
  SELF.did := (INTEGER)STD.Str.Reverse((STRING)l.did);
  SELF := l;
END;
Iheader_changed := PROJECT(Iheader_changed0, ChangeDid(LEFT));
//OUTPUT(Iheader_changed,named('Iheader_changed'));
//OUTPUT(Iheader_changed((INTEGER)TRIM((STRING)did,left,right)<>0),named('Iheader_changeddidNo0'));
//********************************************************************************************************************************************************

	//filtering out delta indicator 3
	filterout := Iheader_changed(delta_ind != 3);
	defaulting_fields := PROJECT(filterout,transform(recordof(filterout),self.dt_effective_first:= 0,
	                                                                    self.dt_effective_last:= 0,
																																	    self.delta_ind:= 1,
																																			self:= left));
	/*Corrections DID Append*/
	SubjectLexIDCorrFile			 := ClaimsDiscoveryAuto_InquiryHistory.AppendDIDCorrections(defaulting_fields,fileDate,ClaimsDiscoveryAuto_InquiryHistory.Files.CD_Prefix,ClaimsDiscoveryAuto_InquiryHistory.Files.Header_Build_Version_Suffix).AppendDID;
	
	/*Add Subject file to super file */
	RoxieKeyBuild.Mac_SF_BuildProcess_V2(SubjectLexIDCorrFile,
																			 ClaimsDiscoveryAuto_InquiryHistory.Files.CD_Prefix, 
																		   ClaimsDiscoveryAuto_InquiryHistory.Files.InqSubj_Suffix, 
																			 fileDate,SubjectIHCorr, 3,,,true);
																		 
	RETURN SubjectLexIDCorrFile;
	
ENDMACRO;

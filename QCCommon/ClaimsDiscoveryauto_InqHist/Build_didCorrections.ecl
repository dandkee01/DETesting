IMPORT ut,Delta_Macro, QCCommon;

SubjectLexIDCorrFile := QCCommon.ClaimsDiscoveryauto_InqHist.DidCorrections(ut.GetDate,Delta_Macro.constants.ClaimsDiscovery_Auto_subject_fields);
SubjectLexIDCorrFile;
Iheader_changed0 := dedup(sort(ClaimsDiscoveryAuto_InquiryHistory.Files.InqSubj_Father_DS,#expand(Delta_Macro.constants.ClaimsDiscovery_Auto_subject_fields),-dt_effective_first,dt_effective_last,delta_ind),#expand(Delta_Macro.constants.ClaimsDiscovery_Auto_subject_fields),keep(1));

RECORDOF(Iheader_changed0) ChangeDid(Iheader_changed0 l) := TRANSFORM
  //SELF.did := (INTEGER)INTFORMAT(l.did,5,1);
  SELF.did := (INTEGER)STD.Str.Reverse((STRING)l.did);
  SELF := l;
END;
Iheader_changed := PROJECT(Iheader_changed0, ChangeDid(LEFT));
OUTPUT(Iheader_changed,named('Iheader_changed'));
OUTPUT(Iheader_changed((INTEGER)TRIM((STRING)did,left,right)<>0),named('Iheader_changeddidNo0'));
filterout := Iheader_changed(delta_ind != 3);
defaulting_fields := PROJECT(filterout,transform(recordof(filterout),self.dt_effective_first:= 0,
	                                                                    self.dt_effective_last:= 0,
																																	    self.delta_ind:= 1,
																																			self:= left));

Rec := Record
typeof(defaulting_fields.reference_no) reference_noL;
typeof(defaulting_fields.reference_no) reference_noR;
typeof(defaulting_fields.unit_no) unit_noL;
typeof(defaulting_fields.unit_no) unit_noR;
typeof(defaulting_fields.transaction_id) transaction_idL;
typeof(defaulting_fields.transaction_id) transaction_idR;
typeof(defaulting_fields.did) didL;
typeof(defaulting_fields.did) didR;
END;

Rec doHalfJoin(defaulting_fields l,SubjectLexIDCorrFile r) := TRANSFORM
  SELF.reference_noL := l.reference_no;
  SELF.unit_noL      := l.unit_no;
  SELF.transaction_idL := l.transaction_id;
  SELF.didL            := l.did;
  SELF.reference_noR   := r.reference_no;
  SELF.unit_noR        := r.unit_no;
  SELF.transaction_idR := r.transaction_id;
  SELF.didR := r.did;
END;
joinedrecs := JOIN(defaulting_fields, SubjectLexIDCorrFile,
                    LEFT.reference_no=RIGHT.reference_no and
                    LEFT.unit_no=RIGHT.unit_no and
                    LEFT.transaction_id=RIGHT.transaction_id,doHalfJoin(LEFT,RIGHT));
                    //LEFT.did<>RIGHT.did,doHalfJoin(LEFT,RIGHT));
joinedrecs;  

OUTPUT(COUNT(defaulting_fields),named('defaulting_fieldsCnt'));                  
OUTPUT(COUNT(joinedrecs),named('joinedrecsCnt'));                  

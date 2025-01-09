IMPORT ClaimsDiscoveryAuto_InquiryHistory;

BaseSubjqa   := DATASET('~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::subject',ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject,THOR);
OUTPUT(BaseSubjqa(reference_no='23085000200058'),named('BaseSubjqa'));

BaseSubjfa   := DATASET('~thor::base::claimsdiscoveryauto::kcd::father::inqhist::subject',ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject,THOR);
OUTPUT(BaseSubjfa(reference_no='23085000200058'),named('BaseSubjfa'));// delta_ind=1 record.
BaseSubjgf   := DATASET('~thor::base::claimsdiscoveryauto::kcd::grandfather::inqhist::subject',ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject,THOR);

Delta3DS := dedup(sort(BaseSubjfa,reference_no),reference_no)(delta_ind=3);
//OUTPUT(,named('BaseSubjfadel3'));// delta_ind=1 record.

rec1 := RECORD
  TYPEOF(BaseSubjqa.reference_no) reference_no;
  TYPEOF(BaseSubjqa.transaction_id) transaction_id;
  TYPEOF(BaseSubjqa.process_date) process_date;
  TYPEOF(BaseSubjqa.lname) lname;
  TYPEOF(BaseSubjqa.fname) fname;
  TYPEOF(BaseSubjqa.mname) mname;
  TYPEOF(BaseSubjqa.source_rid) source_rid;
  TYPEOF(BaseSubjqa.did) didqa;
  TYPEOF(BaseSubjqa.did) didFa;
  TYPEOF(BaseSubjqa.delta_ind) deltaQA;
  TYPEOF(BaseSubjqa.delta_ind) deltaFA;
  TYPEOF(BaseSubjqa.dt_effective_first) dateQA;
  TYPEOF(BaseSubjqa.dt_effective_last) dateFA;
END;

rec1 doJoin(BaseSubjfa l,BaseSubjqa r) := TRANSFORM
  SELF.didqa:= r.did;
  SELF.didFa:= l.did;
  SELF.deltaQA:= r.delta_ind;
  SELF.deltaFA:= l.delta_ind;
  SELF.dateQA:= r.dt_effective_first;
  SELF.dateFA:= l.dt_effective_first;
  SELF := l;
END;
join1 := JOIN(BaseSubjfa, BaseSubjqa,
                    LEFT.reference_no=RIGHT.reference_no and
                    LEFT.transaction_id=RIGHT.transaction_id and
                    LEFT.process_date=RIGHT.process_date and
                    LEFT.lname=RIGHT.lname and
                    LEFT.fname=RIGHT.fname and
                    LEFT.mname=RIGHT.mname and
                    LEFT.source_rid=RIGHT.source_rid and LEFT.did<>RIGHT.did,doJoin(LEFT,RIGHT));
OUTPUT(join1,named('join1'));

join2:= JOIN(BaseSubjfa, BaseSubjqa,
                    LEFT.reference_no=RIGHT.reference_no and
                    LEFT.transaction_id=RIGHT.transaction_id and
                    LEFT.process_date=RIGHT.process_date and
                    LEFT.lname=RIGHT.lname and
                    LEFT.fname=RIGHT.fname and
                    LEFT.mname=RIGHT.mname and
                    LEFT.source_rid=RIGHT.source_rid and LEFT.did=RIGHT.did,doJoin(LEFT,RIGHT));
OUTPUT(join2,named('join2'));

join3:= JOIN(BaseSubjfa, BaseSubjqa,
                    LEFT.reference_no=RIGHT.reference_no and
                    LEFT.transaction_id=RIGHT.transaction_id and
                    LEFT.process_date=RIGHT.process_date and
                    LEFT.lname=RIGHT.lname and
                    LEFT.fname=RIGHT.fname and
                    LEFT.mname=RIGHT.mname and
                    LEFT.source_rid<>RIGHT.source_rid and LEFT.did=RIGHT.did,doJoin(LEFT,RIGHT));
OUTPUT(join3,named('join3'));
OUTPUT(BaseSubjqa(reference_no='23085000800953'),named('BaseSubjqa953'));

join4:= JOIN(BaseSubjfa, BaseSubjqa,
                    LEFT.reference_no=RIGHT.reference_no and
                    LEFT.transaction_id=RIGHT.transaction_id and
                    LEFT.process_date=RIGHT.process_date and
                    LEFT.lname=RIGHT.lname and
                    LEFT.fname=RIGHT.fname and
                    LEFT.mname=RIGHT.mname and
                    //LEFT.source_rid<>RIGHT.source_rid and LEFT.did<>RIGHT.did,doJoin(LEFT,RIGHT));
                    LEFT.source_rid=RIGHT.source_rid and LEFT.did<>RIGHT.did,doJoin(LEFT,RIGHT));
OUTPUT(join4,named('join4')); 

join5:= JOIN(BaseSubjfa, BaseSubjqa,
                    LEFT.reference_no=RIGHT.reference_no and
                    LEFT.transaction_id=RIGHT.transaction_id, doJoin(LEFT,RIGHT));
                    // LEFT.process_date=RIGHT.process_date and
                    // LEFT.lname=RIGHT.lname and
                    // LEFT.fname=RIGHT.fname and
                    // LEFT.mname=RIGHT.mname and
                    //LEFT.source_rid<>RIGHT.source_rid and LEFT.did<>RIGHT.did,doJoin(LEFT,RIGHT));
                    //*LEFT.source_rid=RIGHT.source_rid and*/ LEFT.did IN[1,2,3],doJoin(LEFT,RIGHT));
OUTPUT(join5,named('join5'));
OUTPUT(join5(deltafa IN [2,3]),named('deltafa23'));


rec1 doJoin2(BaseSubjfa l,BaseSubjgf r) := TRANSFORM
  SELF.didqa:= r.did;
  SELF.didFa:= l.did;
  SELF.deltaQA:= r.delta_ind;
  SELF.deltaFA:= l.delta_ind;
  SELF.dateQA:= r.dt_effective_first;
  SELF.dateFA:= l.dt_effective_first;
  SELF := l;
END;
join6:= JOIN(BaseSubjfa, BaseSubjgf,
                    LEFT.reference_no=RIGHT.reference_no and
                    LEFT.transaction_id<>RIGHT.transaction_id, doJoin2(LEFT,RIGHT));
join6;
OUTPUT(join6(deltafa IN [2,3]),named('join6delta23'));

COUNT(BaseSubjqa);
COUNT(DEDUP(BaseSubjqa));

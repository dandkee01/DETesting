IMPORT ClaimsDiscoveryAuto_InquiryHistory;

BaseClaimqa := DATASET('~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::claim', ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim, thor);                                     
BaseClaimfa := DATASET('~thor::base::claimsdiscoveryauto::kcd::father::inqhist::claim', ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim, thor);                                     
BaseClaimgf := DATASET('~thor::base::claimsdiscoveryauto::kcd::grandfather::inqhist::claim', ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim, thor);                                     

//*******************************************************************************************************************************************************

BaseClaimdailyQa := DATASET('~thor::base::claimsdiscoveryauto::kcd::qa::daily::inqhist::claim', ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim, thor);                                     
BaseClaimdailyFa := DATASET('~thor::base::claimsdiscoveryauto::kcd::father::daily::inqhist::claim', ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim, thor);                                     
ClaimFaDailyFa := BaseClaimfa+BaseClaimdailyFa;
SrtedClaimFaDailyFa := Sort(ClaimFaDailyFa,Reference_No, Unit_No, Claim_No,  -dt_effective_first, dt_effective_last, Delta_ind);
OUTPUT(SrtedClaimFaDailyFa,named('SrtedClaimFaDailyFa'));
OUTPUT(BaseClaimqa,named('BaseClaimqa'));
OUTPUT(BaseClaimdailyFa,named('BaseClaimdailyFa'));


rec1 := RECORD
  TYPEOF(BaseClaimqa.reference_no) reference_noL;
  TYPEOF(BaseClaimqa.unit_no) unit_noL;
  TYPEOF(BaseClaimqa.claim_no) claim_noL;
  TYPEOF(BaseClaimqa.reference_no) reference_noR;
  TYPEOF(BaseClaimqa.unit_no) unit_noR;
  TYPEOF(BaseClaimqa.claim_no) claim_noR;
  TYPEOF(BaseClaimqa.delta_ind) delta_indL;
  TYPEOF(BaseClaimqa.delta_ind) delta_indR;
  TYPEOF(BaseClaimqa.dt_effective_first) dt_effective_firstL;
  TYPEOF(BaseClaimqa.dt_effective_first) dt_effective_firstR;
END;

rec1 doJoin(BaseClaimqa l,ClaimFaDailyFa r) := TRANSFORM

  SELF.reference_noL := l.reference_no;
  SELF.unit_noL      := l.unit_no;
  SELF.claim_noL     := l.claim_no;
  SELF.reference_noR := r.reference_no;
  SELF.unit_noR      := r.unit_no;
  SELF.claim_noR     := r.claim_no;
  SELF.delta_indL    := l.delta_ind;
  SELF.delta_indR    := r.delta_ind;
  SELF.dt_effective_firstl    := l.dt_effective_first;
  SELF.dt_effective_firstR    := r.dt_effective_first;
  
END;
join1 := JOIN(BaseClaimqa, ClaimFaDailyFa,
                    LEFT.reference_no=RIGHT.reference_no and
                    LEFT.unit_no=RIGHT.unit_no and
                    LEFT.claim_no=RIGHT.claim_no ,doJoin(LEFT,RIGHT));
OUTPUT(join1,named('join1'));
OUTPUT(COUNT(join1),named('join1Cnt'));
OUTPUT(COUNT(DEDUP(SORT(join1,reference_nol,unit_nol,claim_nol),reference_nol,unit_nol,claim_nol)),named('join1dedupCnt'));

rec := RECORD
join1.reference_nol;
join1.unit_nol;
join1.claim_nol;
Cnt := COUNT(GROUP);
END;
Mytable := TABLE(join1,rec,reference_nol,unit_nol,claim_nol);
Mytable;
 Mytable(Cnt=2);
 Mytable(Cnt>2);
 
 refSET := SET(CHOOSEN(MyTable,10),reference_nol);
 refSET;
 BaseClaimqa(reference_no IN refSET);
 COUNT(BaseClaimqa);
 COUNT(DEDUP(BaseClaimqa));
BaseClaimqa(delta_ind IN [2,3]);


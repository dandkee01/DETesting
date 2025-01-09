IMPORT ClaimsDiscoveryAuto_Delta, ClaimsDiscoveryAuto_InquiryHistory;

DailySubj  := DATASET('~thor::base::claimsdiscoveryauto::kcd::qa::delta_key_subject.txt', ClaimsDiscoveryAuto_Delta.Layouts.Delta_Subject, THOR);
BaseSubj  := DATASET ('~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::subject',ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject,THOR);

CHOOSEN(DailySubj,5);
  
  rec := RECORD
    DailySubj.reference_number;
    Cnt := COUNT(GROUP);
  END;
  Mytable := TABLE(DailySubj,rec,reference_number,FEW);
  Mytable;
  Mytable(Cnt>1);
  
  COUNT(DailySubj);
  COUNT(BaseSubj);
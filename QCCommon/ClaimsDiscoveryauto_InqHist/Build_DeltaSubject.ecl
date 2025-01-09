IMPORT ClaimsDiscoveryAuto_InquiryHistory , ClaimsDiscoveryAuto_Delta,QCCommon, STD;
//******************************************************************************************************************************************************
  BaseSubjQa   := DATASET('~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::subject',ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject,THOR);
  OUTPUT(BaseSubjQa,named('BaseSubjQa'));
  BaseSubj   := DATASET('~thor::base::claimsdiscoveryauto::kcd::202303280301::inqhist::subject',ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject,THOR);
  OUTPUT(BaseSubj,named('BaseSubj'));

//*******************************************************************************************************************************************************  
  
  ChooseDS := CHOOSESETS(BaseSubjQa, delta_ind=1 => 5,
                         delta_ind=2 => 5,
                         delta_ind=3 => 5);
                         
  SortedDS := SORT(ChooseDS,delta_ind,reference_no); 
  Delta1Recs := SortedDS(delta_ind=1);
  
//*******************************************************************************************************************************************************
// Change Did in qa base file.
Delta1Recs CatThem(Delta1Recs L, INTEGER C) := TRANSFORM
  SELF.did := L.did + C;
  SELF := L;
END;

BaseQachangedDid := PROJECT(Delta1Recs,CatThem(LEFT,COUNTER));
OUTPUT(BaseQachangedDid,named('BaseQachangedDid'));  
  
//*******************************************************************************************************************************************************  
  DailySubjtest  := DATASET('~thor::base::claimsdiscoveryauto::kcd::qa::delta_key_subject.txt', ClaimsDiscoveryAuto_Delta.Layouts.Delta_Subject, THOR);
//*******************************************************************************************************************************************************  
  
  setDS := SET(Delta1Recs, reference_no);
  DailySubj := DailySubjtest(reference_number IN setDS);
  OUTPUT(DailySubj,named('DailySubj'));
  BaseSubChangeSSN := BaseSubjQa(reference_no IN setDS);
  DailySubjChangedSSN := PROJECT(DailySubj,TRANSFORM(RECORDOF(DailySubj),
                                                            SELF.subject_ssn := STD.Str.Reverse(LEFT.subject_ssn);
                                                            SELF := LEFT));
  OUTPUT(DailySubjChangedSSN,named('DailySubjChangedSSN'));                                                          
  

//********************************************************************************************************************************************************
// Build
//********************************************************************************************************************************************************  
  SubjectFile := QCCommon.ClaimsDiscoveryauto_InqHist.AppendDeltaSubj(BaseQachangedDid,DailySubj);
  OUTPUT(SubjectFile,named('SubjectFile'));
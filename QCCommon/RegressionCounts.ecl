IMPORT CLUEauto_InquiryHistory, ut, CLUEAuto_Delta;

// BaseSubject    :=  DATASET ('~thor::base::clueauto::kcd::20230507::inqhist::subject',CLUEauto_InquiryHistory.Layouts.Inquiry_Subject_CLUE,THOR);
// OUTPUT(COUNT(BaseSubject), named('BaseSubjectCnt'));
// Foreignsubject :=  DATASET (ut.foreign_prod+'thor::base::clueauto::20230227::inqhist::subject',CLUEauto_InquiryHistory.Layouts.Inquiry_Subject_CLUE,THOR);
// OUTPUT(COUNT(Foreignsubject), named('ForeignsubjectCnt'));
//MAX(Foreignsubject,(INTEGER)process_date);

// fields := 'transaction_id,unit_no,customer_no, account_no, dateoforder, lname, fname, mname, sname, house_no, street_name, apt_no, city, state, zip5, zip4, driverslicense_no, driverslicense_state, policy_no, ssn, dob, sex, service_type, process_date,spl_bill_id, bill_as,report_as';
// DedupDS := DEDUP(SORT(Foreignsubject,#expand(fields)),#expand(fields));
// COUNT(DedupDS);


BaseclaimSubject    :=  DATASET ('~thor::base::clueauto::kcd::20230507::inqhist::claim',CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR);
OUTPUT(COUNT(BaseclaimSubject), named('BaseclaimSubjectCnt'));
ForeignClaimsubject :=  DATASET (ut.foreign_prod+'thor::base::clueauto::20230227::inqhist::claim',CLUEAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR);
OUTPUT(COUNT(ForeignClaimsubject), named('ForeignClaimsubjectCnt'));
//MAX(Foreignsubject,(INTEGER)process_date);

claimfields := 'reference_no,unit_no,claim_no';

DedupClaimDS := DEDUP(SORT(ForeignClaimsubject,#expand(claimfields)),#expand(claimfields));
COUNT(DedupClaimDS);


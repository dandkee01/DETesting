Infile  := DATASET('~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::subject',ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Subject,THOR);
OUTPUT(Infile, named('Infile'));  
OUTPUT(COUNT(Infile), named('Cnt_Infile'));  
  
    Key_RefNo_Did := INDEX(Infile(Did > 0), {Did}, {Reference_No,Unit_No,record_sid,dt_effective_first,dt_effective_last,delta_ind }, 
										 //ClaimsDiscoveryAuto_InquiryHistory.Files.FILE_AUTOKEY_DID_SF);
										 '~thor::key::claimsdiscoveryauto::inqhist::kcd::did_qa');
    //Key_Inqry			:= INDEX(Infile, {Reference_No,Unit_No}, {ClaimsDiscoveryAuto_InquiryHistory.Files.InqSubj_DS}, 
    Key_Inqry			:= INDEX(Infile, {Reference_No,Unit_No}, {Infile}, 
										 //ClaimsDiscoveryAuto_InquiryHistory.Files.FILE_AUTOKEY_INQUIRY_SF);                 
										 '~thor::key::claimsdiscoveryauto::inqhist::kcd::inquiry_qa');                 
                     
InqClaim_DS   := DATASET('~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::claim',ClaimsDiscoveryAuto_InquiryHistory.Layouts.Inquiry_Claim,THOR);

		Key_RefNo_Clm := INDEX(ClaimsDiscoveryAuto_InquiryHistory.Files.InqClaim_DS, {Reference_No,Unit_No}, {Claim_No,record_sid,dt_effective_first,dt_effective_last,delta_ind }, 
										 //ClaimsDiscoveryAuto_InquiryHistory.Files.FILE_AUTOKEY_REFNOCLM_SF);
										 '~thor::key::claimsdiscoveryauto::inqhist::kcd::refno::claim_qa');
		
		
                     
    Acct_Rqmt_DS 	:= DATASET ('~thor::base::claimsdiscoveryauto::kcd::qa::account::requirements',ClaimsDiscoveryAuto_InquiryHistory.Layouts.Mbsi_Cust,THOR);

		Key_Cust			:= INDEX(ClaimsDiscoveryAuto_InquiryHistory.Files.Acct_Rqmt_DS, {Customer_No}, {ClaimsDiscoveryAuto_InquiryHistory.Files.Acct_Rqmt_DS},
										 //ClaimsDiscoveryAuto_InquiryHistory.Files.FILE_AUTOKEY_CUSTNO_SF);
										 '~thor::key::claimsdiscoveryauto::inqhist::kcd::custno_qa');
                     
    DeltaDate_DS  := DATASET ('~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::deltadate',CLUEAuto_InquiryHistory.Layouts.Delta_Date,THOR);

		Key_Date			:= INDEX(ClaimsDiscoveryAuto_InquiryHistory.Files.DeltaDate_DS, {Delta_Text}, {Process_Date},
										 //ClaimsDiscoveryAuto_InquiryHistory.Files.FILE_AUTOKEY_DELTADATE_SF);
										 '~thor::key::claimsdiscoveryauto::inqhist::kcd::deltadate_qa');
                     
   output( Key_RefNo_Did,named('Key_RefNo_Did'));                 
   output( Key_Inqry,named('Key_Inqry'));                 
   output( Key_RefNo_Clm,named('Key_RefNo_Clm'));                 
   output( Key_Cust,named('Key_Cust'));                 
   output( Key_Date,named('Key_Date'));                 
                     
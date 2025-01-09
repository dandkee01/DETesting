#WORKUNIT('priority','high');  
#WORKUNIT('priority',10);      

IMPORT did_add,claimsdiscoveryproperty_InquiryHistory,CLUEProperty_InquiryHistory, STD;

  HdrFileVersion             := did_add.get_EnvVariable(CLUEProperty_InquiryHistory.Constants.iHEADER_PACKAGE_ENV_VARIABLE, CLUEProperty_InquiryHistory.Constants.iHEADER_ROXIE_VIP);
  OUTPUT(HdrFileVersion, named('HdrFileVersion'));	
  ClueLexIDAppendVersion 		 := IF(fileservices.fileexists(ClaimsDiscoveryProperty_InquiryHistory.Files.FILE_CDSCP_INQHIST_BASE_HEADER_BUILD_VERSION), ClaimsDiscoveryProperty_InquiryHistory.Files.DS_CDSCP_INQHIST_BASE_HEADER_BUILD_VERSION()[1].CLUELexIDAppendVersion, 'NoVersion');
	OUTPUT(ClaimsDiscoveryProperty_InquiryHistory.Files.FILE_CDSCP_INQHIST_BASE_HEADER_BUILD_VERSION, named('ClueLexIDAppendVersion_Fname'));	
	OUTPUT(ClueLexIDAppendVersion, named('ClueLexIDAppendVersion'));	
  IsReadyForDidCorrections  		 := ClueLexIDAppendVersion <> HdrFileVersion;
  OUTPUT(IsReadyForDidCorrections, named('IsReadyForDidCorrections'));
  
  Ds := ClaimsDiscoveryProperty_InquiryHistory.Files.DS_CDSCP_INQHIST_BASE_HEADER_BUILD_VERSION();
  didVerChged :=  PROJECT(DS,TRANSFORM(RECORDOF(DS),SELF.CLUELexIDAppendVersion := '20241012i',SELF :=LEFT));
  //didVerChged :=  PROJECT(DS,TRANSFORM(RECORDOF(DS),SELF.CLUELexIDAppendVersion := '20240524i',SELF :=LEFT));
  didVerChged; 
   
    Iheader := OUTPUT(didVerChged,, '~thor::base::claimsdiscoveryproperty::20241025::inqhist::PRODHEADERVERSION', overwrite, __compressed__, named('LexidVersion'));
   
   doClearI   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    IF(~STD.File.SuperFileExists('~thor::base::claimsdiscoveryproperty::QA::inqhist::PRODHEADERVERSION'),STD.File.CreateSuperFile('~thor::base::claimsdiscoveryproperty::QA::inqhist::PRODHEADERVERSION',,1));
                    STD.File.ClearSuperFile('~thor::base::claimsdiscoveryproperty::QA::inqhist::PRODHEADERVERSION'),
                    STD.File.AddSuperFile('~thor::base::claimsdiscoveryproperty::QA::inqhist::PRODHEADERVERSION','~thor::base::claimsdiscoveryproperty::20241025::inqhist::PRODHEADERVERSION'),
                    STD.File.FinishSuperFileTransaction()
      		);
     // Iheader := OUTPUT(didVerChged,, '~thor::base::claimsdiscoveryproperty::kcd::20241025::inqhist::PRODHEADERVERSION', overwrite, __compressed__, named('LexidVersion'));
   
   // doClearI   := SEQUENTIAL(
      							// STD.File.StartSuperFileTransaction(),
                    // IF(~STD.File.SuperFileExists('~thor::base::claimsdiscoveryproperty::kcd::QA::inqhist::PRODHEADERVERSION'),STD.File.CreateSuperFile('~thor::base::claimsdiscoveryproperty::kcd::QA::inqhist::PRODHEADERVERSION',,1));
                    // STD.File.ClearSuperFile('~thor::base::claimsdiscoveryproperty::kcd::QA::inqhist::PRODHEADERVERSION'),
                    // STD.File.AddSuperFile('~thor::base::claimsdiscoveryproperty::kcd::QA::inqhist::PRODHEADERVERSION','~thor::base::claimsdiscoveryproperty::kcd::20241025::inqhist::PRODHEADERVERSION'),
                    // STD.File.FinishSuperFileTransaction()
      		// );
               
   Actions := SEQUENTIAL( Iheader,doClearI);
   Actions;
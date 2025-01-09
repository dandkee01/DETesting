#WORKUNIT('priority','high');
#WORKUNIT('priority',10); 
#WORKUNIT('name','Change Hearder Versions For Lexid Corrections'); 

IMPORT did_add,delta_macro, STD,CLUEAuto_InquiryHistory, ClaimsDiscoveryAuto_InquiryHistory; 
	
	HdrFileVersion                 := did_add.get_EnvVariable(CLUEAuto_InquiryHistory.Constants.iHEADER_PACKAGE_ENV_VARIABLE, CLUEAuto_InquiryHistory.Constants.iHEADER_ROXIE_VIP);
  OUTPUT(HdrFileVersion, named('HdrFileVersion'));	
  ClueLexIDAppendVersion 		     := IF(fileservices.fileexists(ClaimsDiscoveryAuto_InquiryHistory.Files.FILE_CD_INQHIST_BASE_HEADER_BUILD_VERSION), ClaimsDiscoveryAuto_InquiryHistory.Files.DS_CD_INQHIST_BASE_HEADER_BUILD_VERSION()[1].CLUELexIDAppendVersion, 'NoVersion');
  OUTPUT(ClaimsDiscoveryAuto_InquiryHistory.Files.FILE_CD_INQHIST_BASE_HEADER_BUILD_VERSION, named('CLUELexidAppendVersion_Fname'));	
  IsReadyForDidCorrections  		 := ClueLexIDAppendVersion <> HdrFileVersion;
  IsReadyForDidCorrections;
	CLDA_HeaderBuildVersion := ClaimsDiscoveryAuto_InquiryHistory.Files.DS_CD_INQHIST_BASE_HEADER_BUILD_VERSION;
  LexidVerChged           :=  PROJECT(CLDA_HeaderBuildVersion,TRANSFORM(RECORDOF(CLDA_HeaderBuildVersion),SELF.cluelexidappendversion := '20240926i',SELF :=LEFT));
  //LexidVerChged           :=  PROJECT(CLDA_HeaderBuildVersion,TRANSFORM(RECORDOF(CLDA_HeaderBuildVersion),SELF.cluelexidappendversion := '20240813i',SELF :=LEFT));
   
    
    Iheader := OUTPUT(LexidVerChged,, '~thor::base::claimsdiscoveryauto::20241017k::inqhist::PRODHEADERVERSION', overwrite, __compressed__, named('LexidVersion'));
   
   doClearI   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    IF(~STD.File.SuperFileExists('~thor::base::claimsdiscoveryauto::QA::inqhist::PRODHEADERVERSION'),STD.File.CreateSuperFile('~thor::base::claimsdiscoveryauto::QA::inqhist::PRODHEADERVERSION',,1));
                    STD.File.ClearSuperFile('~thor::base::claimsdiscoveryauto::QA::inqhist::PRODHEADERVERSION'),
                    STD.File.AddSuperFile('~thor::base::claimsdiscoveryauto::QA::inqhist::PRODHEADERVERSION','~thor::base::claimsdiscoveryauto::20241017k::inqhist::PRODHEADERVERSION'),
                    STD.File.FinishSuperFileTransaction()
      		);
          
     /* Iheader := OUTPUT(LexidVerChged,, '~thor::base::claimsdiscoveryauto::kcd::20241010::inqhist::PRODHEADERVERSION', overwrite, __compressed__, named('LexidVersion'));
   
   doClearI   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    IF(~STD.File.SuperFileExists('~thor::base::claimsdiscoveryauto::kcd::QA::inqhist::PRODHEADERVERSION'),STD.File.CreateSuperFile('~thor::base::claimsdiscoveryauto::kcd::QA::inqhist::PRODHEADERVERSION',,1));
                    STD.File.ClearSuperFile('~thor::base::claimsdiscoveryauto::kcd::QA::inqhist::PRODHEADERVERSION'),
                    STD.File.AddSuperFile('~thor::base::claimsdiscoveryauto::kcd::QA::inqhist::PRODHEADERVERSION','~thor::base::claimsdiscoveryauto::kcd::20241010::inqhist::PRODHEADERVERSION'),
                    STD.File.FinishSuperFileTransaction()
      		);    
     */ 
   Actions := SEQUENTIAL( Iheader,doClearI);
   Actions;
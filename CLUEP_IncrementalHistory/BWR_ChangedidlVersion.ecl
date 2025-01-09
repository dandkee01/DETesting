#WORKUNIT('priority','high');  
#WORKUNIT('priority',10);      

IMPORT did_add,CLUEProperty_InquiryHistory, STD;

 /*Check to see if header variable has changed*/
	HdrFileVersion             := did_add.get_EnvVariable(CLUEProperty_InquiryHistory.Constants.iHEADER_PACKAGE_ENV_VARIABLE, CLUEProperty_InquiryHistory.Constants.iHEADER_ROXIE_VIP);
	ClueLexIDAppendVersion 		 := IF(fileservices.fileexists(CLUEProperty_InquiryHistory.Files.FILE_CLUP_INQHIST_BASE_HEADER_BUILD_VERSION),CLUEProperty_InquiryHistory.Files.DS_CLUP_INQHIST_BASE_HEADER_BUILD_VERSION()[1].CLUELexIDAppendVersion, 'NoVersion');
	IsReadyForDidCorrections  		 := ClueLexIDAppendVersion <> HdrFileVersion;
  OUTPUT(IsReadyForDidCorrections, named('IsReadyForDidCorrections'));
  OUTPUT(ClueLexIDAppendVersion, named('ClueLexIDAppendVersion'));
  OUTPUT(HdrFileVersion, named('HdrFileVersion'));
  
  Ds := CLUEProperty_InquiryHistory.Files.DS_CLUP_INQHIST_BASE_HEADER_BUILD_VERSION;
  
  didVerChged :=  PROJECT(DS,TRANSFORM(RECORDOF(DS),SELF.CLUELexIDAppendVersion := '20241027i',SELF :=LEFT));
  didVerChged; 
  
   Iheader := OUTPUT(didVerChged,, '~thor::base::clueproperty::20241113kcd::inqhist::PRODHEADERVERSION', overwrite, __compressed__, named('LexidVersion'));
   
   doClearI   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    IF(~STD.File.SuperFileExists('~thor::base::clueproperty::QA::inqhist::PRODHEADERVERSION'),STD.File.CreateSuperFile('~thor::base::clueproperty::QA::inqhist::PRODHEADERVERSION',,1));
                    STD.File.ClearSuperFile('~thor::base::clueproperty::QA::inqhist::PRODHEADERVERSION'),
                    STD.File.AddSuperFile('~thor::base::clueproperty::QA::inqhist::PRODHEADERVERSION','~thor::base::clueproperty::20241113kcd::inqhist::PRODHEADERVERSION'),
                    STD.File.FinishSuperFileTransaction()
      		);
          
   Actions := SEQUENTIAL( Iheader,doClearI);
   Actions;
    
  
#WORKUNIT('priority','high');  
#WORKUNIT('priority',10);      

IMPORT did_add,CLUEAuto_InquiryHistory, STD;

  HdrFileVersion                                    := did_add.get_EnvVariable(CLUEAuto_InquiryHistory.Constants.iHEADER_PACKAGE_ENV_VARIABLE, CLUEAuto_InquiryHistory.Constants.iHEADER_ROXIE_VIP);
  DS_CLUE_INQHIST_BASE_HEADER_BUILD_VERSION        	:= DATASET(CLUEAuto_InquiryHistory.Files.FILE_CLUE_INQHIST_BASE_HEADER_BUILD_VERSION,  CLUEAuto_InquiryHistory.Layouts.IHdr_Build_Version, THOR, OPT);
	ClueLexIDAppendVersion 		     := IF(fileservices.fileexists(CLUEAuto_InquiryHistory.Files.FILE_CLUE_INQHIST_BASE_HEADER_BUILD_VERSION), DS_CLUE_INQHIST_BASE_HEADER_BUILD_VERSION()[1].CLUELexIDAppendVersion, 'NoVersion');
  IsReadyForDidCorrections  		 := ClueLexIDAppendVersion <> HdrFileVersion;
  OUTPUT(IsReadyForDidCorrections,named('IsReadyForDidCorrections'));
  //OUTPUT(CLUEAuto_InquiryHistory.Files.FILE_CLUE_INQHIST_BASE_HEADER_BUILD_VERSION,named('file_name'));
  OUTPUT(HdrFileVersion, named('HdrFileVersion'));
  
  Ds := DS_CLUE_INQHIST_BASE_HEADER_BUILD_VERSION;
  //didVerChged :=  PROJECT(DS,TRANSFORM(RECORDOF(DS),SELF.CLUELexIDAppendVersion := '20240724i',SELF :=LEFT));
  didVerChged :=  PROJECT(DS,TRANSFORM(RECORDOF(DS),SELF.CLUELexIDAppendVersion := '20241112i',SELF :=LEFT));
  didVerChged; 
  
  /* Iheader := OUTPUT(didVerChged,, '~thor::base::clueauto::kcd::20240906::inqhist::PRODHEADERVERSION', overwrite, __compressed__, named('LexidVersion'));
   
   doClearI   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    IF(~STD.File.SuperFileExists('~thor::base::clueauto::kcd::QA::inqhist::PRODHEADERVERSION'),STD.File.CreateSuperFile('~thor::base::clueauto::kcd::QA::inqhist::PRODHEADERVERSION',,1));
                    STD.File.ClearSuperFile('~thor::base::clueauto::kcd::QA::inqhist::PRODHEADERVERSION'),
                    STD.File.AddSuperFile('~thor::base::clueauto::kcd::QA::inqhist::PRODHEADERVERSION','~thor::base::clueauto::kcd::20240906::inqhist::PRODHEADERVERSION'),
                    STD.File.FinishSuperFileTransaction()
      		);
          
   Actions := SEQUENTIAL( Iheader,doClearI);
   Actions;   */
 
   Iheader := OUTPUT(didVerChged,, '~thor::base::clueauto::20241115kcd::inqhist::PRODHEADERVERSION', overwrite, __compressed__, named('LexidVersion'));
   
   doClearI   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    IF(~STD.File.SuperFileExists('~thor::base::clueauto::QA::inqhist::PRODHEADERVERSION'),STD.File.CreateSuperFile('~thor::base::clueauto::QA::inqhist::PRODHEADERVERSION',,1));
                    STD.File.ClearSuperFile('~thor::base::clueauto::QA::inqhist::PRODHEADERVERSION'),
                    STD.File.AddSuperFile('~thor::base::clueauto::QA::inqhist::PRODHEADERVERSION','~thor::base::clueauto::20241115kcd::inqhist::PRODHEADERVERSION'),
                    STD.File.FinishSuperFileTransaction()
      		);
          
   Actions := SEQUENTIAL( Iheader,doClearI);
   Actions; 
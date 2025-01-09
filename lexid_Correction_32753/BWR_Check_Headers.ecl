#WORKUNIT('priority','high');
#WORKUNIT('priority',10); 
#WORKUNIT('name','Change Hearder Versions For Lexid Corrections'); 

IMPORT FCRA_Inquiry_History, STD; 
	
		dsFCRAInqHst_iHeaderVersion     := FCRA_Inquiry_History.Files.DS_FCRA_IH_iHEADER_BUILD_VERSION;
    dsFCRAInqHst_fHeaderVersion     := FCRA_Inquiry_History.Files.DS_FCRA_IH_fHEADER_BUILD_VERSION;
		
    IheaderVerChged :=  PROJECT(dsFCRAInqHst_iHeaderVersion,TRANSFORM(RECORDOF(dsFCRAInqHst_iHeaderVersion),SELF.header_version := '20240201',SELF :=LEFT));
    FheaderVerChged :=  PROJECT(dsFCRAInqHst_fHeaderVersion,TRANSFORM(RECORDOF(dsFCRAInqHst_fHeaderVersion),SELF.header_version := '20240201',SELF :=LEFT));
    
    OUTPUT(IheaderVerChged, named('IheaderVerChged'));
    OUTPUT(FheaderVerChged, named('FheaderVerChged'));
    
    Iheader := OUTPUT(IheaderVerChged,, '~thor::base::fcra_delta_inq_hist::20240501a::prodiheaderversion', overwrite, __compressed__, named('IHeader'));
    FHeader := OUTPUT(FheaderVerChged,, '~thor::base::fcra_delta_inq_hist::20240501a::prodheaderversion', overwrite, __compressed__, named('FHeader'));
   
   doClearI   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    STD.File.ClearSuperFile('~thor::base::fcra_delta_inq_hist::qa::prodiheaderversion'),
                    STD.File.AddSuperFile('~thor::base::fcra_delta_inq_hist::qa::prodiheaderversion','~thor::base::fcra_delta_inq_hist::20240501a::prodiheaderversion'),
                    STD.File.FinishSuperFileTransaction()
      		);
          
   doClearH   := SEQUENTIAL(
      							STD.File.StartSuperFileTransaction(),
                    STD.File.ClearSuperFile('~thor::base::fcra_delta_inq_hist::qa::prodheaderversion'),
                    STD.File.AddSuperFile('~thor::base::fcra_delta_inq_hist::qa::prodheaderversion','~thor::base::fcra_delta_inq_hist::20240501a::prodheaderversion'),
                    STD.File.FinishSuperFileTransaction()
      		);
   Actions := SEQUENTIAL( Iheader,FHeader,doClearI,doClearH);
   Actions;
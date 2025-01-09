IMPORT CustomerSupport, IDLExternalLinking, RoxieKeyBuild, DID_Add, STD, STANDARD,insurance_common_code, Insurance, FCRA_Inquiry_History; 

    STRING sProduct  := 'delta_inq_hist';
    STRING csProduct := 'cs_delta_inq_hist';
    STRING TableName:= 'delta_key';
    STRING build_date := '20240925';
    
    currbase_inquiry    := FCRA_Inquiry_History.Files.read_delta_key_Base (FCRA_Inquiry_History.Constants(sProduct,TableName,,).base_file);
    OUTPUT(Count(currbase_inquiry),named('currbase_inquiry'));

    dailies_inquiry_0   := FCRA_Inquiry_History.Files.read_delta_key_Spray(FCRA_Inquiry_History.Constants(sProduct,TableName,,).spray_File);
    OUTPUT(Count(dailies_inquiry_0),named('dailies_inquiry_0'));
    
    dailies_inquiry     := project(dailies_inquiry_0,
                                transform({recordof(dailies_inquiry_0), string90 house_num, string1 STREET_NAME, string1 APT_NUM,
                                                string25 RCITY,  string2 RST, string9 RZIP,unsigned8 aid, unsigned2 dali, unsigned6 locid,
                                                Insurance.Layout_CleanAddress},
                                          self.did          := (unsigned8) left.Lex_ID; 
                                          self.house_num    := TRIM(left.addr_street,LEFT,RIGHT);
                                          self.STREET_NAME  := '';
                                          self.APT_NUM      := '';
                                          self.RCITY        := left.addr_city;
                                          self.RST          := left.addr_state;
                                          self.RZIP         := left.addr_zip5 + left.addr_zip4; 
                                          self.dob          := left.dob[1..4]+left.dob[6..7]+ left.dob[9..10];
                                          self := left;
                                          self :=[]),local);

    insurance_common_code.MAC_CleanAddress_AID (dailies_inquiry, clnAddr_dailies_out);
    OUTPUT(Count(clnAddr_dailies_out),named('clnAddr_dailies_out'));

    clnAddr_dailies       := PROJECT(clnAddr_dailies_out, TRANSFORM(FCRA_Inquiry_History.Layouts.delta_base_Layout, self := LEFT)):INDEPENDENT;
    OUTPUT(Count(clnAddr_dailies),named('clnAddr_dailies'));

    //================= Lex-ID =====================================
    dsFCRAInqHst_iHeaderVersion     := FCRA_Inquiry_History.Files.DS_FCRA_IH_iHEADER_BUILD_VERSION;
    dsFCRAInqHst_fHeaderVersion     := FCRA_Inquiry_History.Files.DS_FCRA_IH_fHEADER_BUILD_VERSION;

    iHdrFileVersion                 := did_add.get_EnvVariable(FCRA_Inquiry_History.Constants(sProduct,TableName,,).iHEADER_PACKAGE_ENV_VARIABLE, FCRA_Inquiry_History.Constants(sProduct,TableName,,).HEADER_ROXIE_VIP);
    fHdrFileVersion                 := did_add.get_EnvVariable(FCRA_Inquiry_History.Constants(sProduct,TableName,,).fHEADER_PACKAGE_ENV_VARIABLE, FCRA_Inquiry_History.Constants(sProduct,TableName,,).HEADER_ROXIE_VIP);
    //==============================================================

    MVR_DailyVMSData                := FCRA_Inquiry_History.MVR_VMS_DailySprayData(build_date);                //Get MVR VMS Daily Spray Data.
    MVR_DailyTransLogData           := FCRA_Inquiry_History.MVR_TransLog_DailySprayData(build_date);   //Get MVR Transaction Log Daily Spray Data.
  
    MVR_Data                        := PROJECT(MVR_DailyVMSData & MVR_DailyTransLogData, TRANSFORM(FCRA_Inquiry_History.Layouts.delta_base_Layout,
                                              SELF.lex_id     := LEFT.Lex_id;
                                              SELF            := LEFT;
                                              ));
  
    IDLExternalLinking.mac_xlinking_on_thor (MVR_Data, Lex_ID,, name_first, name_middle, name_last,,,, 
                                             addr_street, , addr_city, addr_state, addr_zip5,SSN,DOB,
                                             drivers_license_state,drivers_license_number,,,
                                             tmp_MVR_IDLed_Data,,30,6);

    MVR_IDLed_Data                  := PROJECT(tmp_MVR_IDLed_Data(lex_id <>0),TRANSFORM(FCRA_Inquiry_History.Layouts.delta_base_Layout,
                                              SELF.lex_id     := LEFT.Lex_id;
                                              SELF            := LEFT;
                                              ));
   OUTPUT(Count(MVR_IDLed_Data),named('MVR_IDLed_Data'));

   //================= Lex-ID =====================================
    iFCRAIHLexIDAppendVersion       := IF(NOTHOR(STD.File.FileExists(FCRA_Inquiry_History.Files.FILE_DMV_BASE_iHEADER_BUILD_VERSION)), dsFCRAInqHst_iHeaderVersion[1].header_version, 'NoVersion');
    fFCRAIHLexIDAppendVersion       := IF(NOTHOR(STD.File.FileExists(FCRA_Inquiry_History.Files.FILE_DMV_BASE_fHEADER_BUILD_VERSION)), dsFCRAInqHst_fHeaderVersion[1].header_version, 'NoVersion');

    isReadyForLexIDAppendForInc     := iFCRAIHLexIDAppendVersion <> iHdrFileVersion : INDEPENDENT;
    isReadyForLexIDAppendForFull    := fFCRAIHLexIDAppendVersion <> fHdrFileVersion : INDEPENDENT;
    isReadyForLexIDCorrection       := isReadyForLexIDAppendForInc and  (Not isReadyForLexIDAppendForFull);

    currbase_inquiry_no_addr        := currbase_inquiry(addr_street ='' and addr_city = '');      //Recs without addresses
    currbase_inquiry_w_addr         := currbase_inquiry(~(addr_street ='' and addr_city = ''));   //Recs with addresses

    IDLExternalLinking.mac_xlinking_on_thor (currbase_inquiry_w_addr, lex_id,, name_first, name_middle, name_last,,,
                                             PRIM_NAME, PRIM_RANGE, SEC_RANGE, CITY, ST, ZIP,
                                             SSN,DOB,drivers_license_state,drivers_license_number,,,IDLedBaseData,,30,6,,,,,,,,CorrectionsOn := isReadyForLexIDCorrection);  //Only LexID those recs with addresses

    baseLexID_upd                   := IFF(isReadyForLexIDAppendForInc or isReadyForLexIDAppendForFull, PROJECT(IDLedBaseData,{recordof(currbase_inquiry)}) & currbase_inquiry_no_addr  //Combine recs with and w/o address 
                                                                                                      , currbase_inquiry):INDEPENDENT;                                                  //No lexiding required, continue with full dataset
    //==============================================================
  //~~~~
    OUTPUT( COUNT(baseLexID_upd),named('baseLexID_upd'));
                                       
    DistDaily                       := DISTRIBUTE(clnAddr_dailies & MVR_IDLed_Data,HASH64(lex_id,transaction_id));//Get Daily Data from the Table
    OUTPUT( COUNT(DistDaily),named('DistDaily'));
    
    SampleDaily                     := TABLE(ENTH(DistDaily,10), {lex_id, transaction_id},FEW);
    Outsample                       := OUTPUT(SampleDaily,NAMED('New_Daily_LexIDs')); 
    New_base_inquiry                := DEDUP(SORT(DistDaily & baseLexID_upd, lex_id,transaction_id,product_id,date_added,seq_num, LOCAL), lex_id,transaction_id,product_id,date_added,seq_num, LOCAL);
    OUTPUT( COUNT(New_base_inquiry),named('New_base_inquiry'));

    DistNew_base_inquiry            := DISTRIBUTE(New_base_inquiry,HASH64(lex_id,transaction_id));
    
    
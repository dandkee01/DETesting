  IMPORT CCLUE_PriorHistory,CCLUEServices_v2;
	
  //Delta_Subj := CCLUE_PriorHistory.ReadDeltaFile(CCLUE_PriorHistory.Files.DeltaSubj_Sprayed_DS);
  //Delta_Subj(transaction_id='18165093U153273');

//DeltaSubj_Sprayed_DS	:= DATASET (CCLUE_PriorHistory.Files.DeltaSubj_Subfile,CCLUEServices_v2.Layout_Deltabase.delta_subject,CSV(SEPARATOR('\t'),TERMINATOR(['\n','\r\n','\n\r']),QUOTE('"')));
DeltaSubj_Sprayed_DS	:= DATASET ('~thor::base::cclue::priorhist::sprayed::delta_subject::w20240916-213908',CCLUEServices_v2.Layout_Deltabase.delta_subject,CSV(SEPARATOR('\t'),TERMINATOR(['\n','\r\n','\n\r']),QUOTE('"')));
DeltaSubj_Sprayed_DS(transaction_id='18165093U153273');
//CCLUE_PriorHistory.Files.DeltaSubj_Subfile;
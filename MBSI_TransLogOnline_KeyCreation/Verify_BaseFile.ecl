IMPORT ut, CustomerSupport;

//sProduct    := 'FCRA_MBSI_TranO';
//curr_base_transo						:= CustomerSupport.Files.read_Transaction_OnLine_Base_trano(CustomerSupport.Constants(sProduct).transo_base_file);

File := '~base::fcra_mbsi_trano::transaction_log_online::20241030::trans_online_id'; // 1st run

fcrambsi_DS := DATASET(File,CustomerSupport.Layouts.Layout_transaction_log_online_trano,THOR,OPT);
//OUTPUT(curr_base_transo(dt_effective_first=20241029),named('Base_NewRecs'));
OUTPUT(fcrambsi_DS(TRIM(transaction_id,left,right) = '18501363U577835'));

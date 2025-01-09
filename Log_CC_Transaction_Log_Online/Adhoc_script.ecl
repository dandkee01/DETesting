import ut,std, STANDARD;

Lay :=RECORD
  string20 transaction_id;
  string4 type;
  string request_data{blob, maxlength(2000000)};
  string response_data{blob, maxlength(3000000)};
  string9 request_format;
  string9 response_format;
  string22 date_added;
		STANDARD.LAYOUTS.LAYOUT_ORBIT;
END;

 cc := dataset( '~base::cc_trano::transaction_log_online::qa::trans_online_id', lay, thor);
 OUTPUT(COUNT(CC),NAMED('before_Project_Count'));

		prj:= project(cc,transform(lay,																							
																							self.global_sid := 2162;
																							self.record_sid := 0;
																							self						:= left));
				
				

cc_distribute := Distribute (prj,hash64(transaction_id));
 OUTPUT(COUNT(cc_distribute),NAMED('After_Project_Count'));

	
	 output(cc_distribute,,'~base::cc_trano::transaction_log_online::20240128b::trans_online_id',overwrite, compressed);
import ut,std,STANDARD;

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

 cdsc := dataset('~base::cdsc_trano::transaction_log_online::qa::trans_online_id', lay, thor);
 OUTPUT(COUNT(cdsc), named('before_project_count'));

		prj:= project(cdsc,transform(lay,																							
																							self.global_sid := 2062;
																							self.record_sid := 0;
																							self						:= left));
				
				

  cdsc_distribute := Distribute (prj,hash64(transaction_id));
  OUTPUT(COUNT(cdsc_distribute), named('After_project_count'));

	
	 output(cdsc_distribute,,'~base::cdsc_trano::transaction_log_online::20240126b::trans_online_id',overwrite, compressed);
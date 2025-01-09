import ut,std,STANDARD, Orbit3, CustomerSupport;

Lay :=RECORD
  string20 transaction_id;
  string4 type;
  string request_data{blob, maxlength(2000000)};
  string response_data{blob, maxlength(3000000)};
  string9 request_format;
  string9 response_format;
  string22 date_added;
END;

Lay1 :=RECORD
  string20 transaction_id;
  string4 type;
  string request_data{blob, maxlength(2000000)};
  string response_data{blob, maxlength(3000000)};
  string9 request_format;
  string9 response_format;
  string22 date_added;
		STANDARD.LAYOUTS.LAYOUT_ORBIT;
END;

 mvr := dataset('~base::mvr_trano::transaction_log_online::qa::trans_online_id', lay, thor);
 OUTPUT(COUNT(mvr),named('before_project_count'));
global_source_id	:=  Orbit3.get_glb_srcid_from_orbit(CustomerSupport.orbitIConstants('MVR_TranO').datasetname, CustomerSupport.Constants('').QC_email_target);
global_source_id;

		prj:= project(mvr,transform(lay1,																							
																							self.global_sid := global_source_id;
																							self.record_sid := 0;
																							self						:= left));
				
				

cdsc_distribute := Distribute (prj,hash64(transaction_id));
 OUTPUT(count(cdsc_distribute),named('After_project_count'));

	
	 output(cdsc_distribute,,'~base::mvr_trano::transaction_log_online::20240123c::trans_online_id',overwrite, compressed);
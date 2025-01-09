IMPORT CustomerSupport,Orbit4;

sProduct  := 'CCFC';
currbase_inquiry := CustomerSupport.Files.read_CCFC_InquiryBase(CustomerSupport.Constants(sProduct).base_file);
dailies_inquiry := CustomerSupport.Files.read_InquirySpray(CustomerSupport.Constants(sProduct).spray_File);
dailies_inquiry;

global_source_id := Orbit4.get_glb_srcid_from_orbit(CustomerSupport.orbitIConstants(sProduct).datasetname, CustomerSupport.Constants('').QC_email_target);	

			slim_rec := record
			 string20 transaction_id;
			end;
			
			slim_inquiry := project(dailies_inquiry,transform(slim_rec,self:=left));
			
			dailies := dedup(slim_inquiry,all);
			
			output(enth(dailies,10),named('NewTransactionIDs_'+sProduct));
			
			CustomerSupport.Layouts.Layout_InquiryHistory_Data BatchJobIDsloginqhistDailies(CustomerSupport.Layouts.Layout_InquiryHistory_Data_spray le) := TRANSFORM
				self.global_sid 					:= global_source_id;
				self.record_sid 					:= 0;
				self											:= le;	
				END;
	
			Proj_log_inqhist_Dailies  := PROJECT(dailies_inquiry, BatchJobIDsloginqhistDailies(LEFT));
      OUTPUT(Proj_log_inqhist_Dailies,named('Proj_log_inqhist_Dailies'));
      
      dist_currbase_inquiry := sorted(distributed(currbase_inquiry,HASH(transaction_id,product_id,date_added, process_type)),
			                                transaction_id, product_id, date_added, process_type,processing_time, vendor_code, 
			                                                   request_type, product_version, reference_number, 
																												 -LENGTH(TRIM(CONTENT_DATA)));
                                                         
      Max_RecordSID         := MAX(currbase_inquiry, Record_sid) : INDEPENDENT;
      
      dailies_Interm        := PROJECT(Proj_log_inqhist_Dailies, TRANSFORM({DATA16 vault_UID_Hash_CDSC_Interm, RECORDOF(Proj_log_inqhist_Dailies)},
                                                            SELF.vault_UID_Hash_CDSC_Interm := HASHMD5(LEFT.transaction_id,
                                                                                                     LEFT.product_id,
                                                                                                     LEFT.date_added,
                                                                                                     LEFT.process_type,
                                                                                                     LEFT.processing_time,
                                                                                                     LEFT.vendor_code,
                                                                                                     LEFT.request_type,
                                                                                                     LEFT.product_version,
                                                                                                     LEFT.reference_number,
                                                                                                     LEFT.content_data);
                                                            SELF := LEFT;));
																														
	
  dailies_Interm_dist   := DISTRIBUTE(dailies_Interm, HASH(transaction_id, product_id, date_added, process_type));
 
  dedup_dailies_Interm  := DEDUP(SORT(dailies_Interm_dist, vault_UID_Hash_CDSC_Interm, LOCAL), vault_UID_Hash_CDSC_Interm, LOCAL);
  OUTPUT(dedup_dailies_Interm,named('dedup_dailies_Interm'));
  
  dailies_dedup         := project(dedup_dailies_Interm,TRANSFORM(CustomerSupport.Layouts.Layout_InquiryHistory_CCFC_Data,
                                                                                         self.record_sid := Max_RecordSID + COUNTER,
                                                                                         self.dt_effective_first := std.Date.Today(),
                                                                                         self.delta_ind := 1,
                                                                                         self := LEFT,
                                                                                         self := []));
 OUTPUT(dailies_dedup,named('dailies_dedup'));
  dailies_dedup_cnt     := COUNT(dedup_dailies_Interm);
	dailies_cnt           := count(dailies_inquiry);
  duplicates_count      := dailies_cnt - dailies_dedup_cnt  ;
 			
			
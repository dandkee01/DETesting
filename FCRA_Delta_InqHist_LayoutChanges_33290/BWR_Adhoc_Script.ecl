Import Standard,Insurance,FCRA_Inquiry_History, STD;

ProdSuperFileName_Subject := '~thor::base::fcra::delta_inq_hist::qa::delta_key';

Layout := FCRA_Inquiry_History.Layouts.delta_base_Layout;	

BaseSubject :=  DATASET (ProdSuperFileName_Subject, Layout,THOR);

OUTPUT(COUNT(BaseSubject), named('Base_Count_Before'));

	Layout setRecordSid_Subj (Layout L, INTEGER C) := TRANSFORM
		SELF.Record_Sid := C;
		SELF.dt_effective_first := STD.Date.Today();
		SELF.Delta_ind := 1;
		SELF := L;
	END;
		
	Subject_id := PROJECT (BaseSubject,setRecordSid_Subj(LEFT,COUNTER));
	
	Subject_distribute := Distribute (Subject_id,HASH32(transaction_id));
  
OUTPUT(COUNT(Subject_distribute), named('Base_Count_After'));
	
OUTPUT(max(Subject_distribute, record_sid), named('Max_record_sid'));
	
 Sequential(
				output(Subject_distribute,,'~thor::base::fcra::delta_inq_hist::adhoc_kcd0131::delta_key',overwrite,compressed),
						FileServices.ClearSuperFile(ProdSuperFileName_Subject),
						FileServices.AddSuperFile(ProdSuperFileName_Subject, '~thor::base::fcra::delta_inq_hist::adhoc_kcd0131::delta_key'),
			);
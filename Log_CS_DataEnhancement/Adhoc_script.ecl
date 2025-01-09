IMPORT ut,Orbit4,Customersupport;
#WORKUNIT('priority',10);
#WORKUNIT('priority','high');

Lay := RECORD
  string transaction_id;
  string11 product_id;
  string19 date_added;
  string4 process_type;
  string8 processing_time;
  string10 vendor_code;
  string20 request_type;
  string20 product_version;
  string15 reference_number;
  string content_data{blob, maxlength(2000000)};
 END;
 
Lay1 := RECORD
  string transaction_id;
  string11 product_id;
  string19 date_added;
  string4 process_type;
  string8 processing_time;
  string10 vendor_code;
  string20 request_type;
  string20 product_version;
  string15 reference_number;
  string content_data{blob, maxlength(2000000)};
  unsigned4 global_sid;
  unsigned8 record_sid;
 END;

base := dataset(ut.foreign_prod +'base::dataenh::inquiry_history::qa::id',Lay,Thor);

global_source_id	:=  Orbit4.get_glb_srcid_from_orbit(CustomerSupport.orbitIConstants('DATAENH').datasetname, CustomerSupport.Constants('').QC_email_target);
global_source_id;
OUTPUT(global_source_id, named('global_source_id'));
OUTPUT(COUNT(base), named('before_project_count'));
		prj:= project(base,transform(lay1,																							
																							self.global_sid := global_source_id;
																							self.record_sid := 0;
																							self						:= left));
				
				

de_distribute := Distribute (prj,HASH(transaction_id,product_id,date_added, process_type));

OUTPUT(COUNT(de_distribute), named('after_project_count'));

	
output(de_distribute,,'~base::dataenh::inquiry_history::20240227::id',overwrite, compressed);
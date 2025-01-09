IMPORT Orbit4,Customersupport;

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

base := dataset('~thor::base::log_rules::qa::intermediate_log',Lay,Thor);
OUTPUT(COUNT(base), named('count_before_project'));
global_source_id:= Orbit4.get_glb_srcid_from_orbit(Customersupport.Orbit3Constants('log_rules',,'intermediate_log').datasetname, CustomerSupport.ConstantsV2('log_rules', 'intermediate_log', '20231101').SuccessEmailList);       
OUTPUT(global_source_id, named('global_source_id'));

prj:= project(base,transform(lay1,																							
																							self.global_sid := global_source_id;
																							self.record_sid := 0;
																							self						:= left));
				
				

de_distribute := Distribute (prj,HASH64(transaction_id,product_id,date_added, process_type));

OUTPUT(COUNT(de_distribute), named('count_after_project'));

	
output(de_distribute,,'~thor::base::log_rules::20240327::intermediate_log',overwrite, compressed);
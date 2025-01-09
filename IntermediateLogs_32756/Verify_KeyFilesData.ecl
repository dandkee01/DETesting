
IMPORT DATA_SERVICES, CustomerSupport,ut,std,RoxieKeyBuild;

Key_subject := RECORD
  string16 transaction_id
  =>
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


DS_Key_subject   := INDEX(Key_subject,DATA_SERVICES.FOREIGN_PROD+'key::dd::inquiry_history::20240510::trans_id');
OUTPUT(COUNT(DS_Key_subject),named('Prod_Key_Count'));


curr_base_inquiry := PROJECT(CustomerSupport.Files.read_DD_InquiryBase(CustomerSupport.Constants('DD').base_file),CustomerSupport.Layouts.Layout_InquiryHist_DD_Data);
EarlyDate := ut.date_math((STRING8)Std.Date.Today(), -184);
OUTPUT(EarlyDate,named('earlyDate'));
EarliestHyphened := EarlyDate[1..4] + '-' + EarlyDate[5..6] + '-' + EarlyDate[7..8]:global;
Base:=curr_base_inquiry(date_added >= EarliestHyphened);
COUNT(Base);

 base_srt_inquiry  := DISTRIBUTE (curr_base_inquiry(date_added >= EarliestHyphened), HASH64(transaction_id));
 
 key_inquiry_transID	:= INDEX(base_srt_inquiry,
																	{	transaction_id },
																	{base_srt_inquiry},
																	'~key::dd::inquiry_history::20240514d::trans_id');
                                  
 RoxieKeyBuild.Mac_SK_BuildProcess_v2_local(key_inquiry_transID,
                                             CustomerSupport.Constants('DD').key_file,
																					   CustomerSupport.Constants('DD',, trim('20240514d',left,right)).key_subfile,
																					   build2);
                                 
                                  
OUTPUT(COUNT(key_inquiry_transID),named('Dev_Key_Count'));
build2;
                                  
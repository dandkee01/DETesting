IMPORT std,ut;
BuildSubmittedDate :=20240131;
Max_Date := Std.Date.AdjustDate(BuildSubmittedDate,0,0,-45,);
Min_Date_Back365 := Std.Date.AdjustDate(Max_Date,0,0,-365,);
Min_Date_Back120 := Std.Date.AdjustDate(Max_Date,0,0,-120,);
Min_Date_Back30  := Std.Date.AdjustDate(Max_Date,0,0,-30,);

OUTPUT(Max_Date, named('Max_Date'));
OUTPUT(Min_Date_Back365, named('Min_Date_Back365'));
OUTPUT(Min_Date_Back120, named('Min_Date_Back120'));
OUTPUT(Min_Date_Back30, named('Min_Date_Back30'));

//********************************************************************************************************

Key_Layout := RECORD
  string20 transaction_id
  =>
  string11 product_id;
  string19 date_added;
  string4 process_type;
  string8 processing_time;
  string20 vendor_code;
  string20 request_type;
  string20 product_version;
  string20 reference_number;
  string content_data{blob, maxlength(2000000)};
  unsigned8 __internal_fpos__;
 END;

DS_MVR_Key   := INDEX(Key_Layout,'~key::mvr::inquiry_history::20240131a::trans_id'):persist('DSMVRKey');

//******************************************************************************************************
  
Base_MVR_Layout := RECORD
  string transaction_id;
  string11 product_id;
  string19 date_added;
  string4 process_type;
  string8 processing_time;
  string20 vendor_code;
  string20 request_type;
  string20 product_version;
  string20 reference_number;
  string content_data{blob, maxlength(2000000)};
  string19 date_processed;
 END;

DS_MVR_base := DATASET(ut.foreign_prod+'base::mvr::inquiry_history::qa::id', Base_MVR_Layout, THOR): persist('DSMVRBase');

Days_sample_120 := DS_MVR_base(TRIM(request_type,LEFT,RIGHT)='MVR InsuranceContext' AND trim(vendor_code,left,right)='CONTEXT');
OUTPUT(Days_sample_120,named('Days_sample_120'));
OUTPUT(SORT(Days_sample_120,date_added),named('MinDate_120'));
OUTPUT(SORT(Days_sample_120,-date_added),named('MaxDate_120'));


Days_sample_30 := DS_MVR_base(TRIM(request_type,LEFT,RIGHT)='mvrRoxieRequest' AND trim(vendor_code,left,right)='WORKFLOW');
OUTPUT(Days_sample_30,named('Days_sample_30'));
OUTPUT(SORT(Days_sample_30,date_added),named('MinDate_30'));
OUTPUT(SORT(Days_sample_30,-date_added),named('MaxDate_30'));


Days_sample_365 := DS_MVR_base(TRIM(request_type,LEFT,RIGHT)='customerOutputRespon' AND trim(vendor_code,left,right)='customerOutput');
OUTPUT(Days_sample_365,named('Days_sample_365'));
OUTPUT(SORT(Days_sample_365,date_added),named('MinDate_365'));
OUTPUT(SORT(Days_sample_365,-date_added),named('MaxDate_365'));

//**************************************************************************
//DS_MVR_Key

KeyDays_sample_120 := DS_MVR_Key(TRIM(request_type,LEFT,RIGHT)='MVR InsuranceContext' AND trim(vendor_code,left,right)='CONTEXT');
OUTPUT(KeyDays_sample_120,named('KeyDays_sample_120'));
OUTPUT(SORT(KeyDays_sample_120,date_added),named('KeyMinDate_120'));
OUTPUT(SORT(KeyDays_sample_120,-date_added),named('KeyMaxDate_120'));


KeyDays_sample_30 := DS_MVR_Key(TRIM(request_type,LEFT,RIGHT)='mvrRoxieRequest' AND trim(vendor_code,left,right)='WORKFLOW');
OUTPUT(KeyDays_sample_30,named('KeyDays_sample_30'));
OUTPUT(SORT(KeyDays_sample_30,date_added),named('KeyMinDate_30'));
OUTPUT(SORT(KeyDays_sample_30,-date_added),named('KeyMaxDate_30'));


KeyDays_sample_365 := DS_MVR_Key(TRIM(request_type,LEFT,RIGHT)='customerOutputRespon' AND trim(vendor_code,left,right)='customerOutput');
OUTPUT(KeyDays_sample_365,named('KeyDays_sample_365'));
OUTPUT(SORT(KeyDays_sample_365,date_added),named('KeyMinDate_365'));
OUTPUT(SORT(KeyDays_sample_365,-date_added),named('KeyMaxDate_365'));


IMPORT std,ut;
BuildSubmittedDate :=20240131;
Max_Date         := Std.Date.AdjustDate(BuildSubmittedDate,0,0,-45,);
Min_Date_Back365 := Std.Date.AdjustDate(Max_Date,0,0,-365,);
Min_Date_Back120 := Std.Date.AdjustDate(Max_Date,0,0,-120,);
Min_Date_Back30  := Std.Date.AdjustDate(Max_Date,0,0,-30,);

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

DS_MVR_base     := DATASET(ut.foreign_prod+'base::mvr::inquiry_history::qa::id', Base_MVR_Layout, THOR):persist('DS_MVR_Base');
OUTPUT(DS_MVR_base, named('DS_MVR_base'));
Days_sample_120 := DS_MVR_base(TRIM(request_type,LEFT,RIGHT)='MVR InsuranceContext' AND trim(vendor_code,left,right)='CONTEXT');
Days_sample_30  := DS_MVR_base(TRIM(request_type,LEFT,RIGHT)='mvrRoxieRequest' AND trim(vendor_code,left,right)='WORKFLOW');
Days_sample_365 := DS_MVR_base(TRIM(request_type,LEFT,RIGHT)='customerOutputRespon' AND trim(vendor_code,left,right)='customerOutput');

Filtered_Base := Days_sample_120 + Days_sample_30 + Days_sample_365;
OUTPUT(Filtered_Base, named('Filtered_Base'));

new_layout := RECORD
    RECORDOF(Filtered_Base);
    STRING date_added_modified;
    STRING Is_True;
END;
 
new_layout Modifydate(Filtered_Base l) := TRANSFORM
                                                    newDate    := l.date_added[1..4]+l.date_added[6..7]+l.date_added[9..10];                        
                                                    SELF.date_added_modified := newDate;
                                                    Is_True120 := IF(TRIM(l.request_type,LEFT,RIGHT)='MVR InsuranceContext' AND trim(l.vendor_code,left,right)='CONTEXT' AND (integer)newDate < (integer)Min_Date_Back120, TRUE,FALSE);
                                                    Is_True30  := IF(TRIM(l.request_type,LEFT,RIGHT)='mvrRoxieRequest' AND trim(l.vendor_code,left,right)='WORKFLOW' AND (integer)newDate < (integer)Min_Date_Back30, TRUE,FALSE);
                                                    Is_True365 := IF(TRIM(l.request_type,LEFT,RIGHT)='customerOutputRespon' AND trim(l.vendor_code,left,right)='customerOutput' AND (integer)newDate < (integer)Min_Date_Back365, TRUE,FALSE);
                                                    check      := Is_True120 OR Is_True30 OR Is_True365;
                                                    SELF.Is_True := IF(check,'true','false');
                                                    SELF := l;
END;
Projected_BaseDS := PROJECT(Filtered_Base,Modifydate(LEFT));
OUTPUT(CHOOSEN(Projected_BaseDS,10), named('Projected_BaseDS'));
OUTPUT(Projected_BaseDS(Is_True='true'),named('newDate_EarlierThan_Min120'));

SampleNegativeCases := CHOOSESETS(Projected_BaseDS(Is_True='true'),
                                      TRIM(request_type,LEFT,RIGHT) = 'MVR InsuranceContext' => 10,
                                      TRIM(request_type,LEFT,RIGHT) = 'mvrRoxieRequest' => 10, 10);

OUTPUT(SampleNegativeCases,named('SampleNegativeCases'));

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

DS_MVR_Key   := INDEX(Key_Layout,'~key::mvr::inquiry_history::20240131a::trans_id');
keyNegativeTestcase_120 := DS_MVR_Key(TRIM(transaction_id,left,right)='11128028R94' AND TRIM(request_type,LEFT,RIGHT)='MVR InsuranceContext' AND trim(vendor_code,left,right)='CONTEXT');
keyNegativeTestcase_30 := DS_MVR_Key(TRIM(transaction_id,left,right)='16912261T000181' AND TRIM(request_type,LEFT,RIGHT)='mvrRoxieRequest' AND trim(vendor_code,left,right)='WORKFLOW');
keyNegativeTestcase_365 := DS_MVR_Key(TRIM(transaction_id,left,right)='16912281T000001' AND TRIM(request_type,LEFT,RIGHT)='customerOutputRespon' AND trim(vendor_code,left,right)='customerOutput');

Is120 := IF(EXISTS(keyNegativeTestcase_120),output(keyNegativeTestcase_120,named('Recordsexisted_120')),OUTPUT('No records for -ve testcase 120'));
Is30  := IF(EXISTS(keyNegativeTestcase_30),output(keyNegativeTestcase_30,named('Recordsexisted_30')),OUTPUT('No records for -ve testcase 30'));
//Is365 := IF(EXISTS(keyNegativeTestcase_365),output(keyNegativeTestcase_365,named('Recordsexisted_365')),OUTPUT('No records for -ve testcase 365'));

Actions := PARALLEL(Is120,Is30);
Actions;
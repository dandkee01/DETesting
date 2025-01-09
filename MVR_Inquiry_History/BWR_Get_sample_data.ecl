IMPORT ut, STD;

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

DS_MVR_base := DATASET(ut.foreign_prod+'base::mvr::inquiry_history::qa::id', Base_MVR_Layout, THOR):persist('DSMVRBase');

//*************************************************************************************************

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

//DS_MVR_Key(request_type='GATEWAYCONTROLLERREQ' OR TRIM(vendor_code,LEFT,RIGHT)[1..2]='WORKF');

DS_MVR_base doJoin(DS_MVR_base l,DS_MVR_Key r) := TRANSFORM
  SELF := l;
END;
BASE_KEY_MATCHED := JOIN(DS_MVR_base, DS_MVR_Key,
                    LEFT.vendor_code=RIGHT.vendor_code AND 
                    LEFT.request_type=RIGHT.request_type,doJoin(LEFT,RIGHT)):persist('BASEKEYMATCHED');

//*****************************************************************************************88


Prescreen_Layout := RECORD
  string20 datatype;
  string50 code;
  string2 statepostalcode;
  string5 datasourcecode;
  string translation1{maxlength(100)};
  string translation2{maxlength(100)};
  string translation3{maxlength(100)};
  string translation4{maxlength(100)};
  string translation5{maxlength(100)};
  string translation6{maxlength(100)};
  string translation7{maxlength(100)};
  string translation8{maxlength(100)};
  string translation9{maxlength(100)};
  string translation10{maxlength(100)};
 END;

prescreen_DS :=DATASET(ut.foreign_prod+'thor::mvr::prescreen::build::qa::referencecodes',Prescreen_Layout,THOR):persist('prescreenDS');

prescreen_DS_Filtered := prescreen_DS(translation2 IN ['120','365','30'] AND translation1 <> 'N');

NEWlAY := record
 recordof(DS_MVR_base);
 string translation2;
end; 

NEWlAY doFilter(DS_MVR_base l,prescreen_DS_Filtered r) := TRANSFORM
  SELF.translation2 := r.translation2;  
  SELF := l;
END;

Base_Ds_Sample := JOIN(DS_MVR_base, prescreen_DS_Filtered,
										STD.Str.ToUpperCase(left.request_type)= right.code and
										STD.Str.ToUpperCase(left.vendor_code[1..2]) = right.DataSourceCode[1..2],
										doFilter(LEFT, RIGHT), MANY LOOKUP):persist('baseDsSample');
                    
 OUTPUT(Base_Ds_Sample(translation2='120'),named('sample_120')): persist('sample120');                  
 OUTPUT(Base_Ds_Sample(translation2='365'),named('sample_365')): persist('sample365');                  
 OUTPUT(Base_Ds_Sample(translation2='30'),named('sample_30')): persist('sample30');                   
IMPORT ut,STD;

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

prescreen_DS :=DATASET(ut.foreign_prod+'thor::mvr::prescreen::build::qa::referencecodes',Prescreen_Layout,THOR);

prescreen_DS_Filtered := prescreen_DS(translation2 IN ['120','365','30'] AND translation1 <> 'N');

SampleSet := SORT(CHOOSESETS(prescreen_DS_Filtered,
                            translation2 = '120' => 10,
                            translation2 = '365' => 10, 10),translation2);
                            
SampleSet;                            
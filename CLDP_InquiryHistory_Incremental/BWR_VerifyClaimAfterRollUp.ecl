lay := RECORD
  string14 reference_no;
  string3 unit_no;
  string25 claim_no;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

qa := '~thor::base::clueauto::kcd::20240716::inqhist::claim';
qaDS := DATASET(qa,lay,THOR);
OUTPUT(qaDS(reference_no[1..10] IN ['1111111111','2222222222','3333333333','4444444444','5555555555','6666666666','7777777777','8888888888','9999999999']),named('qaDS'));
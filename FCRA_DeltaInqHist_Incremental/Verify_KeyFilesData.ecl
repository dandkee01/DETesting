Key_subject := RECORD
  unsigned8 did
  =>
  string14 reference_no;
  string3 unit_no;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;



DS_Key_subject   := INDEX(Key_subject,'~thor::key::claimsdiscoveryauto::inqhist::kcd::20240908f::did');
//OUTPUT(DS_Key_subject(did IN [243510411,329594746,36705937238,141856587207,66140222531,70699927557]),named('DS_Key_subject'));
OUTPUT(DS_Key_subject(did IN [34594556604,2346581994,66085168068]),named('DS_Key_subject'));

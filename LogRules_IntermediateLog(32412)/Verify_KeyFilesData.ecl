IMPORT CLUETrans_Build;

Refnum:= CLUETrans_Build.BuildCLUETransactionKeys('20240310ab').key_tranl_Refnum;
OUTPUT(SORT(Refnum,-dt_effective_first),named('Refnum'));
OUTPUT(SORT(Refnum,dt_effective_first),named('Refnumold'));
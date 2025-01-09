IMPORT CLUETrans_BUILD;
#workunit('name','CS FCRA CLUE Transaction - 20240312b')
#workunit('priority','high');
#workunit('priority','10');

BuildDate      := '20240313b';
LogName1       := 'clue_TxLog';
// FlagString1    := '[{\'20240206\', 1633088}, {\'20240207\', 202566}]';
// UniXCount1     := '1835654';
LogName2       := 'clue_Vin_Log';
// FlagString2    := '[{\'20240206\', 475411}, {\'20240207\', 40284}]';
// UniXCount2     := '515695';
LogName3       := 'clue_Person_Log';
// FlagString3    := '[{\'20240206\', 2056920}, {\'20240207\', 235514}]';
// UniXCount3     := '2292434';
LogName4       := 'clue_Claim_Log';
// FlagString4    := '[{\'20240206\', 1461770}, {\'20240207\', 134497}]';
// UniXCount4     := '1596267';
sequential(CLUETrans_BUILD.BuildCLUETransactionBases('20240313b', LogName1,LogName2,LogName3,LogName4/*,UniXCount4,FlagString4*/),CLUETrans_Build.BuildCLUETransactionKeys('20240313b').clue_tranl_keys);

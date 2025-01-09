IMPORT CCLUE_PriorHistory;

#workunit('name','CLUE Commercial Daily Prior History Build - 20240220c');
#OPTION('multiplePersistInstances',FALSE);
CCLUE_PriorHistory.Build_PriorHistory('20240220c');
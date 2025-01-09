IMPORT CCLUE_PriorHistory;
#WORKUNIT('priority','high');  
#WORKUNIT('priority',10);      
#workunit('name','CLUE Commercial Daily Prior History Build - 20240804');
#OPTION('multiplePersistInstances',FALSE);
CCLUE_PriorHistory.Build_PriorHistory('20240804');
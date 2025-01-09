IMPORT CCLUE_PriorHistory;
//#WORKUNIT('priority','high');  
//#WORKUNIT('priority',10);      
#workunit('name','CLUE Commercial Daily Prior History Build - 20241014');
#OPTION('multiplePersistInstances',FALSE);
CCLUE_PriorHistory.Build_PriorHistory('20241014');
#Workunit('priority' ,'high');
#Workunit('priority',10);

Key_subject := RECORD
  string20 transaction_id;
  string30 product_id
  =>
  string30 lex_id;
  string20 suppressionalerts;
  unsigned8 __internal_fpos__;
 END;


DS_Key_subject_P   := INDEX(Key_subject,'~thor::key::fcra::delta_inq_hist::delta_key::20240501::transid');
ProdPulledDS       := PULL(DS_Key_subject_P);
OUTPUT(ProdPulledDS,named('Prod_Lexid_Key_DS'));
OUTPUT(CHOOSEN(ProdPulledDS,500),named('Top500Prod_Lexid_Key_DS'));
OUTPUT(COUNT(ProdPulledDS),named('COUNT_Prod_Lexid_Key'));

DS_Key_subject_D   := INDEX(Key_subject,'~thor::key::fcra::delta_inq_hist::delta_key::20240502::transid');
DevPulledDS        := PULL(DS_Key_subject_D);
OUTPUT(DevPulledDS,named('Dev_Lexid_Key_DS'));
OUTPUT(CHOOSEN(DevPulledDS,500),named('Top500Dev_Lexid_Key_DS'));
OUTPUT(COUNT(DevPulledDS),named('COUNT_Dev_Lexid_Key'));

Lexid_ChangedRecs := DevPulledDS-ProdPulledDS;
OUTPUT(Lexid_ChangedRecs,named('Lexid_ChangedRecs'));
OUTPUT(COUNT(Lexid_ChangedRecs),named('COUNT_Lexid_ChangedRecs'));
Lexid_notChangedRecs := DevPulledDS-Lexid_ChangedRecs;
OUTPUT(COUNT(Lexid_notChangedRecs),named('COUNT_Lexid_notChangedRecs'));

//---------------------------------------------------------------------------------------------------------------------------------------------------------
// Data Verification

DS1 := DISTRIBUTE(ProdPulledDS,HASH32(product_id,transaction_id));
DS2 := DISTRIBUTE(DevPulledDS,HASH32(product_id,transaction_id));
                    
OUTPUT(SORT(DS1,product_id,transaction_id,LOCAL),named('sorted_DS1'));
OUTPUT(SORT(DS2,product_id,transaction_id,LOCAL),named('sorted_DS2'));

NewRec := RECORD  
  string30 lex_id_Before;
  string30 lex_id_After;
  string30 lex_id;
  string30   product_id;
  string20  transaction_id;
  string    Lexid_Changed;
END;
 

NewRec doJoin(DS2 L,DS1 R) := TRANSFORM
  SELF.Lex_id_Before := R.Lex_id;  
  SELF.Lex_id_After  := L.Lex_id; 
  isLexidChanged     := R.Lex_id=L.Lex_id;
  SELF.Lexid_Changed := IF(~isLexidChanged,'TRUE','FALSE');
  SELF := L;
END;
JoinedDS := DEDUP(SORT(JOIN(DS2, DS1,                   
                    LEFT.product_id = RIGHT.product_id AND
                    LEFT.transaction_id = RIGHT.transaction_id 
                    ,doJoin(LEFT, RIGHT),LEFT OUTER, LOCAL),product_id,transaction_id),product_id,transaction_id):INDEPENDENT;

OUTPUT(CHOOSEN(JoinedDS(Lexid_Changed='TRUE' AND lex_id_before<>'' ),500), named('LexidChanged_Set'));
OUTPUT(JoinedDS(Lexid_Changed='FALSE' AND lex_id_before<>''), named('LexidNotChanged_Set'));
OUTPUT(COUNT(JoinedDS), named('JoinedDS_Count'));
OUTPUT(JoinedDS, named('JoinedDS'));

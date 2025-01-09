Lay := RECORD
  string9 account_no;
  string40 account_name;
  string5 cust_no;
  string1 bill_as;
  string1 report_as;
  string40 cust_name;
  unsigned8 record_sid;
  unsigned4 dt_effective_first;
  unsigned4 dt_effective_last;
  unsigned1 delta_ind;
 END;

/*Run1File := '~thor::base::clueauto::kcd::20240729::daily::account::requirements';
Run1DS := DATASET(Run1File,Lay,Thor);

//OUTPUT(Run1Ds(account_no IN['111111','111112','111113','111114','111115','111116','111117','111118','111119','111110','222220']),named('Run1Ds'));
OUTPUT(Run1Ds(dt_effective_first=20240729),named('Run1Dsn'));
OUTPUT(Run1Ds(dt_effective_first NOT IN [20240729]),named('Run1Dsn_Baseline'));
OUTPUT(COUNT(Run1Ds(dt_effective_first NOT IN [20240729])),named('Run1Dsn_Baseline_Cnt'));


Run2File := '~thor::base::clueauto::kcd::20240730::daily::account::requirements';
Run2DS := DATASET(Run2File,Lay,Thor);

//OUTPUT(Run2Ds(account_no IN['111111','111112','111113','111114','111115','111116','111117','111118','111119','111110','222220']),named('Run2Ds'));
OUTPUT(Run2Ds(dt_effective_first IN[20240730,20240729]),named('Run2Dsn'));
OUTPUT(Run2Ds(dt_effective_first NOT IN [20240730,20240729]),named('Run2Dsn_Baseline'));
OUTPUT(COUNT(Run2Ds(dt_effective_first NOT IN [20240730,20240729])),named('Run2Dsn_Baseline_Cnt'));

*/


Run3File := '~thor::base::clueauto::kcd::20240731::daily::account::requirements';
Run3DS := DATASET(Run3File,Lay,Thor);

//OUTPUT(Run3DS(account_no IN['111111','111112','111113','111114','111115','111116','111117','111118','111119','111110','222220']),named('Run3DS'));
OUTPUT(Run3DS(dt_effective_first IN[20240731,20240730,20240729]),named('Run3DSn'));
OUTPUT(Run3DS(dt_effective_first NOT IN [20240731,20240730,20240729]),named('Run3DSn_Baseline'));
OUTPUT(COUNT(Run3DS(dt_effective_first NOT IN [20240731,20240730,20240729])),named('Run3DSn_Baseline_Cnt'));

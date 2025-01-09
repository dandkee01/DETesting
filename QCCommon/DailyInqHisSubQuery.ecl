IMPORT CLUEAuto_InquiryHistory,CLUEAuto_Delta;
InqSubj_DS := DATASET('~thor::base::clueauto::kcd::qa::delta_key_subject.txt',CLUEAuto_Delta.Layouts.Delta_Subject,THOR);
InqSubj_DS;

rec := RECORD
InqSubj_DS.reference_number;
cnt := COUNT(GROUP);
END;
Mytable := TABLE(InqSubj_DS,rec,reference_number, transaction_id); 
Mytable(cnt!=1);  

ds := InqSubj_DS( reference_number='23016231210727' AND subject_first_name='MARIA');

RECORDOF(ds) CalcAges(ds l) := TRANSFORM
  SELF.did := 241428052187;
  SELF.date_added := '2023-01-18 00:00:00';
  SELF.order_date := '20230117';
  SELF.process_date := '20230117';
  SELF := l;
END;
MockedDs := PROJECT(ds, CalcAges(LEFT));
MockedDs;

   DateToday             := (STRING)STD.date.Today();
   fileName              := 'DidmismatchCase.txt';
   LandingZone_File_Dir  := '/data/orbittesting/deltaclue/process/dandke01/process/';
   lzFilePathBaseFile    := LandingZone_File_Dir + fileName; 
   LandingZoneIP         := _control.IPAddress.unixland;//10.194.72.227//
   TempCSV               := '~thor::base::CLDACon::KCD::CSV';

/*---------------------------------------------------------------------------------*/
outputBaseAsCSV   := OUTPUT(DS_NewExist,,TempCSV,CSV(HEADING(SINGLE), QUOTE('"'), SEPARATOR(','),NOTRIM),OVERWRITE);
 deSprayCSV        := STD.File.DeSpray(TempCSV,LandingZoneIP,lzFilePathBaseFile,-1,,,TRUE);
 
 delCSV := NOTHOR(FileServices.DeleteLogicalFile(TempCSV));
 Actions := SEQUENTIAL(deSprayCSV,delCSV);
                                 
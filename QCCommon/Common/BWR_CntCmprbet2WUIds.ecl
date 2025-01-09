
//STRING Wuid1 :='W20230516-163853'; clue property
//STRING Wuid1 :='W20230523-102848';clue property
//STRING Wuid2 :='W20230516-215627';clue property
STRING Wuid1 :='W20240612-232459'; // prod wuid
STRING Wuid2 := 'W20240705-000230'; // dev wuid with changes

ds1 := CountCmp_Btw2WUIDs(Wuid1,'20240612');
OUTPUT(ds1,named('ds1'));
ds2 := CountCmp_Btw2WUIDs(Wuid2,'20240701f');
OUTPUT(ds2,named('ds2'));

   outrec := RECORD
      STRING filebefore;
      integer reccountbefore;
      STRING fileafter;
      integer reccountafter;
      boolean iscountDiff;
      integer difference;
   END;
   
combined1 := JOIN(ds1, ds2, LEFT.filteredname=RIGHT.filteredname, 
                     TRANSFORM(outRec, 
                               SELF.filebefore     := LEFT.file;
                               SELF.reccountbefore := LEFT.reccount;
                               SELF.fileafter      := RIGHT.file;
                               SELF.reccountafter  := RIGHT.reccount;
                               self.iscountdiff    := IF(LEFT.reccount=RIGHT.reccount,false,true);
                               self.difference     := left.reccount-right.reccount));
combined1; 

diffCount := combined1(iscountdiff=true);
diffCount;

//output(combined1,,'~thor::kcd::clueauto::keycountcmp',OVERWRITE);
//output(combined1,,'~thor::kcd::clueproperty::keycountcmp',OVERWRITE);
//output(combined1,,'~thor::kcd::CLDA::keycountcmp',OVERWRITE);


// ds2 := CountCmp_Btw2WUIDs('W20230516-215627');
// OUTPUT(ds2,named('ds2'));
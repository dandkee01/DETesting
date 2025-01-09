IMPORT STD;

MySuperFile1 := '~thor::base::clueproperty::qa::account::requirements';
MySuperFile2 := '~thor::base::clueproperty::qa::inqhist::subject';

STD.File.ClearSuperFile('MySuperFile1',false);
STD.File.ClearSuperFile('MySuperFile2',false);




// a1 := STD.File.RenameLogicalFile('~thor::base::clueproperty::20240916::account::requirements','~thor::base::clueproperty::20240916a::account::requirements');
// a2 := STD.File.RenameLogicalFile('~thor::base::clueproperty::20240916::inqhist::subject','~thor::base::clueproperty::20240916a::inqhist::subject');

// a3 := SEQUENTIAL(b1,b2,a1,a2);
// a3;
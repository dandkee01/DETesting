IMPORT STD;


B := SEQUENTIAL(
 STD.File.StartSuperFileTransaction(),
 STD.File.ClearSuperFile('~base::mbsi::inquiry_history::father::id'),
 STD.File.FinishSuperFileTransaction()
);

A := STD.File.RenameLogicalFile('~base::mbsi::inquiry_history::20240524a::id', '~base::mbsi::inquiry_history::20240524::id');
SEQUENTIAL(B,A);
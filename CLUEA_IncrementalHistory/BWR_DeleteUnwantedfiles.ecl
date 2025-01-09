IMPORT STD;
 
    // FilePattern := 
    BOOLEAN DeleteProtectedFiles := TRUE; // change it to TRUE if you want to delete your protected files also.
    // 2023-09-23T10:08:26

    AllFiles := NOTHOR(STD.File.LogicalFileList('*clueauto*20241110*', TRUE,TRUE)(modified[1..10] <= '2024-11-14' and owner IN [ 'Dandke01','dandke01']  and cluster IN ['hthor__dev_eclagent_1','thor400_198', 'thor20_167_dev','thor400_126','thor20_166_sta']));
    
    AllFilesDS := AllFiles;
    // FsLogicalFileInfoRecord
 
    AllFilesWithOwnersDS :=    NOTHOR(
        PROJECT(
            GLOBAL(AllFilesDS, FEW),
            TRANSFORM(
                {LEFT.Name, DATASET(FsLogicalFileNameRecord ) LogicalFileSuperOwners},
                SELF.Name := LEFT.Name;
                SELF.LogicalFileSuperOwners := STD.File.LogicalFileSuperOwners('~' + LEFT.Name);
            )
        )
    );
 
    RemoveSuperFileDS := NORMALIZE(
        GLOBAL(AllFilesWithOwnersDS, FEW),
        LEFT.LogicalFileSuperOwners,
        TRANSFORM(
            {STRING SuperFilePath, STRING FilePath},
            SELF.FilePath := LEFT.Name;
            SELF.SuperFilePath := RIGHT.Name;
        )
    );
    DeleteFile(STRING Name, BOOLEAN IsSuperFile) := IF(
        IsSuperFile,
        STD.File.DeleteSuperFile(Name)/*output('superfiles are not getting deleted')*/,
        SEQUENTIAL(
            IF(DeleteProtectedFiles, STD.File.ProtectLogicalFile(Name, FALSE)),
            STD.File.DeleteLogicalFile(Name)
        )
    );
 
        SEQUENTIAL(
            NOTHOR(
                APPLY(
                    GLOBAL(RemoveSuperFileDS, FEW),
                    STD.File.RemoveSuperFile('~' + SuperFilePath, '~' + FilePath)
                )
            ),    
            NOTHOR(
                APPLY(
                    GLOBAL(AllFilesDS, FEW),
                    DeleteFile('~' + Name, SuperFile)
                )
            )
        );
IMPORT STD;

Struct := RECORD
  STRING FileName;
END;

 SHARED Ds := DATASET([{'~thor::base::claimsdiscoveryauto::kcd::20230702::daily::inqhist::subject'},
         {'~thor::base::claimsdiscoveryauto::kcd::20230702::daily::inqhist::claim'},
         {'~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::20230702f::payload'},
         {'~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::20230702f::address'},
         {'~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::20230702f::citystname'},
         {'~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::20230702f::name'},
         {'~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::20230702f::policy'},
         {'~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::20230702f::dlno'}],Struct);
         
 
 EXPORT GetLogicalList(STRING File) := FUNCTION
    SuperOwners := STD.File.LogicalFileSuperowners(File);
   RETURN SuperOwners;
 END;

 // GetList := NOTHOR(APPLY(Ds,GetLogicalList(FileName)));
 // GetList;
 
 // GetLogicalList('~thor::base::claimsdiscoveryauto::kcd::20230702::daily::inqhist::subject');
 // GetLogicalList('~thor::base::claimsdiscoveryauto::kcd::20230702::daily::inqhist::claim');
 // GetLogicalList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::20230702f::payload');
 // GetLogicalList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::20230702f::address');
 // GetLogicalList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::20230702f::citystname');
 // GetLogicalList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::20230702f::name');
 // GetLogicalList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::20230702f::policy');
 // GetLogicalList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::20230702f::dlno');
 // GetLogicalList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::20230702f::ssn2');
 // GetLogicalList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::20230702f::stname');
 // GetLogicalList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::20230702f::zip');
 // GetLogicalList('~thor::key::claimsdiscoveryauto::inqhist::kcd::20230702f::did');
 // GetLogicalList('~thor::key::claimsdiscoveryauto::inqhist::kcd::20230702f::refno::claim');
 // GetLogicalList('~thor::key::claimsdiscoveryauto::inqhist::kcd::20230702f::inquiry');
 // GetLogicalList('~thor::key::claimsdiscoveryauto::inqhist::kcd::20230702f::custno');
 // GetLogicalList('~thor::key::claimsdiscoveryauto::inqhist::kcd::20230702f::deltadate');
 
 EXPORT GetSuperFileList(STRING File) := FUNCTION
    SuperOwners := STD.File.SuperFileContents(File);
   RETURN SuperOwners;
 END;
GetSuperFileList('~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::subject');
 GetSuperFileList('~thor::base::claimsdiscoveryauto::kcd::qa::inqhist::claim');
 GetSuperFileList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::payload_qa');
 GetSuperFileList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::address_qa');
 GetSuperFileList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::citystname_qa');
 GetSuperFileList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::name_qa');
 GetSuperFileList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::policy_qa');
 GetSuperFileList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::dlno_qa');
 GetSuperFileList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::ssn2_qa');
 GetSuperFileList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::stname_qa');
 GetSuperFileList('~thor::key::claimsdiscoveryauto::inqhist::kcd::autokey::zip_qa');
 GetSuperFileList('~thor::key::claimsdiscoveryauto::inqhist::kcd::did_qa');
 GetSuperFileList('~thor::key::claimsdiscoveryauto::inqhist::kcd::refno::claim_qa');
 GetSuperFileList('~thor::key::claimsdiscoveryauto::inqhist::kcd::inquiry_qa');
 GetSuperFileList('~thor::key::claimsdiscoveryauto::inqhist::kcd::custno_qa');
 GetSuperFileList('~thor::key::claimsdiscoveryauto::inqhist::kcd::deltadate_qa');
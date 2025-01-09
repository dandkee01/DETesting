/* EXPORT fun_LayoutCompare(STRING file,STRING prod_file) := FUNCTION
 IMPORT STD,DATA_SERVICES;
    
   Dev_DS := DATASET([{STD.File.GetLogicalFileAttribute(file,'ECL'),file,STD.File.GetLogicalFileAttribute(file,'recordCount')}], {STRING Layout,STRING file,UNSIGNED8 RecCount});
   Prod_Ds := DATASET([{STD.File.GetLogicalFileAttribute(DATA_SERVICES.FOREIGN_PROD+prod_file,'ECL'),prod_file,STD.File.GetLogicalFileAttribute(DATA_SERVICES.FOREIGN_PROD+prod_file,'recordCount')}],{STRING Layout,STRING file,UNSIGNED8 RecCount});
   fin_DS := Dev_DS + Prod_Ds;
   RETURN fin_DS;
 
 END; 
*/ 
 
 EXPORT fun_LayoutCompare(STRING file) := FUNCTION
 IMPORT STD,DATA_SERVICES;
    
  Dev_DS := DATASET([{file,STD.File.GetLogicalFileAttribute(file,'recordCount')}], {STRING file,UNSIGNED8 RecCount});
  
 RETURN Dev_DS;
 
 END;

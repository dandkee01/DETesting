    IMPORT FCRA_Inquiry_History;
    
    MarketingSprayDS									 := FCRA_Inquiry_History.Files.read_Marketing_FCRA_Spray_File;
    FilterKeyDS1				 				       := MarketingSprayDS(posting_status = 'R' and order_status_code IN [100,101]);
    FilterKeyDS                        := MarketingSprayDS-FilterKeyDS1;   
    OUTPUT(COUNT(MarketingSprayDS),named('TotalRecsCount_MarketingSprayDS'));
    OUTPUT(COUNT(FilterKeyDS1),named('FilteredRecsCount_MarketingSprayDS'));
    OUTPUT(MarketingSprayDS(posting_status != 'R'),Named('OtherRecs_MarketingSprayDS'));
    
  
IMPORT FCRA_Inquiry_History;

Spray_DS := DATASET('~spray::fcra::delta_inq_hist::delta_key::w20240927-094142', FCRA_Inquiry_History.Layouts.delta_base_Layout,CSV(MAXLENGTH(2000000), SEPARATOR('|\t|'), TERMINATOR('|\n')),OPT);    
Spray_DS;
COUNT(Spray_DS);
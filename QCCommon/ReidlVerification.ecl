IMPORT dx_Consumer_Header;
keyds := PULL(dx_Consumer_Header.key_lexid_corrections);
output(keyds,named('keyds'));
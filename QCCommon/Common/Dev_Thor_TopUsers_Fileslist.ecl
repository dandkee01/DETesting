IMPORT STD;
dsThor400Files := NOTHOR(STD.File.LogicalFileList()(cluster = 'thor400_198' /*and owner IN ['isagi','svc_vault']*/));


choosen(sort(dsThor400Files,-size),100);
choosen(sort(dsThor400Files,-modified),100);

ownercnt := table (dsThor400Files, {owner, cnt := COUNT(group)}, owner);
ownersize := table (dsThor400Files, {owner, totalsize := sum(GROUP, size)}, owner);
output(sort(ownercnt, -cnt));
output(sort(ownersize, -totalsize));
output(SUM(dsThor400Files,size));
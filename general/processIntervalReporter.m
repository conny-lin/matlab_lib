function processIntervalReporter(nfiles,itrgap,name,it_current)

    if ismember(it_current,1:itrgap:nfiles) == 1
        fprintf('%s: %d/%d\n',name,it_current,nfiles);
    end
end
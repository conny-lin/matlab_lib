function loopreporter(it_current,name,itrgap,nfiles)
if nargin==1
    fprintf('- %d\n',it_current);
end
if nargin==2
    fprintf('%s: %d\n',name,it_current);
end
if nargin==3
    if isinteger(it_current/itrgap)
        fprintf('%s: %d\n',name,it_current);
    end
end
if nargin==4
    if ismember(it_current,1:itrgap:nfiles) == 1
        fprintf('%s: %d/%d\n',name,it_current,nfiles);
    end
end

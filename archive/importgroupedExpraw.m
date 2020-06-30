function [Expfdat,Groupf,pGroupf] = importgroupedExpraw(ext,pExp,except)
[~,~,Groupf,pGroupf] = dircontentexcept(pExp,except);
for x = 1:size(pGroupf,1);
    [A] = importsumdata2(pGroupf{x,1},ext,5,1); % import Exp summary data
    Expfdat.(Groupf{x,1}) = A;
end
if isempty(Expfdat)==1; % status reporting
    display('no summary data...');
else
    display('summary data imported...');
end
end
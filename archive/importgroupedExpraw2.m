function [Expfdat,Groupf,pGroupf] = importgroupedExpraw2(ext,pExp,except)
[~,~,Groupf,pGroupf] = dircontentexcept(pExp,except);
for x = 1:size(pGroupf,1);
    [A] = importsumdata2(pGroupf{x,1},ext,5,1); % import Exp summary data
    % evaluate if folder name has no space
    if isempty(strfind(Groupf{x,1},' '))==0; % if folder name has a space
        % replace the space with _
        fname = regexprep(Groupf{x,1},' ','_');
    else
        fname = Groupf{x,1};
    end
    Expfdat.(fname) = A;
end
if isempty(Expfdat)==1; % status reporting
    display('no summary data...');
else
    display('summary data imported...');
end
end

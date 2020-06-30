function [MWTfsn] = getMWTfdatsamplename(ext,MWTf,pMWTf)
%[MWTfdata] = importmwtdata2(ext,MWTf,r,c,pExp)
% MWTf = list of MWTfile name, ext = '*.trv'; r = 5; c = 1;
MWTfsn = MWTf;
for x = 1:size(pMWTf,1); % for each MWTf
p = pMWTf{x,1}; % get path
cd(p); % go to path
a = dir(ext); % list content
a = {a.name}'; % get just the name of the file
if (isempty(a) == 0); % if only one file with ext
    MWTfsn{x,2} = a{1}(1:end-4); % name of file imported     
else % in other situations
    warning('Nothing imported for %s from %s',ext,MWTf{x,1});
end
end

end  
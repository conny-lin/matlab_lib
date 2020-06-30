function [MWTfdata] = importmwtdata3(ext,MWTf,r,c,pMWTf)
%[MWTfdata] = importmwtdata2(ext,MWTf,r,c,pExp)
% MWTf = list of MWTfile name, ext = '*.trv'; r = 5; c = 1;
A = MWTf;
for x = 1:size(pMWTf,1); % for each MWTf
    p = pMWTf{x,1}; % get path
    cd(p); % go to path
    a = dir(ext); % list content
    a = {a.name}'; % get just the name of the file
    if (isempty(a) == 0)&&(size(a,1)==1); % if only one file with ext
        A(x,2) = a; % name of file imported
        A{x,3} = dlmread(a{1},' ',r,c); % import .trv file
    elseif (isempty(a) == 0)&&(size(a,1)>1); % if more than one file with ext
        for xs = 1:size(a,1);
            A{x,2}(xs,1) = a; % name of file imported
            A{x,3}{xs,1} = dlmread(a{1},' ',r,c); % import .trv file
        end   
    else % in other situations
        warning('Nothing imported for %s',ext);
    end
end
MWTfdata = A;
end
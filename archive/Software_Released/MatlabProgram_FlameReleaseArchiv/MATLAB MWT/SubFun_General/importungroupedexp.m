function [Expfdat,MWTftrv,MWTfdat] = importungroupedexp(pExp2)
%% Import sum.dat, MWTf .dat and .trv from ungrouped data
[Expfdat] = importsumdata2(pExp2,'*.dat',5,1); % import Exp summary data
if isempty(Expfdat)==1; % status reporting
    display('no summary data...');
else
    display('summary data imported...');
end
% import MWT files
[~,~,MWTf,pMWTf] = dircontent(pExp2); % get path to MWTf
[T] = validateMWTfn(MWTf,pMWTf); % check if all folders are MWTf
if isequal(sum(T),size(MWTf,1))==1; % if all folders validated as MWT folder
    [MWTftrv] = importmwtdata2('*.trv',MWTf,5,0,pExp2);
    [MWTfdat] = importmwtdata2('*.dat',MWTf,0,0,pExp2);
else
    error('[BUG] some folders are not MWT folders...');
end
end


function [a,b,c,d] = dircontent(p)
%% get directory content
% a = full dir, can be folder or files, b = path to all files, 
% c = only folders, d = paths to only folders
cd(p); % go to directory
a = {}; % create cell array for output
a = dir; % list content
a = {a.name}'; % extract folder names only
a(ismember(a,{'.','..','.DS_Store'})) = []; 
b = {};
c = {};
d = {};
for x = 1:size(a,1); % for all files 
    b(x,1) = {strcat(p,'/',a{x,1})}; % make path for files
    if isdir(b{x,1}) ==1; % if a path is a folder
        c(end+1,1) = a(x,1); % record name in cell array b
        d(end+1,1) = b(x,1); % create paths for folders
    else
    end
end
end

function [Expfdat] = importsumdata2(pExp,ext,r,c)
%% Import summary data from pExp
% [NEED USING IT] import .dat file 
% i.e. ext = '*.dat';
cd(pExp); % go to path
a = dir(ext); % list content
a = {a.name}'; % get just the name of the file
d = {};
for x = 1:size(a,1);
    d(x,1) = a(x,1); % name of file imported
    d{x,2} = dlmread(a{1},' ', r,c); % import 
end
Expfdat = d;
end

function [MWTfdata] = importmwtdata2(ext,MWTf,r,c,pExp2)
%% import MWTf data
%[MWTfdata] = importmwtdata2(ext,MWTf,r,c,pExp)
% MWTf = list of MWTfile name, ext = '*.trv'; r = 5; c = 1;
A = MWTf;
for x = 1:size(MWTf,1); % for each MWTf
    p = strcat(pExp2,'/',A{x,1}); % get path
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

function [T] = validateMWTfn(MWTf,pMWTf)
%% make sure the dir is a MWT folder (20130407_153802)
T = [];
for x = 1:size(MWTf,1);
    % set conditions
    c1 = isequal(isdir(pMWTf{x,1}),1); % c1=1 if it is a dir
    c2 = isequal(size(MWTf{x,1},2),15); % c2=1 if name is 15 characters
    c3 = isequal(strfind(MWTf{x,1},'_'),9); % c3=1 if _ at position9
    c4 = isnumeric(str2num(MWTf{x,1}(1:8))); % first 8 digit numeric
    c5 = isnumeric(str2num(MWTf{x,1}(10:15))); % last 6 digit numeric
    if (c1+c2+c3+c4+c5) ==5; % if satisfies all 5 conditions
        T(x,1) = 1; % record pass
    else
        T(x,2) = 0; % record fail
    end
end
end


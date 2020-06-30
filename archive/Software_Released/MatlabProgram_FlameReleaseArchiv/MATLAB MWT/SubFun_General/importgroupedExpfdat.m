function [ExpfdatGR,MWTfGrecord,pGroupf] = importgroupedExpfdatnremovegroupfolder(pExp)
% import grouped Expfdat to ungrouped format
[~,~,Groupf,pGroupf] = dircontent(pExp);
MWTfGrecord = {};
MWTf = {};
pMWTf = {};
A = {};
for x = 1:size(pGroupf,1);
    [~,~,f,pf] = dircontent(pGroupf{x,1});
    % reorganize summary data   
    % get directory and put a copy of which MWTf belongs to which
    MWTf = cat(1,MWTf,f);
    pMWTf = cat(1,pMWTf,pf);
    A(:,1) = num2cell(x); % get group index
    A(1:size(f,1),4) = Groupf(x,1);
    A(1:size(f,1),3) = f; 
    A(:,2) = num2cell((1:size(f,1))');
    MWTfGrecord = cat(1,MWTfGrecord,A);
end
I(:,1:2) = MWTfGrecord(:,1:2);
I(:,3) = num2cell((1:size(MWTfGrecord))');
I(:,4) = MWTfGrecord(:,3);
I(:,5) = pMWTf;
I = sortrows(I,4);

% set up Expfdat
[A] = importsumdata2(pGroupf{1,1},'Tap*',5,1);
ExpfdatGR = A(:,1);
% reassemble
B = [];
for x = 1:size(pGroupf,1);   
    [A] = importsumdata2(pGroupf{x,1},'Tap_Dist*',5,3); % get summary data
    % take out data
    B = cat(2,B,A{1,2}(:,1:end-1));
end  
% rearrange
D = [];
for x = 1:size(I,1);
    C = B(:,I{x,3});
    D = cat(2,D,C);
end
ExpfdatGR{1,2} = cat(2,A{1,2}(:,1:2),D,A{1,2}(:,end));


% repeat for Tap_Freq
B = [];
for x = 1:size(pGroupf,1);   
    [A] = importsumdata2(pGroupf{x,1},'Tap_Freq*',5,3); % get summary data
    % take out data
    B = cat(2,B,A{1,2}(:,1:end-1));
end  
% rearrange
D = [];
for x = 1:size(I,1);
    C = B(:,I{x,3});
    D = cat(2,D,C);
end
ExpfdatGR{2,2} = cat(2,A{1,2}(:,1:2),D,A{1,2}(:,end));


% move folders up to pExp
for x = 1:size(pGroupf);
    [~,~,~,p] = dircontent(pGroupf{x,1});
    for y = 1:size(p,1);
        movefile(p{y,1},pExp);
    end
end

% move group files
cd(pExp);
mkdir('UngroupRecord');
p = strcat(pExp,'/','UngroupRecord');
for x = 1:size(pGroupf,1);
    movefile(pGroupf{x,1},p);
end
% save ungroup record
cd(p);
UngroupRecord = I;
[savename] = creatematsavename(pExp,'UngroupRecord','.mat'); % create save name
save(savename,'UngroupRecord');

end


%% SF
function [a,b,c,d] = dircontent(p)
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
function [Expfdat] = importsumdata2(p,ext,r,c)
% Import data from pExp
% [NEED USING IT] import .dat file 
% i.e. ext = '*.dat';
cd(p); % go to path
a = dir(ext); % list content
a = {a.name}'; % get just the name of the file
d = {};
for x = 1:size(a,1);
    d(x,1) = a(x,1); % name of file imported
    d{x,2} = dlmread(a{1},' ', r,c); % import 
end
Expfdat = d;
end

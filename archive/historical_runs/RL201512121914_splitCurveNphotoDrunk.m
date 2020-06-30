%% get plate image for visual inspection
pSaveHome = fileparts(fileparts(mfilename('fullpath')));
programName = 'Dance_Glee_Preggers';
analysisNLimit = 0;
exp_exclusion = {};
plate_exclusion = {};

% get plate pictures
pSave = [pSaveHome,'/plate image'];
if isdir(pSave) == 0; mkdir(pSave); end

% load included exp
str = sprintf('%s/Dance_Glee_Preggers/mwt_summary included.csv',pSaveHome);
T = readtable(str);
pMWT = T.mwtpath;

addpath('/Users/connylin/Dropbox/RL/Code/Modules/Dance/Dance_DrunkMoves');
MWTSet = Dance_DrunkMoves(pMWT,'timeStartSet',75,'timeIntSet',10,'timeAssaySet',10,...
    'timeEndSet',96,'pSave',pSaveHome);




%% get curve
D = MWTSet.Import.drunkposture2;

% visual examination suspects plates below are 400mM not 0mM, exclude
excludePlates = {'20120928_214158', '20150423_141445' '20130702_193557'};
[~,j] = ismember(excludePlates, MWTSet.Info.VarIndex.mwtname);
D(ismember(D.mwtname,j),:) = [];

% get only time frame of interest (75-95s curve are pretty stable)
D(D.time < 75 | D.time > 95,:) = [];

%% get curve mean and SD of control group
[~,j] = ismember('N2',MWTSet.Info.VarIndex.groupname);
i = D.groupname == j;
d = D.curve(i);
m = mean(d); 
s = std(d);
% get range
a = m-(2*s);
b = m+(2*s);

%% find MWT plates with curve lower than threshold, higher than threshold and similar to N2
[~,j] = ismember('N2_400mM',MWTSet.Info.VarIndex.groupname);
i = D.groupname == j;
d = D.curve(i);
g = D.mwtname(i);
% get mean
[mn,gn,sd] = grpstats(d,g,{'mean','gname','std'});
t = table;
t.mwtname = MWTSet.Info.VarIndex.mwtname(cellfun(@str2num,gn));
t.mean = mn;
t.mean_lower = mn - (2*sd);
t.mean_upper = mn + (2*sd);

%% get plate with curve smaller than N2
A = cell(size(t,1),1);
A(t.mean_upper < a) = {'flatter curve'};
A(t.mean_lower > b) = {'curvier curve'};
A(cellfun(@isempty,A)) = {'same as N2'};
t.cmp2N2 = A;

writetable(t,sprintf('%s/Dance_DrunkMoves/curve comparison with N2.csv',pSaveHome))


%% pull images of not drunk worms
pImage = '/Users/connylin/Dropbox/RL/PhD/Chapters/2-STH N2/Data/10sISI/1-All Exp/plate image';
[f,p] = dircontent(pImage);
mwtname_image = regexpcellout(f,'\d{8}_\d{6}(?=[.]png)','match');
mwtname_bad = t.mwtname(ismember(t.cmp2N2,{'same as N2'}));
i = ismember(mwtname_image,mwtname_bad);
imageTarget = p(i);
imageTargetFileName = f(i);
pSaveA = [pSaveHome,'/plate image no alcohol effect'];
if isdir(pSaveA) == 0; mkdir(pSaveA); end
for x = 1:numel(imageTarget)
    ps = imageTarget{x};
    pd = [pSaveA,'/',imageTargetFileName{x}];
    copyfile(ps,pd);
end





























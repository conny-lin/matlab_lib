%% run Dance_Glee_Preggers
pSaveHome = '/Users/connylin/Dropbox/RL/PhD/Chapters/2-STH N2/Data/10sISI/1-All Exp';
programName = 'Dance_Glee_Preggers';
% add fun path
addpath('/Users/connylin/Dropbox/Code/Matlab/General');
analysisNLimit = 0;
exp_exclusion = {};


%% load MWTset to find which mwtname has threhold lower than 0.6
% define thresholds
ythreshold = 0.6; % define y threshold
tthreshold = Inf; % define time threshold as all time points
msr = 'RevSpeed';
% load
str = sprintf('%s/Dance_Glee_Preggers Include/Dance_Glee_Preggers.mat',pSaveHome);
load(str);
a = MWTSet.Data.trv.(msr).mean;
% find plates over threshold
mwtname_exclude_threshold = MWTSet.Data.trv.(msr).mwtname(any(a > 0.6));

%% get plate validation file and add more 
cd(pSaveHome)
[~, ~, A] = xlsread(sprintf('%s/mwt_summary included.xlsx',pSaveHome),...
    'mwt_summary included.csv');
A = A(2:end,:);
A(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),A)) = {''};
A = cell2table(A,'VariableNames',{'mwtpath','expname','groupname','mwtname','issues','drunk_status','decision','curve_status','note'});
i = ~ismember(A.curve_status,'same as N2') ...
    & ~ismember(A.issues,{'fuzzy looks like 400mM worms','mostly small worms','looks like drunk worm','wet plate','wet plate suspect to be 400mM','worms clump and too small','worms clumping maybe is npr-1 check','uneven light wet plate','some clumping and is npr1 exp'});
mwtpath_include = A.mwtpath(i);
mwtpath_exclude = A.mwtpath(~i);
mwtname_include = A.mwtname(i);
mwtname_exclude = A.mwtname(~i);


%% add it to general exclude list
i = ismember(mwtname_exclude_threshold,mwtname_include);
mwtpath_include(i)

%% pull images of not drunk worms
% define variables
mwtname_bad = mwtname_exclude_threshold; % get bad mwt plate name
suffix = 'speed over point 6';
pSave = pSaveHome;
% get images
pImage = '/Users/connylin/Dropbox/RL/PhD/Chapters/2-STH N2/Data/10sISI/1-All Exp/plate image';
[f,p] = dircontent(pImage);
mwtname_image = regexpcellout(f,'\d{8}_\d{6}(?=[.]png)','match');
i = ismember(mwtname_image,mwtname_bad);
imageTarget = p(i);
imageTargetFileName = f(i);
pSaveA = sprintf('%s//plate image %s',pSave,suffix);
if isdir(pSaveA) == 0; mkdir(pSaveA); end
for x = 1:numel(imageTarget)
    ps = imageTarget{x};
    pd = [pSaveA,'/',imageTargetFileName{x}];
    copyfile(ps,pd);
end


%% run Preggers for excluded files
pMWT = mwtpath_exclude;
outputsuffix = 'Excluded';
% run
pSave = pSaveHome;
if isdir(pSave) == 0; mkdir(pSave); end
addpath('/Users/connylin/Dropbox/RL/Code/Modules/Dance/Dance_Glee');
MWTSet = Dance_Glee_Preggers(pMWT,'pSave',pSave,'outputsuffix',outputsuffix,'saveimport',0);

%% run Preggers for included files
pMWT = mwtInclude;
outputsuffix = 'Include';
% run
pSave = pSaveHome;
if isdir(pSave) == 0; mkdir(pSave); end
addpath('/Users/connylin/Dropbox/RL/Code/Modules/Dance/Dance_Glee');
MWTSet = Dance_Glee_Preggers(pMWT,'pSave',pSave,'outputsuffix',outputsuffix,'saveimport',0);




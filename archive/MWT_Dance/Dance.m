function [varargout] = Dance(varargin)
%% INSTRUCTION
% modified from Dance to suit Flame
%% Updates
% 20140410 ---
    % take out [pList] = MWTpathMaster('MWTCodingRose');
% 20140414
    % updated matlab function paths
% 20140928

%% VARARGOUT
varargout{1} = {};
    

%% PROGRAM INFO
ProgramName = 'Dance';


%% PATHS
% set Dance home path
addpath('/Users/connylin/OneDrive/MATLAB/RL analysis matlab/MWT_Dance');
% set subfunction path
addpath('/Users/connylin/OneDrive/MATLAB/Functions_Developer');
% set save path
GlobalVar.pSave = '/Users/connylin/Downloads';
% set database path
GlobalVar.pData = '/Volumes/ParahippocampalGyrus/MWT_Data';

% pList = PathCommonList('Dance','Conny','Developer');
% pList.paths.MWT.pFun = [userpath1,'/Functions_MWT'];
% pList.paths.MWT.pSet = [paths.MWT.pFun,'/Settings'];
% %paths.pSum = '/Volumes/Rose/MultiWormTrackerPortal/Summary';
% pList.paths.MWT.pSave = '/Users/connylinlin/Documents/Lab/Lab Project & Data/Lab Data Matlab';
% pList.paths.MWT.pRepeatFiles = [paths.pRose,'/MWT_RepeatFiles'];
% pList.paths.MWT.pBadFiles = [paths.pRose,'/MWT_BadFiles'];
% pList.paths.MWT.pBadTap = [paths.pRose,'/MWT_TapIncorrectFiles'];
% % hard drive data paths
% pList.paths.MWT.pAWMaestro = '/Volumes/AWLIGHT/MWT/Archived Analysis/Maestro';
% pList.paths.MWT.pRoseDataPick = '/Volumes/Rose/MWT_Analysis_20130811';
% pList.paths.MWT.pRoseData = [paths.pRose,'/MWT_Analysis_20131020'];

  
%% ADMIN
% [Admin] = MWTAdminMaster(pList);
% if strcmp(Admin.option,'off') ==0
%     return
% end


%% ANALYSIS SET UP
[MWTSet] = MWTAnalysisSetUpMaster(pList);
% cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');


%% CHOR 
[MWTSet] = chormaster(MWTSet);
% cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');


%% ANALYSIS SWITCH BOARD
[MWTSet] = Dance_AnalysisMaster(MWTSet);
% [MWTSet] = chormaster_legend(MWTSet); % supsend - 20140528 for ShaneSpark

%% STATS SWITCH BOARD
[MWTSet] = Dance_StatsMaster(MWTSet);
cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');


%% GRAPH SETTING
[MWTSet] = MWTAnalysisSetUpMaster_Graphing(MWTSet);
cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');


%% GRAPHING SWITCH BOARD
GraphNames = MWTSet.GraphNames;
GraphN = numel(GraphNames);

for x = 1:GraphN
    display ' '; 
    display(sprintf('Running graphing package [%s]',GraphNames{x}));
    addpath(MWTSet.pFunGP{x}); % add path to analysis packs
    switch GraphNames{x}
        
        case 'Individual graphs'
            [MWTSet] = Dance_Graph_Individual(MWTSet);
        
        case 'subplot all in one'
            [MWTSet] = Dance_Graph_Subplot(MWTSet);
        
        case 'subplot SD'
            [MWTSet] = Dance_Graph_Subplot_SD(MWTSet);
    
        otherwise
        error('Graph packs not installed');
    end
end

cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');


%% CREATE REPORT OF INFO OF THIS ANALYSIS
% REPORT
% GET pMWT from MWTfG
MWTfG = MWTSet.MWTfG;
if isstruct(MWTfG) ==1
    A = celltakeout(struct2cell(MWTfG),'multirow');
    pMWT = A(:,2); 
end
[p,mwtfn] = cellfun(@fileparts,pMWT,'UniformOutput',0);
[pExp,gfn] = cellfun(@fileparts,p,'UniformOutput',0);
groupnames = unique(gfn);
pExpU = unique(pExp);
[~,ExpfnU] = cellfun(@fileparts,pExpU,'UniformOutput',0);
Report = nan(numel(pExpU),numel(groupnames));
expstr = 'Experiments = ';
for e = 1:numel(pExpU)
    [fn,p] = dircontent(pExpU{e});
    a = regexpcellout(ExpfnU{e},'_','split');
    a = [a{1,1},'_',a{2,1}];
    expstr = [expstr,a,', ']; 
    for g = 1:numel(groupnames)
        i = ismember(fn,groupnames{g});
        if sum(i) == 0;
            n = 0;
        else
            p1 = p{i};
            fn1 = dircontent(p1);
            n = numel(fn1);
        end
        Report(e,g) = n;
    end
end
expstr = [expstr(1:end-2),'; '];

% sample size string
names = fieldnames(MWTSet.MWTfG);
a = structfun(@size,MWTSet.MWTfG,'UniformOutput',0);
s = [];
str = '';
for x = 1:numel(names)

    str = [str,names{x},' N=',num2str(a.(names{x})(1,1)),'; '];
end
Nstr = str;

% by experiment number
str = '';
for g = 1:numel(groupnames)
    str = [str,groupnames{g},'='];
    a = Report(:,g);
    
    for x = 1:numel(a)
        str = [str,num2str(a(x,1)),','];
    end
    str = [str(1:end-1),'; '];
end
expNstr = str(1:end-2);

% compose
expreport = [Nstr,' ',expstr,expNstr];

MWTSet.expreport = expreport;
[~,fn] = fileparts(MWTSet.pSaveA);
display([fn,' (', char(MWTSet.StatsOption),') ',MWTSet.expreport]);

cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');




display 'Analysis completed';

%% VARARGOUT
varargout{1} = MWTSet;



end





























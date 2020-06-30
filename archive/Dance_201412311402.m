function [varargout] = Dance(varargin)
%% INSTRUCTION
% ...

%% VARARGOUT
varargout{1} = {};
    
%% PROGRAM INFO
ProgramName = 'Dance';


%% PATHS
% set Dance home path
addpath('/Users/connylin/OneDrive/MATLAB/MWT_Dance');
% set subfunction path
GlobalVar.pFun = '/Users/connylin/OneDrive/MATLAB/Functions_Developer';
addpath(GlobalVar.pFun);
% set save path
GlobalVar.pSave = '/Users/connylin/OneDrive/Dance_Output';
% set database path
GlobalVar.pData = '/Volumes/ParahippocampalGyrus/MWT_Data';
GlobalVar.pJava = GlobalVar.pFun;
GlobalVar.pFunA = '/Users/connylin/OneDrive/MATLAB/MWT_Dance/Dance_AnalysisPack';
GlobalVar.pFunG = '/Users/connylin/OneDrive/MATLAB/MWT_Dance/Dance_GraphPack'; 
% MWTSet = GlobalVar;
% ADMIN
% [Admin] = MWTAdminMaster(pList);



%% CHOOSING ANALYSIS PROGRAMS
% % analysis program list (update analysis program names here)
% optionlist = {'ShaneSpark','Dance_ShaneSpark_20141120';
%                 'DrunkPosture', 'Dance_DrunkPosture'};
% % case 'LadyGaGa' %         Dance_LadyGaGa(MWTSet);
% %     case 'Swanlake2' %         error ('under construction');      
% 
% 
% % select analysis program
% setname = 'AnalysisName'; % setting name in MWTSet
% programName = chooseoption(optionlist,2);
% MWTSet.(setname) = programName;
% 
% % run program
% [MWTSet] = eval([char(programName),'(MWTSet)']);
% 
% 
% %%
% cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');
% 
% %% CODE STOP
% display '*** RETURN CODE STOP ***';
% return

%% ANALYSIS SET UP
clear MWTSet;
[MWTSet] = MWTAnalysisSetUpMaster(GlobalVar);
cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');
% [MWTfG] = MWTDataBaseMaster(GlobalVar.pData,'search');


%% CHOR 
[MWTSet] = chormaster(MWTSet);
cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');

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





























function [varargout] = Dance(varargin)
%% INSTRUCTION
% modified from Dance to suit Flame
%% Updates
% 20140410 ---
    % take out [pList] = MWTpathMaster('MWTCodingRose');
% 20140414
    % updated matlab function paths


%% VARARGOUT
varargout{1} = {};
    

%% PROGRAM INFO
ProgramName = 'Dance';


%% PATHS
pList = PathCommonList('Dance','ConnyCerebralCortex');

  
%% ADMIN
[Admin] = MWTAdminMaster(pList);
if strcmp(Admin.option,'off') ==0
    return
end


%% ANALYSIS SET UP
[MWTSet] = MWTAnalysisSetUpMaster(pList);


%% CHOR 
[MWTSet] = chormaster(MWTSet);


%% ANALYSIS SWITCH BOARD

% report
display ' '; 
display(sprintf('Running analysis package [%s]',MWTSet.AnalysisName));
% add path to analysis packs
addpath(MWTSet.pFunAP);

% run analysis
switch MWTSet.AnalysisName
    case 'ShaneSpark'
        [MWTSet] = Dance_ShaneSpark(MWTSet);
    case 'ShaneSpark2';
        [MWTSet] = Dance_ShaneSpark2(MWTSet);
    case 'DrunkPosture';
        [MWTSet.Raw] = Dance_DrunkPosture(MWTSet);

%     case 'LadyGaGa'
%         Dance_LadyGaGa(MWTSet);
    otherwise
        error('Analysis not installed');
end


%% STATS SWITCH BOARD
[MWTSet] = Dance_StatsMaster(MWTSet);


%% Graph parameter setting
[MWTSet] = MWTAnalysisSetUpMaster_Graphing(MWTSet);


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
    
        otherwise
        error('Graph packs not installed');
    end
end


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
%     [~,expn] = fileparts(pExpU{e});
%     r = find(ismember(ExpfnU,expn));
%     
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

str = '';
for g = 1:numel(groupnames)
    str = [str,groupnames{g},' = '];
    a = Report(:,g);
    
    for x = 1:numel(a)
        str = [str,num2str(a(x,1)),','];
    end
    str = [str(1:end-1),'; '];
end
expreport = [expstr,str(1:end-2)];

MWTSet.expreport = expreport;
[~,fn] = fileparts(MWTSet.pSaveA);
% disp(fn);
display([fn,', ',MWTSet.expreport]);

cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');



varargout{1} = MWTSet;
display 'Analysis completed';





end





























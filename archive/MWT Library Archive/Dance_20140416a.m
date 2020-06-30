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



status = 'coding'; % status = 'released';
switch status
    case 'coding'
        % matlab: add developer function path
        p = regexprep(userpath,pathsep,'');
        pUser = fileparts(fileparts(p));
        pFunD = [pUser,...
            '/Dropbox/MATLAB/Functions_Developer'];
        addpath(pFunD);
        
        % path: MWT specific
        [paths] = PathCommonList;
        A.pFun = [pUser,'/Dropbox/MATLAB/Projects_RankinLab/MWT_Dance'];
        addpath(A.pFun);
        
        A.pJava = [A.pFun,'/ChoreJava'];
        
        
        % data source hard drive (works only for Mac)
        % database path
        [~,pd] = dircontent('/Volumes');
        a = cellfun(@strcat,pd,cellfunexpr(pd,'/MWT_Data'),...
            'UniformOutput',0);
        i = cellfun(@isdir,a);
        if sum(i) ==1
           A.pData = a{i};
        end
        
        % get save path
        [~,pd] = dircontent('/Users');
        a = cellfun(@strcat,pd,...
            cellfunexpr(pd,'/Documents/MWT Outputs'),...
            'UniformOutput',0);
        i = cellfun(@isdir,a);
        if sum(i) ==1
           A.pSave = a{i};
        elseif sum(i) == 0
            A.pSave = [fileparts(A.pData),'/MWT Outputs'];
            if isdir(A.pSave) == 0
                mkdir(A.pSave);
            end
        end
        
        % get analysis pack
        A.pFunA = [A.pFun,'/Dance_AnalysisPack'];  % get analysis pack
        A.pFunG = [A.pFun,'/Dance_GraphPack'];  % get graphing pack
        pList = A; clear paths;
        
        
        
    case 'released'
        % Launched program
        A.pFun = pwd; % get Dance folder
        A.pJava = [A.pFun,'/ChoreJava'];
        display 'open data folder';
        a = uigetdir;
        A.pData = a;
end




%% ADMIN
if nargin ~=0
    if strcmp(varargin{1},'Admin') ==1
        [varargout{1}] = MWTAdminMaster(pList);
        return
    end
else   
    MWTAdminMaster('off');
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
    % add path to analysis packs
    addpath(MWTSet.pFunGP{x})
    switch GraphNames{x}
        case 'Individual graphs'
            [MWTSet] = Dance_Graph_Individual(MWTSet);
        case 'subplot all in one'
            [MWTSet] = Dance_Graph_Subplot(MWTSet);
    otherwise
        error('Graph packs not installed');
    end
end


%% STEP7: REPORT AND END
% MWTSum.Graph = Graph;
varargout{1} = MWTSet;
cd(MWTSet.pSaveA); save('matlab.mat');

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
display 'Analysis completed';








end





























function [varargout] = Dance(varargin)
%% INSTRUCTION
% modified from Dance to suit Flame


%% VARARGOUT
varargout{1} = {};


%% PATHS: FUNCTIONS
% modify for release
ProgramName = 'Dance';
% restoredefaultpath
functionfolder = '/Functions_Developer';
pFunD = [regexprep(userpath,':',''),functionfolder];
addpath(pFunD);
[pFun,FunFolder] = Path2FunctionMaster(ProgramName);

% path: MWT specific
[pList] = MWTpathMaster('MWTCodingRose',pFun);





%% ADMIN
MWTAdminMaster('off')


%% SEARCH MWT DATABASE
[MWTfG] = MWTDataBaseMaster(pList.pData,'search');



%% ANALYSIS SET UP
[MWTSet] = MWTAnalysisSetUpMaster(pList,MWTfG);


%% CHOR 
[MWTSet] = chormaster(MWTSet);



%% ANALYSIS SWITCH BOARD
AnalysisName = MWTSet.AnalysisName;
display ' '; 
display(sprintf('Running analysis package [%s]',AnalysisName));
% add path to analysis packs
addpath(MWTSet.pFunAP);

% check if MWTSet has required files
AInfield = eval([ProgramName,'_',AnalysisName]);
i = ismember(fieldnames(MWTSet),AInfield);
if numel(AInfield) == sum(i) == 0
    error('MWTSet does not contain required input for this analysis');
end

% run analysis
switch AnalysisName
    case 'ShaneSpark'
        [MWTSet.Raw] = Dance_ShaneSpark(MWTSet);
    
    case 'DrunkPosture';
        [MWTSet.Raw] = Dance_DrunkPosture(MWTSet);

%     case 'LadyGaGa'
%         Dance_LadyGaGa(MWTSet);
    otherwise
        error('Analysis not installed');
end


%% STATS SWITCH BOARD
[MWTSet.Graph,MWTSet.GraphGroup] = Dance_StatsMaster(MWTSet);



%% Graph parameter setting
[MWTSet.GraphSetting] = MWTAnalysisSetUpMaster_Graphing(MWTSet);



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
            Dance_Graph_Individual(MWTSet);
        case 'subplot all in one'
            Dance_Graph_Subplot(MWTSet)
    otherwise
        error('Graph packs not installed');
    end
end




%% STEP7: REPORT AND END
MWTSum = MWTSet;
% MWTSum.Graph = Graph;
varargout{1} = MWTSum;
cd(MWTSet.pSaveA); save('matlab.mat');

%% CREATE REPORT OF INFO OF THIS ANALYSIS

display 'Analysis completed';

end





























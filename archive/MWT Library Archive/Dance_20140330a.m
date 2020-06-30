function [varargout] = Dance(varargin)
%% INSTRUCTION
% modified from Dance to suit Flame


%% VARARGOUT
varargout{1} = {};


%% PATHS: FUNCTIONS
% modify for release
ProgramName = 'Dance';
% add developer function path
functionfolder = '/Functions_Developer';
pFunD = [regexprep(userpath,':',''),functionfolder];
addpath(pFunD);
% [pFun,FunFolder] = Path2FunctionMaster(ProgramName);

% get common paths
% [paths] = PathCommonList;

% path: MWT specific
[pList] = MWTpathMaster('MWTCodingRose',pFun);




%% ADMIN
MWTAdminMaster('off');


%% SEARCH MWT DATABASE
liquidtsfcutoffdate = 20120213;
invertedcutoffdate = 20130919;
[MWTfG] = MWTDataBaseMaster(pList.pData,'search');

% choose analysis parameter
choicelist = {'Within Exp';'Any Exp'};
disp(makedisplay(choicelist));
choice = choicelist{input(': ')};
switch choice
    case 'Within Exp'
        [MWTfG] = MWTDataBase_withinexp(MWTfG);
end

%% IDENTIFY PROBLEM PLATES
% get plates
names = fieldnames(MWTfG);
fn = {};
for x = 1:numel(names)
    fn1 = MWTfG.(names{x});
    fn = [fn;fn1];
end
% get rid of MWT plates marked problematic
i = regexpcellout(fn(:,1),'\<(\d{8})[_](\d{6})\>');
fn2 = sortrows(fn(i,:),1);

% ask if want to exclude certain plates
display 'Do you want to exclude specific plates?';
opt = input('[yes/no]: ','s');
if strcmp(opt,'yes') == 1
    [fn3] = chooseoption(fn2,2);
    i = ~ismember(fn2(:,2),fn3);
    fn4 = fn2(i,2);
    [MWTfG] = reconstructMWTfG(fn4);
else
    display 'include all plates found';
end



%% ANALYSIS SET UP
[MWTSet] = MWTAnalysisSetUpMaster(pList,MWTfG);


%% CHOR 
[MWTSet] = chormaster(MWTSet);


%% ANALYSIS SWITCH BOARD
% get analysis name
AnalysisName = MWTSet.AnalysisName;

% report
display ' '; 
display(sprintf('Running analysis package [%s]',AnalysisName));
% add path to analysis packs
addpath(MWTSet.pFunAP);

% check if MWTSet has required files
% AInfield = eval([ProgramName,'_',AnalysisName]);
% i = ismember(fieldnames(MWTSet),AInfield);
% if numel(AInfield) == sum(i) == 0
%     error('MWTSet does not contain required input for this analysis');
% end


% run analysis
switch AnalysisName
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





























function MWTSet = Dance_v2015r1(varargin)
%% INSTRUCTION
% inputs should be paired with a name of the type of input

%% CLEAR MEMORY
% clear

%% PROGRAM INFO & GLOBAL VARIABLES
a = regexp(mfilename,'_','split');
ProgramName = a{:,1}; MWTSet.ProgramName = ProgramName;
ProgramVersion = a{:,2}; MWTSet.ProgramVersion = ProgramVersion;
GeneralFunFolderNames = {'.git','Chor','Modules','TextFiles'};
ProgramStatusType = {'Coding','Testing','Publish_InDrive'};
ProgramStatus = ProgramStatusType{1};


%% add varagin
if nargin > 1
INPUT = varargin;
n = numel(INPUT);
% i = cellfun(@isstr,INPUT);
fn = INPUT(1:2:n);
var = INPUT(2:2:n);
for fni = 1:numel(fn)
    MWTSet.INPUT.(fn{fni}) = var{fni};
end
else
    INPUT = [];
end

%% PATHS: GENERAL FUNCTIONS [updated 20150526]
% get code path
pFun = [fileparts(which(mfilename)),'/',mfilename]; addpath(pFun); 
MWTSet.PATHS.pCode = pFun;

% add matlab public library path
addpathfromtextfile([pFun,'/path_matlabfunction.dat']);

% add common module path
addpathfromtextfile([pFun,'/path_MWTmodules.dat']);

% add chor path
pChor= addpathfromtextfile([pFun,'/path_chor.dat']);
MWTSet.chor.pCodeChor = pChor;
MWTSet.chor.choreversion = 'Chore_1.3.0.r1035.jar';
MWTSet.chor.arguments.chor = ['''',pChor,'/',MWTSet.chor.choreversion,'''']; % call chor 
MWTSet.chor.arguments.beethoven = ['''',pChor,'/Beethoven_v2.jar','''']; % call beethoven 
MWTSet.chor.chorstatus = 'old';
% MWTSet.chor.chorstatus = chooseoption({'old';'new'},'chor outputs:');


%% PATH: DATA, ANALYSIS OUTPUTS, AND REPORTS
% paths are given in text files under TextFile folder
% filepath = [pFun,'/path_datadrive.dat'];
% [p,filename] = fileparts(filepath);
% a = ls(p);
% if isempty(strfind(a,filename)) == 0; 
%     pDriveHome = addpathfromtextfile(filepath);
pData = addpathfromtextfile([pFun,'/path_data.dat']);
MWTSet.PATHS.pData = pData;

% PATH: CHOR ANALYSIS OUTPUT 
pAnalysis=  addpathfromtextfile([pFun,'/path_analysis.dat']);
MWTSet.PATHS.pAnalysis = pAnalysis;


% PATH: OUTPUT HOME
if sum(strcmp('outputpath',INPUT)) == 1
    pOutputHome = char(MWTSet.INPUT.outputpath);
else
    pOutputHome = addpathfromtextfile([pFun,'/path_output.dat']);
end
MWTSet.PATHS.pOutputHome = pOutputHome;


%% SELECT EXTENTION PACKS
if sum(strcmp('extpack',INPUT)) == 0
% p = [MWTSet.PATHS.pCode];
a = dircontent(MWTSet.PATHS.pCode,[ProgramName,'_*.m']);
b = regexprep(a,['(',ProgramName,'_)|(.m)'],'');
% a(ismember(a,{'.git'})) = [];
AnalysisName = a{chooseoption(b,'Choose extension packs:','index')};
MWTSet.AnalysisCode = regexprep(AnalysisName,'(.m)$','');
else
    AnalysisName = [MWTSet.INPUT.extpack,'.m'];
    MWTSet.AnalysisCode = MWTSet.INPUT.extpack;
end


%% RUN COMMON TASKS
Database = Dance_surveydatabase(MWTSet.PATHS.pData);
MWTSet = Dance_selectinputMWTfiles(MWTSet,Database);
MWTSet = Dance_withinoracrossexp(MWTSet);
MWTSet = Dance_choroptions(MWTSet);
MWTSet = Dance_setgroupgraphsequence(MWTSet);
Dance_reportgraph2analyze(MWTSet);
MWTSet = Dance_fixMWTchorResultsPath(MWTSet);


%% PATHS: CREATE OUTPUT PATHS
[MWTSet,pSaveA] = path_createoutputpath(MWTSet);


%% TESTING: STOP PROGRAM 
varargout{1} = MWTSet;
if strcmp(ProgramStatus,'Testing') == 1
    cd(pSaveA); save('matlab.mat','MWTSet'); 
    disp ' ';
    disp(MWTSet)
    return
end


%% RUN SUB-FUNCTION MODULE
cd(pSaveA); save('matlab.mat','MWTSet');
eval(['[MWTSet] = ',MWTSet.AnalysisCode,'(MWTSet);']);


%% make a copy of the analysis code in output folder
source = [pFun,'/',MWTSet.AnalysisCode,'.m'];
dest = regexprep(source,fileparts(source),pSaveA);
copyfile(source,dest)


%% CREATE REPORT OF INFO OF THIS ANALYSIS [disabled]
% % REPORT
% % GET pMWT from MWTfG
% MWTfG = MWTSet.MWTfG;
% if isstruct(MWTfG) ==1
%     A = celltakeout(struct2cell(MWTfG),'multirow');
%     pMWT = A(:,2); 
% end
% [p,mwtfn] = cellfun(@fileparts,pMWT,'UniformOutput',0);
% [pExp,gfn] = cellfun(@fileparts,p,'UniformOutput',0);
% groupnames = unique(gfn);
% pExpU = unique(pExp);
% [~,ExpfnU] = cellfun(@fileparts,pExpU,'UniformOutput',0);
% Report = nan(numel(pExpU),numel(groupnames));
% expstr = 'Experiments = ';
% for e = 1:numel(pExpU)
%     [fn,p] = dircontent(pExpU{e});
%     a = regexpcellout(ExpfnU{e},'_','split');
%     a = [a{1,1},'_',a{2,1}];
%     expstr = [expstr,a,', ']; 
%     for g = 1:numel(groupnames)
%         i = ismember(fn,groupnames{g});
%         if sum(i) == 0;
%             n = 0;
%         else
%             p1 = p{i};
%             fn1 = dircontent(p1);
%             n = numel(fn1);
%         end
%         Report(e,g) = n;
%     end
% end
% expstr = [expstr(1:end-2),'; '];
% 
% % sample size string
% names = fieldnames(MWTSet.MWTfG);
% a = structfun(@size,MWTSet.MWTfG,'UniformOutput',0);
% s = [];
% str = '';
% for x = 1:numel(names)
% 
%     str = [str,names{x},' N=',num2str(a.(names{x})(1,1)),'; '];
% end
% Nstr = str;
% 
% % by experiment number
% str = '';
% for g = 1:numel(groupnames)
%     str = [str,groupnames{g},'='];
%     a = Report(:,g);
%     
%     for x = 1:numel(a)
%         str = [str,num2str(a(x,1)),','];
%     end
%     str = [str(1:end-1),'; '];
% end
% expNstr = str(1:end-2);
% 
% % compose
% expreport = [Nstr,' ',expstr,expNstr];
% 
% MWTSet.expreport = expreport;
% [~,fn] = fileparts(MWTSet.pSaveA);
% display([fn,' (', char(MWTSet.StatsOption),') ',MWTSet.expreport]);
% 
% cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');
% 
% 
% 
% 
% display 'Analysis completed';


%% VARARGOUT
varargout{1} = MWTSet;


%% DISPLAY END AND SAVE
cd(MWTSet.PATHS.pSaveA);
save('matlab.mat','MWTSet');

display '  ** Dance: The End **'
display ' ';
return






























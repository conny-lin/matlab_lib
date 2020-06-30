%% AFTERPARTY   post analysis of Dance program.
% AfterParty_v2015r1
%     MWTSet = AfterParty(DanceOutputPath)  load matlab.mat file generated 
%     from Dance program from path 'DanceOutputPath' to do further 
%     analysis.
% 
% updated [20150514]


%% PROGRAM INFO & GLOBAL VARIABLES
a = regexp(mfilename,'_','split');
ProgramName = a{:,1}; MWTSet.ProgramName = ProgramName;
ProgramVersion = a{:,2}; MWTSet.ProgramVersion = ProgramVersion;
GeneralFunFolderNames = {'.git','Chor','Modules','TextFiles'};
ProgramStatusType = {'Coding','Get MWTSet','Testing','Publish_InDrive'};
ProgramStatus = ProgramStatusType{3};
matFileName = 'AfterPartyResults.mat';
matFileVarName = 'MWTSet';


%% CHECK INPUT
% DanceOutputPath = cd;
filename = 'matlab.mat';
a = dir(DanceOutputPath);
a = {a.name};
if sum(ismember(a,filename)) ~= 1
    error('problem finding matlab.mat Dance output');
end
% PATH: IPUT
MWTSet.PATHS.pDanceResult = DanceOutputPath;


%% PATHS: GENERAL FUNCTIONS [updated 20150511]
% get code path
pFun = [fileparts(which(mfilename)),'/',mfilename];

addpath(pFun); 
MWTSet.PATHS.pCode = pFun;
% add matlab public library path
addpathfromtextfile([pFun,'/path_matlabfunction.dat']);
% add common module path
addpathfromtextfile([pFun,'/path_MWTmodules.dat']);

%% SELECT EXTENTION PACKS
% p = [MWTSet.PATHS.pCode];
a = dircontent(MWTSet.PATHS.pCode,[ProgramName,'_*']);
b = regexprep(a,['(',ProgramName,'_)|(.m)'],'');
% a(ismember(a,{'.git'})) = [];
AnalysisName = a{chooseoption(b,'Choose extension packs:','index')};
pCodeA = [MWTSet.PATHS.pCode,'/',AnalysisName];
MWTSet.PATHS.pCodeA = [MWTSet.PATHS.pCode,'/',AnalysisName];

addpath(MWTSet.PATHS.pCodeA);
MWTSet.AnalysisCode = [AnalysisName,'.m'];


%% PATHS: CREATE OUTPUT PATHS
% generate time stampe
timestamp = generatetimestamp;
MWTSet.timestamp = timestamp;

% create output name
fprintf('\nEnter a name for your output folder\n');
name = input(': ','s');
if isempty(name) == 1
    OutputFolderName = [regexprep(MWTSet.AnalysisCode,'.m',''),' ', timestamp];
else
% generate output folder
OutputFolderName = [MWTSet.AnalysisCode,' ', timestamp,' ', name];
end
pSaveA = [DanceOutputPath,'/',OutputFolderName];
MWTSet.PATHS.pSaveA = pSaveA;
if isdir(pSaveA) == 0; mkdir(pSaveA); end
MWTSet.OutputFolderName = OutputFolderName;


%% TESTING: STOP PROGRAM 
varargout{1} = MWTSet;
if strcmp(ProgramStatus,'Get MWTSet') == 1
    cd(MWTSet.PATHS.pSaveA); save(matFileName,matFileVarName); 
    disp ' ';
    disp(MWTSet)
    return
end


%% RUN SUB-FUNCTION MODULE
eval(['[MWTSet] = ',AnalysisName,'(MWTSet);']);

%% make a copy of the analysis code in output folder
source = [pCodeA,'/',AnalysisName,'.m'];
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


%% DISPLAY END AND SAVE
cd(MWTSet.PATHS.pSaveA); save(matFileName,matFileVarName); 
fprintf(['** ',ProgramName,': The End **\n']);


































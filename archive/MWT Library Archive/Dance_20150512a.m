function [varargout] = Dance(varargin)
%% INSTRUCTION
% inputs should be paired with a name of the type of input

%% CLEAR MEMORY
clearvars -except varargin


%% VARARGOUT
varargout{1} = {};
%


%% VARARGIN
nIn = 0;
if nargin > nIn
    INPUT = varargin;
    % input should be a pair of text + other input
    % if error on this part, the input is not a pair
    INPUT = reshape(INPUT,2,numel(INPUT)/2);
else 
    INPUT = {};
end


%% process INPUT
nInput = size(INPUT,2);

for x = 1:nInput
    inputname = INPUT{1,x};
    inputvar = INPUT{2,x};
    switch inputname
        
        case 'expnamefolderpath'
            %% if the variable must be a path in cell or char array 
            % to a folder named experiment_list.dat document listing the
            % exp names 
            % example: text file contains text: 
            if ischar(inputvar) == 1 
                p = inputvar;
            elseif iscell(inputvar) == 1
                p = char(inputvar);
            end
            % validate path
            if isdir(p) == 0; error('bad input path'); end
            % validate if folder contains experiment_list.dat
            i = strfind(ls(p),'experiment_list.dat');
            if isempty(i) == 1; error('no experiment_list.dat file'); end
            % open file
            fileID = fopen([p,'/experiment_list.dat'],'r');
            dataArray = textscan(fileID, '%s%[^\n\r]',...
                'Delimiter', '',  'ReturnOnError', false);
            dataArray = dataArray{:, 1};
            fclose(fileID);
            INPUT{1,x} = 'expname';
            INPUT{2,x} = dataArray;
            
        case 'expname'    
            % cell array of expnames in one column
            if iscell(inputvar) == 0 || size(inputvar,2) > 1
                error('incorrect expname input');
            end
            INPUT{2,x} = inputvar;
        
        case 'databasepath'
            % char or cell array of path to database
            if iscell(inputvar) == 1
                p = char(inputvar);
            elseif ischar(inputvar) == 1
                p = inputvar;
            end
            if isdir(p) == 0; error('path to database is invalid'); end
            INPUT{2,x} = p;
            
        case 'outputpath'
            % char or cell array of path to output path home
            if iscell(inputvar) == 1
                p = char(inputvar);
            elseif ischar(inputvar) == 1
                p = inputvar;
            end
            if isdir(p) == 0; error('path to output folder is invalid'); end
            INPUT{2,x} = p;
    end
    
end


if isempty(INPUT) == 1; clearvars('INPUT'); end
if exist('INPUT','var') == 1; MWTSet.INPUT = INPUT; end


%% PROGRAM INFO & GLOBAL VARIABLES

MWTSet.ProgramVersion = 'Dance 20150510';
GeneralFunFolderNames = {'.git','Chor','Modules','TextFiles'};
ProgramStatusType = {'Coding','Published_floating','Testing','Publish_InDrive'};
ProgramStatus = ProgramStatusType{1};


%% PATHS: GENERAL FUNCTIONS [updated 20150511]
% get code path
p = fileparts(which(mfilename));
MWTSet.PATHS.pCode = p;

% add local function library folder
pFunLibrary = [p,'/Library'];
addpath(pFunLibrary); 
MWTSet.PATHS.pCodeLibrary = pFunLibrary;

% add common module path
pFunModules = [pFunLibrary,'/Modules'];
addpath(pFunModules);

% add matlab public library path
filepath = [pFunLibrary,'/TextFiles/path_matlabfunction.dat'];
pFunPublic = addpathfromtextfile(filepath);
MWTSet.PATHS.pCodePublic = pFunPublic;


%% PATH: DATA PATHS
% find MWT_Data paths
% if input has given a datapath
filepath = [pFunLibrary,'/TextFiles/path_datadrive.dat'];
[p,filename] = fileparts(filepath);
a = ls(p);
if isempty(strfind(a,filename)) == 0; 
    pDriveHome = addpathfromtextfile(filepath);
    pData = [pDriveHome,'/MWT_Data']; 
else
    error('path_datadrive.dat file did not contain a valid path');
end
    
    
if isfield(MWTSet,'INPUT') == 1
    % check if databasepath is given
    if strcmp(MWTSet.INPUT(1,:),'databasepath') == 1
        pData = MWTSet.INPUT(2,i);
        pDriveHome = fileparts(pData);     
    end
    
elseif strcmp(ProgramStatus,'Published_floating') == 1
    % if program is installed as floating program, choose hard drive
    % attached to Mac computer
    [drivepath, drivenames] = findharddrive;
    [~,i] = chooseoption(drivenames,'Choose hard drive: ');
    pDriveHome = drivepath{i};
    pData = [pDriveHome,'/MWT_Data']; 
end

% validate data path
if isdir(pData) == 0
    error('database path defined in TextFile is invalid')
else
    MWTSet.PATHS.pData = pData;
end


%% PATH: CHOR ANALYSIS OUTPUT 
pAnalysis=  [pDriveHome,'/MWT_Data_Analysis'];
if isdir(pAnalysis) == 0;
    warning('missing analysis folder, creating one')
    mkdir(pAnalysis);
end
MWTSet.PATHS.pAnalysis = pAnalysis;


%% PATH: OUTPUT HOME
% generate output paths
filepath = [pFunLibrary,'/TextFiles/path_output.dat'];
[p,filename] = fileparts(filepath);
a = ls(p);
if isempty(strfind(a,filename)) == 0; 
    pOutputHome = addpathfromtextfile(filepath);
else
    error('path_output.dat file did not contain a valid path');
end
if sum(ismember(fieldnames(MWTSet),'INPUT')) == 1
    % check if databasepath is given
    i = ismember(MWTSet.INPUT(1,:),'outputpath');
    if sum(i) == 1 
        pOutputHome = MWTSet.INPUT(2,i);
    end
end
MWTSet.PATHS.pOutputHome = pOutputHome;


%% SELECT SUB-PROGRAMS AND EXTENTION PACKS
% SELECT SUB-PROGRAMS
SubFunNameList = readTextColumns([pFunLibrary,'/TextFiles/SubPrograms.dat']);
FunName = chooseoption(SubFunNameList,'Which program do you want to run:');
MWTSet.ProgramName = FunName;

% get sub-program library
names = dircontent(pFunLibrary);
names(ismember(names, GeneralFunFolderNames)) = [];
a = strfind(names,FunName);
SubFunName = names{~cellfun(@isempty,a)};

pFunAnalysisPack = [pFunLibrary,'/',SubFunName];
addpath(pFunAnalysisPack);
MWTSet.PATHS.pFunAnalysisPack = pFunAnalysisPack;


%% PATHS: ADD SUB-PROGRAM SPECIFIC PATHS & RUN COMMON TASKS
switch FunName
    case 'Dance'
        pChor = [pFunLibrary,'/Chor'];
        MWTSet.PATHS.pCodeChor = pChor;
        
        % determine data to analyze
        pData = MWTSet.PATHS.pData;
        if exist('INPUT','var') == 0
            Database = Dance_surveydatabase(pData);
        elseif isempty(INPUT) == 0 && sum(strcmp(INPUT(1,:),'expname')) == 1
            i = strcmp(INPUT(1,:),'expname');
            a = INPUT{2,i};
            Database = Dance_surveydatabase(pData,'expname',a);            
        end
        
        MWTSet = Dance_selectinputMWTfiles(MWTSet,Database);
        MWTSet = Dance_withinoracrossexp(MWTSet);
        MWTSet = Dance_choroptions(MWTSet);
        MWTSet = Dance_setgroupgraphsequence(MWTSet);
        Dance_reportgraph2analyze(MWTSet);
        MWTSet = Dance_fixMWTchorResultsPath(MWTSet);


    case 'BackStage'
        pStore = [pDriveHome,'/MWT_Data_ExpZip'];
        MWTSet.PATHS.pStore = pStore;
        
        pIn = [pDriveHome,'/MWT_Data_Inbox'];
        MWTSet.PATHS.pIn = pIn;
        
        pTemp = [pDriveHome,'/TEMP']; 
        MWTSet.PATHS.pTemp = pTemp;
        if isdir(pTemp) == 0; mkdir(pTemp); end
        
    case 'AfterParty'
end


%% PATHS: CREATE OUTPUT PATHS
% generate time stampe
timestamp = generatetimestamp;
MWTSet.timestamp = timestamp;

% create output name
display 'Enter a name for your output folder';
name = input(': ','s');

% generate output folder
OutputFolderName = [FunName,' ', timestamp,' ', name];
pSaveA = [pOutputHome,'/',OutputFolderName];
MWTSet.PATHS.pSaveA = pSaveA;
if isdir(pSaveA) == 0; mkdir(pSaveA); end
MWTSet.OutputFolderName = OutputFolderName;


%% CHOOSE ANALYSIS [UPDATED 20150511]
names = dircontent(pFunAnalysisPack);
names = names(~ismember(names,{'.git'}));
names = chooseoption(names,'Choose extension pack: ');
p = [pFunAnalysisPack,'/',names];
addpath(p);

a = dircontent(p,'*.m');
if numel(a) == 1
    codename = a{1};
elseif numel(a) > 1

    b = regexprep(a,'.m','');
    c = regexpcellout(b,'_','split');
    d = c(:,2);
    i = chooseoption(d,'Choose option:','index');
    codename = a{i};
else
    error('no valid pack selected');
    
end
pFunAP = [p,'/',codename];
a = regexp(codename,'[.]','split');
MWTSet.AnalysisCode = a{1,1};


%% TESTING: STOP PROGRAM 
varargout{1} = MWTSet;
if strcmp(ProgramStatus,'Testing') == 1
    cd(pSaveA); save('matlab.mat','MWTSet'); 
    disp ' ';
    disp(MWTSet)
    return
end


%% RUN SUB-FUNCTION MODULE
eval(['[MWTSet] = ', MWTSet.AnalysisCode,'(MWTSet);']);


%% make a copy of the analysis code in output folder
source = pFunAP;
dest = regexprep(source,p,pSaveA);
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




































function [varargout] = Dance(varargin)
%% INSTRUCTION
% 1. Drag your analysis folder in


% UPDATES
% [updated 20150412]
% 20140410 ---
    % take out [pList] = MWTpathMaster('MWTCodingRose');
% 20140414
    % updated matlab function paths
% modified from Dance to suit Flame
%

%% VARARGOUT
varargout{1} = {};
%

%% PROGRAM INFO
% clear;
MWTSet.DanceVersion = 'Dance 20150412';
%

%% PATHS [updated 20150412]
pDriveHome = '/Volumes/ParahippocampalGyrus/';
pOneDriveHome = '/Users/connylin/OneDrive/Lab/Dance Output';

% pList.pSave = '/Users/connylin/OneDrive/Lab/Dance Output';
p = fileparts(which(mfilename));
MWTSet.PATHS.pFun = [p,'/','Functions'];
addpath([p,'/','Functions']); % add function folder
MWTSet.PATHS.pFunAnalysisPack = [p,'/Dance_ExtentionPacks/Dance_AnalysisPack'];

if nargin > 0
    p = varargin{1};
    if isdir(p) == 1
        MWTSet.PATHS.pData = p;
    end
else
    MWTSet.PATHS.pData = [pDriveHome,'MWT_Data'];

end
    
    
MWTSet.PATHS.pAnalysis = [pDriveHome,'MWT_Data_Analysis'];
% MWTSet.PATHS.pRawBackup = [pDriveHome,'MWT_Data_RawBackup'];
MWTSet.PATHS.pSave = pOneDriveHome;
addpath(MWTSet.PATHS.pSave)
MWTSet.timestamp = generatetimestamp;
MWTSet.PATHS.pSaveA = [MWTSet.PATHS.pSave,'/',MWTSet.timestamp];
if isdir(MWTSet.PATHS.pSaveA) == 0; mkdir(MWTSet.PATHS.pSaveA); end
%


%% ADMIN % [disabled - updated 20140826]
% [Admin] = MWTAdminMaster(pList);
% if strcmp(Admin.option,'off') ==0
%     return
% end
%

%% SURVEY DATABASE  % [updated 20150412]
pData = MWTSet.PATHS.pData;
% [MWTSet] = MWTAnalysisSetUpMaster(pList);

% search data base for exp folders + valid folder names
display 'Searching for Experiment folders...';
[~,~,fn,p] = dircontent(pData); 
str = '^\d{8}[A-Z][_]([A-Z]{2})[_](.){1,}';
i = not(cellfun(@isempty,regexp(fn,str,'match')));
pNonExpf = p(not(i)); 
NonExpfn = fn(not(i));
pExpfD = p(i); 
ExpfnD = fn(i);
Database.pExpfD = pExpfD; 
Database.ExpfnD = ExpfnD;
Database.NonExpfn = NonExpfn; 
Database.pNonExpf = pNonExpf;

% reporting
str = 'Found: %d/%d standardized experiment folders';
display(sprintf(str,sum(i),numel(fn)));

% display unstandardized expfolders + prompt for correction
if sum(~i) ~=0; 
    display 'unstandardized exp folder names:';
    disp(NonExpfn)
    error('please correct exp folder name then rerun Dance...');
end

% pGfD and GfnD
display 'Searching for Group folders...';
[~,~,fn,p] = cellfun(@dircontent,pExpfD,'UniformOutput',0);
fn = celltakeout(fn,'multirow');
i = not(celltakeout(regexp(fn,'MatlabAnalysis'),'singlenumber'));
Gfn = fn(i);
p = celltakeout(p,'multirow');
pGf = p(i);
[fn,p,~,~] = cellfun(@dircontent,pGf,'UniformOutput',0);
empty = cellfun(@isempty,fn); % see which group folder is empty
pGfD = pGf(not(empty));
GfnD = Gfn(not(empty));
if sum(empty)>1; 
    pGfproblem = pGf(empty); 
    display ' ';
    warning('The following folders are empty:');
    disp(Gfn(empty));
    [~,a] = cellfun(@fileparts,...
        cellfun(@fileparts,pGfproblem,'UniformOutput',0),...
        'UniformOutput',0);
    display('From the following exp folders:');
    disp(unique(a))
    error('please correct before running Dance again');
end
str = '> %d group folders found under Exp folders';
display(sprintf(str,numel(Gfn)));
str = '> %d/%d unique Group folders';
display(sprintf(str,numel(unique(GfnD)),numel(GfnD)));
Database.GfnD = GfnD; Database.pGfD = pGfD;


% pMWTfD & MWTfnD
display 'Searching for MWT folders...';
fn = celltakeout(fn(not(empty)),'multirow');
p = celltakeout(p(not(empty)),'multirow');

mwt = logical(celltakeout(regexp(fn,'\<(\d{8})[_](\d{6})\>'),'singlenumber'));
pMWTf = p(mwt); 
MWTfn = fn(mwt);
Database.pMWTf = pMWTf; 
Database.MWTfn = MWTfn;

% Zip files?
zip = logical(celltakeout(regexp(fn,'\<(\d{8})[_](\d{6})\>.zip'),'singlenumber'));
pZipf = p(zip); 
Zipfn = fn(zip);
Database.pZipf = pZipf; 
Database.Zipfn = Zipfn;

% reporting
str = '> %d/%d unique MWT folders';
display(sprintf(str,numel(unique(MWTfn)),numel(MWTfn)));
if sum(zip)>1; 
    str = '> %d/%d unique zip files';
    display(sprintf(str,numel(unique(Zipfn)),numel(Zipfn)));

else
    display '> No zip files found.';
end

% zip unzipped files
pMWTfnotZip = pMWTf(~ismember(pMWTf, pZipf));
[~,unzipNames] = cellfun(@fileparts,pMWTfnotZip,'UniformOutput',0);
if isempty(unzipNames) == 0
    display('Found unzipped files: ')
    disp(unzipNames);
    [~,a] = cellfun(@fileparts,...
        cellfun(@fileparts,...
        cellfun(@fileparts,pMWTfnotZip,'UniformOutput',0),...
        'UniformOutput',0),...
        'UniformOutput',0);
    display('From the following exp folders:');
    disp(unique(a))
    error('Please fix unzip files then rerun analysis');
end

%% USER INPUT: SELECT ANALYSIS PACKAE [updated 20150412]
% define analysis package [updated 20150412]
display ' '; display 'Analysis options: ';
P = MWTSet.PATHS.pFunAnalysisPack; 
APack = dircontent(P);
disp(makedisplay(APack));
AnalysisName = APack{input('Select analysis option: ')};
MWTSet.PATHS.pFunAP = [P,'/',AnalysisName]; % GET ANALYSIS PACK PATH
addpath(MWTSet.PATHS.pFunAP);
MWTSet.AnalysisName = AnalysisName; % MWTSet output
%

%% USER INPUT: SELECT EXP TO ANALYZE [updated 20150412]
% BUG: need to fix unable to repeated narrowing down searches

% option list
display ' '; display 'Filtering files to analyze:';
choice = { 'Run condition';'Experimenter';'After a Date';'Key words'};       
% Search--
display ' '; display 'Search Experiment folders...';
% get database
ExpfnT = Database.ExpfnD;
pExpfT = Database.pExpfD;
% qurey
moresearch = 1;
while moresearch==1;   
    disp(makedisplay(choice))
    i = input('Search database by: ');
    SearchBy = choice{i};
    switch SearchBy
        case 'After a Date'
            a = regexpcellout(ExpfnD,'_','split');
            b = regexpcellout(a(:,1),'[A-Z]','split');
            b = str2num(cell2mat(b(:,1)));
            display('experiment list:');
            display(makedisplay((ExpfnD)));
            k = b >= input('Enter date [yyyymmdd]: ');
            pExpT = pExpfD(k); 
            ExpfnT = ExpfnD(k);
            display(sprintf('[%d] experiment found',numel(ExpfnT)));
            disp(ExpfnT);

        case 'Experimenter'
            display('Experimenter codes:');
            a = regexpcellout(ExpfnD,'_','split');
            RC = a(:,2); 
            r = unique(RC);
            [show] = makedisplay(r,'bracket'); disp(show);
            display('Enter Experimenter index,press [ENTER] to abort'); 
            a = input(': ');
            if isempty(a) ==1; 
                return; 
            else
                RCT = r(a);
                i = ismember(r{a},RC);
            end
            i = ismember(RC,RCT); % index to RC
            ExpfnT = ExpfnD(i); pExpfT = pExpfD(i);
            display(sprintf('[%d] experiment found',numel(ExpfnT)));
            disp(ExpfnT);
            
        case 'Run condition'
            display 'Run conditions:';
            a = celltakeout(regexp(ExpfnD,'_','split'),'split');
            RC = a(:,3); 
            r = unique(RC);
            [show] = makedisplay(r,'bracket'); disp(show);
            display 'Enter run condition number,press [ENTER] to abort'; 
            a = input(': ');
            if isempty(a) ==1; 
                return; 
            else
                RCT = r(a);
                i = ismember(r{a},RC);
            end
            i = ismember(RC,RCT); % index to RC
            ExpfnT = ExpfnD(i); pExpfT = pExpfD(i);
            display(sprintf('selected RC: %s',RCT{1}));
            display(sprintf('[%d] experiment found',numel(ExpfnT)));
            disp(ExpfnT);
            
        case 'Key words'
            pExpfS = pExpfT;
            ExpfnS = ExpfnT;
            display 'Enter search term:';
            searchterm = input(': ','s');
            k = regexp(ExpfnS,searchterm,'once');
            searchindex = logical(celltakeout(k,'singlenumber'));
            pExpfS = pExpfS(searchindex);
            ExpfnS = ExpfnS(searchindex);
            disp(ExpfnS);
            pExpfT = pExpfS;
            ExpfnT = ExpfnS;
            display 'Target experiments:';
            disp(ExpfnT); 
    end   
    moresearch = input('Narrow down search (y=1,n=0)?: ');
end
%

% GET EXP AND GROUP INFO FROM TARGET EXP
% pGfD and GfnD
display 'Searching for Group folders';
[~,~,fn,p] = cellfun(@dircontent,pExpfT,'UniformOutput',0);
fn = celltakeout(fn,'multirow');
i = not(celltakeout(regexp(fn,'MatlabAnalysis'),'singlenumber'));
Gfn = fn(i);
p = celltakeout(p,'multirow');
pGf = p(i);
[fn,p,~,~] = cellfun(@dircontent,pGf,'UniformOutput',0);
empty = cellfun(@isempty,fn); % see which group folder is empty
pGfD = pGf(not(empty));
GfnD = Gfn(not(empty));
if sum(empty)>1; 
    pGfproblem = pGf(empty); 
    display 'the following folders are empty:';
    disp(Gfn(empty));
end
str = '%d folders found under Exp folders';
display(sprintf(str,numel(Gfn)));
str = '%d/%d unique Group folders';
display(sprintf(str,numel(unique(GfnD)),numel(GfnD)));
Database.GfnT = GfnD; Database.pGfT = pGfD;
% pMWTfD & MWTfnD
display 'Searching for MWT folders';
fn = celltakeout(fn(not(empty)),'multirow');
p = celltakeout(p(not(empty)),'multirow');
mwt = logical(celltakeout(regexp(fn,'\<(\d{8})[_](\d{6})\>'),'singlenumber'));
pMWTf = p(mwt); MWTfn = fn(mwt);
str = '%d [%d unique] MWT folders';
display(sprintf(str,numel(MWTfn),numel(unique(MWTfn))));

% CHOOSE GROUP TO ANALYZE
gnameU = unique(Gfn);
disp([num2str((1:numel(gnameU))'),char(cellfunexpr(gnameU,')')),char(gnameU)]);
display 'Choose group(s) to analyze separated by [SPACE]';
display 'enter [ALL] to analyze all groups';
i = input(': ','s');
if strcmp(i,'ALL'); 
    gnamechose = gnameU;
else k = cellfun(@str2num,(regexp(i,'\s','split')'));
    gnamechose = gnameU(k); 
end

% select files
[pG,MWTn] = cellfun(@fileparts,pMWTf,'UniformOutput',0);
[pE,Gn] = cellfun(@fileparts,pG,'UniformOutput',0);
i = ismember(Gn,gnamechose);
MWTSet.MWTInfo.pMWT = pMWTf(i); 
MWTSet.MWTInfo.MWTfn = regexprep(MWTfn(i),'.zip','');

%% USER INPUT: WITHIN/ACROSS EXPERIMENTS
i = input('Within [1] or across [2] experiments: ');
if i == 1
    MWTSet.AnalysisSetting = 'Within Exp';
    % get exp name
    p = MWTSet.MWTInfo.pMWT;
    [pG,~] = cellfun(@fileparts,p,'UniformOutput',0);
    [pEU,gname] = cellfun(@fileparts,unique(pG),'UniformOutput',0);
    [~,expname] = cellfun(@fileparts,pEU,'UniformOutput',0);
    % each exp must have the same count as the total number of groups
    a = tabulate(expname);
    disp(a(:,1:2));
    i = cell2mat(a(:,2)) == numel(unique(gname));
    pET = pEU(i);
    [pE,~] = cellfun(@fileparts,pG,'UniformOutput',0);
    [~,expname] = cellfun(@fileparts,pE,'UniformOutput',0);
    i = ismember(expname,a(i,1));
    pMWT = p(i);
    MWTSet.MWTInfo.pMWT = pMWT;
    [~,MWTfn] = cellfun(@fileparts,pMWT,'UniformOutput',0);
    MWTSet.MWTInfo.MWTfn = regexprep(MWTfn,'.zip','');
    
else
    MWTSet.AnalysisSetting = 'Across Exp';
end

%% USER INPUT: CHOR OPTIONS [updated 20150412]
display ' ';
display 'Choreagraphy options:'

i = input('> Type ''new'' to overwrite with old chor outputs \n or press any key to use old outputs: ','s');
switch i
    case 'new'
        MWTSet.chor.chorstatus = 'new';
    otherwise
        MWTSet.chor.chorstatus = 'old';
end

%% USER INPUT: SET GROUP GRAPH SETTING [updated 20150412]
pMWT = MWTSet.MWTInfo.pMWT;
[pG,~] = cellfun(@fileparts,pMWT,'UniformOutput',0);
[~,GroupName] = cellfun(@fileparts,pG,'UniformOutput',0);
MWTSet.MWTInfo.GroupName = GroupName;

GroupNameU = unique(GroupName);
display ' ';
confirm = 0;
while confirm == 0
    
    %%
    
    %%
    display 'Choose graphing group sequence separated by space:';
    display(makedisplay(GroupNameU))
    i = input(': ','s');
    i = cellfun(@str2num,regexp(i,' ','split')')';
    GroupSeq = [num2cell((1:numel(GroupNameU))'), GroupNameU(i)];
    display ' ';
    display 'New graph sequence: ';
    disp(makedisplay(GroupSeq(:,2)))
    confirm = input('Is this correct (1 = yes, 0 = no): ');
end
MWTSet.GraphSetting.GroupSeq = GroupSeq;

%% REPORT GROUPS TO ANALYZE
display ' ';
p = MWTSet.MWTInfo.pMWT;
[pG,~] = cellfun(@fileparts,p,'UniformOutput',0);
[pE,gname] = cellfun(@fileparts,pG,'UniformOutput',0);
[~,expname] = cellfun(@fileparts,pE,'UniformOutput',0);
a = tabulate(expname);
display 'From the following experiments:';
disp(a(:,1));

a = tabulate(gname);
display 'Number of plates to analyze per group:';
[~,i] = ismember(MWTSet.GraphSetting.GroupSeq(:,2),a(:,1));
disp(a(i,1:2));

%% CREATE MWT CHOR RESULTS FILE PATH
pMWTf = regexprep(...
    regexprep(MWTSet.MWTInfo.pMWT,'.zip',''),...
    MWTSet.PATHS.pData, MWTSet.PATHS.pAnalysis);
[~,MWTfn] = cellfun(@fileparts,pMWTf,'UniformOutput',0);
MWTSet.MWTInfo.pMWTf_Results = pMWTf; 
MWTSet.MWTInfo.MWTfn_Results = MWTfn; 
%

%% ANALYSIS [updated 20150412]
addpath([MWTSet.PATHS.pFunAnalysisPack,'/',MWTSet.AnalysisName]);
eval(['[MWTSet] = Dance_',AnalysisName,'(MWTSet);']);

%% SAVE [updated 20150412]
cd(MWTSet.PATHS.pSaveA);
save('matlab.mat','MWTSet');

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

%% display and save
cd(MWTSet.PATHS.pSaveA);
save('matlab.mat','MWTSet');

display '  ** Dance: The End **'
display ' ';
%% VARARGOUT
varargout{1} = MWTSet;

































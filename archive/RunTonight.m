%% [OBJECTIVE] Analyze all for tap responsses
%% STEP0: PREPARE PATHS [Need flexibility] 
clear;
restoredefaultpath;
pSave = '/Volumes/Rose/MultiWormTrackerPortal/MWT_Analysis_20130811/SummaryAnalysis';
pMaestro = '/Volumes/AWLIGHT/MWT/Archived Analysis/Maestro';
pRose = '/Volumes/Rose/MultiWormTrackerPortal/MWT_Analysis_20130811';
pFun = '/Users/connylinlin/MatLabTest/MultiWormTrackerPortal/MWT_Programs';
pSet = '/Users/connylinlin/MatLabTest/MultiWormTrackerPortal/MWT_Programs/MatSetfiles';

addpath(genpath(pFun));
HomePath = pRose;
pSum = '/Volumes/Rose/MultiWormTrackerPortal/MWT_Analysis_20130811/Summary';

%% STEP1: DEFINE TARGET EXPERIMENTS
% STEP1A: DEFINE ANALYSIS OBJECTIVES
display 'Name your analysis output folder'
name = input(': ','s');
mkdir(pSave,name);
pSaveA = [pSave,'/',name];

% STEP1B: GET EXP DATABASE
% get hard drive name
a = regexp(HomePath,'/Volumes/','split');
b = regexp(a{2},'/','split');
hardrivename = b{1};
savename = ['MWTExpDataBase_' hardrivename, '.mat'];

% load database
display 'Checking if MWTExpDataBase is already loaded';
if exist('pExpfD','var')==0||exist('ExpfnD','var')==0||...
        exist('pMWTfD','var')==0|| exist('MWTfnD','var')==0;
display 'Loading MWTExpDataBase...';
cd(pSet);
load(savename,'pExpfD','ExpfnD','pMWTfD','MWTfnD','MWTfsnD',...
    'dateupdated','HomePath');
% check if database needs to be upated
[~,~,ExpfnU,~] = dircontent(HomePath);
ExpfnU = sortrows(ExpfnU);
b = ExpfnU(end);
a = regexp(b,'(\d{8})','match','once');
if str2num(a{1})>str2num(dateupdated);
    display 'MWTExpDataBase need to be updated'
    [pExpfD,ExpfnD,~,~,pMWTfD,MWTfnD,MWTfsnD] = getMWTpathsNname(HomePath,'noshow');
    dateupdated = datestr(date,'yyyymmdd'); % record date
    cd(pSet);
    savename = ['MWTExpDataBase_' hardrivename, '.mat'];
    save(savename,'pExpfD','ExpfnD','pMWTfD','MWTfnD','MWTfsnD',...
        'dateupdated','HomePath'); 
end
end
display 'done.';
% STEP1C: SELECT TARGET EXPERIMENTS
% search for target paths
display 'Search for...'
display 'MWT files [M], Exp files [E], Group name [G] or no search [A]?';
searchclass = input(': ','s');
switch searchclass
    case 'M' % search for MWT
        display 'option under construction'
    case 'G' % search for group name
        display 'option under construction'
        
    case 'E' % search for Experiment folders
        display 'Enter search term:';
        searchterm = input(': ','s');
        % find matches
        k = regexp(ExpfnD,searchterm,'once');
        searchindex = logical(celltakeout(k,'singlenumber'));
        pExpfS = pExpfD(searchindex);
        ExpfnS = ExpfnD(searchindex);
        disp(ExpfnS);
        moresearch = input('Narrow down search (y=1,n=0)?: ');
        while moresearch==1;
            display 'Enter search term:';
            searchterm = input(': ','s');
            % find matches
            k = regexp(ExpfnS,searchterm,'once');
            searchindex = logical(celltakeout(k,'singlenumber'));
            pExpfS = pExpfS(searchindex);
            ExpfnS = ExpfnS(searchindex);
            disp(ExpfnS);
            moresearch = input('Narrow down search (y=1,n=0)?: ');
        end
        pExpfT = pExpfS;
        ExpfnT = ExpfnS;
        display 'Target experiments:';
        disp(ExpfnT); 
    case 'A'
        pExpfT = pExpfD;
        ExpfnT = ExpfnD;
end  
if isempty(ExpfnT)==1; display 'No target experiments'; return; end

% STEP1E. GET EXP AND GROUP INFO FROM TARGET EXP
[A] = MWTDataBaseMaster(pExpfT,'GetExpTargetInfo');
Gfn = A.GfnT; pGf = A.pGfT; pMWTfT = A.pMWTfT; MWTfnT = A.MWTfnT;

%% STEP3: GET GROUPED MWT folders
% STEP2A: CHOOSE GROUP TO ANALYZE
gnameU = unique(Gfn);
a = num2str((1:numel(gnameU))');
[b] = char(cellfunexpr(gnameU,')'));
c = char(gnameU);
show = [a,b,c];
disp(show);
display 'Choose group(s) to analyze separated by [SPACE]';
display 'or enter [ALL] to analyze all';
i = input(': ','s');
if strcmp(i,'ALL')==1;gnamechose = gnameU;
else
    k = str2num(cell2mat(regexp(i,'\s','split')'));
    gnamechose = gnameU(k);
end

% STEP2B: GET MWT FILES UNDER SELECTED GROUP
% get experiment count for each group
MWTfG = [];
for g = 1:numel(gnamechose);
    str = 'Searching MWT files for group [%s]';
    display(sprintf(str,gnamechose{g}));
    % find MWT files under group folder
    search = ['\<',gnamechose{g},'\>'];
    i = logical(celltakeout(regexp(Gfn,search),'singlenumber'));
    pGfT = pGf(i);
    [MWTfn,pMWTf] = cellfun(@dircontentmwt,pGfT,'UniformOutput',0);
    MWTfn = celltakeout(MWTfn,'multirow');
    pMWTf = celltakeout(pMWTf,'multirow');
    a = celltakeout(regexp(MWTfn,'^(\d{8})','match'),'match');
    expcount = numel(unique(a));
    str = 'Got %d MWT files from %d experiments';
    display(sprintf(str,numel(MWTfn),expcount));
    % create output file
    MWTfG.(gnamechose{g})(:,1:2) = [MWTfn,pMWTf];
end

%% STEP4: CHOR OUTPUTS
% STEP3A: define chor outputs for search and source files
fnvalidate = {'*.trv'};
% option = 'checkLadyGaGa';
% AnaList = '(LadyGaGa)|(ShaneSpark)|(Beethoven)|(check)';
% ActList = '(check)';
% %chormaster
% Chor = char(regexp(option,AnaList,'match'))
% if numel(Chor)>1;end

% STEP3B: CHECK IF CHOR HAD BEEN DONE
display 'Checking chor outputs...'
% prepare pMWTf input for validation
% A = celltakeout(struct2cell(MWTfG),'multirow');
% pMWTfT = A(:,2); MWTfnT = A(:,1);
% pMWTf = pMWTfT; MWTfn = MWTfnT;
pMWTf = A.pMWTfT; MWTfn = A.MWTfnT;
% check chor ouptputs
pMWTfC = {}; MWTfnC = {}; 
for v = 1:size(fnvalidate,1);
    [valname] = cellfunexpr(pMWTf,fnvalidate{v});
    [fn,path] = cellfun(@dircontentext,pMWTf,valname,'UniformOutput',0);
    novalfn = cellfun(@isempty,fn);
    if sum(novalfn)~=0;
        str = 'The following MWTf does not have [%s]:';
        display(sprintf(str,fnvalidate{v}));
        disp(MWTfn(novalfn));
        pMWTfnoval = pMWTf(novalfn); MWTfnoval = MWTfn(novalfn);
        pMWTfC = [pMWTfC;pMWTfnoval]; MWTfnC = [MWTfnC;MWTfnoval];
    end
end
pMWTfC = unique(pMWTfC); MWTfnC = unique(MWTfnC);
if isempty(pMWTfC)==0;
    str = 'Chor needs to be done for %d MWT files';
    display(sprintf(str,numel(MWTfnC)));
%     display 'Chor need to be done for MWT files below:'; disp(MWTfnC);
else
    display 'Chor outputs below found in all target MWT files:';
    disp(fnvalidate');
end
% STEP3C: CHORE IF NEEDED
% choreography
if isempty(pMWTfC)==0; [chorscript] = chormaster(pMWTfC,'Beethoven');
else display 'No Chor needs to be ran.'; end


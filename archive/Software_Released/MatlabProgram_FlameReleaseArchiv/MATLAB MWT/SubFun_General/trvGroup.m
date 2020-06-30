%% [OBJECTIVE] Analyze all for tap responsses
%% STEP1: PREPARE PATHS [Need flexibility] 
clear;
pMaestro = '/Volumes/AWLIGHT/MWT/Archived Analysis/Maestro';
pRose = '/Volumes/Rose/MultiWormTrackerPortal/MWT_Analysis_20130811';
pFun = '/Users/connylinlin/MatLabTest/MultiWormTrackerPortal/MWT_Programs';
pSet = '/Users/connylinlin/MatLabTest/MultiWormTrackerPortal/MWT_Programs/MatSetfiles';
pSum = '/Volumes/Rose/MultiWormTrackerPortal/Summary';
pSave = '/Volumes/Rose/MultiWormTrackerPortal/SummaryAnalysis';
addpath(genpath(pFun));
HomePath = pRose;

%% STEP2: DEFINE TRAGET MWT FILES
% STEP2A: GET BASIC EXP INFO
display 'Checking if MWTExpDataBase is already loaded';
if exist('pExpfD','var')==0||exist('ExpfnD','var')==0||...
        exist('pMWTfD','var')==0|| exist('MWTfnD','var')==0;
display 'Loading MWTExpDataBase...';
[A] = MWTDataBaseMaster(HomePath,'GetStdMWTDataBase');
pExpfD = A.pExpfD; ExpfnD = A.ExpfnD; GfnD = A.GfnD;
pGfD = A.pGfD; pMWTf = A.pMWTf; MWTfn = A.MWTfn;
end
% [suspend] STEP1B: GET EXP DATABASE
% % get hard drive name
% a = regexp(HomePath,'/Volumes/','split');
% b = regexp(a{2},'/','split');
% hardrivename = b{1};
% savename = ['MWTExpDataBase_' hardrivename, '.mat'];
% 
% % load database
% display 'Checking if MWTExpDataBase is already loaded';
% if exist('pExpfD','var')==0||exist('ExpfnD','var')==0||...
%         exist('pMWTfD','var')==0|| exist('MWTfnD','var')==0;
% display 'Loading MWTExpDataBase...';
% cd(pSet);
% load(savename,'pExpfD','ExpfnD','pMWTfD','MWTfnD','MWTfsnD',...
%     'dateupdated','HomePath');
% % check if database needs to be upated
% [~,~,ExpfnU,~] = dircontent(HomePath);
% ExpfnU = sortrows(ExpfnU);
% b = ExpfnU(end);
% a = regexp(b,'(\d{8})','match','once');
% if str2num(a{1})>str2num(dateupdated);
%     display 'MWTExpDataBase need to be updated';
%     
%     [pExpfD,ExpfnD,~,~,pMWTfD,MWTfnD,MWTfsnD] = getMWTpathsNname(HomePath,'noshow');
%     dateupdated = datestr(date,'yyyymmdd'); % record date
%     cd(pSet);
%     savename = ['MWTExpDataBase_' hardrivename, '.mat'];
%     save(savename,'pExpfD','ExpfnD','pMWTfD','MWTfnD','MWTfsnD',...
%         'dateupdated','HomePath'); 
% end
% end
% display 'done.';
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
% STEP2C: CHOOSE GROUP TO ANALYZE
gnameU = unique(Gfn);
a = num2str((1:numel(gnameU))');
[b] = char(cellfunexpr(gnameU,')'));
c = char(gnameU);
show = [a,b,c];
disp(show);
display 'Choose group(s) to analyze separated by [SPACE]';
display 'enter [ALL] to analyze all groups';
i = input(': ','s');
if strcmp(i,'ALL'); gnamechose = gnameU;
else k = cellfun(@str2num,(regexp(i,'\s','split')'));
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
% STEP2D: SORT GROUP DISPLAY SEQUENCE
[show] = makedisplay(gnamechose,'bracket');
disp(show);
display 'is this the sequence to be appeared on graphs (y=1 n=0)';
q2 = input(': ');
while q2 ==0;
    display 'Enter the correct sequence separated by [SPACE]';
    s = str2num(input(': ','s'));
    gnamechose = gnamechose(s,1);
    [show] = makedisplay(gnamechose,'bracket');
    disp(show);
    q2 = input('is this correct(y=1 n=0): ');
end

%% STEP3: CHOR 
%% STEP3A: DEFINE ANALYSIS OBJECTIVES
display 'Name your analysis output folder'
name = input(': ','s');
mkdir(pSave,name);
pSaveA = [pSave,'/',name];
%% STEP3B: DEFINE CHOROUTPUTS AND CHOR CODE
fnvalidate = {'*.trv';'*shanespark.dat'}; chorcode = 'ShaneSpark';
%% STEP3C: CHOR OUTPUTS AND RUN CHOR
% STEP4B: CHECK IF CHOR HAD BEEN DONE
display ' '; display 'Checking chor outputs...'
% prepare pMWTf input for validation
A = celltakeout(struct2cell(MWTfG),'multirow');
pMWTfT = A(:,2); MWTfnT = A(:,1);
pMWTf = pMWTfT; MWTfn = MWTfnT;

% check chor ouptputs
pMWTfC = {}; MWTfnC = {}; 
for v = 1:size(fnvalidate,1);
    [valname] = cellfunexpr(pMWTf,fnvalidate{v});
    [fn,path] = cellfun(@dircontentext,pMWTf,valname,'UniformOutput',0);
    novalfn = cellfun(@isempty,fn);
    if sum(novalfn)~=0;
%         str = 'The following MWTf does not have [%s]:';
%         display(sprintf(str,fnvalidate{v}));
%         disp(MWTfn(novalfn));
        pMWTfnoval = pMWTf(novalfn); MWTfnoval = MWTfn(novalfn);
        pMWTfC = [pMWTfC;pMWTfnoval]; MWTfnC = [MWTfnC;MWTfnoval];
    end
end
pMWTfC = unique(pMWTfC); MWTfnC = unique(MWTfnC);
% reporting
if isempty(pMWTfC)==0;
    str = 'Need to Chore %d MWT files';
    display(sprintf(str,numel(pMWTfC)));
else display 'All files have required Chor outputs';
end
% STEP4C: RUN CHORE
if isempty(pMWTfC)==0; [chorscript] = chormaster(pMWTfC,chorcode);
else display 'No Chor needs to be ran.'; end
%% STEP3D: IMPORT CHOR OUTPUTS
% rev_ssr = '--plugin MeasureReversal::tap::collect=0.5::postfix=ssr';
% reporting
display ' '; display('Importing ssr generated by Choreography...');

%% STEP4: STATS AND GRAPHING
%% STEP3E: EXCLUDE CHOR PROBLEM MWT FILES FROM ANALYSIS
% RE-CHECK CHOR OUTPUTS
display ' '; display 'Double checking chor outputs...'
% prepare pMWTf input for validation
A = celltakeout(struct2cell(MWTfG),'multirow');
pMWTfT = A(:,2); MWTfnT = A(:,1);
pMWTf = pMWTfT; MWTfn = MWTfnT;
% check chor ouptputs
pMWTfC = {}; MWTfnC = {}; 
for v = 1:size(fnvalidate,1);
    [valname] = cellfunexpr(pMWTf,fnvalidate{v});
    [fn,path] = cellfun(@dircontentext,pMWTf,valname,'UniformOutput',0);
    novalfn = cellfun(@isempty,fn);
    if sum(novalfn)~=0;
        pMWTfnoval = pMWTf(novalfn); MWTfnoval = MWTfn(novalfn);
        pMWTfC = [pMWTfC;pMWTfnoval]; MWTfnC = [MWTfnC;MWTfnoval];
    end
end
pMWTfC = unique(pMWTfC); MWTfnC = unique(MWTfnC);
% reporting
if isempty(pMWTfC)==1; display 'All files have required Chor outputs';
elseif isempty(pMWTfC)==0;
    str = 'Chore unsuccessful in %d MWT files';
    display(sprintf(str,numel(pMWTfC)));disp(MWTfnC);
    % STEP3F: EXCLUDE PROBLEM MWT FILES
    display 'Excluding problem MWT from analysis';
    gname = fieldnames(MWTfG);
    for x = 1:numel(MWTfnC) % each problem folders
        for g = 1:numel(gname)
            A = MWTfG.(gname{g})(:,1);
            i = logical(celltakeout(regexp(A,MWTfnC{x}),'singlenumber'));
            if sum(i)>0; 
                str = '>removing [%s]';
                display(sprintf(str,MWTfnC{x}));
                MWTfG.(gname{g})(i,:)=[]; % remove that from analysis
            end
        end
    end
end
%% STEP4A: IMPORT .TRV 
% get MWT list
A = celltakeout(struct2cell(MWTfG),'multirow');
pMWTfT = A(:,2); MWTfnT = A(:,1);
pMWTf = pMWTfT; MWTfn = MWTfnT;
% creating MWTftrv legend
% ALegend = {1,'MWTfile name';3,'RawData'};
% trvL = {1,'time';2,'N?';3,'Noresponse';4,'NReversed';5,'RevDist'};
% import 
A = MWTfn;
for m = 1:size(pMWTf,1);
    [fn,~] = dircontentext(pMWTf{m},'*.trv'); 
    a = dlmread(fn{1},' ',0,0);
    i = [1,3:5,8:10,12:16,19:21,23:27]; % index to none zeros
    A{m,2} = a(:,i); % remove zeros
end
MWTfnImport = A;
%% STEP4X: check tap consistency
[r,c] = cellfun(@size,MWTfnImport(:,2),'UniformOutput',0);
rn = celltakeout(r,'singlenumber');
rfreq = tabulate(rn);
rcommon = rfreq(rfreq(:,2) == max(rfreq(:,2)),1);
str = 'Most common tap number = %d';
display(sprintf(str,rcommon));
rproblem = rn ~= rcommon;
MWTfnP = MWTfn(rproblem);
str = 'The following MWT did not have the same tap(=%d)';
display(sprintf(str,rcommon));
disp(MWTfnP);
display 'Removing from analysis...';
gname = fieldnames(MWTfG);
for x = 1:numel(MWTfnP) % each problem folders
    for g = 1:numel(gname)
        A = MWTfG.(gname{g})(:,1);
        i = logical(celltakeout(regexp(A,MWTfnP{x}),'singlenumber'));
        if sum(i)>0; 
            str = '>removing [%s] from group file';
            display(sprintf(str,MWTfnP{x}));
            MWTfG.(gname{g})(i,:)=[]; % remove that from analysis
        end
        k = logical(celltakeout(regexp(MWTfnImport(:,1),MWTfnP{x}),'singlenumber'));
        if sum(k)>0; 
            str = '>removing [%s] from imported file';
            display(sprintf(str,MWTfnP{x}));
            MWTfnImport(k,:)=[]; % remove that from analysis
        end
    end
end
%% STEP4B: AND MAKING SENSE OF TRV 
% reload MWT files
A = celltakeout(struct2cell(MWTfG),'multirow');
pMWTf = A(:,2); MWTfn = A(:,1);
% calculate
B = [];
B.MWTfn = MWTfn;
A = MWTfnImport;
for m = 1:size(pMWTf,1);
    B.X.TapTime(:,m) = A{m,2}(:,1); 
    B.N.NoResponse(:,m) = A{m,2}(:,3);
    B.N.Reversed(:,m) = A{m,2}(:,4); 
    B.N.TotalN(:,m) = B.N.Reversed(:,m)+B.N.NoResponse(:,m);
    B.Y.RevFreq(:,m) = B.N.Reversed(:,m)./B.N.TotalN(:,m);
    B.Y.RevDist(:,m) = A{m,2}(:,5); 
%     B.Y.SumRevDist(:,m) = B.Y.RevDist(:,m).*B.N.Reversed(:,m); 
    B.Y.RevDistStd(:,m) = B.Y.RevDist(:,m)/B.Y.RevDist(1,m);
    B.Y.RevFreqStd(:,m) = B.Y.RevFreq(:,m)/B.Y.RevFreq(1,m); % freqStd
end
Stats = B;
%% STEP4B: PREPARE GRAPH SUMMARY FOR SUBPLOTS
Graph = [];
MWTfnimport = Stats.MWTfn;
M = fieldnames(Stats.Y);
gnameL = gnamechose;
for m = 1:numel(M);% for each measure
    Y = []; X = []; E = [];
    for g = 1:numel(gnameL); % for each group
        gname = gnameL{g};
        pMWTf = MWTfG.(gname)(:,2); 
        MWTfn = MWTfG.(gname)(:,1);
        N = size(MWTfG.(gname),1);
        [~,i,~] = intersect(MWTfnimport,MWTfn);
        Graph.Y.(M{m})(:,g) = mean(Stats.Y.(M{m})(:,i),2);
        Graph.E.(M{m})(:,g) = std(Stats.Y.(M{m})(:,i)')'./sqrt(N);
        Graph.X.(M{m})(:,g) = (1:size(Stats.X.TapTime,1));
    end
end 
%% STEP4C.SUBPLOTS
% source code: LadyGaGaSubPlot(MWTftrvG,pExp,SavePrefix)
% define universal settings
% switch graphing sequence
i = [2,3,1,4];
k = fieldnames(Stats.Y)';
M = k(i);
groupname = gnamechose';
groupsize = numel(gnamechose);
gnshow = regexprep(groupname,'_',' ');
xmax = size(Graph.X.(M{m}),1)+1;
subplotposition(1,1:4) = [0.065 0.55 0.4 0.4];
subplotposition(2,1:4) = [0.55 0.55 0.4 0.4];
subplotposition(3,1:4) = [0.065 0.11 0.4 0.4];
subplotposition(4,1:4) = [0.55 0.11 0.4 0.4];
legendposition = 2;
% Create figure
figure1 = figure('Color',[1 1 1]); 
for m = 1:numel(M);
axes1 = axes('Parent',figure1,'FontName','Arial',...
    'Position',subplotposition(m,1:4));
% 'XTickLabel','', (remove setting it off
ylim(axes1,[0 1.1]); xlim(axes1,[0 xmax]); hold(axes1,'all');
errorbar1 = errorbar(Graph.X.(M{m}),Graph.Y.(M{m}),Graph.E.(M{m}),...
    'Marker','.','LineWidth',1);
ylabel(M{m},'FontName','Arial'); % Create ylabel
if m ==legendposition; % if making righttop cornor
    for g = 1:numel(groupname);
            set(errorbar1(g),'DisplayName',gnshow{g});
            legend1 = legend(axes1,'show');
            set(legend1,'EdgeColor',[1 1 1],'YColor',[1 1 1],...
                'XColor',[1 1 1],'TickDir','in',...
                'LineWidth',1);
    end
end
end
% create textbox for N
for g = 1:numel(groupname); gN(g) = size(MWTfG.(groupname{g}),1); end
n = num2str(gN'); b = cellfunexpr(groupname',' ');
a = char(cell2mat(cellstr([n,char(b)])'));
v = a(1,1:end); t = 'N = '; 
N = [t,v];
annotation(figure1,'textbox',[0.003 0.02 0.20 0.05],'String',{N},...
    'FontName','Arial','FitBoxToText','off','EdgeColor','none');
% save figure 
h = (gcf);
titlename = ['ShaneSpark_CombineGraph']; % set name of the figure
set(h,'PaperPositionMode','auto'); % set to save as appeared on screen
cd(pSaveA);
print (h,'-dtiff', '-r0', titlename); saveas(h,titlename,'fig');
% finish up
display 'Graph done.';
close;



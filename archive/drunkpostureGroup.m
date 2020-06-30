%% [OBJECTIVE] COMBINE GROUPS (drunk posture)
% source: drunkposterdotdat
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
%% STEP2: USER INPUT-TIME INTERVALS
% works only for the same run conditions
status = 'input';
switch status
    case 'input'
        display 'Enter analysis time periods: ';
        tinput = input('Enter start time, press [Enter] to use MinTracked: ');
        intinput = input('Enter interval, press [Enter] to use default (10s): ');
        tfinput = input('Enter end time, press [Enter] to use MaxTracked: ');
        display 'Enter duration after each time point to analyze';
% (optional) survey duration after specifoied target time point
        durinput = input('press [Enter] to analyze all time bewteen intervals: '); 
    case 'auto'
        tinput = []; int = []; tf = []; dur = [];
end

%% STEP3: GET GROUPED MWT folders
% STEP2A: CHOOSE GROUP TO ANALYZE
gnameU = unique(Gfn);
a = num2str((1:numel(gnameU))');
[b] = char(cellfunexpr(gnameU,')'));
c = char(gnameU);
show = [a,b,c];
disp(show);
display 'Choose group(s) to analyze separated by [SPACE]';
i = input(': ','s');
k = str2num(cell2mat(regexp(i,'\s','split')'));
gnamechose = gnameU(k);
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

%% STEP4: CHOR 
% STEP3A: DEFINE ANALYSIS OBJECTIVES
display 'Name your analysis output folder'
name = input(': ','s');
mkdir(pSave,name);
pSaveA = [pSave,'/',name];
% STEP3A: define chor outputs for search and source files
fnvalidate = {'*drunkposture.dat'};
% option = 'checkLadyGaGa';
% AnaList = '(LadyGaGa)|(ShaneSpark)|(Beethoven)|(check)';
% ActList = '(check)';
% %chormaster
% Chor = char(regexp(option,AnaList,'match'))
% if numel(Chor)>1;end
% STEP3B: CHECK IF CHOR HAD BEEN DONE
display 'Checking chor outputs...'
% prepare pMWTf input for validation
A = celltakeout(struct2cell(MWTfG),'multirow');
pMWTfT = A(:,2); MWTfnT = A(:,1);
pMWTf = pMWTfT; MWTfn = MWTfnT;

%% check chor ouptputs
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
    str = 'Chor need to be done for %d MWT files'; 
    display(sprintf(str,numel(MWTfnC)));
else
    display 'Chor outputs below found in all target MWT files:';
    disp(fnvalidate');
end
%% STEP3C: CHORE IF NEEDED
% choreography
if isempty(pMWTfC)==0; [chorscript] = chormaster(pMWTfC,'LadyGaGa');
else display 'No Chor needs to be ran.'; end
%% STEP5: Import and process Chor generated data
display 'Importing drunkposture.dat';
% tnNslwakb
% drunkposturedatL = {1,'time';2,'number';3,'goodnumber';4,'speed';5,'length';...
%     6,'width';7,'aspect';8,'kink';9,'bias'};
for p = 1 : numel(pMWTfT);
str = 'Importing from [%s]';
display(sprintf(str,MWTfnT{p}));
[~,datevanimport] = dircontentext(pMWTfT{p},'*drunkposture.dat');  
A(p,1) = MWTfnT(p);
A(p,2) = {dlmread(datevanimport{1})};
end
MWTfdrunkposturedat = A;
display 'Got all the drunkposture.dat.';
%% STEP6: Run Graphing
%% STEP6A: PREPARE TIME POINTS
% prepare universal timepoints limits
% timepoints
% find smallest starting time and smallest ending time
MWTfdrunkposturedatL = {1,'MWTfname';2,'Data';3,'time(min)';4,'time(max)'};
Raw = MWTfdrunkposturedat;    
for p = 1:numel(MWTfn)
    Raw{p,3} = min(Raw{p,2}(:,1)); 
    Raw{p,4} = max(Raw{p,2}(:,1));
end
valstartime = max(cell2mat(Raw(:,3)));
valendtime = min(cell2mat(Raw(:,4)));
str = 'Earliest time tracked (MinTracked): %0.1f';
display(sprintf(str,valstartime));
str = 'Max time tracked  (MaxTracked): %0.1f';
display(sprintf(str,valendtime));
% processing inputs
if tinput ==0; ti = valstartime; 
elseif isempty(tinput)==1; ti = valstartime; tinput = 0; 
elseif tinput>valstartime; ti = tinput; 
end
if isempty(intinput)==1; int = 10; else int = intinput; end
if isempty(tfinput)==1; tf = valendtime; else tf = tfinput; end
if isempty(durinput)==0; duration = 'restricted'; else duration = 'all'; end

% reporting
str = 'Starting time: %0.0fs';
display(sprintf(str,ti));
switch duration
    case 'all'
        timepoints = [0,ti+int:int:tf];
        str = 'Time points: %0.0f ';
        timeN = numel(timepoints);
        display(sprintf(str,timeN));
    case 'restricted'
        display 'Under construction';% need coding
end
%% STEP6B: STATS
Raw = MWTfdrunkposturedat;
% Stats.MWTfdrunkposturedat
% drunkposturedatL = {1,'time';2,'number';3,'goodnumber';4,'Speed';5,'Length';...
%     6,'Width';7,'Aspect';8,'Kink';9,'Bias'};
Graph = [];
for p = 1:numel(MWTfn);
    Graph.X = timepoints; Graph.MWTfn = MWTfn';
    % summary 
    for t = 1:numel(timepoints)-1; % for each stim
        % get timeframe
        k = Raw{p,2}(:,1)>timepoints(t) & Raw{p,2}(:,1)<timepoints(t+1); 
        dataVal = Raw{p,2}(k,:);
        % create Graph.N
        Nrev = size(dataVal(:,2),1);
        Graph.N.Ndatapoints(t,p) = Nrev;
        Graph.N.NsumN(t,p) = sum(dataVal(:,2));
        Graph.N.NsumNVal(t,p) = sum(dataVal(:,3));
        Graph.Y.Speed(t,p) = mean(dataVal(:,4));
        Graph.E.Speed(t,p) = std(dataVal(:,4))./sqrt(Nrev);
        Graph.Y.Length(t,p) = mean(dataVal(:,5));
        Graph.E.Length(t,p) = std(dataVal(:,5))./sqrt(Nrev);
        Graph.Y.Width(t,p) = mean(dataVal(:,6));
        Graph.E.Width(t,p) = std(dataVal(:,6))./sqrt(Nrev);
        Graph.Y.Aspect(t,p) = mean(dataVal(:,7));
        Graph.E.Aspect(t,p) = std(dataVal(:,7))./sqrt(Nrev);        
        Graph.Y.Kink(t,p) = mean(dataVal(:,8));
        Graph.E.Kink(t,p) = std(dataVal(:,8))./sqrt(Nrev);         
        Graph.Y.Bias(t,p) = mean(dataVal(:,8));
        Graph.E.Bias(t,p) = std(dataVal(:,8))./sqrt(Nrev);
    end
end
Graph.YLegend = fieldnames(Graph.Y);
clearvars Y X E;
MWTfnimport = (Graph.MWTfn');
M = Graph.YLegend;
gnameL = gnamechose;
for m = 1:numel(M);% for each measure
    for g = 1:numel(gnameL);
        gname = gnameL{g};
        pMWTf = MWTfG.(gname)(:,2); 
        MWTfn = MWTfG.(gname)(:,1);
        A.MWTfn = MWTfn;
        [~,i,~] = intersect(MWTfnimport(:,1),MWTfn);
        Y(:,g) = mean(Graph.Y.(M{m})(:,i),2);
        E(:,g) = std(Graph.Y.(M{m})(:,i)')'./sqrt(sum(i));
        X(:,g) = Graph.X(2:end);
    end
    errorbar(X,Y,E);
    figname = [M{m},'[',num2str(ti,'%.0f'),':',num2str(int,'%.0f'),':',num2str(tf,'%.0f'),']'];
    savefig(figname,pSaveA);
end   

%% STEP7: RERUN
% 
% run = input('would you like to run different time points (y=1,n=0)? ');
% while run ==1;
% % STEP2: USER INPUT-TIME INTERVALS
% % works only for the same run conditions
% status = 'input';
% switch status
%     case 'input'
%         display 'Enter analysis time periods: ';
%         tinput = input('Enter start time, press [Enter] to use MinTracked: ');
%         intinput = input('Enter interval, press [Enter] to use default (10s): ');
%         tfinput = input('Enter end time, press [Enter] to use MaxTracked: ');
%         display 'Enter duration after each time point to analyze';
% % (optional) survey duration after specifoied target time point
%         durinput = input('press [Enter] to analyze all time bewteen intervals: '); 
%     case 'auto'
%         tinput = []; int = []; tf = []; dur = [];
% end
% % STEP1A: DEFINE ANALYSIS OBJECTIVES
% display 'Name your analysis output folder'
% name = input(': ','s');
% mkdir(pSave,name);
% pSaveA = [pSave,'/',name];
% 
% % STEP6: Run Graphing
% % STEP6A: PREPARE TIME POINTS
% % prepare universal timepoints limits
% % timepoints
% % find smallest starting time and smallest ending time
% MWTfdrunkposturedatL = {1,'MWTfname';2,'Data';3,'time(min)';4,'time(max)'};
% Raw = MWTfdrunkposturedat;    
% for p = 1:numel(MWTfn)
%     Raw{p,3} = min(Raw{p,2}(:,1)); 
%     Raw{p,4} = max(Raw{p,2}(:,1));
% end
% valstartime = max(cell2mat(Raw(:,3)));
% valendtime = min(cell2mat(Raw(:,4)));
% str = 'Earliest time tracked (MinTracked): %0.1f';
% display(sprintf(str,valstartime));
% str = 'Max time tracked  (MaxTracked): %0.1f';
% display(sprintf(str,valendtime));
% % processing inputs
% if tinput ==0; ti = valstartime; 
% elseif isempty(tinput)==1; ti = valstartime; tinput = 0; 
% elseif tinput>valstartime; ti = tinput; 
% end
% if isempty(intinput)==1; int = 10; else int = intinput; end
% if isempty(tfinput)==1; tf = valendtime; else tf = tfinput; end
% if isempty(durinput)==0; duration = 'restricted'; else duration = 'all'; end
% 
% % reporting
% str = 'Starting time: %0.0fs';
% display(sprintf(str,ti));
% switch duration
%     case 'all'
%         timepoints = [0,ti+int:int:tf];
%         str = 'Time points: %0.0f ';
%         timeN = numel(timepoints);
%         display(sprintf(str,timeN));
%     case 'restricted'
%         display 'Under construction';% need coding
% end
% % STEP6B: STATS
% Raw = MWTfdrunkposturedat;
% % Stats.MWTfdrunkposturedat
% % drunkposturedatL = {1,'time';2,'number';3,'goodnumber';4,'Speed';5,'Length';...
% %     6,'Width';7,'Aspect';8,'Kink';9,'Bias'};
% Graph = [];
% for p = 1:numel(MWTfn);
%     Graph.X = timepoints;
%     Graph.MWTfn = MWTfn';
%     % summary 
%     for t = 1:numel(timepoints)-1; % for each stim
%         % get timeframe
%         k = Raw{p,2}(:,1)>timepoints(t) & Raw{p,2}(:,1)<timepoints(t+1); 
%         dataVal = Raw{p,2}(k,:);
%         % create Graph.N
%         Nrev = size(dataVal(:,2),1);
%         Graph.N.Ndatapoints(t,p) = Nrev;
%         Graph.N.NsumN(t,p) = sum(dataVal(:,2));
%         Graph.N.NsumNVal(t,p) = sum(dataVal(:,3));
%         Graph.Y.Speed(t,p) = mean(dataVal(:,4));
%         Graph.E.Speed(t,p) = std(dataVal(:,4))./sqrt(Nrev);
%         Graph.Y.Length(t,p) = mean(dataVal(:,5));
%         Graph.E.Length(t,p) = std(dataVal(:,5))./sqrt(Nrev);
%         Graph.Y.Width(t,p) = mean(dataVal(:,6));
%         Graph.E.Width(t,p) = std(dataVal(:,6))./sqrt(Nrev);
%         Graph.Y.Aspect(t,p) = mean(dataVal(:,7));
%         Graph.E.Aspect(t,p) = std(dataVal(:,7))./sqrt(Nrev);        
%         Graph.Y.Kink(t,p) = mean(dataVal(:,8));
%         Graph.E.Kink(t,p) = std(dataVal(:,8))./sqrt(Nrev);         
%         Graph.Y.Bias(t,p) = mean(dataVal(:,8));
%         Graph.E.Bias(t,p) = std(dataVal(:,8))./sqrt(Nrev);
%     end
% end
% Graph.YLegend = fieldnames(Graph.Y);
% 
% %% group and stats
% clearvars Y X E;
% MWTfnimport = (Graph.MWTfn');
% M = Graph.YLegend;
% gnameL = gnamechose;
% for m = 1:numel(M);% for each measure
%     for g = 1:numel(gnameL);
%         gname = gnameL{g};
%         pMWTf = MWTfG.(gname)(:,2); 
%         MWTfn = MWTfG.(gname)(:,1);
%         A.MWTfn = MWTfn;
%         [~,i,~] = intersect(MWTfnimport,MWTfn);
%         Y(:,g) = mean(Graph.Y.(M{m})(:,i),2);
%         E(:,g) = std(Graph.Y.(M{m})(:,i)')'./sqrt(sum(i));
%         X(:,g) = Graph.X(2:end)';
%     end
%     errorbar(X,Y,E);
%     figname = [M{m},'[',num2str(ti,'%.0f'),':',num2str(int,'%.0f'),...
%         ':',num2str(tf,'%.0f'),']'];
%     savefig(figname,pSaveA);
% end   
% display 'graphing done.';
% display ' ';
% run = input('would you like to run different time points (y=1,n=0)? ');
% 
% end



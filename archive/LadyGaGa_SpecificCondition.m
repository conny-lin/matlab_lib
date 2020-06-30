%% LadyGaGa_SpecificCondition

%% STEP1: PREPARE PATHS [Need flexibility] 
clear;
restoredefaultpath;
pMaestro = '/Volumes/AWLIGHT/MWT/Archived Analysis/Maestro';
pRose = '/Volumes/Rose/MultiWormTrackerPortal/MWT_Analysis_20130811';
pFun = '/Users/connylinlin/MatLabTest/MultiWormTrackerPortal/MWT_Programs';
pSet = '/Users/connylinlin/MatLabTest/MultiWormTrackerPortal/MWT_Programs/MatSetfiles';

addpath(genpath(pFun));

HomePath = pRose;

%% STEP1: Get Exp database
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


%% STEP2: SELECT TARGET EXPERIMENTS
% search for target paths
display 'Search for...'
display 'MWT files [M], Exp files [E], Group name [G] or no search [A]?';
searchclass = input(': ','s');
switch searchclass
    case 'M' % search for MWT
        % need coding
%         display 'enter the oldest year/date you want the analysis [20120304] or [2013]:';
%         datemin = input(': ');
%         searchterm = ['^' num2str(datemin)];
%         searchstart = min(find(not(cellfun(@isempty,regexp(MWTfn,searchterm))))); % find minimum
%         pMWTtarget = pMWTf(searchstart:end); % get all MWT from search start
%         MWTfntarget = MWTfn(searchstart:end);
%         disp(MWTfntarget);
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


%% STEP3: user input for time intervals
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


%% STEP4A: MAKE SURE MWT RUN NAMES ARE OK FOR CHOREOGRAPHY
%% check names
Stage(pExpfT,pFun,'CheckMWTnames');
%%Stage(pExpfT,pFun,'Conny')
%% [need testing...] check if group files matches MWTfgcode
status = 'release';
switch status
    case 'coding'
for e = 1:numel(pExpfT)
    pExp = pExpfT{e};
    cd(pExp);
    load('Groups_1Set.mat','Groups');
    [~,~,~,~,pMWTfD,~,MWTfsn] = getMWTpathsNname(HomePath,'noshow');
    [~,~,~,~,a] = parseMWTfnbyunder(MWTfsnM);
    b = char(a);
    if size(Groups,1) ~= unique(cellstr(b(:,end-1)));
    [Groups] = GroupNameMaster(pExp,pSet,'groupnameEnter');
    end
end
    case 'release'
        
end
    
    
%% STEP4B: CHECK IF CHOR HAD BEEN DONE
%% define chor outputs for search 
fnvalidate = {'*evan.dat';'*.sprevs'};
%% check chor ouptputs
pMWTfC = {};
MWTfnC = {};
pExpfC = {};
ExpfnC = {};
for x = 1:numel(pExpfT);
    str = 'Looking into [%s]';
    display(sprintf(str,ExpfnT{x}));
    [MWTfn,pMWTf] = dircontentmwt(pExpfT{x});
    for v = 1:size(fnvalidate,1);
%         str = 'Looking for [%s] in all MWT files';
%         display(sprintf(str,fnvalidate{v}));
        [valname] = cellfunexpr(pMWTf,fnvalidate{v});
        [fn,path] = cellfun(@dircontentext,pMWTf,valname,'UniformOutput',0);
        novalfn = cellfun(@isempty,fn);
        if sum(novalfn)~=0;
            str = 'The following MWTf does not have [%s]:';
            display(sprintf(str,fnvalidate{v}));
            disp(MWTfn(novalfn));
            pMWTfnoval = pMWTf(novalfn);
            MWTfnoval = MWTfn(novalfn);
            pMWTfC = [pMWTfC;pMWTfnoval];   
            MWTfnC = [MWTfnC;MWTfnoval];
            pExpfC = [pExpfC;pExpfT(x)];
            ExpfnC = [ExpfnC;ExpfnT(x)];
        end
    end
    
end
pMWTfC = unique(pMWTfC);
MWTfnC = unique(MWTfnC);
pExpfC = unique(pExpfC);
ExpfnC = unique(ExpfnC);
if isempty(pMWTfC)==0;
    display 'Chor need to be done for MWT files below:'
    disp(MWTfnC);
    display 'In the following experiments'
    disp(ExpfnC);
else
    display 'Chor outputs below found in all target MWT files:'
    disp(fnvalidate');
end


%% STEP4C: do chor
%% choreography
if isempty(pMWTfC)==0;
[chorscript] = chormaster(pMWTfC,'LadyGaGa');
else
    display 'No Chor needs to be ran.';
end


%% STEP5A: PREPARE SAVE PATHS
pExpfS = {};
for e = 1:numel(pExpfT)
    pExp = pExpfT{e};
   [fn,p] = dircontentext(pExp,'MatlabAnalysis*');
   if isempty(p)==1;
       display 'making MatlabAnalysis folder...';
        mkdir(pExp,'MatlabAnalysis');
        pExpfS{e,1} = [pExp,'/','MatlabAnalysis'];
   elseif isdir(char(p))==1; pExpfS(e,1) = p;
   end
end
   
   
   
%% STEP5B: Import and process Chor generated data
for e = 1:numel(pExpfT)
pExp = pExpfT{e};
[MWTfn,pMWTf] = dircontentmwt(pExpfT{e});
    

%% import and summarize evandat
% evandat legends
%tnNss*b12
evandatL = {1,'time';2,'number';3,'goodnumber';4,'speed';5,'speedStd';...
    6,'bias';7,'tap';8,'puff'};
MWTfevandatL = {1,'MWT filename';2,'Data';3,'mintime';4,'maxtime';...
    5,'mean number tracked';6,'mean good number';7,'mean percent N valid';...
    8,'mean speed';9,'min speed';10,'max speed';11,'mean bias'};

MWTfevandat = {};
for p = 1 : numel(pMWTf); % for each mwt
    [~,datevanimport] = dircontentext(pMWTf{p},'*evan.dat');  
    MWTfevandat(p,1) = MWTfn(p);
    MWTfevandat(p,2) = {dlmread(datevanimport{1})};
end
for x = 1:size(MWTfevandat,1)
    MWTfevandat{x,3} = min(MWTfevandat{x,2}(:,1)); % min time
    MWTfevandat{x,4} = max(MWTfevandat{x,2}(:,1)); % max time
    MWTfevandat{x,5} = mean(MWTfevandat{x,2}(:,2)); % mean number tracked
    MWTfevandat{x,6} = mean(MWTfevandat{x,2}(:,3)); 
    MWTfevandat{x,7} = MWTfevandat{x,6}/MWTfevandat{x,5}*100; 
    MWTfevandat{x,8} = mean(MWTfevandat{x,2}(:,4)); 
    MWTfevandat{x,9} = min(MWTfevandat{x,2}(:,4)); 
    MWTfevandat{x,10} = max(MWTfevandat{x,2}(:,4)); 
    MWTfevandat{x,11} = mean(MWTfevandat{x,2}(:,6)); 
end

%% import and summarize sprevs
% sprevs legends
MWTfsprevsL = {1,'MWT filename'; 2,'Data';3,'mintime';4,'maxtime';...
    5,'objects tracked';6,'mean reversal';7,'minreversal'; ...
    8,'max reversal'};
sprevsL = {1,'object ID'; 2,'time'; 3,'reversal'; 4,'trackduration?'};

% import data
MWTfsprevs = {};
for p = 1 : numel(pMWTf); % for each mwt
    [~,ps] = dircontentext(pMWTf{p},'*.sprevs');
    dirData = dir('*.sprevs');
    % import all .sprevs data (each file is one individual
    A = [];
    for k = 1:size(ps,1);
        a = dlmread(ps{k}); % import .sprevs data
        A = [A;a];
    end
    MWTfsprevs(p,1) = MWTfn(p);
    MWTfsprevs(p,2) = {A};A
    
end % end loop for MWT folder

% summarize
for x = 1:size(MWTfsprevs,1)
MWTfsprevs{x,3} = min(MWTfsprevs{x,2}(:,2));
MWTfsprevs{x,4} = max(MWTfsprevs{x,2}(:,2)); 
MWTfsprevs{x,5} = numel(unique(MWTfsprevs{x,2}(:,1))); 
MWTfsprevs{x,6} = mean(MWTfsprevs{x,2}(:,3)); 
MWTfsprevs{x,7} = min(MWTfsprevs{x,2}(:,3)); 
MWTfsprevs{x,8} = max(MWTfsprevs{x,2}(:,3)); 
end

%% LadyGaGa - put all data together
LadyGaGa.MWTfsprevs = MWTfsprevs;
LadyGaGa.MWTfsprevsL= MWTfsprevsL;
LadyGaGa.MWTfevandat = MWTfevandat;
LadyGaGa.MWTfevandatL = MWTfevandatL;
LadyGaGa.evandatL = evandatL;
LadyGaGa.sprevsL = sprevsL;
cd(pExpfS{e});
save('LadyGaGa.mat','LadyGaGa','MWTfevandat','MWTfsprevs');
end

%% STEP6: Run Graphing
for e = 1:numel(pExpfT)
    pExp = pExpfT{e}; % get paths
    [MWTfn,pMWTf] = dircontentmwt(pExpfT{e}); % get MWT paths

    %% import LadyGaGa - put all data together
    cd(pExp);
    load('LadyGaGa.mat','LadyGaGa','MWTfevandat','MWTfsprevs');
    MWTfsprevs = LadyGaGa.MWTfsprevs;
    MWTfsprevsL = LadyGaGa.MWTfsprevsL;
    MWTfevandat = LadyGaGa.MWTfevandat;
    MWTfevandatL = LadyGaGa.MWTfevandatL;
    evandatL = LadyGaGa.evandatL;
    sprevsL = LadyGaGa.sprevsL;


    %% timepoints
    % find smallest starting time and smallest ending time
    MWTfsprevStartTime = max(cell2mat(MWTfsprevs(:,3)));
    MWTfsprevEndTime = min(cell2mat(MWTfsprevs(:,4)));
    str = 'Earliest time tracked (MinTracked): %0.1f';
    display(sprintf(str,MWTfsprevStartTime));
    str = 'Max time tracked  (MaxTracked): %0.1f';
    display(sprintf(str,MWTfsprevEndTime));

    % processing inputs
    if tinput ==0; ti = MWTfsprevStartTime; 
    elseif isempty(tinput)==1; ti = MWTfsprevStartTime; tinput = 0; end
    if isempty(intinput)==1; int = 10; else int = intinput; end
    if isempty(tfinput)==1; tf = MWTfsprevEndTime; else tf = tfinput; end
    if isempty(durinput)==0; duration = 'restricted'; else duration = 'all'; end

    % reporting
    str = 'Starting time: %0.0fs';
    display(sprintf(str,ti));
    switch duration
        case 'all'
            timepoints = [ti,tinput+int:int:tf];
            str = 'Time points: %0.0f ';
            timeN = numel(timepoints);
            display(sprintf(str,timeN));
        case 'restricted'
            % need coding
    end

    %% MWTfsprevsum 
    % legends
    MWTfsprevsumL = {1,'MWT filename'; 2,'summary'};
    MWTfsprevsumColumn2L = {1,'timepoint';2,'MinN';3,'MaxN';...
        4,'NRev';5,'NwormRev';6,'MeanRevDist';7,'SERevDist';...
        8,'MeanRevDur';9,'SERevDur';10,'SumTimeRev'};

    % MWTfsprevsum summary
     MWTfsprevsum = {};
    for p = 1:numel(MWTfn);
    for t = 1:numel(timepoints)-1; % for each stim
    % get data durint time frame 
    k = MWTfsprevs{p,2}(:,2)>timepoints(t) & MWTfsprevs{p,2}(:,2)<timepoints(t+1);
    sprevsValid = MWTfsprevs{p,2}(k,:);
    m = MWTfevandat{p,2}(:,1)>timepoints(t) & MWTfevandat{p,1}(:,1)<timepoints(t+1);
    evandatValid = MWTfevandat{p,2}(m,:);
    MWTfsprevsum{p,1} = MWTfn{p};
    MWTfsprevsum{p,2}(t,1) = t;
    if isempty(evandatValid)==1; MWTfsprevsum{p,2}(t,2) = 0; 
    else MWTfsprevsum{p,2}(t,2) = min(evandatValid(:,3)); end
    if isempty(evandatValid)==1; MWTfsprevsum{p,2}(t,3) = 0; 
    else MWTfsprevsum{p,2}(t,3) = max(evandatValid(:,3)); end
    Nrev = size(sprevsValid(:,2),1);
    MWTfsprevsum{p,2}(t,4) = Nrev;
    MWTfsprevsum{p,2}(t,5) = size(unique(sprevsValid(:,1)),1);
    MWTfsprevsum{p,2}(t,6) = mean(sprevsValid(:,3));
    MWTfsprevsum{p,2}(t,7) = std(sprevsValid(:,3))./sqrt(Nrev);
    MWTfsprevsum{p,2}(t,8) = mean(sprevsValid(:,4));
    MWTfsprevsum{p,2}(t,9) = std(sprevsValid(:,4))./sqrt(Nrev);
    % calculate total duration reversed
    RevEndTime = sprevsValid(:,2)+sprevsValid(:,4); % time start+time end
    overTimei = RevEndTime(:,1)>timepoints(t+1); % time tracked till after the end of timepoint
    RevEndTime(overTimei,1) = timepoints(t+1);
    RevDur = RevEndTime(:,1)-sprevsValid(:,2);
    MWTfsprevsum{p,2}(t,10) = sum(RevDur);
    end % end of loop timepoints
    end % end of loop MWT

    %% Graph: reorganize data into graphing format
    clearvars Graph;
    Graph.MWTfn = MWTfn;
    for x = 1:size(MWTfsprevsumColumn2L,1)
        A = [];
        for p = 1:size(MWTfsprevsum,1)
            A(p,:) =  MWTfsprevsum{p,2}(:,x);
        end
        Graph.(MWTfsprevsumColumn2L{x,2}) = A;
    end
    Graph.X = Graph.timepoint;
    A = MWTfsprevsumColumn2L;
    B = [A(2:6,2);A(8,2);A(10,2)];
    Graph.YLegend = B;

    % group data
    cd(pExp)
    load('Groups_1Set.mat','Groups')
    % get group code from MWT
    [MWTfsn,MWTsum] = getMWTruname(pMWTf,MWTfn);
    [~,~,~,~,trackergroup] = parseMWTfnbyunder(MWTfsn);
    a=char(trackergroup);
    groupcode = cellstr(a(:,end-1));
    clearvars GroupedData
    GroupedData.Y = [];
    A = Graph.YLegend; 
    for x = 1:size(Groups,1)
    i = logical(celltakeout(regexp(groupcode,Groups{x,1}),'singlenumber')); 
    N = sum(i);
        for a = 1:numel(A); 
        GroupedData.X(:,x) = Graph.X(1,:)';
        GroupedData.Y.(A{a})(:,x) = mean(Graph.(A{a})(i,:)',2);
        GroupedData.E.(A{a})(:,x) = (std(Graph.(A{a})(i,:))./sqrt(N))';
        end
    end

    % make graphsAH
    A = Graph.YLegend; 
    for a = 1:numel(A);
    X = GroupedData.X;
    Y = GroupedData.Y.(A{a});
    E = GroupedData.E.(A{a});
    errorbar(X,Y,E);
    figname = [(A{a}),'[',num2str(ti,'%.0f'),':',num2str(int,'%.0f'),':',num2str(tf,'%.0f'),']'];
    savefig(figname,pExp);
    end   

    %% Save
    cd(pExpfS{e});
    save('GraphData.mat','MWTfsprevsum','MWTfevandat','MWTfsprevs');

end
display 'LadyGaGa graphing finished...';















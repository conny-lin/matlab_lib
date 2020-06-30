%function [LadyGaGa] = ProcessChorsprevs(HomePath,pSet)
%% Instruction:
% Source: evanscript1
% Instruction from Evan Ardiel
% This will give you a .txt file for every object listing each reversal 
% for that object. The following matlab script will combine your plates
% for 1 condition and give a .sprev file for whatever intervals you 
% specify in the %input options section. In the script below you'd get the 
% spontaneous reversals from 180-190s, 190-200s, 200-210s, but this could 
% be adjusted however you needed. For example, for spontaneous reversals 
% for the first three minutes, it'd be
% revInit = 0:60:120;
% revTerm = 60:60:180;
% 
% The .sprev files contain summarized info about the spontaneous reversals 
% for each interval. This script works, but it's not very elegant so I'll be 
%     embarrassed if you show it to your programming boyfriend! I can explain
%     more about the output in person if you want it.
%%%%%%%%
% input options
%revInit = 180:10:200;
%revTerm = 190:10:210;
%

%% testing code
HomePath = pRose;

%% STEP1: load Exp database
% get hard drive name
a = regexp(HomePath,'/Volumes/','split');
b = regexp(a{2},'/','split');
hardrivename = b{1};
savename = ['MWTExpDataBase_' hardrivename, '.mat'];

% load database
cd(pSet);
load(savename,'pExpfD','ExpfnD','pMWTfD','MWTfnD','MWTfsnD',...
    'dateupdated','HomePath');
% check if database needs to be upated
[~,~,ExpfnU,pExpfU] = dircontent(HomePath);
a = regexp(ExpfnU,'(\d{8})','match','once');
display 'Loading MWTExpDataBase...';
if str2num(a{end})>str2num(dateupdated);
display 'MWTExpDataBase need to be updated'
[pExpfD,ExpfnD,~,~,pMWTfD,MWTfnD,MWTfsnD] = getMWTpathsNname(HomePath,'noshow');
dateupdated = datestr(date,'yyyymmdd'); % record date
cd(pSet);
savename = ['MWTExpDataBase_' hardrivename, '.mat'];
save(savename,'pExpfD','ExpfnD','pMWTfD','MWTfnD','MWTfsnD',...
    'dateupdated','HomePath');
end



%% STEP2: NARROW DOWN TARGETS
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


%% STEP 3: user input for time intervals
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

%% STEP 4: Run Graphing
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
    if isempty(dur)==0; duration = 'restricted'; else duration = 'all'; end

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
    cd(pExp);
    save('GraphData.mat','MWTfsprevsum','MWTfevandat','MWTfsprevs');

end
display 'LadyGaGa graphing finished...';



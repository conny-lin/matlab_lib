function LadyGaGa(pExp,pFun,codingstatus,graph,Chor,zipfile)
%% [Goal] analyze reversal ignoring tap

%% coding status
% choice
% supsend = testing
% reopen = parts of program untested
% graph = combined = grouped by exp code, single = one folder = 1 group,
% single group analysis only


%% Userinputs interface
output = 'userinput';
switch output
    case 'userinput'; % new condition
        [revInit,revTerm,ti,int,tf] = selectrevInterval; % ask for userinput
        cd(pExp);
        % [waste] %save('interval.mat','revInit','revTerm');
        % [BUG:] xticklable = [revInit revTerm(end)]; % get x ticketlabel
    case 'predetermined';
        cd(pExp);
        load('interval.mat','revInit','revTerm');
        xticklable = [revInit revTerm(end)]; % get x ticketlabel
end

%% set up paths
addpath(genpath(pFun));
pExpO = pExp; % define pExp as original path name 


%% Choreography and data analysis 
% check if chor had been done before
[chortest,~] = dircontentext(pExp,'*.sqrevs');
if isempty(chortest)==1;
    LadyGaGaChor_v1(pExp);
else
    q = input('Re-Run choreography (y=1,n=0)?');
    if q ==1;
        LadyGaGaChor_v1(pExp);
    else
    end
end 

%% process chor data
display('Making sense of chor data...');
status = 'Evan';
switch status
    case 'Evan'
    evanscript1(revInit,revTerm,pExp);
    [sumimport] = importsprevs(pExp);
    cd(pExp);
    save(strcat('LadyGaGa_sumimport_',expname,'.mat'),'sumimport');
    case 'Conny'
    [sumimport,Summaryheader] = evanscriptRv3(pExp,revInit);
end

%% Descriptive Stats and graphs
switch graph
    case 'combined'
        display('Graphing...');
         LadyGaGa_GraphGrouped(pExp,pFun,xticklable,ti,int,tf);
    case 'single' 
        %% Descriptive stats
        [Summaryheader] = LadyGaGasummaryheader
        % calculate individuals
        [~,revIncident.N,revIncident.Mean,revIncident.SE,DesStatsh] = ...
            decriptstats2(sumimport,Summaryheader,'revIncident',pExp);
        [~,revSN.N,revSN.Mean,revSN.SE,~] = ...
            decriptstats2(sumimport,Summaryheader,'revSN',pExp);
        [~,meanRevDist.N,meanRevDist.Mean,meanRevDist.SE,~] = ...
            decriptstats2(sumimport,Summaryheader,'meanRevDist',pExp);
        [~,meanRevDur.N,meanRevDur.Mean,meanRevDur.SE,~] = ...
            decriptstats2(sumimport,Summaryheader,'meanRevDur',pExp);
        % save files
        cd(pExp);
        save(strcat('LadyGaGa_graphstats_',expname,'.mat'),'meanRevDist',...
            'revIncident','meanRevDur','revSN');

        %% Graphing
        % [DEVELOPMENT] LadyGaGaGraph1(pSave,pSet,pExpO,MWTfgcode,GAA,expname)
        makefigsinglegroup(meanRevDist.Mean,meanRevDist.SE,'meanRevDist','time','groupname')
        savefig('meanRevDist',pExp);
        makefigsinglegroup(revSN.Mean,revSN.SE,'revSN','time','groupname')
        savefig('revSN',pExp);
        makefigsinglegroup(revIncident.Mean,revIncident.SE,'revIncident','time','groupname')
        savefig('revIncident',pExp);
        makefigsinglegroup(meanRevDur.Mean,meanRevDur.SE,'meanRevDur','time','groupname')
        savefig('meanRevDur',pExp);
end

%% [suspend] untested parts of the program
switch codingstatus
    case 'tested'
        ...
    case 'untested'  
        %% [Check] statistic formula needs to be checked
        ShaneSparkGraph3(pSave,pFun,pExpO,MWTfgcode,GAA,expname,diarysavename);

        %% back up and clean up
        % remove blobs, summary png and set files
        removeallexceptanalyzed(pExpO);
        % move analyzed files from original exp folder to analyzed folder
        moveanalyzedfiles2analyzedfolder(pExpO,pAExp);
        % make a copy to Conny's folder
        backup2Connyfolder(pFun,analyzedname,pAExp);

end

%% reporting
display(' ');
display('LadyGaGa analysis completed.');


end







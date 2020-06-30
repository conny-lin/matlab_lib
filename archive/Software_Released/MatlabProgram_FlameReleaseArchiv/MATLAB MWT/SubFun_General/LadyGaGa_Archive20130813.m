function LadyGaGa(pExp,pFun,codingstatus,graph,Chor,zipfile,sprevsQ)
% analyze reversal ignoring tap

%% coding status
% choice
% supsend = testing
% reopen = parts of program untested
% graph = combined = grouped by exp code, single = one folder = 1 group,
% single group analysis only


%% Userinputs interface
switch sprevsQ
    case 'userinput'; % new condition
        [revInit,revTerm,ti,int,tf] = selectrevInterval; % ask for userinput
        cd(pExp);
        save('interval.mat','revInit','revTerm');
        xticklable = [revInit revTerm(end)]; % get x ticketlabel
    case 'predetermine';
        cd(pExp);
        load('interval.mat','revInit','revTerm');
        xticklable = [revInit revTerm(end)]; % get x ticketlabel
end

%% set up paths
addpath(genpath(pFun));
pExpO = pExp; % define pExp as original path name 

%% zip and unzip data
% [DEVELOP] change original name file for it to start with expname
% unzip MWTf if zipped, and zip one original file in student folder for
% backup
switch zipfile
    case 'backup'; % zip file
        [~,pMWTf] = unziprawdata(pExpO); % Unzip raw data
        if exist(strcat(pExpO,'.zip'),'file') ~=2;
            display('zipping a copy of current file as backup, please wait...');
            zip(pExpO,pExpO); % create a zip back up in case of mistakes
        end
        display('done');
    case 'nobackup'; % don't zip file
        display('zip backup skipped.');
end


%% [suspend] untested parts of the program
switch codingstatus
    case 'tested'
        % do nothing
    case 'untested'
    %% validate MWTf folder contents
    % [DEVELOP] should have png, set, summary and blobs, can get report for how
    % many blobs here
    validaterawfilecontents(pExpO); % Experiment error reporting

        %% check MWT run names
        % [DEVELOP] show strain group. validate strains
        % [DEVELOP] choice to get rid of bad files
        [MWTfsn] = correctMWTnamingswitchboard3(pExpO); % Make sure MWTrun naming are correct


        %% create standardize folder name
        [pAExp,pExpS,pRaw,pRawC,pRawCExp,expname,analyzedname] = ...
            standardizefoldername(pFun,pExpO); % standardize folder name


        %% [DEVELOP] change raw report to text file append
        rawdatareport2Conny(pRawC,expname); % report raw to Conny


        %% [DEVELOP] Assign group names and sequence appears on the graph
        [GA,MWTfgcode] = assigngroupnameswitchboard2(MWTfsn,pFun,pExpO,0);
        display(' ');
        [GAA] = groupseq(GA);
        [savename] = creatematsavename3(expname,'Groups_','.mat');
        cd(pRawCExp);
        save(savename,'GA','MWTfgcode');
        cd(pAExp);
        save(savename,'GA','MWTfgcode');
        display('done');


        %% organize MWT files and back up
        organizemwtfiles(pExpO,pExpS,pRaw,expname); % move files
end


%% Choreography and data analysis 
switch Chor
    case 'runchor'; % no chor had done before
        LadyGaGaChor_v1(pExp);
    case 'nochor'; % chor had been done before
        display('chor skipped'); % do nothing
    case 'checkifchor[CODING]'
        [~,psp] = dircontentext(pExp,'*.txt');
end 

%% access data
display('Making sense of chor data...');
switch sprevsQ
    case 'userinput'; % run new condition
    switch codingstatus
        case 'tested'
            evanscript1(revInit,revTerm,pExp);
            switch codingstatus
                case 'suspend';
                    [~,expname] = fileparts(pExp);
                case 'combinedifftrackers'
                    [expname] = findstadexpfoldername(pExp(1,:),pFun); % replace tracker code as X in experiment folder
                    expname = regexp(expname,'[A-Z]_','X_');
            end
            [sumimport] = importsprevs(pExp);
            cd(pExp);
            save(strcat('LadyGaGa_sumimport_',expname,'.mat'),'sumimport');           
        case 'untested'
            % [EFFICIENCY] can be increased
            [sumimport,Summaryheader] = evanscriptRv3(pExp,revInit);
    end
    case 'predetermine'; % don't run new condition
        % do nothing
end

%% Descriptive Stats
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







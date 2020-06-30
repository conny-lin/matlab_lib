function MWTSet = Dance_DrunkPosture2(MWTSet)
%% DRUNKPOSTURE
% 
% modified to enable AfterParty post analysis

%% CODE

MWTSet.Data.Timepoints = ...
    Dance_setanalysistimeinterval(...
        MWTSet,MWTSet.MWTInfo.pMWT);

[MWTSet.chor.chorscript,...
MWTSet.chor.chor_fileoutputnames,...
MWTSet.chor.choroutputLegend] = ...
    makechorscript(...
        MWTSet.chor.arguments,...
        MWTSet.chor.pCodeChor);
 
[MWTSet.MWTInfo.pMWT_Results,...
MWTSet.chor.done] = ...
    runchormaster(MWTSet.chor.chorscript,...
        MWTSet.MWTInfo.pMWT,...
        MWTSet.chor.chor_fileoutputnames,...
        MWTSet.PATHS.pAnalysis,...
        MWTSet.PATHS.pData,...
        MWTSet.chor.chorstatus);
  

[MWTSet.MWTInfo.pMWT_Results,...
MWTSet.MWTInfo.pMWT_badchor] = ...
    checkchorresults(...
        MWTSet.MWTInfo.pMWT_Results,...
        MWTSet.chor.chor_fileoutputnames,...
        MWTSet.PATHS.pData,...
        MWTSet.PATHS.pAnalysis);


MWTSet.Data.Import = ...
    importNprocessChorData(...
        MWTSet.MWTInfo.pMWT_Results,...
        MWTSet.chor.chor_fileoutputnames);

[MWTSet.Data.Import,...
MWTSet.Data.ImportBad,...
MWTSet.MWTInfo.pMWT,...
MWTSet.MWTInfo.pMWT_Bad] = ...
    checkimportTime(...
            MWTSet.Data.Timepoints,...
            MWTSet.Data.Import);

[MWTSet.Data.ByPlates] = ...
    statsNPlates(...
        MWTSet.Data.Timepoints,...
        MWTSet.Data.Import,...
        MWTSet.chor.choroutputLegend);


save_byplatepertimemean(...
        MWTSet.Data.Timepoints,...
        MWTSet.Data.Import,...
        MWTSet.chor.choroutputLegend,...
        MWTSet.PATHS.pSaveA);


save_bygrouppertimeDescriptiveStats(...
        MWTSet.Data.Timepoints,...
        MWTSet.Data.Import,...
        MWTSet.chor.choroutputLegend,...
        MWTSet.PATHS.pSaveA);

save_pergrouppair2N2(...
        MWTSet.Data.Timepoints,...
        MWTSet.Data.Import,...
        MWTSet.chor.choroutputLegend,...
        MWTSet.PATHS.pSaveA);

MWTSet.Data.ByPlates_OrgByGroup = ...
    orgstatsPlates2groups(...
        MWTSet.Data.ByPlates);


MWTSet.Data.ByGroup = ...
    statsbygroup(...
        MWTSet.Data.ByPlates_OrgByGroup);


graph_bygrouppermeasure(...
        MWTSet.PATHS.pSaveA,...
        MWTSet.Data.ByGroup,...
        MWTSet.AnalysisCode,...
        MWTSet.timestamp);


graph_bar_lasttime_bygrouppermeasure(...
        MWTSet.PATHS.pSaveA,...
        MWTSet.Data.ByGroup,...
        MWTSet.AnalysisCode,...
        MWTSet.timestamp)


end




%% MODULES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Timepoints = Dance_setanalysistimeinterval(MWTSet,pM)
%% SET UP ANALYSIS TIME: 
% source: 
%     MWTAnalysisSetUpMaster_timeinterval 20150202 copy
% 

% MWTSet.AnalysisSetting.TimeInputs = Dance_setanalysistimeinterval(pMWT)

%% CODE
% get run condition
expdur = mwtpath_parse(pM,{'expdur'});
expdurMax = max(expdur);
expdurMin = min(expdur);

if sum(strcmp('INPUT',fieldnames(MWTSet))) == 1
if sum(strcmp('assaytime',fieldnames(MWTSet.INPUT))) == 1
    TimeInputs = MWTSet.INPUT.assaytime;
else
% time option list
TimeList = {...
    '60s:60s:60s:[min tracked]',[60,60,60,-1];
    '10s:10s:10s:[min tracked]',[10,10,10,-1];
    '10s:5s:1s:[min tracked]',[10,5,1,-1];
    'Manually enter time intervals',[NaN NaN NaN NaN]};

% choose time
a = 'Time interval setting options:\n';
b = '[start time]:[assay interval]:[assay range]:[end time]';
str = [a,b];
TimeInputs = chooseoption(TimeList,str);
end
end

% start time
tinput = TimeInputs(1);
if isnan(tinput) == 1
    str = 'Enter start time, press [Enter] to use Mintracked: ';
    tinput = input(str);
end
if isempty(tinput) ==1 || tinput < 10
    ti = 10; 
else
    ti = tinput;
end

% end time
tfinput = TimeInputs(4);
if isnan(tfinput) == 1
    d = mwtpath_parse(pM,{'expdur'});
    s1 = 'end time'; s2 = sprintf('Min end tracked %.0fs',min(d));
    str = sprintf('Enter [%s], press [Enter] to use %s: ',s1,s2);
    tfinput = input(str);
end
if isempty(tfinput) ==1 || tfinput >= expdurMin
    tf = expdurMin; 
elseif tfinput == -1
    tf = expdurMin;
else
    tf = tfinput;
end

% interval
intinput = TimeInputs(2);
if isnan(intinput) == 1
    intinput = input('Enter interval, press [Enter] to use default (10s): ');
end
if isempty(intinput) ==1; 
    int = 10; 
else
    int = intinput;
end

% duration
durinput = TimeInputs(3);
if isnan(durinput) == 1
    display 'Enter assay range';
    % (optional) survey duration after specifoied target time point
    durinput = input('press [Enter] to analyze all time bewteen intervals: '); 
end
if isempty(durinput) ==1 || int <= durinput
    dur = int;
else
    dur = durinput;
end

% organize time inputs
TimeTranslate = [ti,int,dur,tf];

% report results
display ' '; display('Set analysis time:');
str = 'start time(s): %d\nend time(s): %d\ninterval(s): %d\nrange(s): %d';
ti = TimeTranslate(1);
int = TimeTranslate(2);
dur = TimeTranslate(3);
tf = TimeTranslate(4);

disp(sprintf(str,ti,tf,dur,int));

% store setting
% MWTSet.AnalysisSetting.TimeInputs = TimeTranslate;


% generate assay time points

% MWTSet output
Timepoints = [ti:int:tf-dur; (ti:int:tf-dur)+dur];
disp ' ';
disp('time periods will be assayed:');
disp(Timepoints');
% MWTSet.Data.Timepoints = timepoints;
    
end


function [chorscript,chor_fileoutputnames,choroutputLegend] = ...
            makechorscript(chorarguments,pCodeChor)
%% CHOR SCRIPTS
%     A = MWTSet.chor.arguments;
%     pChor = MWTSet.chor.pCodeChor;

    %% get MWTSet inputs

    A = chorarguments;
    pChor = pCodeChor;
       
    %% code
    % ANALYSIS SPECIFIC SCRIPTS
    odrunkposture2 = '-O drunkposture2 -o nNslwakbcemM';
    choroutputLegend = {'time';'number';'goodnumber';'Speed';'Length';'Width';...
        'Aspect';'Kink';'Bias';'Curve';'Area';'midline';'morphwidth'};

    fval = {'*drunkposture2.dat'};
    
    % get arguments
    names = fieldnames(A);
    for x = 1:numel(names)
        fname = names{x};
        eval([fname,'=A.',fname,';']);
    end

    % get standard chor variable settings
    % check if there is standard chor setting file
    if isempty(dircontent(pChor,'chor_setting.mat')) == 1
        error('missing chor_setting.mat file in Chor folder');
    else
        cd(pChor); load('chor_setting.mat');
    end


    % CREATE CHOR JAVA SCRIPTS
    chorscript = {};
    chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
                mintime,b,minmove,b,shape,b,odrunkposture2,b,....
                preoutline,b,prespine,b]; 

    % add MWTSet outputs
    chor_fileoutputnames = fval;
%     
%     MWTSet.chor.chorscript = chorscript;
%     MWTSet.chor.chor_fileoutputnames = fval;
%     MWTSet.chor.choroutputLegend = choroutputLegend;
end


function [pMWTA,chordone] = ...
    runchormaster(chorscript,pMWT,fval,pAnalysis,pData,chorstatus)
    %% RUN CHOR
    
    
    %% import input
%     chorscript = MWTSet.chor.chorscript;
%     pMWT = MWTSet.MWTInfo.pMWT;
%     fval = MWTSet.chor.chor_fileoutputnames;
%     pAnalysis = MWTSet.PATHS.pAnalysis;
%     pData = MWTSet.PATHS.pData;
%     chorstatus = MWTSet.chor.chorstatus;

     
    %% run
    pMWTA = chormaster2(pMWT,pAnalysis,pData,fval,chorscript,chorstatus);
    
    % MWTSet output
    chordone = true;
%     MWTSet.chor.done = chordone;
%     MWTSet.MWTInfo.pMWTf_Results = pMWTA;
    
end


function [pMWTfValid,pMWTfBad] = ...
    checkchorresults(pMWTf,fnvalidate,pData,pAnalysis)
    %% CHECK IMPORT INTEGRITY
    
    %% validate output
%     vname = {'chor.chor_output_validated'};
%     if validateoutput(MWTSet,vname) == true; return; end

    
    %% validate input
%     vname = {'MWTSet.MWTInfo.pMWTf_Results';
%         'MWTSet.chor.chor_fileoutputnames';
%         'MWTSet.PATHS.pAnalysis';
%         'MWTSet.PATHS.pData'
%         };
%     validateStructInput(vname,MWTSet);
%    
    
    %% get input
%     pMWTf = MWTSet.MWTInfo.pMWTf_Results;
%     fnvalidate = MWTSet.chor.chor_fileoutputnames;
%     pData = MWTSet.PATHS.pData;
%     pAnalysis = MWTSet.PATHS.pAnalysis;
    
    %% code
    disp('Check integrity of chor results');
    A = {}; ival = true(size(pMWTf));
    for p = 1:numel(pMWTf);
        [~,datevanimport] = dircontent(pMWTf{p},fnvalidate{1});  
        [~,mf] = fileparts(pMWTf{p});
        A{p,1} = mf;   
        if isempty(datevanimport) == 0
            ival(p,1) = false; 
        else
            ival(p,1) = true;
        end
    end
    
    %% create new pMWT
    if sum(ival) > 1
        badMWT = A(ival,1);
        disp('Remove bad MWT files:');
        disp(badMWT);
    end
    pMWTfValid = pMWTf(~ival);
    pMWTfOriginal =  pMWTf;
    pMWTfBad = pMWTf(ival);
     
    %% outputs
    MWTSet.chor.chor_output_validated = true;
    MWTSet.Data.ImportFileName = fnvalidate{1};
    A = struct;
    A.pMWT = regexprep(pMWTfValid,pAnalysis,pData);
    A.pMWT_Results = pMWTfValid;
    A.pMWT_input = regexprep(pMWTfOriginal,pAnalysis,pData);
    A.pMWT_nochor = pMWTfBad;
    MWTInfo = A;
%     MWTSet.MWTInfo = A;

end


function A = importNprocessChorData(pMWTf,fnvalidate)
    %% IMPORT AND PROCESS CHOR DATA [updated: 20150510]
 
    
    %% code (only import the first file name)
    display(sprintf('Importing %s...',fnvalidate{1})); 
    MWTSet.Data.ImportFileName = fnvalidate{1};
    A = cell(size(pMWTf,1),2);
    for p = 1:numel(pMWTf);
        [~,datevanimport] = dircontent(pMWTf{p},fnvalidate{1});  
        A{p,1} = pMWTf{p};    
        A{p,2} = dlmread(datevanimport{1});
    end
    display(sprintf('Got all the %s',fnvalidate{1}));

end


function [DataGood,DataBad,pMWTGood,pMWTBad] = checkimportTime(timepts,Raw)
%% CHECKIMPORTTIME  check if imports satisfy timepoints, discard those
% that do not satisfy time points


%% get info from inputs
pMWT = Raw(:,1);

%% find start end times for each plate
% -1 = min, Inf = max, -2 = common
% prepare universal timepoints limits
% timepoints
% find smallest starting time and smallest ending time
% MWTfdrunkposturedatL = {1,'MWTfname';2,'Data';3,'time(min)';4,'time(max)'};

Time = nan(size(pMWT,1),2);    
for p = 1:size(Raw,1)
    Time(p,1) = min(Raw{p,2}(:,1)); 
    Time(p,2) = max(Raw{p,2}(:,1));
end

% by second
str = 'Earliest time tracked (MinTracked): %0.1f';
valstartime = floor(max(Time(:,1)));
display(sprintf(str,valstartime));
str = 'Min last time tracked  (MaxTracked): %0.1f';
valendtime = floor(min(Time(:,2)));
display(sprintf(str,valendtime));

% unique time
display('unique max time(s): N of each')
a = floor(Time(:,2));
b = tabulate(a);
b = b(b(:,2)~=0,1:2);
disp(b);


%% get rid of plates that does not have analysis time points
disp ' '; disp 'validating time:';
% val
ival = true(size(pMWT));

% start time
t = timepts(1,1);
tiPlate = Time(:,1);
i = tiPlate > t;
if sum(i) > 0
    str = '-following plates started tracking later than %ds';
    disp(sprintf(str,t));
    MWTBad = mwtpath_parse(pMWT(i),{'MWTname'});
    disp(char(MWTBad));
    ival(i) = false;
else
    str = '-all plates started tracking later than %ds';
    disp(sprintf(str,t));
end

% end time
t = timepts(2,end);
tiPlate = Time(:,2);
i = tiPlate < t;
if sum(i) > 0
    str = '-following plates stopped tracking earlier than %ds';
    disp(sprintf(str,t));
    MWTBad = mwtpath_parse(pMWT(i),{'MWTname'});
    disp(char(MWTBad));
    ival(i) = false;

else
    str = '-all plates stopped tracking earlier than %ds';
    disp(sprintf(str,t));
end

%% exclude invalidated plates
pMWTBad = pMWT(~ival);
pMWTGood = pMWT(ival);

%% get rid of certain plate names
DataBad = Raw(~ival,:);
DataGood = Raw(ival,:);

%% update MWTInfo
% MWTfnData = mwtpath_parse(pMWTData,{'MWTname'});
% i = ismember(MWTfnData,MWTfnGood);
% pMWTGood = pMWTData(i);
% pMWTBad = pMWTData(~i);
% MWTSet.MWTInfo.pMWT = pMWTGood;

%% export
% MWTSet.Data.Import = DataGood;
% MWTSet.Data.ImportBad = DataBad;


end


function [Graph,pMWT] = statsNPlates(timepoints,Raw,L)
% timepoints = MWTSet.Data.Timepoints;
%     Raw = MWTSet.Data.Import;
%     L = MWTSet.chor.choroutputLegend;
%     Measure = L(~ismember(L,{'time','number','goodnumber'}));
%     MWTSet.Data.ByPlates = Graph;
    %% STATS: N = PLATES [tested: 20150510]

    
    %% code
    Graph = [];
    Graph.X = timepoints(1,:)'; 

    for p = 1:size(Raw,1);
        Graph.pMWT{p} = Raw{p,1};
        [~,mwtname] = fileparts(Raw{p,1});
        disp(sprintf('assaying plate [%s]',mwtname));
        D = Raw{p,2};
        time = Raw{p,2}(:,1);

        % summary 
        for t = 1:size(timepoints,2); % for each stim
            % get timeframe
            starttime = timepoints(1,t);
            endtime = timepoints(2,t);
            k = time >= starttime & time < endtime;
            nT = sum(k);
            if nT == 0
                disp(sprintf('- time point %d, no time points found',...
                    endtime,nT));
            end
            dataVal = D(k,:);
            % create Graph.N
            Nrev = size(dataVal(:,2),1);
            Graph.N.Ndatapoints(t,p) = Nrev;
            Graph.N.NsumN(t,p) = sum(dataVal(:,2));
            Graph.N.NsumNVal(t,p) = sum(dataVal(:,3));

            for m = 4:numel(L)
                Graph.Y.(L{m})(t,p) = nanmean(dataVal(:,m));
                Graph.E.(L{m})(t,p) = nanstd(dataVal(:,m))./sqrt(Nrev);
            end
        end
    end
    pMWT = Graph.pMWT;
end


function save_byplatepertimemean(timepoints,Raw,Legend,pSave)
%% STATS: text file output by platse [tested: 20150510]

%% get input
%     timepoints = MWTSet.Data.Timepoints;
%     Raw = MWTSet.Data.Import;
%     Legend = MWTSet.chor.choroutputLegend;
%     pMWT = MWTSet.MWTInfo.pMWT;
%     pSave = MWTSet.PATHS.pSaveA;
    


%% code

% calculate global var
timelabel = timepoints(1,:)';
pMWT = cellfun(@fileparts,Raw(:,1),'UniformOutput',0);


% create table contents
[En,s,Gn,Mn] = mwtpath_parse(pMWT,{'expname','strain','gname','MWTname'});
NameRef = table;
NameRef.expname = En;
NameRef.gname = Gn;
NameRef.strain = s;
NameRef.mwtname = Mn;


nTime = size(timepoints,2);

% create mean summary table
DD = [];
for p = 1:size(Raw,1);

    % get data 
    D = Raw{p,2};
    time = Raw{p,2}(:,1);

    % create struct array
    L = [{'timelable';'nTimeAssyed'};Legend];
    dd = nan(nTime,numel(L)); 
    for t = 1:nTime; % for each stim
        timelabelnow = timelabel(t);

        % get timeframe
        starttime = timepoints(1,t);
        endtime = timepoints(2,t);
        k = time >= starttime & time < endtime;
        nT = sum(k); % number of time record assayed
        if nT == 0
            disp(sprintf('- time point %d, no time points found',...
                endtime,nT));
        end
        % get data within time range
        dataVal = D(k,:);

        % get stats
        dd(t,:) = [timelabelnow, nT, nanmean(dataVal,1)];
    end

    % create plate specific information header
    header = repmat(NameRef(p,:),nTime,1);


    if p == 1
        headerTable = header;
    else
        headerTable = [headerTable;header];
    end

    % create summary table
    DD = [DD;dd];


end

% convert 2 table and save
T = [headerTable, array2table(DD,'VariableNames',L)];
cd(pSave);
writetable(T,'Data_byplates_mean.txt','Delimiter','\t');

end


function save_bygrouppertimeDescriptiveStats(timepoints,Raw,Legend,pSave)
%% get input
%     timepoints = MWTSet.Data.Timepoints;
%     Raw = MWTSet.Data.Import;
%     Legend = MWTSet.chor.choroutputLegend;
%     pMWT = MWTSet.MWTInfo.pMWT;
%     pSave = MWTSet.PATHS.pSaveA;
    %% SAVE TXT FILE ON MEAN, SD, SE, N MIN, MAX PER GROUP


    %% code

    % calculate global var
    timelabel = timepoints(1,:)';
    nTime = size(timepoints,2);

    %% match MWTfn with reference paths
    RawData = Raw(:,2);


    %% create table contents
    [En,s,Gn,MWTfn] = mwtpath_parse(Raw(:,1),{'expname','strain','gname','MWTname'});
    NameRef = table;
    NameRef.expname = En;
    NameRef.gname = Gn;
    NameRef.strain = s;
    NameRef.mwtname = MWTfn;


    %% get plate mean per time points
    L = [{'timelable';'nTimeAssyed'};Legend];
    A = cell(numel(MWTfn),1);
    for p = 1:numel(MWTfn)
       D = RawData{p};
       time = D(:,1);

       % get plate mean per time points
       dd = nan(nTime,numel(L)); 
       for t = 1:nTime; % for each stim
            timelabelnow = timelabel(t);
            % get timeframe
            starttime = timepoints(1,t);
            endtime = timepoints(2,t);
            k = time >= starttime & time < endtime;
            nT = sum(k); % number of time record assayed
            % get data within time range
            dataVal = D(k,:);
            % get stats
            dd(t,:) = [timelabelnow, nT, nanmean(dataVal)];
       end
       A{p} = dd;     
    end
    PlateMean = A;


    %% get group mean from plate mean
    LL = [{'plateN'};L];
    GU = unique(Gn);
    TT = table;
    for g = 1:numel(GU)

        gn = GU(g);

        % create header
        T = cell2table([repmat(gn,size(LL,1),1),LL],...
            'VariableNames',{'GroupName','measure'});
        B = cell2mat(A(ismember(Gn,gn))); % get data
        tU = unique(B(:,1)); % find unique t pt

        % get mean
        d = [];
        for t = 1:numel(tU)
           i = B(:,1) == tU(t);
           d(t,:) = [sum(i), nanmean(B(i,:))];
        end
        Mean = d';     % invert table
        T = [T,array2table(Mean)];

        % get SE
        d = [];
        for t = 1:numel(tU)
           i = B(:,1) == tU(t);
           d(t,:) = [sum(i), nanstd(B(i,:))./sqrt(sum(i)-1)];
        end
        SE = d';     % invert table
        T = [T,array2table(SE)];

        % get SD
        d = [];
        for t = 1:numel(tU)
           i = B(:,1) == tU(t);
           d(t,:) = [sum(i), nanstd(B(i,:))];
        end
        SD = d';     % invert table
        T = [T,array2table(SD)];

        TT = [TT;T];

    end

    % write table
    cd(pSave);
    writetable(TT,'stats_byGroup.txt','Delimiter','\t');


    %% create mean summary table
    DD = [];
    for p = 1:size(Raw,1);

        % get data 
        D = Raw{p,2};
        time = Raw{p,2}(:,1);

        % create struct array
        L = [{'timelable';'nTimeAssyed'};Legend];
        dd = nan(nTime,numel(L)); 
        for t = 1:nTime; % for each stim
            timelabelnow = timelabel(t);

            % get timeframe
            starttime = timepoints(1,t);
            endtime = timepoints(2,t);
            k = time >= starttime & time < endtime;
            nT = sum(k); % number of time record assayed

            % get data within time range
            dataVal = D(k,:);

            % get stats
            dd(t,:) = [timelabelnow, nT, nanmean(dataVal)];
        end

        % create plate specific information header

        header = repmat(NameRef(p,:),nTime,1);

        if p == 1
            headerTable = header;
        else
            headerTable = [headerTable;header];
        end

        % create summary table
        DD = [DD;dd];


    end

    % convert 2 table and save
    T = [headerTable, array2table(DD,'VariableNames',L)];
    cd(pSave);
    writetable(T,'Data_byplates_mean.txt','Delimiter','\t');
end


function save_pergrouppair2N2(timepoints,Raw,Legend,pSave)
%% get input
%     timepoints = MWTSet.Data.Timepoints;
%     Raw = MWTSet.Data.Import;
%     Legend = MWTSet.chor.choroutputLegend;
%     pMWT = MWTSet.MWTInfo.pMWT;
%     pSave = MWTSet.PATHS.pSaveA;
    %% SAVE TXT FILE ON MEAN, SD, SE, N MIN, MAX PER GROUP


    %% code
    % calculate global var
    timelabel = timepoints(1,:)';
    nTime = size(timepoints,2);

    % match MWTfn with reference paths
    RawData = Raw(:,2);

    %% create table contents
    [En,s,Gn,MWTfn] = mwtpath_parse(Raw(:,1),...
        {'expname','strain','gname','MWTname'});
    NameRef = table;
    NameRef.expname = En;
    NameRef.gname = Gn;
    NameRef.strain = s;
    NameRef.mwtname = MWTfn;
    
    %% create timepoints colm name
    colN = regexprep(...
        strcat(repmat({'N'},size(timelabel)),cellstr(num2str(timelabel))),...
        ' ','');
    colMean = regexprep(...
        strcat(repmat({'Mean'},size(timelabel)),cellstr(num2str(timelabel))),...
        ' ','');
    colSE = regexprep(...
        strcat(repmat({'SE'},size(timelabel)),cellstr(num2str(timelabel))),...
        ' ','');
    colstatlabel = [colN',colMean',colSE'];


    %% create mean summary table
    DD = [];
    for p = 1:size(Raw,1);

        % get data 
        D = Raw{p,2};
        time = Raw{p,2}(:,1);

        % create struct array
        L = [{'timelable';'nTimeAssyed'};Legend];
        dd = nan(nTime,numel(L)); 
        for t = 1:nTime; % for each stim
            timelabelnow = timelabel(t);

            % get timeframe
            starttime = timepoints(1,t);
            endtime = timepoints(2,t);
            k = time >= starttime & time < endtime;
            nT = sum(k); % number of time record assayed

            % get data within time range
            dataVal = D(k,:);

            % get stats
            dd(t,:) = [timelabelnow, nT, nanmean(dataVal)];
        end
        
        d3 = dd(:,2:end)';
       
        % variable legned
        vL = cell2table(L(2:end),...
            'VariableNames',{'msr'});
        % create plate specific information header
        header = repmat(NameRef(p,:),numel(vL),1);
        header = [header,vL];

        if p == 1
            headerTable = header;
        else
            headerTable = [headerTable;header];
        end

        % create summary table
        DD = [DD;d3];
    end

    % convert 2 table and save
    T = [headerTable, array2table(DD,'VariableNames',colMean)];
    
    % sort table by msr and then strain then MWT name
    T= sortrows(T,{'msr','gname','mwtname'});

    pSaveA = [pSave,'/Tables'];
    if isdir(pSaveA) == 0; mkdir(pSaveA); end
    cd(pSaveA);
    writetable(T,'Data_byplates_grpxmean.txt','Delimiter','\t');
    
    % save by group by msr
    gn = T.strain;
    gnu = unique(gn);
    for gnui = 1:numel(gnu)
        T2 = T(ismember(gn,gnu(gnui)),:);
        fn = ['Data_byplates_grpxmean_',gnu{gnui},'.txt'];
        cd(pSaveA); writetable(T2,fn,'Delimiter','\t');
        msru = unique(T2.msr);
        for msrui = 1:numel(msru)
            T3 = T2(ismember(T2.msr,msru(msrui)),:);
            fn = ['Data_byplates_grpxmean_',gnu{gnui},'_',msru{msrui},'.txt'];
            cd(pSaveA); writetable(T3,fn,'Delimiter','\t');
        end
    end
    
    % save by group paired with N2 by msr
    N2i = regexpcellout(T.strain,'N2');
    % take N2 table
    TN2 = T(N2i,:);
    T4 = T(~N2i,:);
    gn = T4.strain;
    gnu = unique(gn);
    for gnui = 1:numel(gnu)
        T2 = [TN2;T4(ismember(gn,gnu(gnui)),:)];
        fn = ['Data_byplates_N2xgrpxmean_',gnu{gnui},'.txt'];
        cd(pSaveA); writetable(T2,fn,'Delimiter','\t');
        msru = unique(T2.msr);
        for msrui = 1:numel(msru)
            T3 = T2(ismember(T2.msr,msru(msrui)),:);
            fn = ['Data_byplates_N2xgrpxmean_',gnu{gnui},'_',msru{msrui},'.txt'];
            cd(pSaveA); writetable(T3,fn,'Delimiter','\t');
        end
    end

    
    
end


function A = orgstatsPlates2groups(D)
%% get input
%     D = MWTSet.Data.ByPlates;
%     MWTSet.Data.ByPlates_OrgByGroup = A;
    %% ORGANIZE STATS FROM PLATES TO GROUPS
    
    
    %% ORGANIZE ByPlate data BY GROUPS
    [GroupName,MWTfn] = mwtpath_parse(D.pMWT,{'gname','MWTname'});

    O = struct;
    GnameU = unique(GroupName);
    A = struct;
    for g = 1:numel(GnameU)
        gname = GnameU{g};
        ind  = ismember(GroupName,gname);
        A.time = D.X;
        A.MWTfn.(gname) = MWTfn(ind);

        graphfields = {'N','Y','E'};
        for gg = 1:numel(graphfields)
            gf = graphfields{gg};

            anames = fieldnames(D.(gf));
            for a = 1:numel(anames)
                aa = anames{a};
                A.(aa).(gname).(gf) = D.(gf).(aa)(:,ind);            
            end
        end

    end
%     MWTSet.Data.ByPlates_OrgByGroup = A;

end


function C = statsbygroup(D)
% D = MWTSet.Data.ByPlates_OrgByGroup;
% MWTSet.Data.ByGroup = C;
    %% STATS BY GROUP N = PLATES
    


    %% code
    anames_common = {'time', 'MWTfn'};
    X = D.time;
    anames = {'Ndatapoints', 'NsumN', 'NsumNVal'};
    C = [];
    for r = 1:numel(anames)
        rname = anames{r};
        gnameList = fieldnames(D.(rname));

        B = [];
        for g = 1:numel(gnameList)
            gname = gnameList{g};

            d = D.(rname).(gname).N;

            A = calDescriptive(d);

            B.gname{g} = gname;
            B.X(:,g) = D.time;
            B.N(:,g) = A.N;
            B.Y(:,g) = A.mean;
            B.E(:,g) = A.SE;
        end
        C.(rname) = B;
    end

    anames = {
        'Speed'
        'Length'
        'Width'
        'Aspect'
        'Kink'
        'Bias'
        'Curve'
        'Area'
        'midline'
        'morphwidth'};

    for r = 1:numel(anames)
        rname = anames{r};
        gnameList = fieldnames(D.(rname));

        B = [];
        for g = 1:numel(gnameList)
            gname = gnameList{g};

            d = D.(rname).(gname).Y;

            A = calDescriptive(d);

            B.gname{g} = gname;
            B.X(:,g) = D.time;
            B.N(:,g) = A.N;
            B.Y(:,g) = A.mean;
            B.E(:,g) = A.SE;
        end
        C.(rname) = B;
    end

    

end


function graph_bygrouppermeasure(pSaveA,D,AnalysisCode,timestamp)
  %% get input
%     pSaveA = MWTSet.PATHS.pSaveA;
%     D = MWTSet.Data.ByGroup;
%     AnalysisCode = MWTSet.AnalysisCode;
%     timestamp = MWTSet.timestamp;
    
    %% GRAPHING: Per measure
    
    %% global setting
    visiblesetting = 1;
    colorset = [0 0 0; 1 0 0; [0.5 0.5 0.5]; [0.04 0.52 0.78]]; 
    pSaveAA = [pSaveA,'/Individual Graphs'];
    if isdir(pSaveAA) == 0; mkdir(pSaveAA); end
    
    %% code
    rnamelist = fieldnames(D);
    for r = 1:numel(rnamelist)
        rname = rnamelist{r};
        titlestr = [AnalysisCode, ' ',timestamp];
        gname = D.(rname).gname;
        X = D.(rname).X;
        Y = D.(rname).Y;
        E = D.(rname).E;

        yname = rname;
        figname = rname;
        PlateN = size(Y,2);
        figure1 = makefig_Errorbar_line(X,Y,E,gname,colorset,titlestr,yname,PlateN,...
                    visiblesetting);
        switch visiblesetting
            case 0
                savefigepsOnly150(figname,pSaveAA);
            case 1
                savefigeps(figname,pSaveAA);
        end
    end
end


function graph_bar_lasttime_bygrouppermeasure(pSaveA,D,AnalysisCode,timestamp)
    %% get input
%     pSaveA = MWTSet.PATHS.pSaveA;
%     D = MWTSet.Data.ByGroup;
%     AnalysisCode = MWTSet.AnalysisCode;
%     timestamp = MWTSet.timestamp;    

    %% GRAPH BAR of last time point
    % will run with enoug input
    

    %% global setting
    pSaveAA = [pSaveA,'/Bar Graphs'];
    if isdir(pSaveAA) == 0; mkdir(pSaveAA); end
    visiblesetting = 1;
    colorset = [0 0 0; 1 0 0; [0.5 0.5 0.5]; [0.04 0.52 0.78]]; 


    %% code
    rnamelist = fieldnames(D);
    for r = 1:numel(rnamelist)
        rname = rnamelist{r};
        figname = [rname];
        titlestr = [AnalysisCode,' ',timestamp];
        gname = regexprep(D.(rname).gname,'_',' ');
        bartime = size(D.(rname).X,1);
        X = D.(rname).X(bartime,:);
        Y = D.(rname).Y(bartime,:);
        E = D.(rname).E(bartime,:);
        yname = rname;
        PlateN = size(Y,2);
        makefig_barwitherrorbar(X,Y,E,gname,titlestr,yname,visiblesetting)
        switch visiblesetting
            case 0
                savefigepsOnly150(figname,pSaveAA);
            case 1
                savefigeps(figname,pSaveAA);
        end
    end

end





%% SHARED FUNCTIONS
function [pass,vnameval,valvname] = validateoutput(MWTSet,vname)
%% VALIDATE MWTSET INPUTS
%       vname = {'chor.arguments';'chor.pCodeChor.a';...
%           'chor.chorscript';'chor.chor_fileoutputnames'};

%% code
vname_split = regexpcellout(vname,'[.]','split');
nlevel = size(vname_split,2);
nvname = size(vname_split,1);
valvname = true(nvname,1);

A = MWTSet;

% validate
for x = 1:nvname

    B = A;
    v = vname_split(x,:);
    v = v(1,~cellfun(@isempty,v));
    nlevel = size(v,2);

    for y = 1:nlevel
        vv = v{y};
        if isstruct(B) ~=1
            valvname(x) = false;
            break
        end
        
        if ismember(vv,fieldnames(B)) ~= 1 
            valvname(x) = false;
        end
        
        if isstruct(B) == 1 && y < nlevel
            B = B.(vv);
        end
    end
end

vnameval = vname(valvname);
if sum(valvname) == numel(vname); pass = true; else pass = false; end
end



%% DISABLED FUNCTIONS
function MWTSet = preptime(MWTSet)
    %% PREPARE TIME POINTS [updated 20150510]

    %% validate output
    vname = {'Data.Import_TimeEval';
        'Data.Import_TimeCommonEndTime';'Data.Timepoints'};
    if validateoutput(MWTSet,vname) == true; return; end

    %% validate input
    vname = {'MWTSet.Data.Import';
        'MWTSet.AnalysisSetting.TimeInputs'};
        validateStructInput(vname,MWTSet);

    
    %% get input
    Raw = MWTSet.Data.Import;
    TimeInputs = MWTSet.AnalysisSetting.TimeInputs;
    MWTfn = MWTSet.Data.Import(:,1);


    %% CODE
    %% find start end times for each plate
    % -1 = min, Inf = max, -2 = common
    % prepare universal timepoints limits
    % timepoints
    % find smallest starting time and smallest ending time
    % MWTfdrunkposturedatL = {1,'MWTfname';2,'Data';3,'time(min)';4,'time(max)'};
    
    Time = nan(size(MWTfn,1),2);    
    for p = 1:size(Raw,1)
        Time(p,1) = min(Raw{p,2}(:,1)); 
        Time(p,2) = max(Raw{p,2}(:,1));
    end

    % by second
    str = 'Earliest time tracked (MinTracked): %0.1f';
    valstartime = floor(max(Time(:,1)));
    display(sprintf(str,valstartime));
    str = 'Min last time tracked  (MaxTracked): %0.1f';
    valendtime = floor(min(Time(:,2)));
    display(sprintf(str,valendtime));

    % unique time
    display('unique max time(s): N of each')
    a = floor(Time(:,2));
    b = tabulate(a);
    b = b(b(:,2)~=0,1:2);
    disp(b);
    
    % export
    MWTSet.Data.Import_TimeStartEnd = Time;
    MWTSet.Data.Import_TimeEval = [min(Time); max(Time)];
    MWTSet.Data.Import_TimeCommonEndTime = b(end,1);


    %% prep assay time points
    display ' '; display('Actual analysis time:');
    
    % get input
    timeSurvey = MWTSet.Data.Import_TimeEval;
    commonEndtime = MWTSet.Data.Import_TimeCommonEndTime ;

    minstart = timeSurvey(1,1);
    maxstart = timeSurvey(2,1);    
    minsend = timeSurvey(1,2);
    maxend = timeSurvey(2,2);


    % prep timepoints
    % starting time 
    tinput = TimeInputs(1);

    if maxstart < 10  % earliest 10s
        minvalid = maxstart;
    else % if less than 10s, set to 10s increments
        minvalid = floor(maxstart/10)*10;
        warning('minimum start time is larger than 10s');
    end

   
    if tinput <= 0 || isempty(tinput)==1 || ...
        isnan(tinput) ==1 || tinput <= minvalid
        ti = minvalid; 
    elseif tinput > minvalid
        ti = tinput;
    end
    display(sprintf('starting time(s): %d',ti));

    % interval
    intinput = TimeInputs(2);
    if isempty(intinput)==1 || isnan(intinput) ==1; 
        int = 10; 
    else
        int = intinput;
    end
    display(sprintf('interval(s): %d',int));


    % last time
    tfinput = TimeInputs(4);
    if isempty(tfinput)==1 || isnan(tfinput)==1; 
        tf = minsend; 
    elseif tfinput == -1
        tf = minsend;
    elseif tfinput == -2
        tf = commonEndtime;
    elseif tfinput > maxend
        tf = maxend;
    else
        tf = tfinput;
    end
    display(sprintf('endtime(s): %d',tf));


    % duration
    durinput = TimeInputs(3);
    if isempty(durinput)==1 || isnan(durinput) ==1 || ...
        durinput <= int
        dur = int;
        timepoints = [0,ti+int:int:tf];
        str = 'Time points: %0.0f ';
        timeN = numel(timepoints)-1;
        display(sprintf(str,timeN));
    else
        dur = durinput;
        duration = 'restricted'; 
        error('Under construction');% need coding
    end

    display(sprintf('duration(s): %d',durinput));


    % MWTSet output
    timepoints = [ti:int:tf-dur; (ti:int:tf-dur)+dur];
    MWTSet.Data.Timepoints = timepoints;
    
    
    %% exclude plates outside of time points
    % import data
    Time = MWTSet.Data.Import_TimeStartEnd;
    timepoints = MWTSet.Data.Timepoints;
    
    %% 
    
    
    %% validate output
    vname = {'Data.Import_TimeEval';
        'Data.Import_TimeCommonEndTime';'Data.Timepoints'};
    if validateoutput(MWTSet,vname) == false; 
        error('MWTSet output not enough');
    end
    
end









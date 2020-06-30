%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% GLOBAL INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paths ++++++++++++++
pD = fileparts(pM);
pSave = pM;
msrlist = {'speed','curve'};


load(fullfile(pD,'MWTDB.mat'),'MWTDB');
pMWT = MWTDB.mwtpath;

timelist= [5 10 95];
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return


%% LOAD MWT DATABASE
databasepath = '/Users/connylin/Dropbox/RL/Publication/PhD Dissertation/Chapters/2-Materials and Methods General/MWTDB/MWTDB.mat';
D = load(databasepath);
MWTDB = D.MWTDB.text;
%% QUERY DATABASE
% after liquid transfer date
MWTDB(MWTDB.exp_date <= 20120120,:) = [];
% ISI
MWTDB(~ismember(MWTDB.rc,'100s30x10s10s'),:) = [];
% must have groups
e = unique(MWTDB.expname(ismember(MWTDB.groupname,{'N2_100mM','N2_200mM','N2_300mM','N2_500mM','N2_600mM'})));
MWTDB(~ismember(MWTDB.expname,e),:) = [];
% % must have controls
% e = unique(MWTDB.expname(ismember(MWTDB.groupname,'N2')));
% MWTDB(~ismember(MWTDB.expname,e),:) = [];
% keep only interested groups
gnseq = {'N2','N2_100mM','N2_200mM','N2_300mM','N2_400mM','N2_500mM','N2_600mM'};
MWTDB(~ismember(MWTDB.groupname,gnseq),:) = [];
% report unique
e = unique(MWTDB.expname);
fprintf('%d experiments qualified\n',numel(e));
fprintf('plates per group:');
tabulate(MWTDB.groupname);
%% QUALIFIERS (N AND CURVE): suspend
% plate qualifiers: curve < 23.51
% pMWT = MWTDB.mwtpath;
% % 1) 400mM has curve less than 23.51
% % -look which mwt needs chor
% [pSPfile,pMWT_hasSP,pMWT_noSP] = getpath2chorfile(pMWT,'.drunkposture2.dat');
% % chor (already checked, no other files can be chored)
% chormaster4('DrunkPostureOnly',pMWT_noSP); 
% % experiment summary
% MWTDB = parseMWTinfo(pMWT_hasSP);
% fprintf('plates per group:');
% tabulate(MWTDB.groupname);
% % does every experiment has N2 and N2_400mM
% % must have N2_400mM group
% e = unique(MWTDB.expname(ismember(MWTDB.groupname,'N2_400mM')));
% MWTDB(~ismember(MWTDB.expname,e),:) = [];
% % must have N2 group
% e = unique(MWTDB.expname(ismember(MWTDB.groupname,'N2')));
% MWTDB(~ismember(MWTDB.expname,e),:) = [];
% % report unique
% e = unique(MWTDB.expname);
% fprintf('\n%d experiments qualified\n',numel(e));
% fprintf('plates per group:');
% tabulate(MWTDB.groupname);
% 
% 
% %% get only 400mM data
% i = ismember(MWTDB.groupname,'N2_400mM');
% pSPfile_400 = pSPfile(i);
% pMWT_400 = MWTDB.mwtpath(i);
% 
% % get curve data
% % -input variables
% fprintf('importing %s\n','.drunkposture2.dat');
% itrgap = 10;
% pFiles = pSPfile_400; 
% nfiles = numel(pFiles);
% time1 = 90; time2 = 95;
% curve = nan(size(pFiles));
% % load data
% for mwti = 1:nfiles
%     % report every x iterations
%     processIntervalReporter(nfiles,itrgap,'MWT',mwti)
%     pfile = pFiles{mwti}; % get current path
%     clear D A; % clear variables
%     D = import_drunkposture2_dat({pfile}); % load file
%     D = D{1}; % get that one file out
%     if isempty(D) == 1; continue; end % if no file loaded, skip to next
%     if isempty(D) == 0
%        A = extract_data_drunkposture2dat(D,'time1',time1,'time2',time2,'varnames',{'curve'});
%        curve(mwti) = mean(A.curve);
%     end
% end
% fprintf('done\n');
% 
% 
% 
% %% find plates that has curve less than 
% i = curve > 23.51;
% Db = parseMWTinfo(pMWT_400(i));
% en = unique(Db.expname);
% fprintf('\n%d mwt in %d exp contains invalid curve\n',sum(i),numel(en));
% MWTDB(ismember(MWTDB.mwtname,Db.mwtname),:) = [];
% % report unique
% fprintf('\n%d experiments qualified\n',numel(unique(MWTDB.expname)));
% fprintf('plates per group:'); tabulate(MWTDB.groupname);
% 
% % must have N2_400mM group
% e = unique(MWTDB.expname(ismember(MWTDB.groupname,'N2_400mM')));
% MWTDB(~ismember(MWTDB.expname,e),:) = [];
% % must have N2 group
% e = unique(MWTDB.expname(ismember(MWTDB.groupname,'N2')));
% MWTDB(~ismember(MWTDB.expname,e),:) = [];
% % fprintf('\n%d exp contains invalid curve\n',numel(en))
% % report unique
% fprintf('\n%d experiments qualified\n',numel(unique(MWTDB.expname)));
% fprintf('plates per group:'); tabulate(MWTDB.groupname);
% 
% 
% %% plate qualifiers: 2) N plate > 20 (for speed analysis)
% % -input variables
% pMWT = MWTDB.mwtpath;
% [pSPfile,pMWT_hasSP] = getpath2chorfile(pMWT,'.drunkposture2.dat');
% pFiles = pSPfile; 
% nfiles = numel(pFiles);
% itrgap = 10; time1 = 101; time2 = 395;
% N = nan(numel(pFiles),3);
% % load data
% for mwti = 1:nfiles
%     % report every x iterations
%     if ismember(mwti,1:itrgap:nfiles) == 1
%         fprintf('%d/%d MWT file\n',mwti,nfiles);
%     end
%     pfile = pFiles{mwti}; % get current path
%     clear D A; % clear variables
%     D = import_drunkposture2_dat({pfile}); % load file
%     D = D{1}; % get that one file out
%     if isempty(D) == 1; continue; end % if no file loaded, skip to next
%     if isempty(D) == 0
%        A = extract_data_drunkposture2dat(D,'time1',time1,'time2',time2,'varnames',{'goodnumber'});
%        d = A.goodnumber;
%        N(mwti,1:3) = [min(d) mean(d) max(d)];
%     end
% end
% fprintf('done\n');
% 
% 
% 
% 
% 
% %% minimum good number > 20
% MWTDB(ismember(MWTDB.mwtpath,pMWT(N(:,1) < 20)),:) = [];
% % must have N2_400mM group
% e = unique(MWTDB.expname(ismember(MWTDB.groupname,'N2_400mM')));
% MWTDB(~ismember(MWTDB.expname,e),:) = [];
% % must have N2 group
% e = unique(MWTDB.expname(ismember(MWTDB.groupname,'N2')));
% MWTDB(~ismember(MWTDB.expname,e),:) = [];
% % fprintf('\n%d exp contains invalid curve\n',numel(en))
% % report unique
% fprintf('\n%d experiments qualified\n',numel(unique(MWTDB.expname)));
% fprintf('plates per group:'); tabulate(MWTDB.groupname);
%% EXPORT EXPERIMENT INFO
% save qualified exp
cd(pSave);
save('MWTInfo.mat','MWTDB');
% print output
T = table;
T.mwtid = MWTDB.mwtid;
T.expname = MWTDB.expname;
T.groupname = MWTDB.groupname;
T.mwtname = MWTDB.mwtname;
cd(pSave);
writetable(T,'experiment list.csv');
%% CHOR FILES
pMWT = MWTDB.mwtpath;
% check trv files
[pTrv,~,pMWTnoTRV] = getpath2chorfile(pMWT,'*.trv');
% chor
[Legend,pMWTcS,fval,chorscript] = chormaster4('BeethovenOnly',pMWTnoTRV);
% check version of trv files
trv_oldversion = true(size(pTrv));
for mwti =1:numel(pTrv)
    pf = pTrv{mwti};
    % see version of trv
    fileID = fopen(pf,'r');
    a = textscan(fileID,'%s', 1,'Delimiter', '', 'WhiteSpace', '');
    a = char(a{1}(1));
    fc = a(1);
    fclose(fileID);
    if regexp(fc,'\d{1,}') == 1; 
        trv_oldversion(mwti) = false;
    end
end
fprintf('%d files are old trv version\n',sum(trv_oldversion))
%% IMPORT HABITUATION CURVES DATA
% check trv files
[pTrv,pMWThasTRV,pMWTnoTRV] = getpath2chorfile(pMWT,'*.trv');
% import legend
pTrvLegend = '/Users/connylin/Dropbox/RL/Code/Modules/Chor_output_handling/trv/legend_trv.mat';
load(pTrvLegend);
% get necessary legends
legend_output = {'tap','time', 'N_alreadyRev', 'N_ForwardOrPause', 'N_Rev', 'RevDis', 'RevDur'};
ind_get = find(ismember(legend_trv,legend_output));

% import into structural array
% Import= cell(size(pTrv));
S = struct;
for mwti =1:numel(pTrv)
    pf = pTrv{mwti};
    if size(pf,1) > 1; error('fix trv paths'); end
    % see version of trv
    d = dlmread(pf);
    ncol = size(d,2);
    if ncol ~= numel(legend_trv); error('trv col number wrong'); end
    % add tap
    tapnumber = (1:size(d,1))';
    D = array2table([tapnumber,d(:,ind_get)],'VariableNames',legend_output);
    % frequency is # reversed divided by total number not already reversing
    D.RevFreq = D.N_Rev./(D.N_Rev + D.N_ForwardOrPause);
    % calculate reversal speed: reversal speed is reversal distance divided by reversal duration
    D.RevSpeed = D.RevDis./D.RevDur;
    D.RevDis = [];
    % prepare summary output identifiers
    pmwt = fileparts(pf);
    db = parseMWTinfo(pmwt);
    dbname = {'expname','groupname','mwtname'};
    S(mwti).mwtpath = {pmwt};
    S(mwti).expname = db.expname;
    S(mwti).groupname = db.groupname;
    S(mwti).mwtname =  db.mwtname;
    % enter variable in structural array
    vnames = D.Properties.VariableNames;
    for vi = 1:numel(vnames)
        vn = vnames{vi};
        S(mwti).(vn) = D.(vn);
    end
end

% expand import into table
n = arrayfun(@(x) numel(x.tap),S);
nrow = sum(n);
rowi = [0 cumsum(n)];
vnames = fieldnames(S);
identifiers = {'expname', 'groupname', 'mwtname','mwtpath'};
varn = vnames(~ismember(vnames,identifiers));
measurename = varn(~ismember(varn,'wormid'));
% prepare table
Data = table;
for vi = 1:numel(identifiers)
    v = identifiers{vi};
    a = cell(nrow,1); 
    for i = 1:numel(S); a(rowi(i)+1:rowi(i+1)) = S(i).(v); end
    Data.(v) = a;
end
% variables
for vi = 1:numel(varn)
    v = varn{vi};
    A  = cell(size(S)); for i = 1:numel(S); A{i} = S(i).(v); end
    Data.(v) = cell2mat(A');
end
%% DESCRIPTIVE STATS & RMANOVA N=PLATES
fprintf('calculating habituation curve\n');
measurename = {'RevDur','RevFreq','RevSpeed'};
gname = Data.groupname;
gu = unique(gname);
[~,guseq] = ismember(gu,gnseq);
for vi = 1:numel(measurename)
    msr = measurename{vi};
    MEAN= table; SE = table; TOut = table;
    for gi = guseq'
        gn = gu{gi};
        i = ismember(Data.groupname,gn);
        % calculate
        X = Data.(msr)(i);
        T = Data.tap(i);
        yname = regexprep(msr,'_',' ');
        B = table;
        [B.tap,B.N,B.mean,B.SD,B.SE] = grpstats(X,T,{'gname','numel','mean','std','sem'});
        B.tap = cellfun(@str2num,B.tap);
        if size(MEAN,1) == 0; MEAN.tap = B.tap; end
        [i,j] = ismember(B.tap,MEAN.tap);
        a = nan(size(MEAN.tap));
        MEAN.(sprintf('%s_Mean',gn)) = a;
        SE.(sprintf('%s_SE',gn)) =a;
        MEAN.(sprintf('%s_Mean',gn))(j(i)) = B.mean;
        SE.(sprintf('%s_SE',gn))(j(i)) = B.SE;
        
        T = table;
        T.groupname = repmat(gn,size(B,1),1);
        T = [T B];
        savename = sprintf('%s %s N by plate.csv',msr,gn);
        cd(pSave); writetable(T,savename);
    end
    TOut = [MEAN SE];
    cd(pSave); writetable(TOut,sprintf('%s Graph by plate.csv',msr));
end
%% COLLAPSE DATA BY EXPERIMENTS
% calculate experiment mean
measurename = {'RevDur','RevFreq','RevSpeed'};
gname = Data.groupname;
gu = unique(gname);
% convert group name into label name
a = Data.groupname; a(ismember(a,'N2')) = {'0mM'}; a = regexprep(a,'(N2_)|(mM)','');
gnamelabel = a;

for vi = 1:numel(measurename)
    msr = measurename{vi};
    T1 = table;
    for gi = 1:numel(gu)
        gn = gu{gi};
        i = ismember(Data.groupname,gn);
        eu = unique(Data.expname(i));
        for ei = 1:numel(eu)
            en = eu{ei};
            i = ismember(Data.groupname,gn) & ismember(Data.expname,en);
            % calculate
            X = Data.(msr)(i);
            tap = Data.tap(i);
            B = table;
            [B.tap,B.N,B.(msr)] = grpstats(X,tap,{'gname','numel','mean'});
            B.tap = cellfun(@str2num,B.tap);
            T = table;
            T.groupname = repmat({gn},size(B,1),1);
            T.expname = repmat({en},size(B,1),1);
            T = [T B];
            T1 = [T1;T];
        end
    end
    if vi ==1;
        TS = T1;
    else
        TS = innerjoin(TS,T1);
    end
end
%% DESCRIPTIVE STATS & RMANOVA N=EXPERIMENTS
measurename = {'RevDur','RevFreq','RevSpeed'};
gname = TS.groupname;
gu = unique(gname);
[~,guseq] = ismember(gu,gnseq);
for vi = 1:numel(measurename)
    msr = measurename{vi};
    MEAN= table; SE = table; TOut = table;
    for gi = guseq'
        gn = gu{gi};
        i = ismember(TS.groupname,gn);
        % calculate
        X = TS.(msr)(i);
        T = TS.tap(i);
        yname = regexprep(msr,'_',' ');
        B = table;
        [B.tap,B.N,B.mean,B.SD,B.SE] = grpstats(X,T,{'gname','numel','mean','std','sem'});
        B.tap = cellfun(@str2num,B.tap);
        if size(MEAN,1) == 0; MEAN.tap = B.tap; end
        [i,j] = ismember(B.tap,MEAN.tap);
        a = nan(size(MEAN.tap));
        MEAN.(sprintf('%s_Mean',gn)) = a;
        SE.(sprintf('%s_SE',gn)) =a;
        MEAN.(sprintf('%s_Mean',gn))(j(i)) = B.mean;
        SE.(sprintf('%s_SE',gn))(j(i)) = B.SE;
        T = table;
        T.groupname = repmat(gn,size(B,1),1);
        T = [T B];
        savename = sprintf('%s %s N by experiment.csv',msr,gn);
        cd(pSave); writetable(T,savename);
    end
    TOut = [MEAN SE];
    cd(pSave); writetable(TOut,sprintf('%s Graph by exp.csv',msr));
end


% repeated measures ANOVA by experiment
measurename = {'RevDur','RevFreq','RevSpeed'};
gname = TS.groupname;
gu = unique(gname);
for vi = 1:numel(measurename)
    msr = measurename{vi};
    X = cell(size(gu));
    for gi = 1:numel(gu)
        fprintf('calculating %s %s, ',msr,gn);
        gn = gu{gi};
        i = ismember(TS.groupname,gn);
        % calculate
        x = TS.(msr)(i);
        tap = TS.tap(i);
        en = TS.expname(i);
        ntap = numel(unique(tap));
        enu = unique(en);
        nexp = numel(enu);
        a = nan(nexp,ntap);
        for ei = 1:numel(enu)
            e = enu(ei);
            i = ismember(en,e);
            a(ei,tap(i)) = x(i)';
        end
        i = ~any(isnan(a),2);
        n = sum(i);
        fprintf('N exp = %d\n',n);
        X{gi} = a(i,:);
    end
    [p,t]  = anova_rm(X,'off');
    a = t(2:end,2:end);
    colname =  regexprep(t(1,2:end),'>F','');
    rowname = regexprep(t(2:end,1),'[(]|[)]','');
    a = array2table(a,'VariableNames',colname);
    A = table;
    A.rowname = rowname;
    A = [A a];
    cd(pSave);
    writetable(A,sprintf('%s RMANOVA.csv',msr))
end
%% REPORT DONE
fprintf('\nDONE\n');


















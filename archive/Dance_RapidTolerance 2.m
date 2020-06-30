function MWTSet = Dance_RapidTolerance(pMWT,varargin)
%% Dance_DrunkMoves_RapidTolerance
% updated: 201603270930

%% Paths
addpath(fileparts(mfilename('fullpath')));

%% DEFAULTS ---------------------------------------------------------------
fprintf('\n** Running %s **\n',mfilename);
pSave = '/Users/connylin/Dropbox/RL/Dance Output';
pDataBase = '/Volumes/COBOLT/MWT/MWTDB.csv';
timeStartSet = 240;
timeEndSet = 300;
% varargin
vararginProcessor;
% output
MWTSet.Input.pMWT = pMWT;
MWTSet.Input.timeStartSet = timeStartSet;
MWTSet.Input.timeEndSet = timeEndSet;
% create save
pSave = [pSave,'/',mfilename]; if isdir(pSave)==0; mkdir(pSave); end
% save a copy of this to pSave
copyfile([mfilename('fullpath'),'.m'], [pSave,'/',mfilename,'_a',generatetimestamp,'.m']);


%% PREPARE ----------------------------------------------------------------
% CHOR
[~,~,pfailed] = chormaster5('DrunkPostureOnly',pMWT);
% get legend
% Legend = Legend{1}{2,ismember(Legend{1}(1,:),'drunkposture2')};
% only pMWT with chor can be analyzed
if isempty(pfailed)==false
   warning('these mwt files do not have chor');
   a = parseMWTinfo(pfailed);
   disp(char(a.mwtname))
end
% update MWTDB from database
pMWT = pMWT(~ismember(pMWT,pfailed)); 
Db = readtable(pDataBase);
i = ismember(Db.mwtpath,pMWT);
if sum(i) ~= numel(pMWT)
   error('database missing input pMWT info');
end
[i,j] = ismember(pMWT,Db.mwtpath);
MWTDB = Db(j(i),:); clear Db;
MWTDB.mwtid_db = MWTDB.mwtid;
MWTDB.mwtid = [1:size(MWTDB,1)]';
% group name translation: specific for rapid tolerance
MWTDB = parseToleranceName(MWTDB);



%% import
[Data,~,Legend2] = import_drunkposture2_dat(pMWT,'array');
if numel(pMWT) ~=numel(Data); error('import number incorrect'); end
Data = array2table(cell2mat(Data),'VariableNames',Legend2);
% remove data outside of assay time
Data(Data.time < timeStartSet | Data.time > timeEndSet,:) = [];
% store in MWTSet
MWTSet.Import.drunkposture2 = Data;
MWTSet.Info.MWTDB = MWTDB;
MWTSet.Info.legend.drunkposture2 = Legend2;
% clear memory
clear gnn s a b c strain expr e i


%% CALCULATE --------------------------------------------------------------
%% CAL: MEAN 
pMWT = MWTDB.mwtpath;
msr = Legend2(2:end);
x = Data.(Legend2{1});
% set up output
A = nan(numel(pMWT),numel(Legend2));
A(:,1) = MWTDB.mwtid;
for msri = 1:numel(msr)
    [gn,m] = grpstats(Data.(msr{msri}),x,{'gname','mean'});
    gn = cellfun(@str2num,gn);
    [i,j] = ismember(A(:,1),gn);
    A(i,msri+1) = m(j(i));
end
% transform to table
Sum = array2table(A,'VariableNames',Legend2);
% add table variables
S = innerjoin(MWTDB,Sum,'Keys','mwtid');
MWTSet.Data_Plate = Sum;
% export raw data
cd(pSave);
writetable(S,'raw.csv');

%% TABLE OUTPUT: MEAN PER GROUP (N=PLATES)
msrlist = {'speed','curve'};
A = struct;
grp = S.groupname_short;
gnameu = unique(grp);
% make header
grpheader = table;  
a = regexpcellout(gnameu,' ','split');
grpheader.strains = a(:,1);
grpheader.predose = a(:,2);
grpheader.postdose = a(:,3);
for msri= 1:numel(msrlist)
    T = grpstatsTable(S.(msrlist{msri}), grp,'grpheader',grpheader,'gnameu',gnameu);
    filename = sprintf('%s/%s.csv',pSave,msrlist{msri});
    writetable(T,filename)
    A.(msrlist{msri}) = T;
end
MWTSet.Data_Group = A;


%% MAKE GRAPH

msrlist = fieldnames(MWTSet.Data_Group);
D = MWTSet.Data_Group.(msrlist{1});
strains = unique(D.strains);
rowsname = 'predose';
colsname = 'postdose';

rowvaru = unique(D.(rowsname));
colvaru = unique(D.(colsname));

X = repmat((0:0.1:(0.1*(numel(rowvaru)-1)))', 1,numel(colvaru));
yEmpty = nan(numel(rowvaru),numel(colvaru));

% color: black and red
color = [0 0 0; [0.635294139385223 0.0784313753247261 0.184313729405403]];
for msri = 1:numel(msrlist)
    msr = msrlist{msri};
    D = MWTSet.Data_Group.(msr);

for si = 1:numel(strains) % run through each strain
    sname = strains{si};
    % rearrange to output
    Y = yEmpty;
    E = Y;
    for ri = 1:numel(rowvaru)
    for ci = 1:numel(colvaru)
        i = ismember(D.strains, sname) ...
            & ismember(D.(rowsname), rowvaru{ri}) ... % get predose
            & ismember(D.(colsname), colvaru{ci});
        if sum(i)==1; 
            Y(ri,ci) = D.mean(i);
            E(ri,ci) = D.se(i);
        end
        
    end
    end
    
    % create figure
    close;
    f1 = figure('Visible','off');
    axes1 = axes('Parent',f1,'Box','off','FontSize',10);
    hold on;
    ebar1 = errorbar(X,Y,E,'LineStyle','none','Marker','o','MarkerSize',6);
    for ei = 1:size(X,1) 
        c = color(ei,:);
        set(ebar1(ei),'Color',c,'DisplayName',colvaru{ei})
    end
    set(axes1,'XTick',X(:,1),'XTickLabel',rowvaru);
    ylabel(msr);
    xlim([-0.05 X(end)+0.01])
    lg1 = legend('show',colvaru);
    set(lg1,'EdgeColor','none','Location','northeastoutside')
    title(sname);
    % save fig
    savename = sprintf('%s %s',msr,sname);
    printfig(savename,pSave,'closefig',1,'w',3,'h',3)
    
end
end


%% MULTI-FACTORIAL ANOVA: STRAIN X PREDOSE X POSTDOSE (N=PLATES)
msrlist = {'speed','curve'};
strainu = unique(S.strain);

for msri = 1:numel(msrlist)
    % get measure name
    msr = msrlist{msri};
    % current data
    Y = S.(msr);
    % multi-factorial anova
    gvarnames = {'strain','predose','postdose'};
    G = {S.strain, S.predose, S.postdose};
    anovan_std(Y,G,gvarnames,pSave, msrlist{msri},'export','text');
    
    %% within strain effect
    for si = 1:numel(strainu)
        strainame = strainu{si};
        i = ismember(S.strain,strainame);
        Y1 = Y(i);
        G1 = {S.predose(i), S.postdose(i)};
        gvarnames = {'predose','postdose'};
        anovan_std(Y1,G1,gvarnames, pSave, msrlist{msri},'suffix',strainu{si},'export','text');
    end
end

%% CALCULATE EXP MEAN
% mean per experiment
D = MWTSet.Data_Plate;
D = innerjoin(MWTSet.Info.MWTDB,D,'Keys','mwtid');
% create exp-groupname combo
a = [D.expname D.groupname_short];
b = cell(size(a,1),1);
for x = 1:size(a,1)
    b{x} = strjoin(a(x,:),' x ');
end
D.expXgname = b;


% find means by exp
msrlist= {'speed','curve'};
grp = D.expXgname;
gnameu = unique(grp); 
% make header
grpheader = table;  
grpheader.expXgname = gnameu;
a = regexpcellout(gnameu,' x ','split');
grpheader.expname = a(:,1);
a = a(:,2);
a = regexpcellout(a,' ','split');
grpheader.strain = a(:,1);
grpheader.predose = a(:,2);
grpheader.postdose = a(:,3);
% declare struct array
A = struct;
for msri = 1:numel(msrlist)
    T = grpstatsTable(D.(msrlist{msri}),grp,'grpheader',grpheader,'gnameu',gnameu);
%     filename = sprintf('%s/%s by exp.csv',pSave,msrlist{msri});
%     writetable(T,filename)
    A.(msrlist{msri}) = T;
end
MWTSet.Data_Exp = A;


%% INDEX
% calculate rapid tolerance index
% group name translation: specific for rapid tolerance
MWTDB = MWTSet.Info.MWTDB;
MWTDB = parseToleranceName(MWTDB);
D = MWTSet.Data_Plate;
D = innerjoin(MWTSet.Info.MWTDB,D,'Keys','mwtid');

msrlist = {'speed','curve'};
fid1 = fopen(sprintf('%s/Effect Ind.txt',pSave),'w');
TAll = table;
TAllExp = table;
posthocname = 'bonferroni';
pv = 0.05;

for msri = 1:numel(msrlist)
    %% add
    fprintf(fid1,'-- %s --\n',msrlist{msri});
    
    %% get exp mean
    EM = MWTSet.Data_Exp.(msrlist{msri});
    %% get 0mM-0mM control per exp mean
    a = EM((ismember(EM.predose,'0mM') & ismember(EM.postdose,'0mM')),:);
    % create table
    RefT = table;
    RefT.group = strjoinrows([a.expname a.strain]);
    s = regexpcellout(RefT.group,' ','split');
    RefT.strain = s(:,2);
    RefT.a = a.mean;
    
    %% calculate tolerance
    % get 0mM 200mM exp mean
    c = EM((ismember(EM.predose,'0mM') & ismember(EM.postdose,'200mM')),:);
    % get control groups
    t = table; 
    t.group = strjoinrows([c.expname c.strain]);
    t.c = c.mean;
    RefT = innerjoin(RefT,t);
    % calculate A = c-a
    RefT.A = RefT.c - RefT.a;
    
    %% get 200mM 200mM data
    d = D(ismember(D.postdose,'200mM') & ismember(D.predose,'200mM'),:);
    t = table;
    t.group = strjoinrows([d.expname d.strain]);
    t.plate = d.mwtname;
    t.strain = d.strain;
    t.d = d.(msrlist{msri});
    DT = innerjoin(t,RefT);
    % calculate tolerance
    DT.B = DT.d-DT.a;
    DT.TI = (DT.A-DT.B)./DT.A;
    writetable(DT,sprintf('%s/%s TI raw.csv',pSave,msrlist{msri}));
    
    
    %% calculate Withdrawal
    % determine k
    i = ismember(RefT.strain,'N2');
    m = RefT.c(i) > RefT.a(i);
    if sum(m) == sum(i)
        k = -1;
    elseif sum(~m) == sum(i)
        k = 1;
    else
        error('effect direction unstable in N2');
    end
    % get 200-0mM data
    d = D(ismember(D.postdose,'0mM') & ismember(D.predose,'200mM'),:);
    t = table;
    t.group = strjoinrows([d.expname d.strain]);
    t.plate = d.mwtname;
    t.strain = d.strain;
    t.b = d.(msrlist{msri});
    DW = innerjoin(t,RefT);
    % calculate withdrawal
    DW.WI = ((DW.b- DW.a)./DW.a).*k;
    writetable(DT,sprintf('%s/%s WI raw.csv',pSave,msrlist{msri}));

    
    %% N= plates
    fprintf(fid1,'N(plates)\n');
    % tolerance
    T = grpstatsTable(DT.TI, DT.strain);
    i = ismember(T.gnameu,'N2');
    T = T([find(i) find(~i)],:);
    T1 = table;
    T1.Index = repmat({'TI'},size(T,1),1);
    T1 = [T1 T];
    [atextTI,phtextTI] = anova1_std(DT.TI,DT.strain);
    % anova
    fprintf(fid1,'Tolerance Index:\nANOVA(strain): %s\n',atextTI);
    fprintf(fid1,'posthoc(%s) a=%.2f\n',posthocname,pv);
    fprintf(fid1,'%s\n',phtextTI);
    % t test
    fprintf(fid1,'t test(right tail)\n');
    gnu = unique(DT.strain);
    gnu = [gnu(ismember(gnu,'N2')) gnu(~ismember(gnu,'N2'))];
    for gi = 1:numel(gnu)
        d = DT.TI(ismember(DT.strain,gnu(gi)));
        [h,p,~,STATS] = ttest(d,0,'tail','right');
        str = statTxtReport('t',STATS.df,STATS.tstat,p);
        fprintf(fid1,'%s, %s\n',gnu{gi},str);
    end    
    fprintf(fid1,'\n');

    
    %% withdrawal
    T = grpstatsTable(DW.WI, DW.strain);
    i = ismember(T.gnameu,'N2');
    T = T([find(i) find(~i)],:);
    T2 = table;
    T2.Index = repmat({'WI'},size(T,1),1);
    T2 = [T2 T];
    T3 = [T1;T2];
    [atextWI,phtextWI] = anova1_std(DW.WI,DW.strain);
    % export anova
    fprintf(fid1,'Withdrawal Index:\nANOVA(strain): %s\n',atextWI);
    fprintf(fid1,'posthoc(%s) a=%.2f\n',posthocname,pv);
    fprintf(fid1,'%s\n',phtextWI);
    % t test
    fprintf(fid1,'t test(right tail)\n');
    gnu = unique(DW.strain);
    gnu = [gnu(ismember(gnu,'N2')) gnu(~ismember(gnu,'N2'))];
    for gi = 1:numel(gnu)
        d = DW.WI(ismember(DW.strain,gnu(gi)));
        [h,p,~,STATS] = ttest(d,0,'tail','right');
        str = statTxtReport('t',STATS.df,STATS.tstat,p);
        fprintf(fid1,'%s, %s\n',gnu{gi},str);
    end 
    fprintf(fid1,'\n');

    % add to all table
    T = table;
    T.msr = repmat(msrlist(msri),size(T3,1),1);
    T3 = [T T3];
    TAll = [TAll;T3];

    
    
    %% N=exp
    fprintf(fid1,'N(exp)\n');
    % calculate stats summary
    T = grpstatsTable(DT.TI, DT.group);
    a = regexpcellout(T.gnameu,' ','split');
    T.strain = a(:,2);
    [atextTI,phtextTI] = anova1_std(T.mean, T.strain);
    % export anova
    fprintf(fid1,'Tolerance Index:\nANOVA(strain): %s\n',atextTI);
    fprintf(fid1,'posthoc(%s) a=%.2f\n',posthocname,pv);
    fprintf(fid1,'%s\n',phtextTI);
    % t test
    fprintf(fid1,'t test(right tail)\n');
    gnu = unique(T.strain);
    gnu = [gnu(ismember(gnu,'N2')) gnu(~ismember(gnu,'N2'))];
    for gi = 1:numel(gnu)
        d = T.mean(ismember(T.strain,gnu(gi)));
        [h,p,~,STATS] = ttest(d,0,'tail','right');
        str = statTxtReport('t',STATS.df,STATS.tstat,p);
        fprintf(fid1,'%s, %s\n',gnu{gi},str);
    end 
    fprintf(fid1,'\n');
    % table
    T = grpstatsTable(T.mean, T.strain);
    T.Properties.VariableNames(ismember(T.Properties.VariableNames,'gnameu')) = {'strain'};
    i = ismember(T.strain,'N2');
    T = T([find(i) find(~i)],:);
    T1 = table;
    T1.Index = repmat({'TI'},size(T,1),1);
    T1 = [T1 T];
        
    % withdrawal
    T = grpstatsTable(DW.WI, DW.group);
    a = regexpcellout(T.gnameu,' ','split');
    T.strain = a(:,2);
    [atextWI,phtextWI] = anova1_std(T.mean, T.strain);

    fprintf(fid1,'Withdrawal Index:\nANOVA(strain): %s\n',atextWI);
    fprintf(fid1,'posthoc(%s) a=%.2f\n',posthocname,pv);
    fprintf(fid1,'%s\n',phtextWI);
     % t test
    fprintf(fid1,'t test(right tail)\n');
    gnu = unique(T.strain);
    gnu = [gnu(ismember(gnu,'N2')) gnu(~ismember(gnu,'N2'))];
    for gi = 1:numel(gnu)
        d = T.mean(ismember(T.strain,gnu(gi)));
        [h,p,~,STATS] = ttest(d,0,'tail','right');
        str = statTxtReport('t',STATS.df,STATS.tstat,p);
        fprintf(fid1,'%s, %s\n',gnu{gi},str);
    end 
    fprintf(fid1,'\n');

    % table
    T = grpstatsTable(T.mean, T.strain);
    T.Properties.VariableNames(ismember(T.Properties.VariableNames,'gnameu')) = {'strain'};
    i = ismember(T.strain,'N2');
    T = T([find(i) find(~i)],:);
    T2 = table;
    T2.Index = repmat({'WI'},size(T,1),1);
    T2 = [T2 T];
    T3 = [T1;T2];
    % add to all table
    T = table;
    T.msr = repmat(msrlist(msri),size(T3,1),1);
    T3 = [T T3];
    TAllExp = [TAllExp;T3];
    
end

fclose(fid1);
cd(pSave);
writetable(TAll,'Effect Index N plate.csv');
writetable(TAllExp,'Effect Index N Exp.csv');


%% Export
% MWT output info sheet
a = MWTSet.Info.MWTDB;
writetable(a,sprintf('%s/info.csv',pSave));
% save MWTSet
cd(pSave);
save(mfilename,'MWTSet');

%% FINISH
fprintf('*** completed ***\n');
return








function MWTSet = Dance_RapidTolerance(pMWT,varargin)
%% Dance_DrunkMoves_RapidTolerance
% updated: 201603270930

%% DEFAULTS ---------------------------------------------------------------
fprintf('\n** Running %s **\n',mfilename);
pSave = '/Users/connylin/Dropbox/RL/Dance Output';
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
% copyfile([mfilename('fullpath'),'.m'], [pSave,'/',mfilename,'_a',generatetimestamp,'.m']);


%% PREPARE ----------------------------------------------------------------
% CHOR
[Legend,pMWTc,~,~,pfailed] = chormaster4('DrunkPostureOnly',pMWT); 

% get legend
Legend = Legend{1}{2,ismember(Legend{1}(1,:),'drunkposture2')};

% only pMWT with chor can be analyzed
if isempty(pMWTc)==false
   warning('these mwt files do not have chor');
   a = parseMWTinfo(pfailed);
   disp(char(a.mwtname))
end

% update MWTDB
pMWTv = pMWT(~ismember(pMWT,pfailed));
MWTDB = parseMWTinfo(pMWTv);

% import
[Data,~,Legend2] = import_drunkposture2_dat(pMWTv,'array');
if numel(pMWTv) ~=numel(Data); error('import number incorrect'); end
Data = array2table(cell2mat(Data),'VariableNames',Legend2);

% remove data outside of assay time
Data(Data.time < timeStartSet | Data.time > timeEndSet,:) = [];

% group name translation: specific for rapid tolerance
gnn = MWTDB.groupname;
strain = MWTDB.strain;
expr = '\d+(?=mM)';
a = regexp(gnn,expr,'match');
a = celltakeout(a);
c = cell(size(gnn,1),1);
b = c;
predose = c;
postdose = predose;
for x = 1:size(a,1)
   predose{x} = [a{x,1},'mM'];
   postdose{x} = [a{x,2},'mM'];
   c(x) = {[strjoin(a(x,:),'mM '),'mM']};
   b{x} = [strain{x},' ' c{x}];
end
MWTDB.groupname_short = b;
MWTDB.condition_short = c;
MWTDB.predose = predose;
MWTDB.postdose = postdose;

% store in MWTSet
MWTSet.Import.drunkposture2 = Data;
MWTSet.Info.MWTDB = MWTDB;
MWTSet.Info.legend.drunkposture2 = Legend2;

% clear memory
clear gnn s a b c strain expr e i


%% CALCULATE --------------------------------------------------------------
%% CAL: MEAN 
% Legend2 = MWTSet.Info.legend.drunkposture2;
% Data = MWTSet.Import.drunkposture2 ;
% pMWTv = MWTSet.Info.MWTDB.mwtpath;
% MWTDB = MWTSet.Info.MWTDB;
% if numel(pMWTv) ~= size(MWTDB,1)
%    error('something wrong with database'); 
% end
msr = Legend2(2:end);
x = Data.(Legend2{1});
% set up output
A = nan(numel(pMWTv),numel(Legend2));
A(:,1) = (1:numel(pMWTv));
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
    anovan_std(Y,G,gvarnames,pSave, msrlist{msri});
    
    %% within strain effect
    for si = 1:numel(strainu)
        strainame = strainu{si};
        i = ismember(S.strain,strainame);
        Y1 = Y(i);
        G1 = {S.predose(i), S.postdose(i)};
        gvarnames = {'predose','postdose'};
        anovan_std(Y1,G1,gvarnames, pSave, msrlist{msri},'suffix',strainu{si});
    end
end


%% PERCENT CHANGE WITHDRAWAL AND TOLERANCE
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
    filename = sprintf('%s/%s by exp.csv',pSave,msrlist{msri});
    writetable(T,filename)
    A.(msrlist{msri}) = T;
end
MWTSet.Data_Exp = A;



% divide individual plats by predose control
% make header
gnameu = unique(D.groupname_short);
grpheader = table;  
a = regexpcellout(gnameu,' ','split');
grpheader.strains = a(:,1);
grpheader.predose = a(:,2);
grpheader.postdose = a(:,3);
for msri = 1:numel(msrlist)
    %% create reference
    Ref = MWTSet.Data_Exp.(msrlist{msri});
    % delete postdose not 0mM control
    Ref(~ismember(Ref.predose,'0mM'),:) = [];
    % join cell strings
    Refg = strjoinrows([Ref.expname Ref.strain Ref.postdose]);
    % get group values
    g = strjoinrows([D.expname D.strain D.postdose]);
    % get reference values
    [i,j] = ismember(g, Refg);
    r = nan(size(g));
    r(i) = Ref.mean(j(i));   
    % calculate precent control
    d = pct_diff(D.(msrlist{msri}),r);
    
    % calculate within group
    g = D.groupname_short;
    % descriptive
    T = grpstatsTable(d, g,'grpheader',grpheader,'gnameu',gnameu);
    writetable(T,sprintf('%s/%s pct.csv',pSave,msrlist{msri}))
    A.(msrlist{msri}) = T;
    
    %% reorganize for graphing
    strainsu = unique(T.strains);
%     doseu = unique(T.predose);
    varnames = {'mean','se','n'};
    i = regexpcellout(strainsu,'N2');
    strainsu = [strainsu(i) strainsu(~i)]';
    R = table;
    R.comp = {'tolerance';'withdrawal'};
    R.Properties.RowNames = {'tolerance';'withdrawal'};
    for vi = 1:numel(varnames)
    for si = 1:numel(strainsu)
        if strcmp(varnames{vi},'mean')==0
            vn = [strainsu{si},'_',varnames{vi}];
        else
            vn = strainsu{si};
        end
        sn = strainsu{si};
        R.(vn) = nan(2,1);
        i = ismember(T.strains,sn) &...
            ismember(T.predose,'200mM') & ismember(T.postdose,'200mM');
        if sum(i) ==1
            R.(vn)('tolerance') = T.(varnames{vi})(i);
        end
        i = ismember(T.strains,sn) &...
            ismember(T.predose,'200mM') & ismember(T.postdose,'0mM');
        if sum(i)==1
            R.(vn)('withdrawal') = T.(varnames{vi})(i);
        end
    end
    end
    writetable(R,sprintf('%s/%s pct graph.csv',pSave,msrlist{msri}));

    %% ANOVA
    i = ~ismember(D.predose,'0mM');
    y = d(i);
    % deal with N=1
    a = tabulate(D.postdose(i));
    if sum(cell2mat(a(:,2)) ==1) ~= size(a,1)
        G = {D.strain(i), D.postdose(i)};
        anovan_std(y,G,{'strain','postdose'},pSave,[msrlist{msri},' pct']);
        %% T TEST FROM 0%
        strain = G{1};
        strainu = unique(strain);
        postdose = G{2};
        pdoseu = unique(postdose);
        filename = sprintf('%s pct ttest.txt',msrlist{msri});
        fid = fopen(filename,'w');
        fprintf(fid,'t test %s\n',msrlist{msri});

        for si = 1:numel(strainu)
        for pdi = 1:numel(pdoseu)
            sn = strainu{si};
            pdn = pdoseu{pdi};
            y1 = y(ismember(postdose,pdn) & ismember(strain,sn));
            % t test
            [~,p,~,st] = ttest(y1,0);
            fprintf(fid,'%s(%s): t(%d)=%.3f, %s\n',sn, pdn,st.df, st.tstat,print_pvalue(p,0.001));
        end
        end
        fclose(fid);
    end
    
   
    
    %% if more than one strain
    if numel(unique(D.strain)) > 1
        %% ANOVA: Tolerance (postdose = 200mM)
        i = ~ismember(D.predose,'0mM') & ~ismember(D.postdose,'0mM');
        y = d(i);
        G = {D.strain(i)};
        anovan_std(y,G,{'strain'},pSave,[msrlist{msri},' pct tolerance']);

        %% ANOVA: Withdrawal (postdose = 0mM)
        i = ~ismember(D.predose,'0mM') & ismember(D.postdose,'0mM');
        y = d(i);
        G = {D.strain(i)};
        anovan_std(y,G,{'strain'},pSave,[msrlist{msri},' pct withdrawal']);
    end
    
end




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



















%% TRANSFORM DATA FOR GRAPH: CURVE
% prepare data for graphing
gnameR = MWTSet.Info.VarIndex.groupname;
% reorg table into graph
S = MWTSet.Data_GroupByPlate;
msr = fieldnames(S);
A = struct;
for msri = 1:numel(msr) 
    msr = msr{msri};
    D = S.(msr);
    gnameU = unique(D.groupname)';
    tN = unique(D.timeind);
    K = struct;
    K.groupname = gnameR(gnameU);
    K.N = nan(size(gnameU));
    B = nan(numel(tN),numel(gnameU));
    K.timeind = B;
    K.mean = B;
    K.SE = B;
    for gi = 1:numel(gnameU)
        d = D(D.groupname == gnameU(gi),:);
        K.N(gi) = mean(d.N);
        K.timeind(d.timeind,gi) = d.timeind;
        K.mean(d.timeind,gi) = d.mean;
        K.SE(d.timeind,gi) = d.SE;
    end
    A.(msr) = K;
end
MWTSet.Graph.Curve = A;
%% GRAPH: CURVE - INDIVIDUAL
pSaveA = [pSave,'/Graph Curve']; if isdir(pSaveA) == 0; mkdir(pSaveA); end
G = MWTSet.Graph.Curve;
msr = fieldnames(G);
for mi = 1:numel(msr)
    msr = msr{mi};
    X = G.(msr).timeind;
    Y = G.(msr).mean;
    E = G.(msr).SE;
    gname = MWTSet.Graph.Curve.(msr).groupname;
    color = [0 0 0;1 0 0;[0.04 0.52 0.78];[0.478 0.0627 0.8941]]; 
    PlateN = MWTSet.Graph.Curve.(msr).N;
    titlestr = gen_Nstring(PlateN);
    figure1 = Graph_errorbar(X,Y,E,gname,color,...
        'titlestr',titlestr,'xname','time(min)','yname',msr,'visiblesetting','off');
    savefigepsOnly150(sprintf('%s',msr),pSaveA)
end
%% GRAPH: CURVE - COMPOSITE
fprintf('Generating composite graph\n');
pSaveA = pSave;
G = MWTSet.Graph.Curve;
msr = {'number' 'goodnumber' 'speed' 'bias',...
    'midline' 'area' 'width' 'morphwidth',...
    'length' 'aspect' 'kink' 'curve'};
nM = numel(msr);
nMs = sqrt(nM);
nGY = floor(nMs);
nGX = ceil(nMs);
gname = MWTSet.Graph.Curve.(msr).groupname;
color = [0 0 0;1 0 0;[0.04 0.52 0.78];[0.478 0.0627 0.8941]]; 
PlateN = MWTSet.Graph.Curve.(msr).N;
titlestr = gen_Nstring(PlateN);
xname = 'time(min)';
% make figure
figure1 = figure('Color',[1 1 1],'Visible','off');

for mi = 1:numel(msr)
    msr = msr{mi};
    X = G.(msr).timeind;
    Y = G.(msr).mean;
    E = G.(msr).SE;
    % Create subplot
    subplot1 = subplot(nGY,nGX,mi,'Parent',figure1,'XTick',0:10:max(max(X)),...
        'FontSize',8);
    xmax = max(max(X));
    xlim(subplot1,[0 xmax+1]);
    % ylim(subplot1,[0 150]);
    hold(subplot1,'all');
    errorbar1 = errorbar(X,Y,E);
    if size(color,1) > size(Y,2)
        colorn = size(Y,2);
    else
        colorn = size(color,1);
    end
    for x = 1:colorn
        set(errorbar1(x),'Color',color(x,1:3))
    end
    for x = 1:size(Y,2)
        set(errorbar1(x),'DisplayName',regexprep(gname{x},'_',' '))
    end
    title(msr);
    % put x lable at the bottom row only
    if mi > nGX*((nGY)-1)
        xlabel(xname,'FontSize',8); % Create xlabel
    end
    % ylabel(msr); % Create ylabel
    % legend
    if mi == 1
        legend1 = legend(subplot1,'show');
        set(legend1,'EdgeColor',[1 1 1],...
            'Position',[0.02 0.88 0.025 0.08],...
            'YColor',[1 1 1],'XColor',[1 1 1],'FontSize',6); 
    end
end
% Create textbox
annotation(figure1,'textbox',...
    [0.01 0.99 0.33 0.018],...
    'FitBoxToText','off','String',titlestr,...
    'LineStyle','none','FontSize',8);
savefigepsOnly150('Curve composit',pSaveA)
%% STATS: LAST 5MINS RESPONSE - SPECIFIC FOR RAPID TOLERANCE
% create save folder
pSaveA = sprintf('%s/Stats %dmin mark',pSave,responseAssayTime/60);
if isdir(pSaveA) == 0; mkdir(pSaveA); end
% posthoc stats type
posthocname = 'bonferroni';
condName = MWTSet.Info.VarIndex.condition_short;
groupName = MWTSet.Info.VarIndex.groupname_short;
% separate into pre and post dose
g = MWTSet.Info.VarIndex.groupname;
a = regexpcellout(g,'\d+(?=mM)','match');
for x = 1:numel(a) % add mM behind 
    a(x) = strcat(a(x),{'mM'});
end
predoseName = a(:,1);
postdoseName = a(:,2);
% graph settings
color = [0 0 0; 1 0 0; [0.04 0.52 0.78]; [0.47843137383461 0.062745101749897 0.894117653369904]]; 
condSeq = {'0mM 0mM' '0mM 200mM' '200mM 0mM' '200mM 200mM'};

% stats
A = struct;
for mi = 1:numel(responseAssayMsr)
    msr = responseAssayMsr{mi};
    D = MWTSet.Data_Plate.(msr);
    t1 = (responseAssayTime - timeIntSet);
    D = D(D.assaytimeStart >= t1,:);
    D = sortrows(D,{'groupname'});
    % separate exposure condition 
    % this is dependent on the group names stay the same
    cond = MWTSet.Info.VarIndex.condition(D.condition);
    exposuredose = regexpcellout(cond,'(?<=E3d24h)\d+','match');
    testdose = regexpcellout(cond,'(?<=T4d)\d+','match');
    
    % stats for only one strain
    if numel(unique(D.strain)) == 0
        error('analysis can not accomodate multiple strains');
    else
        % multi-factorial anova
        G = {exposuredose,testdose};
        Y = D.mean;
        [~,t,~] = anovan(Y,G,'varnames',{'prexposure','testdose'},'model','full','display','off');
        [r,T] = anovan_textresult(t); 
        % export anovan text output
        fid = fopen(sprintf('%s/%s MANOVA.txt',pSaveA,msr),'w');
        fprintf(fid,'Multifactorial ANOVA\n');
        for x = 1:numel(r); fprintf(fid,'%s\n',r{x}); end
        fclose(fid);
        MWTSet.Graph.(msr).ANOVA = T;
        MWTSet.Graph.(msr).ANOVA_type = 'MANOVA';
        MWTSet.Graph.(msr).ANOVA_string = r;
        
        % find pair wise comparison statistics
        G = groupName(D.groupname);
        [~,~,stats] = anova1(Y,G,'off');
        % 0.05
        pv = 0.05;
        [c,~,~,gnames] = multcompare(stats,'ctype',posthocname,'display','off','alpha',pv);
        [T,r,TC,t] = multcompare_pairinterpretation(c,gnames,'nsshow',1,'pvalue',pv);
        writetable(TC,sprintf('%s/%s posthoc %s.csv',pSaveA,msr,posthocname),'Delimiter',',');
        fid = fopen(sprintf('%s/%s posthoc %s.txt',pSaveA,msr,posthocname),'w');
        for x = 1:numel(r); fprintf(fid,'%s\n',r{x}); end
        fclose(fid);
        MWTSet.Graph.(msr).posthoc = T;
        MWTSet.Graph.(msr).posthoc_type = posthocname;
        MWTSet.Graph.(msr).posthoc_string = r;
    end
    
    % cal descriptive stats for output
    [n,mn,se,gn] = grpstats(D.mean,groupName(D.groupname),{'numel','mean','sem','gname'});

    %% csv output (specific to rapid tolerance)
    % get pre and post exposure 
    nrow = unique(postdoseName);
    ncol = unique(predoseName);
    a = nan(numel(nrow)+2, numel(ncol)*3);
    for icol = 1:numel(ncol)
        for irow = 1:numel(nrow)
            i = ismember(predoseName,ncol(icol)) & ismember(postdoseName,nrow(irow));
            a(irow,icol) = mn(i);
            a(irow,icol+numel(ncol)) = se(i);
            a(irow,icol+(numel(ncol)*2)) = n(i);
        end
    end
    % calculate dose effect if there are only two conditions
    if numel(nrow) == 2
       a(3,1) = a(2,1) - a(1,1); % i.e. 200mM - 0mM test dose, naive group
       a(3,2) = a(2,2) - a(1,2); % i.e. 200mM - 0mM test dose, exposed group
       a(4,1) = a(3,1) - a(3,2); % naive group dose effect - exposed group
       a(4,2) = a(3,2) - a(3,1); % exposed group dose effect - test group
    end
    % create col names
    s = ncol';
    for x = 1:numel(s)
        s{x} = strjoin([{'Mean'},s(x)],'_');
    end
    b = s;
    s = ncol';
    for x = 1:numel(s)
        s{x} = strjoin([{'SE'},s(x)],'_');
    end    
    b = [b s];
    s = ncol';
    for x = 1:numel(s)
        s{x} = strjoin([{'N'},s(x)],'_');
    end  
    b = [b s];
    % table 
    t = array2table(a,'VariableNames',b);
    % create row names
    rowNames = [unique(postdoseName); {'test dose effect';'test dose effect diff'}];
    T = table;
    T.(msr) = rowNames;
    T = [T t];
    writetable(T,sprintf('%s/%s.csv',pSaveA,msr));
    
    
    %% (suspend) graph - bar
%     A = MWTSet.Graph.Curve.(msr);
%     Y = mn;
%     E = se;
%     figure1 = figure('visible','off');
%     axes1 = axes('Parent',figure1,'FontSize',18);
%     box(axes1,'off');
%     bar1 = barwitherr(E,Y);
%     set(gca,'XTickLabel',gn,'FontSize',12)
%     set(bar1,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none');
%     hold all
%     ylabel(msr,'FontSize',20);
%     str = gen_Nstring(MWTSet.Graph.Curve.(msr).N);
%     str = strjoin([cellstr(str) A.ANOVA_string'],', ');
%     title(str,'FontSize',6);
%     savefigepsOnly150(sprintf('%s bar graph',msr),pSaveA);
    
    %% graph - stats combine (coding...)
    % separate pre and post dose
%     a = regexpcellout(gn,' ','split');
%     strain = a(:,1);
%     predose = a(:,2);
%     postdose = a(:,3);
%     if numel(unique(strain)) > 1
%         error('can not accomodate multiple strains');
%     else
% 
%         for x = 1:2
%             i = ismember(condName,condSeq{x});
%             c = color(x,1:3);
%             errorbar(1,mn(i),se(i),'LineStyle','none','Color',c,...
%                     'MarkerFaceColor',c,...
%                     'MarkerEdgeColor',c,...
%                     'Marker','o');
%             hold on
%         end
%         for x = 3:4
%             i = ismember(condName,condSeq{x});
%             c = color(x,1:3);
% 
%             errorbar(2,mn(i),se(i),'LineStyle','none','Color',c,...
%                     'MarkerFaceColor',c,...
%                     'MarkerEdgeColor',c,...
%                     'Marker','o');
%             hold on
%         end
% 


%     end

end










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
load(fullfile(pD,'MWTDB.mat'),'MWTDB');
pMWTS = MWTDB.mwtpath;
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Chor Gangnam ============================================================
% find existing gangnam
[~,~,pMWTmiss] = getpath2chorfile(pMWTS,'Gangnam.mat');
% chor plates without gangnam
[~,~,pMWTS] = getpath2chorfile(pMWTmiss,'*.gangnam.*.dat');
[Legend,pMWTcS,fval,chorscript] = chormaster4('Gangnam',pMWTS);
legend_gangnam = Legend{1}{2};
inputname = Legend{1}{1};
% convert gangnam into .mat
convertchorNall2mat(pMWTS,inputname,'Gangnam');
% check if mwt plates have gangnam 
pMat = getpath2chorfile(MWTDB.mwtpath,'Gangnam.mat');
% reconstruct MWT database
MWTDB_Mat = parseMWTinfo(cellfun(@fileparts,pMat,'UniformOutput',0));
% -----------------------------------------------------
% =========================================================================



%% SPEED, CURVE, MIDLINE data ===========================================

% settings: time +++++++
startTime = 10; 
endTime = 99;
timeint = 1;
timestartlist = [startTime:timeint:endTime];
% ----------------------

% declare input arrays +++++++++
nMWT = numel(pMat);
sampleSize = nan(nMWT,1);
DATA = cell(nMWT,1);
PMWT = DATA;
WRMID = DATA;
% -----------------------------

T_allplates = table;

for mwti = 1:nMWT
    
    % report progress ++++++++++++++++++++
    processIntervalReporter(nMWT,20,'MWT',mwti);
    % -----------------------------------
    
    % get cycle specific info +++++++++
    pmat = pMat{mwti};
    pmwt = fileparts(pmat);
    % ---------------------------------
    
    % load data ++++++++++++++++
    D = load(pmat);
    i = D.time(:,1) <= startTime & D.time(:,2) >= endTime;
    files = D.Data(i);
    % ---------------------------
    
    % get sample size +++++++++++++
    n = numel(files);
    sampleSize(mwti) = n;
    % ----------------------------
    
    if n>0
        % extract data +++++++++++++
        T_plate = table;
        for wrmi = 1:numel(files)
            % get only needed data ++++++++
            d = files{wrmi};
            [a,legend] = extractChorData(d,legend_gangnam,'varnames',{'id','time','speed','curve'},'outputtype','array');
            a = array2table(a,'VariableNames',legend);
            % ----------------------------
            
            
            % condense into time list +++++++++
            a.timer = round(a.time);
            tu = unique(a.timer);
            tun = numel(tu);
            T = table;
            T.time = tu;
            T.id = repmat(unique(a.id),tun,1);
            
            legendv = {'speed','curve'};
            for si = 1:numel(legendv)
                legname = legendv{si};
                T2 =  statsBasicG(a.(legname), a.timer);
                
                T3 = table;
                T3.time = T2.gname;
                T3.(legname) = T2.mean;
                T = outerjoin(T,T3,'MergeKeys',1,'Type','left');                
            end
            % -----------------------------------
            
            % add to plate table +++++
            T_plate = [T_plate; T];
            % -----------------------
            
        end
        
        
        %% calculate plate stats
        
        
        return
        %%
        
        % create mwt paths for each row ++++++++
        leg = table;
        leg.mwtpath = repmat(pmwt, size(T_plate,1),1);
        % ---------------------------------------
        
        % add to central table +++++++++
        T_allplates = [T_allplates; [leg, T_plate]];
        % ---------------------------

        % store data +++++++++++++
%         sampleSize = nan(nMWT,1);
%         DATA{mwti} = cell(nMWT,1);
%         PMWT{mwti} = repmatpmwt;
%         WRMID = DATA;
%         % ------------------------
        
        
        
        % prepare summary output identifiers ++++++++++
%         db = parseMWTinfo(pmwt);
%         dbname = {'expname','groupname','mwtname'};
%         S(mwti).mwtpath = {pmwt};
%         S(mwti).expname = db.expname;
%         S(mwti).groupname = db.groupname;
%         S(mwti).mwtname =  db.mwtname;
%         S(mwti).wormid = arrayfun(@(x) unique(x.id),A)';
        % --------------------------------------------

        % calculate other outputs ++++++++++++++++++
%         varn = legend(~ismember(legend,'id'));
%         for vi = 1:numel(varn)
%             S(mwti).(varn{vi}) = arrayfun(@(x) nanmean(x.(varn{vi})),A)';
%         end
        % ------------------------------------------
    end
    
    
    
end
% =========================================================================


return
%% SPEED, CURVE, MIDLINE 90-95s ===========================================

% settings: time +++++++
startTime = 10; 
endTime = 99;
% ----------------------

% declare input arrays +++++++++
nMWT = numel(pMat);
sampleSize = nan(nMWT,1);
S = struct;
% -----------------------------

for mwti = 1:nMWT
    
    % report progress ++++++++++++++++++++
    processIntervalReporter(nMWT,20,'MWT',mwti);
    % -----------------------------------
    
    % get cycle specific info +++++++++
    pmat = pMat{mwti};
    pmwt = fileparts(pmat);
    % ---------------------------------
    
    % load data ++++++++++++++++
    D = load(pmat);
    i = D.time(:,1) <= startTime & D.time(:,2) >= endTime;
    files = D.Data(i);
    % ---------------------------
    
    % get sample size +++++++++++++
    n = numel(files);
    sampleSize(mwti) = n;
    % ----------------------------
    
    if n>0
        % extract data +++++++++++++
        A = struct;
        for wrmi = 1:numel(files)
            d = files{wrmi};
            [a,legend] = extractChorData(d,legend_gangnam,'varnames',{'id','speed','midline','curve'},'outputtype','array');
            for si = 1:numel(legend)
                A(wrmi).(legend{si}) = a(:,si);
            end
        end
        % ---------------------------

        % prepare summary output identifiers ++++++++++
        db = parseMWTinfo(pmwt);
        dbname = {'expname','groupname','mwtname'};
        S(mwti).mwtpath = {pmwt};
        S(mwti).expname = db.expname;
        S(mwti).groupname = db.groupname;
        S(mwti).mwtname =  db.mwtname;
        S(mwti).wormid = arrayfun(@(x) unique(x.id),A)';
        % --------------------------------------------

        % calculate other outputs ++++++++++++++++++
        varn = legend(~ismember(legend,'id'));
        for vi = 1:numel(varn)
            S(mwti).(varn{vi}) = arrayfun(@(x) nanmean(x.(varn{vi})),A)';
        end
        % ------------------------------------------
    end
    
end
% =========================================================================


%% 


%%

%% prepare summary ========================================================
% set variable names +++++++++++++++++++
identifiers = {'expname', 'groupname', 'mwtname','mwtpath'};
vnames = fieldnames(S);
varn = vnames(~ismember(vnames,identifiers));
measurename = varn(~ismember(varn,'wormid'));
% ------------------------------------------

n = arrayfun(@(x) numel(x.wormid),S);
nrow = sum(n);
rowi = [0 cumsum(n)];

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

% calculate speed/midline
Data.speed_midline = Data.speed./Data.midline;
% =========================================================================



%% stats and graph: speed ++++++++++++++++++++++++++++++++++++++
close all;
vnames = Data.Properties.VariableNames;
measurename = vnames(~ismember(vnames,{'wormid','expname', 'groupname', 'mwtname','mwtpath'}));
gname = Data.groupname;
a = Data.groupname; a(ismember(a,'N2')) = {'0mM'}; a = regexprep(a,'(N2_)|(mM)','');
gnamelabel = a;
    
for vi = 1:numel(measurename)
    msr = measurename{vi};
    savename = sprintf('%s x dose bar scatter',msr);
    fprintf('\n%s\n',savename);
    % calculate weighted group stats
    X = Data.(msr);
    yname = regexprep(msr,'_',' ');
    B = table;
    [B.groupname,B.N,B.mean,B.SD,B.SE] = grpstats(X,gname,{'gname','numel','mean','std','sem'});
    disp(B)
    cd(pSave); writetable(B,savename);

    % graph cluster dots
    close all
    clusterDotsErrorbar(X,gnamelabel,'xname','mM','yname',yname,'visible','on');
    savefigeps(savename,pSave);

end

% export 
cd(pSave);
save('data.mat','Data');
% -----------------------------------------------------



%% calculate % to control +++++++++++++++++++++++++++
% get control
i = ismember(Data.groupname,'N2');
DataCtrl = Data(i,:);
DataExp = Data(~i,:);

% create control reference
vnames = DataCtrl.Properties.VariableNames;
measurename = vnames(~ismember(vnames,{'wormid','expname', 'groupname', 'mwtname','mwtpath'}));
gname = DataCtrl.expname;
B = table;
B.expname = unique(DataCtrl.expname);
R = nan(size(B,1),numel(measurename));
for vi = 1:numel(measurename)
    msr = measurename{vi};
    X = DataCtrl.(msr);
    A = table;
    [A.(msr),A.expname] = grpstats(X,gname,{'mean','gname'});
    B =  innerjoin(B,A);
end
% accomodate for missing N2 values
expname_exp = unique(DataExp.expname);
expname_missing = expname_exp(~ismember(expname_exp,B.expname));
b = B(1:2,2:end);
vn = b.Properties.VariableNames;
variable_adpot = mean(table2array(b));
a = repmat(variable_adpot,numel(expname_missing),1);
B1 = table;
B1.expname = expname_missing;
for i = 1:numel(vn)
   B1.(vn{i}) = a(:,i); 
end
B = [B;B1];
CtrlRef = B;

% divided by control
expnameu = unique(DataExp.expname);
A = nan(size(DataExp,1),numel(measurename));
for ei = 1:numel(expnameu)
    en = expnameu{ei};
    i = ismember(DataExp.expname,en);
    j = ismember(B.expname,en);
    nrow = sum(i);
    C = table2array(B(j,2:end));
    C = repmat(C,nrow,1);
    E = table2array(DataExp(i,6:9));
    PCT = ((E-C)./C).*100;
    
    A(i,:) = PCT;
end
% convert
DataExpPCT = DataExp;
A = array2table(A,'VariableNames',measurename);
DataExpPCT(:,6:9) = A;
% -----------------------------------------------------


%% stats and graph: speed +++++++++++++++++++++++++++++++
close all;
vnames = DataExpPCT.Properties.VariableNames;
measurename = vnames(~ismember(vnames,{'wormid','expname', 'groupname', 'mwtname','mwtpath'}));
gname = DataExpPCT.groupname;
a = DataExpPCT.groupname; a(ismember(a,'N2')) = {'0mM'}; a = regexprep(a,'(N2_)|(mM)','');
gnamelabel = a;
    
for vi = 1:numel(measurename)
    msr = measurename{vi};
    savename = sprintf('%s percent x dose bar scatter',msr);
    fprintf('\n%s\n',savename);
    % calculate weighted group stats
    X = DataExpPCT.(msr);
    yname = [regexprep(msr,'_',' '),' % untreated'];
    B = table;
    [B.groupname,B.N,B.mean,B.SD,B.SE] = grpstats(X,gname,{'gname','numel','mean','std','sem'});
    disp(B)
    cd(pSave); writetable(B,savename);

    % graph cluster dots
    close all
    clusterDotsErrorbar(X,gnamelabel,'xname','mM','yname',yname,'visible','on');
    savefigeps(savename,pSave);

end


% export
cd(pSave);
save('data.mat','DataExpPCT','-append');
% -----------------------------------------------------


%% plot two graphs on the same graph, SE = exp +++++++++++++++++
D = DataExpPCT;
vnlist = {'speed','curve'};
for vi = 1:numel(vnlist)
    vn = vnlist{vi};
    x = D.(vn);
    gname = D.groupname;
    expname = D.expname;
    expnameu= unique(expname);
    gne = {};
    ex = [];
    for ei = 1:numel(expnameu)
        en = expnameu{ei};
        i = ismember(expname,en);
        xx = x(i);
        gg = gname(i);
        t = table;
        [gn,newx] = grpstats(xx,gg,{'gname','mean'});
        gne = [gne;gn];
        ex = [ex;newx];    
    end

    T = table;
    [T.groupname,T.N,T.mean,T.SD,T.SE] = grpstats(ex,gne,{'gname','numel','mean','std','sem'});
    cd(pSave); writetable(T,sprintf('descriptive by exp %s.csv',vn));

    % T test from 100% line
    cd(pSave);
    fid = fopen(sprintf('ttest %s.txt',vn),'w');
    fprintf(fid,'t test from 100%%\n');
    gu = unique(gne);
    for gi = 1:numel(gu)
        gn = gu{gi};
        x = ex(ismember(gne,gn));
        [h,p,c,s] = ttest(x,100);
        fprintf(fid,'%s: ttest(%d) = %.4f, p=%.4f\n',gn,s.df,s.tstat,p);
    end
    fclose(fid);

end
% -----------------------------------------------------




%% raw comparison curve and speed +++++++++++++++++++++++
msrlist ={'speed','curve'};
gn = Data.groupname;
mwt = Data.mwtpath;

for mi = 1:numel(msrlist)
    
    msr = msrlist{mi};
    
    x = Data.(msr);
    
    T = statsBasicG(x,mwt);
    mwtdb = parseMWTinfo(T.gname);
    
    T = statsBasicG(T.mean,mwtdb.groupname);
    
    cd(pSave);
    writetable(T,sprintf('descriptive by plate mean %s.csv',msr));
end
% --------------------------------------------------------


%% stats for raw 
msrlist ={'speed','curve'};
gn = Data.groupname;
mwt = Data.mwtpath;

for mi = 1:numel(msrlist)
    
    msr = msrlist{mi};
    
    x = Data.(msr);
    
    T = statsBasicG(x,mwt);
    mwtdb = parseMWTinfo(T.gname);
    
    x = T.mean;
    g =mwtdb.groupname;
    
    dose = repmat({'0mM'},size(g,1),1);
    dose(regexpcellout(g,'400mM')) = {'400mM'};
    food = repmat({'Food'},size(g,1),1);
    food(regexpcellout(g,'NoFood')) = {'NoFood'};
    
    
    [~,t,~,~] = anovan(x,{dose food},'varnames',{'dose','food'},'model','full','display','off');
    [anovatxt,T] = anovan_textresult(t);
    anovatxt = print_cellstring(anovatxt);
    
    [txt] = anova1_multcomp_auto(x,g);
    
    % save text result
    p =fullfile(pSave,sprintf('anova by plate %s.txt',msr));
    fid = fopen(p,'w');
    fprintf(fid,'%s\n\n%s',anovatxt,txt);
    fclose(fid);
    
end

%%











































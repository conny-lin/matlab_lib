%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% GLOBAL INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paths ++++++++++++++
pData_Strain = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
addpath(fullfile(fileparts(pM),'functions'));
pSave = create_savefolder(fullfile(pM,'Tables'));
% --------------------

% settings ++++++
pvsig = 0.05;
pvlim = 0.001;
w = 9;
h = 4;
strainNames = DanceM_load_strainInfo;
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% construct table ++++
T = table;
T.strain = strainNames.strain;
colnames = {'N','wt','mut','d_mut','p','ES'};
T = [T array2table(nan(size(T.strain,1),numel(colnames)), 'VariableNames',colnames)];
T.N = cell(size(T,1), 1);
BC = T;

T = table;
T.strain = strainNames.strain;
colnames = {'df1','df2','p_strain','p_dose','p_strain_dose','p_W0M0','p_W0W4','p_M0M4','p_W4M4'};


T = [T array2table(nan(size(T.strain,1),numel(colnames)), 'VariableNames',colnames)];
Prev = T;
Pacc = T;
% ----------------------

for si = 1:size(strainNames,1);
    
    % get strain +++
    strain = strainNames.strain{si};
    genotype = strainNames.genotype{si};
    processIntervalReporter(size(strainNames,1),1,strain,si);
    % --------------
    
    %% load data =======================================
    %% curve sensitivity +++++++++++++++
    pC = fullfile(pData_Strain,strain,'Etoh sensitivity','InitialEtohSensitivityPct','data.mat');
    DC = load(pC,'DataMeta','MWTDB');
    CS = CurveStats;
    CS.mwtid = DC.DataMeta.mwtid;
    CS.curve = DC.DataMeta.curve;
    CS.MWTDB = DC.MWTDB;
    [anovatxt,T] = anova(CS);
    gn = regexprep(T.gnames,'_400mM','');
    
    a = sortN2first(gn,T.N)';
    a = num2cellstr(a);
    a = strjoin(a,', ');
    BC.N{si} = a;
    
    b = (sortN2first(gn,T.mean).*100)-100;
    BC.wt(si) = b(1);
    BC.mut(si) = b(2);
    
    d = b(2) - b(1);
    BC.d_mut(si) =d;
    
    a = regexp(anovatxt,'(?<=p(<|=))\d{1,}[.]\d{1,}','match');
    a = cellfun(@str2num,a);
    BC.p(si) = a;
    
    A = CS.pctEtohByPlate;
    x1 = A.pct_ctrl(ismember(A.groupname,'N2_400mM'));
    x2 = A.pct_ctrl(ismember(A.groupname,[strain,'_400mM']));
    e = effectsize_cohend(x2,x1);
    BC.ES(si) = e;
    

    
    %%  2/3-rev curve ++++++++++++++++
    p = fullfile(pData_Strain,strain,'TWR/Dance_ShaneSpark4/Dance_ShaneSpark4.mat');
    A = load(p);
    M = A.MWTSet.MWTDB;
    D = A.MWTSet.Raw;
    X1 = D.tap;
    Y1 = D.RevFreq;
    G1 = D.mwtid;
    
    TWR = rmANOVATWR;
    TWR.datapath = fullfile(pData_Strain,strain,'TWR/Dance_ShaneSpark4/RMANOVA.txt');
    ANOVA = TWR.anova;
    
    a = char(ANOVA.F('strain'));
    a = regexp(a,'[,]|[(]|[)]|( = )|( < )','split');
    
    Prev.df1(si) = str2num(a{2});
    Prev.df2(si) = str2num(a{3});
    Prev.p_strain(si) = ANOVA.pvalue('strain');
    Prev.p_dose(si) = ANOVA.pvalue('dose');
    Prev.p_strain_dose(si) = ANOVA.pvalue('strain*dose');
    
    T = TWR.posthoc_groups;
    
    Prev.p_W0M0(si) = T.pvalue(sprintf('N2*%s',strain));
    Prev.p_W0W4(si) = T.pvalue(sprintf('N2*N2_400mM'));
    Prev.p_M0M4(si) = T.pvalue(sprintf('%s*%s_400mM',strain,strain));
    Prev.p_W4M4(si) = T.pvalue(sprintf('N2_400mM*%s_400mM',strain));

    
    %% -------------------------------

    %% acc graph ++++++++++++
    p = fullfile(pData_Strain,strain,'TAR/Dance_rType/data.mat');
    A = load(p);
    D = A.Data;
    M = parseMWTinfo(unique(D.mwtpath));
    [i,j] = ismember(D.mwtpath,M.mwtpath);
    D.mwtid = j;
    
    X1 = D.tap;
    Y1 = D.AccProb;
    G1 = D.mwtid;
    % calculate under the curve for each plate
%     Pacc = calandAddIntegralValue(X1,Y1,G1,Pacc,si);
%     
    nr = numel(unique(X1));
    mwtidu = unique(G1);
    nc = max(mwtidu);
    B = nan(nr,nc);
    i = sub2ind([nr,nc],D.tap,D.mwtid);
    B(i) = Y1;
    X = repmat([1:30]',1,nr);
    A = diff(X);
    y = B(1:end-1,:);
    y2 = diff(B)./2;
    y = y+y2;
    Y = nansum(y);
    D1 = table;
    D1.mwtid = [1:max(mwtidu)]';
    D1.area = Y';
    D1(isnan(Y'),:) = [];
    
    D2 = CurveStats;
    D2.curve = D1.area;
    D2.mwtid = D1.mwtid;
    D2.MWTDB = M;
    [anovatxt,T] = anova(D2);
    
    return
    gn = regexprep(T.gnames,'_400mM','');
    a = sortN2first(gn,T.N)';
    a = num2cellstr(a);
    a = strjoin(a,', ');
    Pacc.N{si} = a;
    
    b = sortN2first(gn,T.mean);
    Pacc.wt(si) = b(1);
    Pacc.mut(si) = b(2);
    
    d = b(2) - b(1);
    Pacc.d_mut(si) =d;
    
    a = regexp(anovatxt,'(?<=p (<|=) )\d{1,}[.]\d{1,}','match');
    a = cellfun(@str2num,a);
    Pacc.p(si) = a;
    
    A = D2.pctEtohByPlate;
    x1 = A.pct_ctrl(ismember(A.groupname,'N2_400mM'));
    x2 = A.pct_ctrl(ismember(A.groupname,[strain,'_400mM']));
    e = effectsize_cohend(x2,x1);
    Pacc.ES(si) = e;    
    % -----------------------
    % ====================================================
return

    




end

%% save ++++++
writetable([strainNames(:,{'genotype'}),BC],fullfile(pSave,'BodyCurve.csv'))
writetable([strainNames(:,{'genotype'}),Prev],fullfile(pSave,'Prev.csv'))
writetable([strainNames(:,{'genotype'}),Pacc],fullfile(pSave,'Pacc.csv'))

% -------------

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



























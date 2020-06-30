%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% GLOBAL INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paths ++++++++++++++
pData_Strain = '/Users/connylin/Dropbox/RL/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
addpath(fullfile(fileparts(pM),'functions'));
% --------------------

% settings ++++++
strainNames = DanceM_load_strainInfo;
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set up matrix
SampleSize = strainNames(:,{'strain','genotype'});

% open text file
% fid = fopen(fullfile(pM,'Sample Size.txt'),'w');

for si = 1:size(SampleSize,1)
    clear MWTDB
    
    strainname = SampleSize.strain{si};
    genotype = SampleSize.genotype{si};
    
    load(fullfile(pData_Strain,strainname,'MWTDB.mat'));
    return
    groupnames = MWTDB.groupname;
    GNC = tabulate(groupnames);
    
    n1 = cell2mat(GNC(ismember(GNC(:,1),'N2'),2));
    n2 = cell2mat(GNC(ismember(GNC(:,1),'N2_400mM'),2));
    n3 = cell2mat(GNC(ismember(GNC(:,1),strainname),2));
    n4 = cell2mat(GNC(ismember(GNC(:,1),[strainname,'_400mM']),2));

%     fprintf(fid,'%s, %s, N(plate)=%d,%d,%d,%d\n',strainname, genotype,n1,n2,n3,n4);
    
    
end

% fclose(fid);



return











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
    if ~isempty(a)
        a = cellfun(@str2num,a);
    else
        a = 1;
    end
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
    TAR = rmANOVATWR;
    TAR.datapath = fullfile(pData_Strain,strain,'TAR/Dance_rType/AccProb RMANOVA.txt');
    ANOVAA = TAR.anova;
    
    a = char(ANOVAA.F('strain'));
    a = regexp(a,'[,]|[(]|[)]|( = )|( < )','split');
    
    Pacc.df1(si) = str2num(a{2});
    Pacc.df2(si) = str2num(a{3});
    Pacc.p_strain(si) = ANOVAA.pvalue('strain');
    Pacc.p_dose(si) = ANOVAA.pvalue('dose');
    Pacc.p_strain_dose(si) = ANOVAA.pvalue('dose*strain');
    
    T = TAR.posthoc_groups;
    
    Pacc.p_W0M0(si) = T.pvalue(sprintf('N2*%s',strain));
    Pacc.p_W0W4(si) = T.pvalue(sprintf('N2*N2_400mM'));
    Pacc.p_M0M4(si) = T.pvalue(sprintf('%s*%s_400mM',strain,strain));
    Pacc.p_W4M4(si) = T.pvalue(sprintf('N2_400mM*%s_400mM',strain));    
    % ====================================================


    




end

%% save ++++++
writetable([strainNames(:,{'genotype'}),BC],fullfile(pSave,'BodyCurve.csv'))
writetable([strainNames(:,{'genotype'}),Prev],fullfile(pSave,'Prev.csv'))
writetable([strainNames(:,{'genotype'}),Pacc],fullfile(pSave,'Pacc.csv'))

% -------------

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



























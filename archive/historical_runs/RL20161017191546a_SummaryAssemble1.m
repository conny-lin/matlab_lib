%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% ---------------------------

%% GLOBAL INFORMATION
% paths & settings -----------
pSave = fileparts(pM);
addpath(fileparts(pM));
pData = '/Volumes/COBOLT/MWT';
addpath('/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/x-SummaryAssemble/Functions');

% ---------------------------

% strains %------
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
% get strain info
s = dircontent(pData);
strainNames = DanceM_load_strainInfo(s);
strainNames = sortrows(strainNames,{'strain'});
strainlist = strainNames.strain;
%----------------



%%
% strain info +++++
si = 1;
strain = strainlist{si};
genotype = strainNames.genotype{si};
% -----------------

%% 1-initial sensitivity ==================================================
% need to get data from MANOVA txt
prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
suffix = 'Etoh sensitivity/InitialEtohSensitivity';
pF = fullfile(prefix,strain,suffix);

msrlist = {'curve','speed'};
R = struct;
for msri = 1:numel(msrlist)
    msr = msrlist{msri};

    % load file ++++++++++++++++++++++++++++++++
    p = fullfile(pF,sprintf('%s MANOVA.txt',msr));
    f = fopen(p,'r');
    c = textscan(f, '%s%[^\n\r]', 'Delimiter', '','ReturnOnError', false);
    fclose(f);
    c = c{1};
    T = getDStatsFromTxt(c);
    % ---------------------------------------
    
    R.(msr).dstat = T;
    R.(msr).MANOVAtxt = c;
end

Summary.sensitivity = R;

% =========================================================================

%% 2-rev curve ============================================================
% load data +++++++++++++++++++
prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
suffix = 'TWR/Dance_ShaneSpark4';
p = fullfile(prefix,strain,suffix,'Dance_ShaneSpark4.mat');
load(p);
% ---------------------------------

% get graph data ++++++++++++++++
D = MWTSet.ByGroupPerPlate.RevFreq;
y = D.Mean;
e = D.SE;
x = D.tap;
gn = D.groupname;
D1(:,:,1) = x;
D1(:,:,2) = y;
D1(:,:,3) = e;
% sort by N2
gns = sortN2first(gn',gn');
[i,j] = ismember(gn,gns);
D1 = D1(:,j,:);
X = D1(:,:,1);
Y = D1(:,:,2);
E = D1(:,:,3);
% store
R = struct;
R.X = X;
R.Y = Y;
R.E = E;
Summary.TWR.graph = R;
% -------------------------------

%% reorg to repeated measures anova format +++++
D = MWTSet.Raw;
mwtids = unique(D.mwtid);
taps = unique(D.tap);
A = nan(numel(mwtids),numel(taps));

for mi = 1:numel(mwtids)
    
   i = D.mwtid == mwtids(mi);
   d = D(i,:);
   d = sortrows(d,{'tap'});
   
   t = d.tap;
   y = d.RevFreq;
   
   [i,j] = ismember(taps,t);
   
   A(mi,j(i)) = y;
end

tap = A;
tap = array2table(tap);

% create legend
M = MWTSet.MWTDB(mwtids,:);
gn = M.groupname;
a = regexpcellout(gn,'_','split');
strain = a(:,1);
dose = a(:,2);
dose(cellfun(@isempty,dose)) = {'0mM'};

T = table;
T.groupname = gn;
T.strain = strain;
T.dose = dose;

D = [T tap];
% ----------------------------------------------


%% stats +++++++++++++++
rmfactorName = 'tap';
StatsOut = struct;
tptable = array2table(taps,'VariableNames',{rmfactorName});


%% anova
factorName = 'strain*dose';
astring = sprintf('%s0-%s20~%s',rmfactorName,rmfactorName,factorName);
rm = fitrm(T,astring,'WithinDesign',tptable);
%         StatOut.(timeName).fitrm = rm;
t = ranova(rm); 
StatOut.(timeName).ranova = t;
% t = anovan_textresult(t,0, 'pvlimit',pvlimit);
% fprintf(fid1,'RMANOVA(%s,t:%s):\n%s\n',timeName,factorName,t);

% run pairwise
astring = sprintf('%s0-%s20~%s',rmfactorName,rmfactorName,factor1Name);
rm = fitrm(T,astring,'WithinDesign',tptable);
%         StatOut.(timeName).fitrmg = rm;
t = multcompare(rm,factor1Name);
StatOut.(timeName).mcomp_g = t;
% t = multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alphanum);
% fprintf(fid1,'\nPosthoc(Tukey)curve by group:\n%s\n',t);


% comparison by taps
t = multcompare(rm,factor1Name,'By',rmfactorName);
StatOut.(timeName).mcomp_g_t = t;
t = multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alphanum);
% fprintf(fid1,'\nPosthoc(Tukey)%s by %s:\n%s\n',factor1Name,rmfactorName,t);

% comparison within group bewteen time
t = multcompare(rm,rmfactorName ,'By',factor1Name);
StatOut.(timeName).mcomp_t_g = t;
% t = multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alphanum);
% fprintf(fid1,'\nPosthoc(Tukey)%s by %s:\n%s\n',rmfactorName,factor1Name,t);

% fprintf(fid1,'\n\n');
% ----------------------

return

%% ========================================================================

% 3-rev t1 and t30
% does not exist, code
pF3 = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains/BZ142/TWR/Dance_Glee';

% 4-Acc curve
% does not exist, need to rater all points to get this

% 5-Acc t1/30
pF5 = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/2-EARS/1-response type probability/resp_type_probabiity_acc_201610101118/rType_fig_bar/Figure/t1';


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% CREATE GRAPH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% make graph
% sort groups +++++++++++++++++++++++
gn = T.gname;
a = regexpcellout(gn,'_','split');
T.strain = a(:,1);
T.dose = a(:,2);
b = a(:,1);
b = regexprep(b,'N2','Wildtype');
b = regexprep(b,strain,genotype);
T.genotype = b;

% --------------------------------

%% graph setting ++++++++++++++++++++++
edgecolor = {[0 0 0], [0 0 0],[1 0 0],[1 0 0]};
facecolor = {'none',edgecolor{2},'none',edgecolor{4}};
x = [1 2 3.5 4.5];
% ------------------------------

% create figure +++++++++++++++++++++
figure1 = figure('Visible','on');
axes1 = axes('Parent',figure1,'FontSize',10);
hold on;

for gi = 1:numel(gn)
    bar(x(gi),T.mean(gi),...
        'EdgeColor',edgecolor{gi},...
        'FaceColor',facecolor{gi},...
        'BarWidth',1);
end
% ---------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%































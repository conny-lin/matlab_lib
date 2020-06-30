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
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/rasterPlot_colorSpeed');
% ---------------------------

% strains %------
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
% get strain info
strainNames = DanceM_load_strainInfo(dircontent(pData));
strainNames = sortrows(strainNames,{'strain'});
%----------------



%% cycle through strain
% strain info +++++
si = 1;
strain = strainlist{si};
genotype = strainNames.genotype{si};
% -----------------



%% 1-initial sensitivity ===================================================
p = fullfile(pData_Strain,strain,'Etoh sensitivity','InitialEtohSensitivity','curve MANOVA.txt');
Data = rmANOVACurveReport;
curveData.datapath = p

return

% =========================================================================



%% 2/3-rev curve ============================================================
% load data +++++++++++++++++++
prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
suffix = 'TWR/Dance_ShaneSpark4';
p = fullfile(prefix,strain,suffix,'Dance_ShaneSpark4.mat');
load(p);
% ---------------------------------

% get graph data ++++++++++++++++
D = MWTSet.ByGroupPerPlate.RevFreq;
R = TWR_graph_data(D);
Summary.TWR.graph_curve = R;
% -------------------------------

% reorg to repeated measures anova format +++++
[D,taps,A] = TWR_data2anovaFormat(MWTSet);
Stats = rmanova_TWR(D);
Summary.TWR.stats = Stats;
% --------------------------------------------
% ========================================================================



%% 3-rev t1 and t30 =======================================================
% load data +++++++++++++++++++
prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
suffix = 'TWR/Dance_ShaneSpark4';
p = fullfile(prefix,strain,suffix,'Dance_ShaneSpark4.mat');
load(p);
% ---------------------------------

% get graph data ++++++++++++
D = Summary.TWR.graph_curve;
A = struct;

gn = D.gn;
A.gn = gn;

m = D.Y(1,:);
se = D.E(1,:);
A.t1.y = m;
A.t1.e = se;

m = D.Y(30,:);
se = D.E(30,:);
A.t30.y = m;
A.t30.e = se;

Summary.TWR.graph_bar = A;
% -----------------------------
% ========================================================================



%% 4-Acc curve =============================================================
% create save path +++++++++++++++++++
prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
suffix = 'Raster';
pSave = fullfile(prefix,strain,suffix);
% -----------------------------------

% load data +++++++++++++++++++
prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
suffix = 'MWTDB.mat';
p = fullfile(prefix,strain,suffix);
load(p);
% ---------------------------------

% dance raster ---------------

% ----------------------------


%% ========================================================================

%% 5-Acc t1/30 =============================================================
pF5 = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/2-EARS/1-response type probability/resp_type_probabiity_acc_201610101118/rType_fig_bar/Figure/t1';
%% ========================================================================


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































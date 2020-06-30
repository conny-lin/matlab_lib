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
pSave = create_savefolder(fullfile(pM,'Report'));
% --------------------

% settings ++++++
pvsig = 0.05;
pvlim = 0.001;
strainNames = DanceM_load_strainInfo;
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for si = 1:size(strainNames,1);
    
    % get strain +++
    strain = strainNames.strain{si};
    genotype = strainNames.genotype{si};
    processIntervalReporter(size(strainNames,1),1,sprintf('%s',strain),si);
    % --------------


    % 1-initial sensitivity ++++
    p = fullfile(pData_Strain,strain,'Etoh sensitivity','InitialEtohSensitivity','curve MANOVA.txt');
    Data = rmANOVACurveReport;
    Data.datapath = p;
    Summary.Curve.groupname = Data.groupnames;
    Summary.Curve.N = Data.n;
    Summary.Curve.Y = Data.mean;
    Summary.Curve.E = Data.se;
    % --------------------------

    %  2/3-rev curve ++++++++++++++++
    p = fullfile(pData_Strain,strain,'TWR/Dance_ShaneSpark4/Dance_ShaneSpark4.mat');
    load(p);
    D = MWTSet.ByGroupPerPlate.RevFreq;
    R = TWR_graph_data(D);
    Summary.TWR = R;
    % -------------------------------

    % acc graph ++++++++++++
    p = fullfile(pData_Strain,strain,'TAR/Dance_rType/data.mat');
    A = load(p);
    Summary.TAR = A.G.AccProb;
    % -----------------------

    %% graph
%     fig = graphHabCurvePck(X,Y,E,msr,gnu)
    %%
return
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



















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































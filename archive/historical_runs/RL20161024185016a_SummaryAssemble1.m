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
pSave = create_savefolder(fullfile(pM,'Graphs'));
% --------------------

% settings ++++++
pvsig = 0.05;
pvlim = 0.001;
w = 10;
h = 4;
strainNames = DanceM_load_strainInfo;
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for si = 1%:size(strainNames,1);
    
    % get strain +++
    strain = strainNames.strain{si};
    genotype = strainNames.genotype{si};
    processIntervalReporter(size(strainNames,1),1,sprintf('%s',strain),si);
    % --------------


    % 1-initial sensitivity ++++
    p = fullfile(pData_Strain,strain,'Etoh sensitivity','InitialEtohSensitivity','curve MANOVA.txt');
    Data = rmANOVACurveReport;
    Data.datapath = p;
    
    a = Data.se;
    b = Data.mean;
    c = a./b;
    ep = [mean(c(1:2)); mean(c(3:4))];
    a = percentChange(Data);
    E = a.pct .* ep;
    Y = a.pct;
    gn = Data.groupnames';
    gn = gn([1 3]);
    gn =regexprep(gn,'( 0mM)','')';
    Summary.Curve.groupname = gn;
    Summary.Curve.N = Data.n;
    Summary.Curve.Y = Y;
    Summary.Curve.E = E;
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

%%
markersize = 4.5;
gp = graphsetpack('cathyline');
gpn = fieldnames(gp);

close all
figure1 = figure('Visible','on');

% bar graph +++++++++++++
GN = Summary.Curve.groupname;
Y = Summary.Curve.Y;
E = Summary.Curve.E;
% Create axes
axes1 = axes('Parent',figure1,'Position',[0.05 0.11 0.15 0.3],'Box','off');
% axes properties
set(axes1,'XTick',[1 2]);
hold(axes1,'on');
bar1 = bar(Y,'Parent',axes1);
% errorbar
e1 = errorbar(Y,E,'LineStyle','none','Color',[0 0 0]);
% ------------------------

% plot 2 ++++++++++++++++
GN = Summary.TWR.gn;
X = Summary.TWR.X;
Y = Summary.TWR.Y;
E = Summary.TWR.E;
% Create axes
axes2 = axes('Parent',figure1,...
    'Position',[0.25 0.11 0.3 0.9]);
hold(axes2,'on');
xlim([0 30.5]);
ylabel('P (reversal)');
xlabel('Tap');
e2 = errorbar(X,Y,E,'Marker','o','MarkerSize',markersize);
e2 = graphApplySetting(e2,'cathyline');
% ------------------------



% plot 3 +++++++++++
GN = Summary.TAR.groupname;
X = Summary.TAR.X;
Y = Summary.TAR.Y;
E = Summary.TAR.E;
% Create axes
axes3 = axes('Parent',figure1,...
    'Position',[0.65 0.11 0.3 0.8]);
hold(axes3,'on');
xlim([0 30.5])
ylabel('P (acceleration)');
xlabel('Tap');
e3 = errorbar(X,Y,E,'Marker','o','MarkerSize',markersize);
e3 = graphApplySetting(e3,'cathyline');
% ------------------------



% save -------------------------------------------
printfig(strain,pSave,'w',w,'h',h,'closefig',1);
% -------------------------------------------



return
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



























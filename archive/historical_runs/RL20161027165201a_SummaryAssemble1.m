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
w = 9;
h = 4;
strainNames = DanceM_load_strainInfo;
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for si = 1:size(strainNames,1);
    
    % get strain +++
    strain = strainNames.strain{si};
    genotype = strainNames.genotype{si};
    processIntervalReporter(size(strainNames,1),1,strain,si);
    % --------------
    
    %% load data =======================================
    % 1-initial sensitivity ++++
%     p = fullfile(pData_Strain,strain,'Etoh sensitivity','InitialEtohSensitivity','curve MANOVA.txt');
%     Data = rmANOVACurveReport;
%     Data.datapath = p;
%     
%     a = Data.se;
%     b = Data.mean;
%     c = a./b;
%     ep = [mean(c(1:2)); mean(c(3:4))];
%     a = percentChange(Data);
%     E = a.pct .* ep;
%     Y = a.pct;
%     gn = Data.groupnames';
%     gn = gn([1 3]);
%     gn =regexprep(gn,'( 0mM)','')';

    pC = fullfile(pData_Strain,strain,'Etoh sensitivity','InitialEtohSensitivityPct','data.mat');
    DC = load(pC,'DataMeta','MWTDB');
    CS = CurveStats;
    CS.mwtid = DC.DataMeta.mwtid;
    CS.curve = DC.DataMeta.curve;
    CS.MWTDB = DC.MWTDB;
    [anovatxt,T] = anova(CS);
    gn = regexprep(T.gnames,'_400mM','');
    
    
    Summary.Curve.groupname = sortN2first(gn,gn);
    Summary.Curve.N = sortN2first(gn,T.N);
    Summary.Curve.Y = sortN2first(gn,T.mean).*100;
    Summary.Curve.E = sortN2first(gn,T.SE).*100;
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
    % ====================================================


    %% graph ==========================================
    markersize = 4.5;
    gp = graphsetpack('cathyline');
    gpn = fieldnames(gp);

    close all
    figure1 = figure('Visible','off');

    % bar graph +++++++++++++
    GN = Summary.Curve.groupname;
    if ~strcmp(GN{1},'N2'); error('bad n2');end
    Y = Summary.Curve.Y;
    E = Summary.Curve.E;
    % Create axes
    axes1 = axes('Parent',figure1,'Position',[0.07 0.11 0.1 0.45],'Box','off');
    hold(axes1,'on');
    % axes properties
    set(axes1,'XTick',[1 2],'XTickLabel',{'+','-'});
    xlim([0.5 2.5]);
    ylim([-60 20]);
    ylabel('% curve (etoh/control)')
    bar1 = bar(Y,'Parent',axes1,'EdgeColor',[0 0.447058826684952 0.74117648601532],'FaceColor',[0 0.447058826684952 0.74117648601532]);
    % errorbar
    e1 = errorbar(Y,E,'LineStyle','none','Color','k','LineWidth',1,'Marker','none');
    % ------------------------



    % plot 2 ++++++++++++++++
    GN = Summary.TWR.gn;
    X = Summary.TWR.X;
    Y = Summary.TWR.Y;
    E = Summary.TWR.E;
    if ~strcmp(GN{1},'N2'); 
        X = sortN2first(GN,X')';
        Y = sortN2first(GN,Y')';
        E = sortN2first(GN,E')';
        GN = sortN2first(GN,GN);
    end 
    % Create axes
    axes2 = axes('Parent',figure1,'Position',[0.25 0.11 0.3 0.8]);
    hold(axes2,'on');
    xlim([0 30.5]);
    ylim([0,1]);
    ylabel('P (reversal)');
    xlabel('Tap');
    e2 = errorbar(X,Y,E,'Marker','o','MarkerSize',markersize);
    e2 = graphApplySetting(e2,'cathyline');
    % Create multiple error bars using matrix input to errorbar
    legname = {'+ 0mM','+ 400mM','(-) 0mM','(-) 400mM'};
    for ei = 1:numel(GN)
        set(e2(ei),'DisplayName',legname{ei});
    end
    % Create legend
    legend1 = legend(axes2,'show');
    set(legend1,'Position',[0.04 0.66 0.1 0.22],'EdgeColor',[1 1 1]);
    annotation(figure1,'textbox',[0.02 0.95 0.08 0.08],...
        'String',{genotype},'FontWeight','bold','EdgeColor','none');
    % ------------------------


    % plot 3 +++++++++++
    GN = Summary.TAR.groupname;
    X = Summary.TAR.X;
    Y = Summary.TAR.Y;
    E = Summary.TAR.E;
    if ~strcmp(GN{1},'N2'); 
        X = sortN2first(GN,X')';
        Y = sortN2first(GN,Y')';
        E = sortN2first(GN,E')';
        GN = sortN2first(GN,GN);
    end    
    % Create axes
    axes3 = axes('Parent',figure1,'Position',[0.65 0.11 0.3 0.8]);
    hold(axes3,'on');
    xlim([0 30.5])
     ylim([0,1]);

    ylabel('P (acceleration)');
    xlabel('Tap');
    e3 = errorbar(X,Y,E,'Marker','o','MarkerSize',markersize);
    e3 = graphApplySetting(e3,'cathyline');
    % ------------------------

    % save -------------------------------------------
    printfig(strain,pSave,'w',w,'h',h,'closefig',1);
    % -------------------------------------------




end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



























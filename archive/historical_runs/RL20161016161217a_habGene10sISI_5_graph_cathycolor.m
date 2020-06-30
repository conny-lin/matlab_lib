%  habituation curve 10sISI of valid experiments

%% INITIALIZING ===========================================================
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
pSaveM = fileparts(pM);
%% ========================================================================

%% SETTING ================================================================
% paths
pDataHome = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/Data/10sIS by strains';
pSave = create_savefolder(fullfile(pM,'Figure'));
% get strain names
strainlist = dircontent(pDataHome);
% strainlist(~ismember(strainlist,{'VG254'})) = [];
strainNames = DanceM_load_strainInfo(strainlist);
% other settings ----------------------------
msr = 'RevFreq';
w = 5;
h = 3;
% -------------------------------------------
%% ========================================================================


%% make new graphs ========================================================
for si = 1:numel(strainlist)
    
    % report progress %------------
    fprintf(''); % separator
    processIntervalReporter(numel(strainlist),1,'strain',si);
    % ------------------------------
    
    % load data -----------------------
    strain = strainlist{si};
    genotype = strainNames.genotype{si};
    p = fullfile(pDataHome,strain,'Dance_ShaneSpark4','Dance_ShaneSpark4.mat');
    load(p);
    % ---------------------------------
    
    % get graph data ----------------
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
    % -------------------------------
    
    %% setting --------------------------
    gp = graphsetpack('cathy');
    gnss = regexprep(gns','_',' ');
    gnss = regexprep(gnss,strain,genotype);
    gnss = regexprep(gnss,'N2','Wildtype');
    gp.DisplayName = gnss;
    gpn = fieldnames(gp);
    % -----------------------------------
    
    % plot ------------------------------------------
    fig = figure('Visible','off','PaperSize',[w h],'Unit','Inches',...
        'Position',[0 0 w h]); 
    ax1 = axes('Parent',fig,'XTick',[0:10:30]); 
    hold(ax1,'on');
    e1 = errorbar(X,Y,E,'Marker','o','MarkerSize',4.5);
    % -----------------------------------------------

    % get settings -----------------------------------
    for gi = 1:numel(gn)
        for gpi = 1:numel(gpn)
            e1(gi).(gpn{gpi}) = gp.(gpn{gpi}){gi};
        end
    end
    % -----------------------------------------

    % legend ------------------------
    lg = legend('show');
    lg.Location = 'eastoutside';
    lg.Box = 'off';
    lg.Color = 'none';
    lg.EdgeColor = 'none';
    lg.FontSize = 8;
    % -------------------------------

    % x axis -----------------------------------------------
    xlabel('Tap')
    xlim([0 30.5]);
    % --------------------------
    % y axis ---------------------
    yname = 'P (reversal)';
    ylim([0 1]);
    ylabel(yname);
    % ------------------------
    % axis ------------------------------------
    axs = get(ax1);
    ax1.TickLength = [0 0];
    ax1.FontSize = 10;
    % ----------------------------------------------------

    % save -------------------------------------------
    savename = sprintf('%s/%s %s',pSave,strain,msr);
    printfig(savename,pSave,'w',w,'h',h,'closefig',1);
    % -------------------------------------------


end
%% ========================================================================
















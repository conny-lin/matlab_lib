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

% other settings ----------------------------
msr = 'RevFreq';
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
    
    %% plot --------------------------
    gp = graphsetpack(graphpack);
    gp.DisplayName = gns;
    fig = figure('Visible','on','PaperSize',[4 2.5],'Unit','Inches'); 
    ax1 = axes('Parent',fig); hold(ax1,'on');
    e1 = errorbar(X,Y,E,'Marker','o','MarkerSize',3);
    % -----------------------------------------------

    % get settings -----------------------------------
    for gi = 1:numel(gn)

        gpn = fieldnames(gp);
        % find expected group name
        k = find(ismember(gp.DisplayName,regexprep(gn{gi},'_',' ')));

        if numel(k) ~= 1; 
            warning('multiple group name per graph setting assignment'); 
            k = k(1); 
        end

        for gpi = 1:numel(gpn)
            e1(gi).(gpn{gpi}) = gp.(gpn{gpi}){k};
        end

    end
    % -----------------------------------------

    % legend ------------------------
    lg = legend('show');
    lg.Location = 'northeastoutside';
    lg.Box = 'off';
    lg.Color = 'none';
    lg.EdgeColor = 'none';
    lg.FontSize = 8;
    % -------------------------------

    % axis -----------------------------------------------
    xlabel('stimuli')
    xlim([0 max(max(x))+0.5]);
    if strcmp(msr,'RevFreq');
        yname = 'RevProb';
        ylim([0 1]);
    else
        yname = msr;
        ylim([0 max(max(y))*1.1]);
    end
    ylabel(yname);
    axs = get(ax1);
    ax1.TickLength = [0 0];
    ax1.FontSize = 10;
    %% ----------------------------------------------------

    % save -------------------------------------------
    savename = sprintf('%s/%s %s',pSave,graphname,msr);
    printfig(savename,pSave,'w',4,'h',2.5,'closefig',1);
    % -------------------------------------------


    Graph_HabCurveSS(X,Y,E,gn,msr,pSave,'graphpack','cathy','graphname',strain);
    % --------------------------------
return    
end
%% ========================================================================

















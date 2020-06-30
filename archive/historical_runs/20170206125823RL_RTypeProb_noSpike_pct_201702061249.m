
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Dance/Dance_RespType');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% ---------------------------

%% GLOBAL INFORMATION
% paths & settings -----------
pSave = pM;
addpath(fileparts(pM));
pData = fileparts(pM);
% ---------------------------

%% RECREATE PROBABILITY PLOT WITHOUT SPIKES
% load data -----
p = fullfile(pData,'matlab.mat');
load(p);
% ---------------

% settings %--------------------
% timelist = [95:10:29*10+95];
timelist = 100:10:(100+(29*10));
coli = [1:6:(30*6)];
% --------------------------------

%% extract only 0.1s data
glist = fieldnames(Out);
for gi = 1:numel(glist)
    gn = glist{gi};

end


%% plot errorbar across time (manual)
titlename = {'Wildtype 0mM','Wildtype 400mM'};
for gi = 1:numel(glist)
    % get group specific info ---------
    gn = glist{gi};
    % ---------------------------------
    
    % get data ---------------------
    d = Out.(gn);
    % ------------------------------
    
    % get variables -----------------------------
    y = d.mean(1:2,coli)';
    e = d.se(1:2,coli)';
    x = repmat(timelist,size(d.mean,1)-1,1)';

    
    
    % transform to percentage
    y = y./repmat(y(1,:),size(y,1),1);
    
    % ------------------------------------------
    
    % save figure ---------
%     fig_pResp(pM,x,y,e,titlename{gi},gn)
    % ---------------------
    
    
% figure ---------------------------------------
    % Create figure
    figure1 = figure('Visible','off','Position',[0 0 3 4]);

    % Create axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');

    % Create multiple error bars using matrix input to errorbar
    errorbar1 = errorbar(x,y,e,'Marker','o');
    dispname = {'Acceleration','Reversal','Pauses'};
    color = [[1 0 0]; [0 0.447058826684952 0.74117648601532]; [0 0 0]];
    for ei = 1:size(x,2)
    set(errorbar1(ei),'DisplayName',dispname{ei},...
            'MarkerFaceColor',color(ei,:),...
        'MarkerEdgeColor',color(ei,:),...
        'Color',color(ei,:));

    end

    % Create xlabel
    xlabel('time(s)');
    % Create title
    title(titlename{gi});
    % Create ylabel
    ylabel('P (% responses to initial)');
    % Uncomment the following line to preserve the X-limits of the axes
    xlim(axes1,[95 400]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim(axes1,[0.2 1.8]);
    % Create legend
    legend1 = legend(axes1,'show');
    set(legend1,'Location','north','EdgeColor',[1 1 1]);

    % save
    savename = [gn,' no pauses'];
    printfig(savename,pM,'w',5,'h',4)



end


% report done --------------
fprintf('\n--- Done ---\n\n' );
return
% --------------------------































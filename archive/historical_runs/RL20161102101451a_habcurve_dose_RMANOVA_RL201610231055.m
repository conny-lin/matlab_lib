%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% GLOBAL INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paths ++++++++++++++
pD = fileparts(pM);
pSave = pM;
% --------------------
% load MWTDB +++++++
load(fullfile(pD,'MWTDB.mat'),'MWTDB');
pMWT = MWTDB.mwtpath;
% -----------------

% settings ++++++
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get data ================================================================
% IMPORT HABITUATION CURVES DATA +++++++++++
[Data,msrlist] = importHabCurveData(pMWT);
% ------------------------------------------

% create tap data obj ++++++++++++++++++++++
TD = TapData;
v = {'mwtpath','groupname','tap'};
for vi = 1:numel(v)
    TD.(v{vi}) = Data.(v{vi});
end
TD.Response = table2array(Data(:,msrlist));
TD.Measures = msrlist;
% ------------------------------------------
% =========================================================================


% anova ===================================================================
rmanovar = rmANOVA(TD);
for msri = 1:numel(msrlist)
    
    msr = msrlist{msri};
    textout = rmanovar.(msr);
    % save text data +++++++
    p = fullfile(pSave,sprintf('%s RMANOVA.txt',msr));
    fid = fopen(p,'w');
    fprintf(fid,'%s',textout);
    fclose(fid);
    % ----------------------

end
% =========================================================================



%% Graph ==================================================================
% plot line graph +++++++++++++++++++++++++++
w = 4;
h = 3;
for msri = 1:numel(msrlist)
    msr = msrlist{msri};
    
    fig1 = plotHabStd(TD,msr,'off');

    % adjust color +++++
    color = color_rainbow;
    f1 = get(fig1);
    a1 = get(f1.Children);
    e1 = get(a1.Children);
    for x =1:size(color,1)
        c = color(x,:);
        f1.Children.Children(x).Color = c;
        f1.Children.Children(x).MarkerFaceColor = c;
        f1.Children.Children(x).MarkerEdgeColor = c;
    end
    % ------------------
    
    % save +++++++
    savename = sprintf('%s/%s',pSave,msr);
    printfig(savename,pSave,'w',w,'h',h,'closefig',1);
    % ------------
end
% ------------------------------------------
% =========================================================================


%% Save and exit ==========================================================
% save data ++++++++++++
save(fullfile(pSave,'data.mat'),'Data','TD','rmanovar');
% ----------------------

% report done ++++++++++++
fprintf('\nDONE\n'); return
% ------------------------
% =========================================================================

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


















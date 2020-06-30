
%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return


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





%% Graph ==================================================================
load(fullfile(pSave,'data.mat'));

%% create tap data obj ++++++++++++++++++++++
TD = TapData;
v = {'mwtpath','groupname','tap'};
for vi = 1:numel(v)
    TD.(v{vi}) = Data.(v{vi});
end
msr = {'RevFreq','RevSpeed','RevDur'};
TD.Response = table2array(Data(:,msr));
TD.Measures = msr;
% ------------------------------------------

%%
G = graphicData(TD);
fig1 = plotHabStd(TD,'RevFreq','on');
%         % save -------------------------------------------
%         savename = sprintf('%s/%s %s',pSave,strain,msr);
%         printfig(savename,pSave,'w',w,'h',h,'closefig',1);
%         % -------------------------------------------
%%














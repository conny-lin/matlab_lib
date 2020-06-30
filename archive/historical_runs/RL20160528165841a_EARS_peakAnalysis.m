% function ephys_accpeak_graph2_stats(strainT)

%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);

%% SETTING
pSF = '/Users/connylin/Dropbox/RL Pub InPrep - PhD Dissertation/4-STH genes/Data/10sIS by strains';

% Settings - graphs
Setting = struct;
Setting.Color = {[0.5 0.5 0.5]; [1 0.5 0.5];[0 0 0];[1 0 0]};
Setting.Marker = {'o' 'o' 'o' 'o'};
Setting.MarkerEdgeColor = Setting.Color;
Setting.MarkerFaceColor = Setting.Color;
Setting.MarkerSize = {2 2 2 2};
% setting others
rmfactorName = 't';
factor1Name = 'groupname';
pvlimit = 0.001;
alphanum = 0.05;
        
%% strains
strainlist = dircontent(pSF);
% strainlist(ismember(strainlist,{'VG202','VG302'})) = [];
strainlist(~ismember(strainlist,'NM1968')) = [];


%% load data
for si =1:numel(strainlist)
    % get strain info
    strain = strainlist{si}; fprintf('%d/%d: %s\n',si, numel(strainlist), strain);
    pSave = pM;

    %% graph space out graphs
    timeNameList = {'t28_30','t1'};
    
    for ti = 1:numel(timeNameList)
        timeName = timeNameList{ti};
        p = sprintf('%s/%s/ephys graph/data_ephys_%s.mat',pSF,strain,timeName);
        load(p,'DataG');
        
        %% 1-find baseline
           
        %% 2-find response (y/n)
        % 3-response duration (time)
        % 4-peak time (t)
        % 5-peak magnitude (v)
        % 6-peak dir (-/+)
       
        
       

    end

end
% end
fprintf('Done\n');



























    
    
    
    
    
    
    
    
    
    
    
    
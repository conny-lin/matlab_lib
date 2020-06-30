% function ephys_accpeak_graph2_stats(strainT)

%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);

%% SETTING
pSF = '/Users/connylin/Dropbox/RL Pub InPrep - PhD Dissertation/4-STH genes/Data/10sIS by strains';

        
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
    statString = '';
    StatOut = struct;
    savename = sprintf('%s/%s',pSave,strain);

    for ti = 1:numel(timeNameList)
        timeName = timeNameList{ti};
        load(sprintf('%s/%s/ephys graph/data_ephys_%s.mat',pSF,strain,timeName));
        
        return
        %% 0-get data 
        D = cell(size(DataG,2),1);
        GN = cell(size(DataG,2),1);
        % set time
        time1 = -0.5;
        time2 = 1;
        % get data
        for gi = 1:size(DataG,2)
            t = DataG(gi).time(1,:);
            ti1 = find(t==time1);
            ti2 = find(t==time2);
            x = DataG(gi).time(1,ti1:ti2);
            Y = DataG(gi).speedb(:,ti1:ti2);
            Y(:,x==0) = NaN;
%             x(:,x==0) = [];
            D{gi} = Y;
            GN{gi} = repmat({DataG(gi).name},size(Y,1),1);
        end
        return
    end
end


fprintf('Done\n');
% end


























    
    
    
    
    
    
    
    
    
    
    
    
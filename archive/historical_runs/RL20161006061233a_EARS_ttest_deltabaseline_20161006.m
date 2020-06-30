%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);

%% GLOBAL INFORMATION
% paths & settings
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/Data/10sIS by strains';
% strains
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/Data/10sIS by strains';
strainlist = dircontent(pData);
strainNames = DanceM_load_strainInfo(strainlist);

%% cycle through strains
% decalure output array
DF = nan(size(strainNames,1),10*4);
TStatR = DF;
TStatL = DF;
TailRp = DF;
TailLp = DF;
gncol = [1:10:10*4];

for si = 1:size(strainNames,1)
    strain = strainNames.strain{si}; % get strain name

    % get data
    load(fullfile(pData, strain, 'ephys graph','data_ephys_t28_30.mat'),'DataG');
    DataG = struct2table(DataG); % convert to table
    DataG = output_sortN2first(DataG,'tblcolname','name'); % sort N2 first

    groupnames = DataG.name; % get list of group names

    for gi = 1:numel(groupnames); % cycle through groups
        gn = groupnames{gi}; % get group name

        % CALCULATIONS
        % get current group data
        Time = DataG.time{gi}(1,:);
        Speed = DataG.speedbm{gi}; % get speed data
        % get baseline (mean of -0.5-0.1s)
        S1 = nanmean(Speed(:,Time >= -0.5 & Time <=0.1), 2);
        % get time from -0.1s-1s
        S = Speed(:,Time >= 0.1 & Time <=1);
        % find delta baseline
        dS = S - repmat(S1,1,size(S,2));
        
        % t test cycle through each time points
        r1 = gncol(gi); 

        for ti = 1:size(dS,2)
            [~,p,~,stats] = ttest(dS(:,ti),0,'Tail','right');
            DF(si,r1+ti-1) = stats.df;
            TStatR(si,r1+ti-1) = stats.tstat;
            TailRp(si,r1+ti-1) = p;
            
            [~,p,~,stats] = ttest(dS(:,ti),0,'Tail','left');
            TStatL(si,r1+ti-1) = stats.tstat;
            TailLp(si,r1+ti-1) = p;
        end
    end

end









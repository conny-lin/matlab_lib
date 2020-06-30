
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);

%% GLOBAL INFORMATION
% paths & settings
pSave = fileparts(pM);
addpath(fileparts(pM));
pData = '/Volumes/COBOLT/MWT';

% strains %------
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/Data/10sIS by strains';
strainlist = dircontent(pData);
% get strain info
strainNames = DanceM_load_strainInfo(strainlist);
%----------------

% settings %--------
time_baseline = [-0.3 -0.1];
time_response = [0.1 0.5];
n_lowest = 10;
% frameInt = 0.2; %(ed20161004)
% assaywindow = 10;
% NWORMS = Inf;
% expLimit = 'N2 within';
% 
% % create time frames
% startList = [98 388];
% endList = startList+assaywindow;
% --------------------------------


%% RESPONSE PROBABILITY: ACC, PAUSE, NO RESPONSE, REVERSAL, DECELLEARTION
for si = 1:size(strainNames,1) % cycle through strains
    
    % report progress %------------
    fprintf('\n\n\n');
    processIntervalReporter(numel(strainlist),1,'strain',si);
    % ------------------------------
    
    % data % -------------
    strain = strainNames.strain{si}; 
    p = fullfile(pData, strain,'ephys graph','data_ephys_t28_30.mat');
    load(p,'DataG','MWTDB');
    DataG = struct2table(DataG);
    gnlist = DataG.name; % get unique groups 
    % sort by N2 first
%     i = regexpcellout(gnlist,'N2');
%     gnlist = gnlist([find(i); find(~i)]);
    % ----------------
    
    % get assay time % ------------
    t = DataG.time{1}(1,:);
    i_baseline = find(t >= time_baseline(1) & t <= time_baseline(2));
    i_response = find(t >= time_response(1) & t<= time_response(2));
    % --------------------------
   
    
    %% GET RESPONSE TYPE SUMMARY
    %% flatten data
    S = cell2mat(DataG.speedb);
    % input data -----------------
    Baseline = S(:,i_baseline);
    Response = S(:,i_response);
    [~,~,R,~,leg] = compute_response_type(Response, Baseline, 'pSave',pM);
    R = cell2table(R);
    
    % plate info
    % add plate info % --------------
    id = cell(size(gnlist,1),1);
    for gi = 1:numel(gnlist)
        id{gi} = table2array(DataG.id{gi});
    end
    plateinfo = cell2mat(id);
    plateinfo = array2table(plateinfo,'VariableNames',{'mwtid','timeid','wormid'});
    [i,j] = ismember(plateinfo.mwtid, MWTDB.mwtid);
    i = j(i);
    plateinfo.groupname = MWTDB.groupname(i);
    plateinfo.mwtpath = MWTDB.mwtpath(i);
%     T = [plateinfo R];
%     
%     return
% 
%     Output.(gn).plateinfo = plateinfo;
%     Output.(gn).RespType = R;
% 
%         
%         
%     Output = struct;
%     for gi = 1:numel(gnlist) % cycle through groups
%         
%         gn = gnlist{gi}; % get gname
%     
% 
%         % input data -----------------
%         Baseline = DataG.speedb{gi}(:,i_baseline);
%         Response = DataG.speedb{gi}(:,i_response);
%         [~,~,R,~,leg] = compute_response_type(Response, Baseline, 'pSave',pM);
%         R = cell2table(R);
%         
%         % add plate info % --------------
%         plateinfo = DataG.id{gi};
%         [i,j] = ismember(plateinfo.mwtid, MWTDB.mwtid);
%         i = j(i);
%         plateinfo.groupname = MWTDB.groupname(i);
%         plateinfo.mwtpath = MWTDB.mwtpath(i);
%         T = [plateinfo R];
%         
%         Output.(gn).plateinfo = plateinfo;
%         Output.(gn).RespType = R;
%         
%     end
%     
%     
%     %%
%     a =cell2mat(DataG.speedb);
%     size(a)
    
    %%
    
    
    %% SUMMARIZE RESPONSE TYPE PER TIME PER GROUP PER PLATE
    
    for gi = 1:numel(gnlist) % cycle through groups
        gn = gnlist{gi}; % get gname
        
        i_group = ismember(plateinfo.groupname, gn);
        plateidu = unique(plateinfo.mwtid(i));
        
        for plateidi = 1:numel(plateidu)
            i_plate = plateinfo.mwtid == plateidi(pi);
            
            R1 = R(i_group & i_plate,:);
            R1 = categorical(R1);
            a = countcats(R1);

            a'
            return
        end
        
    end
    
    
    
    return
end

fprintf('\n--- Done ---' );
return































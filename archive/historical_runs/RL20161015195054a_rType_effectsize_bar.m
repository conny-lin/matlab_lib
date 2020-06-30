

%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% ---------------------------

%% GLOBAL INFORMATION
% paths & settings -----------
pSave = fileparts(pM);
addpath(fileparts(pM));
pData = '/Volumes/COBOLT/MWT';
% ---------------------------

% strains %------
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/1-response type probability/resp_type_probabiity_acc_201610101118/rType_fig_bar/Data';
timelist = dircontent(pData);
% get strain info
pStrain = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/1-response type probability/resp_type_probabiity_acc_201610101118/raster_RespondOnly_20161013/Figure/t1';
strainlist = dircontent(pStrain);
strainNames = DanceM_load_strainInfo(strainlist);
%----------------

% settings %--------------------
time_baseline = [-0.3 -0.1];
time_response = [0.1 0.5];
n_lowest = 10;

statsName = 'exclude no response';
% --------------------------------


%% effect size
Output = struct;
% effect sizse master
GroupMaster = {};
ESMaster = [];  
% ----------------------


for ti = 1:numel(timelist) % cycle through time choices
    % time ------------------
    tname = timelist{ti};
    ES = nan(numel(strainlist),3);  
    % -----------------------
    
    for si = 1:numel(strainlist) % cycle through strains

        % report progress %------------
        fprintf(''); % separator
        processIntervalReporter(numel(strainlist),1,'strain',si);
        % ------------------------------

        % data % -------------
        strain = strainNames.strain{si}; 
        p = fullfile(pData, tname,[strain,'by plate.csv']);
        Data = readtable(p);
        % ----------------

        % effect size ----------------------------------
        d = Data.pct;
        group_plate = Data.groupname;
        gpairs = {'N2','N2_400mM'; 'N2',strain; strain,[strain,'_400mM']};
        A = nan(1,size(gpairs,1));
        for gi = 1:size(gpairs,1)
            g1 = gpairs{gi,1};
            g2 = gpairs{gi,2};
            x1 = d(ismember(group_plate,g1));
            x2 = d(ismember(group_plate,g2));
            cohend = effectsize_cohend(x2,x1);
            A(gi) = cohend;
        end      
        
        ES(si,:) = A;
    end
    ESMaster = [ESMaster ES];
end


% report done --------------
beep on;
beep;
beep;
fprintf('\n--- Done ---\n\n' );
return
% --------------------------













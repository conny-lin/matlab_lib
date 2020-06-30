
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
   
    
    %% GET RESPONSE TYPE SUMMARY STRUCTURAL ARRAY
    Output = struct;
    for gi = 1:numel(gnlist) % cycle through groups
        
        gn = gnlist{gi}; % get gname
    

        % input data -----------------
        Baseline = DataG.speedb{gi}(:,i_baseline);
        Response = DataG.speedb{gi}(:,i_response);
        [~,~,R,~] = compute_response_type(Response, Baseline, 'pSave',pM);
        
        R = cell2table(R)
        return
        
        
        %%

        % evaluate per plate % --------------
        plateinfo = DataG.id{gi};
        plateu = unique(plateinfo.mwtid);
        nplatecount = 1;
        for platei = 1:numel(plateu)
            
            % get plate info % -----------
            mwtid = plateu(platei);
            i_plate = plateinfo.mwtid == mwtid;
            % ----------------------------
            
            % input data -----------------
            Baseline = DataG.speedb{gi}(i_plate,i_baseline);
            Response = DataG.speedb{gi}(i_plate,i_response);
            % ---------------------------
            
            % evalute input data -----------
            if size(Baseline,1) < n_lowest
               info = MWTDB(MWTDB.mwtid == mwtid,:);
               fprintf('  *skip plate N<%d: %s [%s] %s\n',n_lowest, ...
                   char(info.groupname), ...
                   char(info.mwtname),...
                   char(info.expter));
            else
                % determine response type % -----------
                % run function 
                [Rsum,RTclean,RTN,~] = compute_response_type(Response, Baseline, 'pSave',pM);
                % ----------------------------------

                % put output
                Output.(gn).mwtid(nplatecount) = mwtid;
                Output.(gn).RSwitchSum{nplatecount} = Rsum;   
                Output.(gn).RTclean{nplatecount} = RTclean;    
                Output.(gn).RT{nplatecount} = RTN;    

                nplatecount = nplatecount+1;
            end
            
        end
    end
    
    
    %% CREATE SUMMARY FROM STRUCTURAL ARRAY
    
    return
%         
    
        
end

fprintf('\n--- Done ---' );
return































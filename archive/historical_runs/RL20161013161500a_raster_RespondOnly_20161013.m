
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% ---------------------------

%% GLOBAL INFORMATION
% paths & settings -----------
addpath(fileparts(pM));
pData = '/Volumes/COBOLT/MWT';
% ---------------------------

% strains %------
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/Data/10sIS by strains';
strainlist = dircontent(pData);
% get strain info
strainNames = DanceM_load_strainInfo(strainlist);
%----------------

% settings %--------------------
time_baseline = [-0.3 -0.1];
time_response = [0.1 0.5];
n_lowest = 10;
timelist = {'t28_30','t1'};
statsName = 'exclude no response';
w = 3;
h = 3;
grad1 = 0.5;
grad2 = -0.4;
% --------------------------------




%% RESPONSE PROBABILITY: ACC, PAUSE, NO RESPONSE, REVERSAL, DECELLEARTION
Output = struct;
for ti = 1:numel(timelist) % cycle through time choices
    
    tname = timelist{ti};
    tfilename = ['data_ephys_',tname,'.mat'];
    
    for si = 1:size(strainNames,1) % cycle through strains

        % report progress %------------
        fprintf(''); % separator
        processIntervalReporter(numel(strainlist),1,'strain',si);
        % ------------------------------

        % data % -------------
        strain = strainNames.strain{si}; 
        p = fullfile(pData, strain,'ephys graph',tfilename);
        load(p,'DataG','MWTDB');
        DataG = struct2table(DataG);
        gnlist = DataG.name; % get unique groups
        % ----------------

        % get assay time % ------------
        t = DataG.time{1}(1,:);
        i_baseline = find(t >= time_baseline(1) & t <= time_baseline(2));
        i_response = find(t >= time_response(1) & t<= time_response(2));
        % --------------------------


        % plot raster ----------------------------------
        groupname = DataG.name;

        for gi = 1:numel(groupname)

            % identify responded worms ---------------
            S = DataG.speedb{gi};
            t = DataG.time{gi}(1,:);
            name = groupname{gi};
            % -----------------------------------------
            
            % get response type summary %--------------
            Baseline = S(:,i_baseline);
            Response = S(:,i_response);
            [~,~,~,RTN,leg] = compute_response_type(Response, Baseline, 'pSave',pM);            
            % ----------------------------------------
            
            % get rid of data without response --------------
            d = S;
            d(:,62:end) = [];
            d(:,t==0) = [];
            i = any([any(RTN(:,1:2)==4,2) any(isnan(RTN),2)],2);
            d(i,:) = [];
            % -------------------------------------------
            
            % random select 1000 worms -----------------------
            n = size(d,1);
            r = randi(n,5000,1);
            d = d(r,:);
            % ------------------------------------------------
            
            
            % create figure ------------------------------
            [f,~,cm] = rasterPlotc(d,t,0,'grad','CL','cmap','white intense',...
                'gradmin',grad2,'gradmax',grad1,'savelegend',0,'w',w,'h',h);            
            % -------------------------------------------
            
            % save figure ------------------------------------
            pSaveFig = fullfile(pM,'Figure',tname,strain);
            if ~isdir(pSaveFig); mkdir(pSaveFig); end
            
            savename = name;
            cd(pSaveFig);
            print(savename,'-dtiff'); 
            printfig(savename,pSaveFig,'w',w+0.5,'h',h+0.5)
            % -----------------------------------

        end
                
        
    end

end

%% save legend ----------------
figure1 = create_colorlegend(grad2,grad1,cm);
p = pM;
savename = 'legend';
print(savename,p,'w',10,'h',2);
% ---------------------------

% report done --------------
fprintf('\n--- Done ---\n\n' );
return
% --------------------------































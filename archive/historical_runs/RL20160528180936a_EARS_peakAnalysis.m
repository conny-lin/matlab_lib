% function ephys_accpeak_graph2_stats(strainT)

%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);

%% SETTING
pSF = '/Users/connylin/Dropbox/RL Pub InPrep - PhD Dissertation/4-STH genes/Data/10sIS by strains';

% setting others

        
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
        % get info
        timeName = timeNameList{ti};
        % load data
        p = sprintf('%s/%s/ephys graph/data_ephys_%s.mat',pSF,strain,timeName);
        load(p,'DataG');
        
        % 0-get universal information get groups
        DataT = struct2table(DataG);
        gn = DataT.name;
        [gns,gni] = output_sortN2first(gn);
        
        for gi = gni'
            % get time
            t = DataT.time{gi}(1,:);
            t1 = find(t==-0.5);
            t2 = find(t==-0.1);
            t0 = find(t==0);
            tr1 = find(t==0.1);
            tr2 = find(t==1);
            
            %% get data
            % don't need to capture worms that did not move at all because
            % those data were excluded previously
            Speed = DataT.speedb{gi};
            
            %% prepare data
            % 1 - baseline
            % baseline is defined as -0.5 - -0.1 before the tap
            BL = Speed(:,t1:t2);
            
            
            
            %% response within worms
            BLmean = nanmean(BL,2);
            BLsd = nanstd(BL')';
            BLmax = BLmean+(2*BLsd);
            BLmin = BLmean-(2*BLsd);
            
            % response at all within 1sec?
            RP = Speed(:,tr1:tr2);
            RPonset = nan(size(RP,1),1);
            for r = 1:size(RP)
                if ~isnan(BLmax(r)) % if worm moved before tap
                    b = RP(r,:) > BLmax(r) | RP(r,:) < BLmin(r);
                    a = find(b,1);
                    if ~isempty(a); RPonset(r) = a; end
                else % if worm did not move before tap and moved after tap
                    a = find(~isnan(RP),1);
                    if ~isempty(a); RPonset(r) = a; end

                end
            end
            RPonset
            %%
            % - peak(t/v)
            
            
            
            
           
            
            return
            
        end
        

        
       

    end

end
% end
fprintf('Done\n');



























    
    
    
    
    
    
    
    
    
    
    
    
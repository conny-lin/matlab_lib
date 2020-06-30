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
            
            % 1-baseline
            % baseline is defined as -0.5 - -0.1 before the tap within a
            % worm
            BL = Speed(:,t1:t2);
            
            % 2-response within worms
            BLmean = nanmean(BL,2);
            BLsd = nanstd(BL')';
            BLmax = BLmean+(2*BLsd);
            BLmin = BLmean-(2*BLsd);
            
            % response at all within 0.5 second
            RP = Speed(:,find(t==0.1):find(t==1));
            RPonset = nan(size(RP,1),1);
            RPonsetv = RPonset;
            
            for r = 1:size(RP)
                
                if ~isnan(BLmax(r)) % if worm moved before tap
                    
                    b = (RP(r,:) > BLmax(r) | RP(r,:) < BLmin(r));
                    a = find(b,1);
                    % if the worm responded
                    if ~isempty(a); 
                        v = RP(r,a);
                        % if response is pause, check if worm move another dir after
                        if v==0 
                            rp = RP(r,a:end);
                            rpd2 = rp(rp < 0); % accelerate or reverse
                            if ~isempty(rpd2)
                                a = find(RP(r,:)<0,1);
                                v = RP(r,a);
                            end
                        elseif v > 0 && v < BLmin(r)
                            rp = RP(r,a:end);
                            error('stop');
                            
                        end
                        % record decision
                        RPonset(r) = a;
                        RPonsetv(r) = v;
                    end
                end
            end
            % convert to time
            tref = t(find(t==0.1):find(t==1));
            RPonset(~isnan(RPonset)) = tref(RPonset(~isnan(RPonset)));
            
            %% calculate response direction (0, slow down (still+), acc or -, or NaN-not good data)
            % 0=pause, 0.5=slowdown, 1=acc, -1=reverse
            RPonsetDir = nan(size(RPonsetv));
            RPonsetDir(RPonsetv<BLmin & RPonsetv>0) = -0.5;
            RPonsetDir(RPonsetv>BLmax) = 1;
            RPonsetDir(RPonsetv==0) = 0;
            RPonsetDir(RPonsetv<0) = -1;
            
            
            %% - peak(t/v)
            PeakTime = nan(size(RP,1),1);
            PeakV = PeakTime;
            
            % positive peak
            i = RPonsetDir==1;
            RAcc = RP(i,:);
            RAcc(RAcc<0) = NaN;
            [m,k] = max(RAcc,[],2);
            PeakV(i) = m;
            PeakTime(i) = tref(k)';
            
            % negative peak (reverse)
            i = RPonsetDir==-1;
            R = RP(i,:);
            R(R>0) = NaN;
            [m,k] = max(R,[],2);
            PeakV(i) = m;
            PeakTime(i) = tref(k)';
           
            
            
           
            
            return
            
        end
        

        
       

    end

end
% end
fprintf('Done\n');



























    
    
    
    
    
    
    
    
    
    
    
    
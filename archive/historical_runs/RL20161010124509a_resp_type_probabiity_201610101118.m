
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);

%% GLOBAL INFORMATION
% paths & settings
pSave = fileparts(pM);
pData = '/Volumes/COBOLT/MWT';

% strains %------
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/Data/10sIS by strains';
strainlist = dircontent(pData);
% get strain info
strainNames = DanceM_load_strainInfo(strainlist);
%----------------

% time settings %--------
time_baseline = [-0.3 -0.1];
time_response = [0.1 0.5];
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
    
    % data -------------
    strain = strainNames.strain{si}; 
    p = fullfile(pData, strain,'ephys graph','data_ephys_t28_30.mat');
    load(p,'DataG');
    DataG = struct2table(DataG);
    gnlist = DataG.name; % get unique groups 
    % ----------------
    
    % get assay time ------------
    t = DataG.time{1}(1,:);
    i_baseline = find(t >= time_baseline(1) & t <= time_baseline(2));
    i_response = find(t >= time_response(1) & t<= time_response(2));
    % --------------------------
    
    for gi = 1:numel(gnlist) % cycle through groups
        
        gn = gnlist{gi}; % get gname
        
        %% DETERMINE RESPONSE TYPE --------------
        % input data ---------
        Baseline = DataG.speedb{gi}(:,i_baseline);
        Response = DataG.speedb{gi}(:,i_response);
        % -------------------
        
        % compute variables
RespType = cell(size(Baseline,1),1); % declare output array

% baseline range
baseline_max = max(Baseline')';
baseline_max = repmat(baseline_max, size(Response));
baseline_min = min(Baseline')'; 
baseline_min = repmat(baseline_min, size(Response));

% no response
Reponse


%% baseline direction
dir_baseline = Baseline(:,end);
v_baseline = Baseline(:,end); % velocity baseline

% response direction
d = Response;
d(d>0) = 1;
d(d<0) = -1;
dd = diff(d')';

% diff baseline/response
% response within baseline sem



% Baseline(Baseline > 0) = 1;
% Baseline(Baseline < 0) = -1;
% 
% b = nansum(Baseline,2); % baseline bias
% a = nan(size(b)); 
% a(b>0) = 1; % forward
% a(b<0) = -1; % reverse
% 
% a = [Baseline b a ];

        
        return
        % ----------------------------------
        %% get plate information

        
        
        
        
        
        
        %% old data --------------------------------------------
    % declare ephys data output
    EphysT = struct;

    
        % prepare local variables
        gn = gnlist{gi}; % get group name
        i = ismember(MWTDB.groupname, gn); % get index to mwt path
        pMWT = MWTDB.mwtpath(i); % get pMWT path
        % create group folder
        pSaveG = fullfile(pM, strain, gn); % create save path
        if isdir(pSaveG) == 0; mkdir(pSaveG); end

        for ti = 1:numel(startList) % cycle through time points 
            % get time
            start = startList(ti); 
            finish = endList(ti); 

            % get trinity data
            [Data,rTime,savename,mwtid,~] = TrinitySum_multiPlates(pMWT,finish,start);
            % save data
            p = fullfile(pSaveG,[savename,' rasterData.mat']);
            save(p,'pMWT','Data','mwtid','rTime');


            % make hot figure
            f1 = rasterPlot_colorSpeed_hot(Data);
            % get print path
            p = fullfile(pSaveG,'raster hot'); if ~isdir(p); mkdir(p); end
            % print
            set(f1,'PaperPositionMode','auto'); % set to save as appeared on screen
            cd(p); print (f1,'-depsc', '-r1200', savename); % save as eps
            print(f1,'-dtiff', savename); % save as (r600 will give better resolution)
            close;


            % make figure (green, jet)
            [f1,Img] = rasterPlot_colorSpeed_gradient2(Data,rTime,0);
            % get print path
            p = fullfile(pSaveG,'raster jet'); if ~isdir(p); mkdir(p); end
            % print
            set(f1,'PaperPositionMode','auto'); % set to save as appeared on screen
            cd(p); print (f1,'-depsc', '-r1200', savename); % save as eps
            print(f1,'-dtiff', savename); % save as (r600 will give better resolution)
            close;


            % make lava plot (sort proportion)
            f1 = moveproportion(Data,rTime,0);
            p = fullfile(pSaveG,'lava proportion plot'); if ~isdir(p); mkdir(p); end
            titlename = sprintf('%s/speed_dir_proportion_%s',p,savename);
            print(f1,'-depsc', titlename); 
            print(f1,'-dtiff', titlename); % save as (r600 will give better resolution)
            close;

            % electrophys
            M = nanmean(Data);
            EphysT(ti).(gn) = M';
            EphysT(ti).([gn,'_SE']) = (std(Data)./sqrt(size(Data,1)-1))';

        end

    end
    
    % write electrophys data
    p = fullfile(pM,strain,'ephys data.mat');
    save(p,'EphysT');
    

    
end

fprintf('\n--- Done ---' );
return
% 
% 
% 
% %% old code
% 
% pSaveA = [pSaveHome,'/rasterPlots'];
% if isdir(pSaveA) == 0; mkdir(pSaveA); end
% 
% for ti = 1:numel(startList) % raster plot per time points
%     % get time
%     start = startList(ti);
%     finish = endList(ti);     
%     
%     % set up table array for electrophys
%     T = table; % for electrophys
%     
%     for gi = 1:numel(groupnameList) % cycle through groups
%         gn = groupnameList{gi};
%         pMWTG = pMWT(ismember(Db.groupname,gn));
%         pSaveG = [pSaveA,'/',gn];
%         if isdir(pSaveG) == 0; mkdir(pSaveG); end
%         
%         %% run raster
%         [f1,Data,savename,Tog,mwtid,rTime,Import] = rasterPlot_colorSpeed(pMWTG,start,finish,...
%             'NWORMS',NWORMS,'visibleG',0,'frameInt',frameInt);
%         
%         %% save trinity import
%         if isempty(dircontent(pSaveG,'trinity.mat')) == 1
%             cd(pSaveG); save('trinity.mat','Import','-v7.3');
%         end
%         
%         %% save fig
%         cd(pSaveG);
%         set(f1,'PaperPositionMode','auto'); % set to save as appeared on screen
%         print (f1,'-depsc', '-r1200', savename); % save as eps
%         close;
%         
%         % save data
%         save(sprintf('%s/%s rasterData.mat',pSaveG,savename),'pMWT','Data','mwtid','Tog','rTime');
%                
%         % electrophys
%         D = Data;
%         M = mean(D);
%         T.(gn) = M';
%         T.([gn,'_SE']) = (std(D)./sqrt(size(D,1)-1))';
% %         T.([gT,'_N']) = size(D,1);
%     end
%     writetable(T,sprintf('%s/ef graph %d-%d.csv',pSaveA,t1,t2));
% end
% fprintf('\n\nDONE\n');
% 
% %% COMPOSIT
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 

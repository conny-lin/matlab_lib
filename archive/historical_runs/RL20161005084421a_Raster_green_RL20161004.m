%% get raster plot for all strains
% must all have trinity.mat

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
% create time frames
startList = [98 238 368];
assaywindow = 30;
endList = startList+assaywindow;
frameInt = 0.2; %(ed20161004)
NWORMS = Inf;
expLimit = 'N2 within';
% strains
strainNames = DanceM_load_strainInfo;
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/Data/10sIS by strains';


%% RASTER PLOT - RED
%% cycle through strains
load(fullfile(pData,'BZ142','MWTDB.mat')); % get strain pMWT paths

return
% get trinity files
% cycle through time list



pSaveA = [pSaveHome,'/rasterPlots'];
if isdir(pSaveA) == 0; mkdir(pSaveA); end

for ti = 1:numel(startList) % raster plot per time points
    % get time
    start = startList(ti);
    finish = endList(ti);     
    
    % set up table array for electrophys
    T = table; % for electrophys
    
    for gi = 1:numel(groupnameList)
        gT = groupnameList{gi};
        pMWTG = pMWT(ismember(Db.groupname,gT));
        pSaveG = [pSaveA,'/',gT];
        if isdir(pSaveG) == 0; mkdir(pSaveG); end
        
        %% run raster
        [f1,Data,savename,Tog,mwtid,rTime,Import] = rasterPlot_colorSpeed(pMWTG,start,finish,...
            'NWORMS',NWORMS,'visibleG',0,'frameInt',frameInt);
        
        %% save trinity import
        if isempty(dircontent(pSaveG,'trinity.mat')) == 1
            cd(pSaveG); save('trinity.mat','Import','-v7.3');
        end
        %% save fig
        cd(pSaveG);
        set(f1,'PaperPositionMode','auto'); % set to save as appeared on screen
        print (f1,'-depsc', '-r1200', savename); % save as eps
        close;
        % save data
        save(sprintf('%s/%s rasterData.mat',pSaveG,savename),'pMWT','Data','mwtid','Tog','rTime');
               
        % electrophys
        D = Data;
        M = mean(D);
        T.(gT) = M';
        T.([gT,'_SE']) = (std(D)./sqrt(size(D,1)-1))';
%         T.([gT,'_N']) = size(D,1);
    end
    writetable(T,sprintf('%s/ef graph %d-%d.csv',pSaveA,t1,t2));
end
fprintf('\n\nDONE\n');

%% COMPOSIT




























%% get raster plot for all strains

%% get strain names

%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);

%% paths & settings
pSave = pM;
pData = '/Volumes/COBOLT/MWT';
% create time frames
startList = [98 238 368];
assaywindow = 30;
endList = startList+assaywindow;
frameInt = 0.2; %(ed20161004)
NWORMS = Inf;
expLimit = 'N2 within';


%% load
load(fullfile(fileparts(pM),'Dance_Glee_Showmance.mat'));
pMWT = MWTSet.Data.Raw.pMWT;
pMWT(~cellfun(@isdir, pMWT)) = []; % check valid path (ed20161004)
% parse pMWT into groups
Db = parseMWTinfo(pMWT);
groupnameList = unique(Db.groupname);

return

%% CHOR
pMWTc = convertTrinityDat2Mat(pMWT,1); 
L = chormaster4('Trinity',pMWTc);
% summarize trinity data and delete .dat file to save memory
pMWTbad = convertTrinityDat2Mat(pMWTc,1); 
% exclude bad files
pMWToriginal = pMWT;
pMWT(ismember(pMWT,pMWTbad)) = [];

%% raster plot per time points
pSaveA = [pSaveHome,'/rasterPlots'];
if isdir(pSaveA) == 0; mkdir(pSaveA); end

for ti = 1:numel(startList)
    start = startList(ti);
    finish = endList(ti);        
    T = table; % for electrophys
    for gi = 1:numel(groupnameList)
        gT = groupnameList{gi};
        pMWTG = pMWT(ismember(Db.groupname,gT));
        pSaveG = [pSaveA,'/',gT];
        if isdir(pSaveG) == 0; mkdir(pSaveG); end
        % run raster
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

%% old
% %% electrophys graph
% for ti = 1:numel(startList)
%     t1 = startList(ti);
%     t2 = endList(ti);
%     for gi = 1:numel(groupnameList)
%         gT = groupnameList{gi};
%         pSave = sprintf('%s/%s/%s/%s',pDest,strainName,gT);
%         pSave = regexprep(pSave,'[/]\>','');
%         if isdir(pSave) == 1
%             [f,p] = dircontent(pSave);
%             if isempty(f) == 0
%                 str = sprintf('[_]%d[_]%d(?=[_])',t1,t2);
%                 i = regexpcellout(f,str) & regexpcellout(f,'mat\>');
% 
%                 D = load(p{i},'Data');
%                 D = D.Data;
%                 M = mean(D);
%             %     N = size(D,1);
%             %     SE = std(D)./sqrt(size(D,1)-1);
%                 T.(gT) = M';
%             end
%         end
%     end
% 
%     pHome =fileparts(pSave);
%     writetable(T,sprintf('%s/ef graph %d-%d.csv',pHome,t1,t2));
% end
% 
% 
% 
% fprintf('\n\nDONE, and below strains did not work:\n');
% % disp(char(strainList(~strainSuccess)));
% 
% 
% 
% 
% 
% 
% return
% % D = Data;
% % % plot all data
% % plot(D','Color',[0.8 0.8 .8]); hold on
% % savefigepsOnly150([savename,' ef all'],pSave);
% % 
% % M = mean(D);
% % N = size(D,1);
% % SE = std(D)./sqrt(size(D,1)-1);
% % 
% % % plot(M+SE,'Color',[0 0 0])
% % t = table; 
% % t.mean = M';
% % t.mse1 = (M+SE)';
% % t.mse2 = (M-SE)';
% % writetable(t,sprintf('%s/ef graph.csv',pSave));
% % 
% % %%
% % 
% % 
% % bv = min(M-(2*SE));
% % area(M+(2*SE),'basevalue',bv,'FaceColor',[.5 .5 .5],'EdgeColor','none')
% % hold on
% % 
% % area(M-(2*SE),'basevalue',bv,'FaceColor',[1 1 1],'EdgeColor','none')
% % % plot(M-SE,'Color',[0 0 0])
% % line([1:size(D,2)+1],zeros(1,size(D,2)+1),'Color',[0 0 0])
% 
% 
% 
% 
% %% TROEBLE SHOOTING - remove no tap plate
% % load raster plot .mat output
% cd(pSave); 
% load('rasterPlot_98_108_N_680 rasterData.mat','Data');
% load('rasterPlot_98_108_N_680 rasterData.mat','rTime');
% load('rasterPlot_98_108_N_680 rasterData.mat','mwtid');
% %% find no reversals
% t1 = 11;
% t2 = 15;
% d = Data(:,t1:t2);
% rev = sum(d < 0.2,2); % reversals
% pause = sum(d==0,2); % pause
% [s,gn,n] = grpstats(rev,mwtid,{'sum','gname','numel'});
% t = table;
% t.mwtid = cellfun(@str2num,gn);
% t.sum = s;
% t.N = n.*(t2-t1+1);
% t.p = t.sum./t.N;
% t
% % selection
% ip = t.mwtid(t.p > 0.8);
% 
% 
% 
% A = parseMWTinfo(pMWT);
% A.expname(ip)





























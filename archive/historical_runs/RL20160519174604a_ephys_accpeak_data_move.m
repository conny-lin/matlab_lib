%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',false);


%% SETTING
pSF = '/Users/connylin/Dropbox/RL/PubInPrep/PhD Dissertation/4-STH genes/Data/10sIS by strains';

strainlist = dircontent(pSF);
strainlist(~ismember(strainlist,'BZ142')) = [];


%% load data
for si =1:numel(strainlist)
% get strain info
strain = strainlist{si};
fprintf('%d/%d: %s\n',si, numel(strainlist), strain);
% load data for strain
pData = sprintf('%s/%s/data_ephys_t28_30.mat',pSF,strain);

%% pDest folder
pDestF = sprintf('%s/%s/ephys graph',pSF,strain);

%%
exist(pData,'file')
if exist(pData,'file')==7 && isdir(pDestF)
%     ps = pData;
%     pd = sprintf('%s/data_ephys_t28_30.mat',pDestF);
%    movefile(ps,pd)
   'copy' 
end

return
load([pData,'/data_ephys_t28_30.mat'],'DataG');
pSave = pM;


return


end

fprintf('Done\n');




























    
    
    
    
    
    
    
    
    
    
    
    
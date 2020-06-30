%% raster plot data all strains

%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
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
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
% get strain info
s = dircontent(pData);
strainNames = DanceM_load_strainInfo(s);
pathwayseq = {'VGK'
    'neuropeptide'
    'Synaptic'
    'Neuroligin'
    'Gluamate'
    'Dopamine'
    'G protein'
    'Gai'
    'Gaq'
    'Gas'
    'TF'};
strainNames.seq = zeros(size(strainNames,1),1);

    
y = 1;
for x = 1:numel(pathwayseq)
    i = ismember(strainNames.pathway,pathwayseq{x});
    
    k = sum(i);
    strainNames.seq(i) = y:y+k-1;
    y = y+k;
end
strainNames = sortrows(strainNames,{'seq'});
strainlist = strainNames.strain;
%----------------


%% check incomplete =======================================================
needDance = true(size(strainNames,1),1);
for si = 1:size(strainNames.strain,1)
    % strain info +++++
    strain = strainNames.strain{si};
    genotype = strainNames.genotype{si};
    % ------------------
    
    % report progress %------------
%     fprintf(''); % separator
%     processIntervalReporter(numel(strainlist),1,'*** strain ****',si);
    % ------------------------------
   
    % create save path +++++++++++++++++++
    prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
    suffix = 'Raster/Dance_Raster';
    pSave = fullfile(prefix,strain,suffix);
    % -----------------------------------

    % check if has dance result +++++++++++
    if isdir(pSave)
        
        % load data +++++++++++++++++++
        prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
        suffix = 'MWTDB.mat';
        p = fullfile(prefix,strain,suffix);
        load(p);
        % ---------------------------------
        
        %% check if last group has raster plot 389
        gnlist = unique(MWTDB.groupname);
        gnlast = gnlist{end};
        p = fullfile(pSave,gnlast);
        if isdir(p)
            a = dircontent(p);
            i = regexpcellout(a,'rasterPlot_389');
            k = sum(i)==1;
            if k
               needDance(si) = false;
               fprintf('%s done\n',strain)
            end
        end
    end
    % -----------------------------------

end
strainNames = strainNames(needDance,:);
% =========================================================================




%% cycle through strain ===================================================
for si = 1:size(strainNames.strain,1)
    % strain info +++++
    strain = strainNames.strain{si};
    genotype = strainNames.genotype{si};
    % ------------------
    
    % report progress %------------
    fprintf(''); % separator
    processIntervalReporter(size(strainNames.strain,1),1,'*** strain ****',si);
    % ------------------------------
   
    % create save path +++++++++++++++++++
    prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
    suffix = 'Raster';
    pSave = fullfile(prefix,strain,suffix);
    % -----------------------------------

    % load data +++++++++++++++++++
    prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
    suffix = 'MWTDB.mat';
    p = fullfile(prefix,strain,suffix);
    load(p);
    % ---------------------------------

    % check if all MWTDB are dir ++++++++++
    i = cellfun(@isdir,MWTDB.mwtpath);
    if sum(i) ~= numel(i)
       MWTDB(~i,:) = [];
       if isempty(MWTDB)
           error('no data');
       end
    end
    % ---------------------------------- 


    % dance raster ++++++++++++++++
    if ~isempty(MWTDB)
        Dance_Raster(MWTDB,'pSave',pSave,'graphopt',0);
    end
    % ----------------------------
    
    % clear command window +++++++
    clc;
    % -----------------------------------

end
% =========================================================================






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
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
% get strain info
s = dircontent(pData);
strainNames = DanceM_load_strainInfo(s);
strainNames = sortrows(strainNames,{'strain'});
strainlist = strainNames.strain;

%----------------

%% Organize
pDS = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/2-EARS/Summary v3/ephys_accpeak_graph_vbm';
[~,dataname_source] = fileparts(pDS);
[f,~,ff,~] = dircontent(pDS);
pmat = fullfile(pDS,[dataname_source,'.mat']);

%%
foldername_dest = 'Ephys';

for si = 3:numel(strainlist)
    % report progress +++++
    fprintf(''); % separator
    processIntervalReporter(numel(strainlist),1,'strain',si);
    % ---------------------

    % strain specific data % +++++
    strain = strainNames.strain{si}; 
    pDestStrain = fullfile(pData,strain);
    pS = create_savefolder(pDestStrain,foldername_dest);
    pSave = create_savefolder(pS,dataname_source);

    % ----------------------------
    
    % move matlab files ++++
    ps = pmat;
    pd = fullfile(pSave,f);
    copyfile(ps,pd);
    % ----------------------
 
    
   % move files (file,multiple folders) ++++++
    fns = {'Graph csv t1', 'Graph csv t28_30'};
    for fi = 1:numel(fns);
        psource = fullfile(pS,fns{fi});
        [files,pfiles,folder,pfolder] = dircontent(psource);
        regexpcellout(psource,['^',strain])
        return
        %%
        i = ismember(files,folder);
        files(i) = [];
        pfiles(i) = [];
        pfs = files(regexpcellout(files,['^',strain]));
        if ~isempty(pfs)
            for x = 1:numel(pfs)
                pf = pfs{x};
                ps = pf;

                [~,f] = fileparts(ps);
                pd = fullfile(pS,f);
                movefile(ps,pd)
            end
        end
    end
    % -----------------
    
%     % move files (file) ++++++
%     [files,pfiles,folder,pfolder] = dircontent(pDS);
%     i = ismember(files,folder);
%     files(i) = [];
%     pfiles(i) = [];
%     pfs = files(regexpcellout(files,['^',strain]));
%     if ~isempty(pfs)
%         for x = 1:numel(pfs)
%             pf = pfs{x};
%             ps = pf;
%             
%             [~,f] = fileparts(ps);
%             pd = fullfile(pS,f);
%             movefile(ps,pd)
%         end
%     end
%     % -----------------
%     
end


return

%%
foldername_dest = 'Etoh sensitivity';

for si = 3:numel(strainlist)
    % report progress +++++
    fprintf(''); % separator
    processIntervalReporter(numel(strainlist),1,'strain',si);
    % ---------------------

    % strain specific data % +++++
    strain = strainNames.strain{si}; 
    pstrain = fullfile(pData,strain);
    pS = create_savefolder(pstrain,foldername_dest);
    pS = create_savefolder(pS,dataname_source);

    % ----------------------------
    
    % move matlab files ++++
    f = [dataname_source,'.m'];
    ps = fullfile(pDS,f);
    pd = fullfile(pS,f);
    copyfile(ps,pd);
    % ----------------------
    
    % move files  ++++++
    
    [files,pfiles,folder,pfolder] = dircontent(pDS);
    i = ismember(files,folder);
    files(i) = [];
    pfiles(i) = [];
    pfs = files(regexpcellout(files,['^',strain]));
    if ~isempty(pfs)
        for x = 1:numel(pfs)
            pf = pfs{x};
            ps = pf;
            
            [~,f] = fileparts(ps);
            pd = fullfile(pS,f);
            movefile(ps,pd)
%             if isdir(ps)
%                 pd = fullfile(pS);
%                 movefile(ps,pd)
%             end
        end
    end
    % -----------------
    
end
































%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',false); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% OVERALL VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
pDataBase = '/Volumes/COBOLT/MWT';
pData = fullfile(fileparts(pM),'Data');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808

%% ADD NEW DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
MWTDatabase_v2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808


%% GET STRAIN INFO FROM CURRENT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
% get group names
[fn,pM] = dircontent(pData);
% minus archive code folder
pM(regexpcellout(fn,'[_]')) = [];
% get gene names
[fn,pM] = cellfun(@dircontent,pM,'UniformOutput',0);
pM = celltakeout(pM);
% get strain names
[fn,pM] = cellfun(@dircontent,pM,'UniformOutput',0);
pstrains = celltakeout(pM);
strainnames = celltakeout(fn);
% get gene name
pM = cellfun(@fileparts,pstrains,'UniformOutput',0);
[pM,genenames] = cellfun(@fileparts,pM,'UniformOutput',0);
% get groupname
[pM,groupnames] = cellfun(@fileparts,pM,'UniformOutput',0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808


%% SEE IF ANY NEW STRAINS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
strainDataU = unique(regexprep(strainnames,' New',''));
c = numel(strainDataU);
[pMWT,MWTDB,Set]  = search_MWTDB('rc','100s30x10s10s','rx','400mM');
a = unique(MWTDB.groupname);
b = numel(a)-1;
if c~=b
    error('new strains')
else
    fprintf('no new strains\n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808


%% GET TIME FROM ANALYZED DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
f = 'Dance_ShaneSpark5'; % reference folder name
folderupdate = false(size(strainnames));
t = todatenum(cdfepoch('07-Jun-1999 14:04:42'));
folderdates = repmat(t,size(strainnames));
for si = 1:numel(strainnames) % for each strain folder
    % get last analysis time from folders
    p = pstrains{si};
    % get folder time
    t = foldertime(p,'file');
    % get folder names
    fn = dircontent(p);
    % get time stampe for dance
    i = ismember(fn,f);

    if sum(i) == 0 % if no shanespark5, 
        folderupdate(si) = true; % consider old
    else % if has 5, check dates
        folderdates(si) = t(i);
    end    
end
% get max time for analysis folders
AtimeMax = max(folderdates);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808


%% GET DATABASE TIME STAMP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
[DBtime,DBDir] = foldertime(pDataBase);
DBtimeMax = max(DBtime);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808


%% ANALYSIS FOLDERS WITH NEW DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
if AtimeMax < DBtimeMax
    datestr(DBtimeMax)
    datestr(AtimeMax)
    % find DB time later than analysis time
    i = DBtime > AtimeMax;
    % get expname
    e = {DBDir(i).name};
    % search database
    [pMWT,MWTDB,Set]  = search_MWTDB('expname',e,...
                        'rc', '100s30x10s10s',...
                        'rx','400mM');
    % get strains
    strainNewData = unique(MWTDB.strain);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808


%% ANALYZE NEW DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
for si = 1:numel(strainNewData) % for each strain
    strain = strainNewData{si}; % strain name
    % get pSave
    pSaveStrain = pstrains{ismember(strainnames,strain)};
    % get pMWT ----------
    % create group name
    g = [strain,'_400mM'];    
    % search database
    [~,DB]  = search_MWTDB('groupname',g,'rc','100s30x10s10s');
    e = unique(DB.expname); % get target exp
    % create group list
    g = {'N2','N2_400mM',strain,g};
    % search database
    pMWT  = search_MWTDB('expname',e,'groupname',g,'rc','100s30x10s10s');
    % analysis 
    Dance_ShaneSpark_v1707(pMWT,pSaveStrain)
    Dance_rType2_v1707(pMWT,pSaveStrain);
    Dance_InitialEtohSensitivityPct_v1707(pMWT,pSave);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808



%% FINISH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
fprintf(' END \n');
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808


























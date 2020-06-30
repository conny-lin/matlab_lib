%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSaveM = setup_std(mfilename('fullpath'),'RL','genSave',false);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%


%% OVERALL VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
pDataBase = '/Volumes/COBOLT/MWT';
pData = '/Users/connylin/Dropbox/Publication/Manuscript RL Alcohol Genes/Figures Tables Data/Tbl2 genetic screen result summary/Data_by_ortholog/Data';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808


%% GET STRAIN INFO FROM CURRENT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
% get category names
[fn,pM] = dircontent(pData);
% minus archive code folder
pM(regexpcellout(fn,'[_]')) = [];
% get strain paths
[~,pM] = cellfun(@dircontent,pM,'UniformOutput',0);
pM = celltakeout(pM);
[fn,pM] = cellfun(@dircontent,pM,'UniformOutput',0);
pstrains = celltakeout(pM);
% get strain names
strainnames = celltakeout(fn);
% get gene name
pgenes = cellfun(@fileparts,pstrains,'UniformOutput',0);
[pcategory,genenames] = cellfun(@fileparts,pgenes,'UniformOutput',0);
% get groupname
[~,catnames] = cellfun(@fileparts,pcategory,'UniformOutput',0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808


%% RE-ORGANIZE, COMBINE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
% find folder without new
pstrainNew = pstrains(regexpcellout(strainnames,'New'));
% get strain names
[pH,strainNew] = cellfun(@fileparts,pstrainNew,'UniformOutput',0);
% for each strain, combine
for si = 1:numel(strainNew)
    strain = regexprep(strainNew{si},' New',''); % get strain name
    i = ismember(strainnames,strain);
    fprintf('%s\n',strain)
    pStrainFNew = pstrainNew{si}; % source path
    if sum(i) == 0 % if no old data, 
       % just remove the new from the directory name
       pd = fullfile(pH{si},strain); % des path
       if ~isdir(pd); mkdir(pd); end % create folder if that's not a folder yet
       movefile(pStrainFNew,pd); % move data
    else % if old data, combine
       % find old data
       pOld = pstrains{i};
       % find fn
       [fStrainNewContent,pStrainFNewContent] = dircontent(pStrainFNew);
       % create new paths to old folder
       a = cellfunexpr(fStrainNewContent,pOld);
       pNewcontent = cellfun(@fullfile,a,fStrainNewContent,'UniformOutput',0);
       % check old folder dir
       [~,pOldcontent] = dircontent(pOld);
       % check over lap
       pOverlap = intersect(pOldcontent,pNewcontent);
       if numel(pOverlap)>0
           % get extensions
           b = regexpcellout(pOverlap,'[.]','split');
           prefix = b(:,1);
           suffix = b(:,2);
           % treat folder and file differently
           i = cellfun(@isempty,suffix);
           suffix(i) = {''};
           a = suffix(~i);
           b = strjoinrows([cellfunexpr(a,'.') a],'');
           suffix(~i) = b;
           % create new
           inserttext= cellfunexpr(prefix,' 20170808');
           % combine new path name
           pd = strjoinrows([prefix inserttext suffix],'');
           % move intersect
           ps = pOverlap;
           cellfun(@movefile,ps,pd);
           % update 
          [fStrainNewContent,pStrainFNewContent] = dircontent(pStrainFNew);
       end
       % move non overlapping
       pd = regexprep(pStrainFNewContent,pStrainFNew,pOld); % get des
       ps = pStrainFNewContent; % get sources
       cellfun(@movefile,ps,pd); % move data
    end
    
    if isdir(pStrainFNew)
        if isempty(dircontent(pStrainFNew))
            rmdir(pStrainFNew)
        else
            disp(pStrainFNew)
            error('still something remains')
        end    
    end
end







return

















AfolderTarget = {'Etoh sensitivity','Raster','TAR','TWR'};
% for each folder
for fi = 1:numel(pstrainOld)
    pStrain = pstrainOld{fi}; % get strain folder path
    % for each analysis folder targets
    for ai = 1:numel(AfolderTarget)
        % get paths to analysis folder
        pA = fullfile(pStrain,AfolderTarget{ai});
        
        if isdir(pA) % if directory exist
            % find analysis sub-folders
            [fSub,~] = dircontent(pA);
            % check if group folder has folder content
            [fStrain,~,~,pAfolders] = dircontent(pStrain);
            % check if any empty, 
            [~,p] = cellfun(@dircontent,pAfolders,'UniformOutput',0);
            i = cellfun(@isempty,p);
            if sum(i) > 0 % if any empty
                p = pAfolders(i); % get folder paths
                cellfun(@rmdir,p,cellfunexpr(p,'s')) % delete
                % reconstruct folder list
                [fStrain,~,~,pAfolders] = dircontent(pStrain);
            end            
            % check if duplicates in strain home folder
            a = intersect(fSub,fStrain);
            if ~isempty(a)               
               % show error
               % strain
               [p,s] = fileparts(pStrain);
               % group
               [p,g] = fileparts(p);
               % folder
               [p,f] = fileparts(p);
               % display
               fprintf('%s/%s/%s\n',f,g,s);
               % problem folder
               disp(a);
               error('already duplicate name'); 
            end
            % move folder and files up under the strain
            for ffi = 1:numel(fSub)
                fname = fSub{ffi};
                ps = fullfile(pA,fname);
                pd = fullfile(pStrain,fname);
                movefile(ps,pd)
            end
            % if group folder empty
            if isempty(dircontent(pA))
                rmdir(pA,'s'); % delete group folder
            else
                % find out what other files are still there                
                error('still something in the folder');
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808



















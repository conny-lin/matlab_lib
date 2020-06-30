
%% SCRIPT: COMBINE MULTIPLE ANALYSIS (old Dance)

%% PATHS
% function paths
addpath('/Users/connylin/OneDrive/MATLAB/Functions_Developer');

% folder paths (contains subfolders)
pDH = '/Users/connylin/OneDrive/Dance Output/';
pDF = [pDH,'cnb-1/Shane sparks Ava All/KJ300'];

%% OPTIONS
OPT.fixGroupName = true;


%% GET DATA: MWTInfo
% get all folder paths
[~,~,f,pF] = dircontent(pDF);
% get all pMWTf
% decalre output
pMWTf = {}; 
FolderIndex = [];
for x = 1:numel(pF)
    % get mat files paths
    [~,p] = dircontent(pF{x},'matlab.mat');
    d = load(char(p),'pMWTf'); % load matfiles
    % reorganize 
    pMWTf = [pMWTf; d.pMWTf];
    FolderIndex = [FolderIndex; repmat(x,numel(d.pMWTf),1)];
end

% get MWT folder name
[pG,MWTfn] = cellfun(@fileparts,pMWTf,'UniformOutput',0);

% get group names
[pExp,groupNames] = cellfun(@fileparts,...
    cellfun(@fileparts,pMWTf,'UniformOutput',0),'UniformOutput',0);
% get exp names
[~,expNames] = cellfun(@fileparts,...
    cellfun(@fileparts,...
    cellfun(@fileparts,pMWTf,'UniformOutput',0),...
    'UniformOutput',0),'UniformOutput',0);

% [OPTIONAL] fix age correct folder names 
if OPT.fixGroupName == true
    [~,~,f,pF] = dircontent(pDF);
    a = regexpcellout(f,'_','split');
    a = a(:,3); 
    a = regexprep(a,'96hr',''); % replace 96hours as none

    % fix group names
    for x = 1:numel(a)
        if isempty(a{x}) == 0
            groupNames(FolderIndex == x,1) = ...
                strcat(groupNames(FolderIndex == x),...
                strcat({'_'},a(x)));
        end
    end
end


% GET RAW DATA: MWTfnImport
MWTfnImport = [];
for x = 1:numel(pF)
    % get mat files paths
    [~,p] = dircontent(pF{x},'matlab.mat');
    d = load(char(p),'MWTfnImport'); % load matfiles
    % reorganize 
    MWTfnImport = [MWTfnImport;d.MWTfnImport];
end
% make sure MWTfnImport aligns with pMWTf
if isequal(MWTfn, MWTfnImport(:,1)) ~=1
    display('fixing MWTfnImport sequence');
   [~,i] = ismember(MWTfnImport(:,1),MWTfn);
   MWTfnImport = MWTfnImport(i,:);
end

% construct MWTInfo
MWTInfo = table;
MWTInfo.groupNames = groupNames; clear groupNames
MWTInfo.MWTfn = MWTfn; clear MWTfn
MWTInfo.datImport = MWTfnImport(:,2); clear MWTfnImport
MWTInfo.expNames = expNames; clear expNames
[~,~,f,pF] = dircontent(pDF);
MWTInfo.analysisFolder = f(FolderIndex); clear FolderIndex
MWTInfo.path = pMWTf; clear pMWTf

%% CALCULATE
[MWTInfo,MWTStats] = Dance_ShaneSpark_AfterParty(MWTInfo);
% save work
cd(pDF); save('AfterParty.m','MWTInfo','MWTStats','pDH');

%% GRAPH
% repeatControl = 1;
% while repeatControl ==1
%     % select groups for graphing
%     display('select groups for graphing');
%     gnameS = chooseoption(MWTStats.groupNames,2);
%     [~,i] = ismember(MWTStats.groupNames,gnameS);
%     i = i(i>0);
%     analysisNames = {'RevFreq','RevDur','RevSpeed'};
%     for x = 1:numel(analysisNames)
%         aa = analysisNames{x};
%         Y = cell2mat(MWTStats.([aa,'_Mean'])(i)');
%         E = cell2mat(MWTStats.([aa,'_SE'])(i)');
%         X = repmat([1:size(E,1)]',1,size(E,2));
%         N = MWTStats.NPlateValid(i);
%         AnalysisName = aa;
%         AfterParty_Fig_Hab_2Groups(X,Y,E,N,gnameS,AnalysisName)
%         savefigepsOnly([AnalysisName,'_AfterParty ',strjoin(gnameS')],pDF);
%     end
% 
%     repeatControl = input('do you have more graphs to make (1 = yes, 0 = no)?');
% 
% end




% %% correct for problem plates
% % i = strcmp(MWTStats.groupNames,'N2');
% MWTStats.RevSpeed_Mean{strcmp(MWTStats.groupNames,'N2')}
% 
% %%
% A = cell2mat(MWTInfo.RevSpeed(strcmp(MWTInfo.groupNames,'N2'))');
% 
% i= isnan(A);
% sum(i)







































% combine data (exclude duplicates) ,'Graph','MWTfG'




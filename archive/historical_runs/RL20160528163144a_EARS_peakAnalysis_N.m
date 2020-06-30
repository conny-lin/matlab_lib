% function ephys_accpeak_graph2_stats(strainT)

%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);

%% SETTING
pSF = ['/Users/connylin/Dropbox/RL Pub InPrep - PhD Dissertation/',...
    '4-STH genes/Data/10sIS by strains'];
        
% setting - strains
strainlist = dircontent(pSF);
% strainlist(~ismember(strainlist,'NM1968')) = [];

% setting - time
timeNameList = {'t28_30','t1'};



%% set up output array
rown = numel(strainlist);
coln = numel(timeNameList)*4;
Narray = nan(rown,coln);
Nleg_row = strainlist;
a = {'N2','N2_400mM','Mut','Mut_400mM'}';
b = cell(numel(timeNameList),1);
for gi = 1:numel(timeNameList)
    b{gi} = strjoinrows([cellfunexpr(a,timeNameList{gi}),a],'_');
end
Nleg_col = celltakeout(b);

%% run through all strains
for si =1:numel(strainlist) 
    % get strain info
    strain = strainlist{si}; fprintf('%d/%d: %s\n',si, numel(strainlist), strain);
    
    coli = [1:4;5:8];
    for ti = 1:numel(timeNameList)
        % load data
        load(sprintf('%s/%s/ephys graph/data_ephys_%s.mat',pSF,strain,timeName{ti}));
        
        
        DataT = struct2table(DataG); % convert to table
        [~,i] = output_sortN2first(DataT.name);
        [n,b] = cellfun(@size,DataT.speedb);
        n = n(i);
        Narray(si,coli(ti,:)) = n;
    end
    
end

%% transform to table
T = array2table(Narray,'VariableNames',Nleg_col,'RowNames',strainlist);
cd(pM);
writetable(T,'EARS_N.csv','WriteRowName',1)

%% end

fprintf('Done\n');


























    
    
    
    
    
    
    
    
    
    
    
    
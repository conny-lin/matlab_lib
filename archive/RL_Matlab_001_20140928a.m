%% OBJECTIVE:
% Convert N2 Within Exp_ShaneSpark_201403111939 matlab.mat descriptive 
% stats to N by experiment


%% 1. clear memory
clear


%% 2. Add funciton path
addpath('/Users/connylin/OneDrive/MATLAB/Functions_Developer');


%% 3. load data
pO = '/Users/connylin/Downloads/N2 Within Exp_ShaneSpark_201403111939';
Import = load([pO,'/matlab.mat']);


%% 3. get grouping plate number
% define output legend
fileNameL = {'expName','groupName','plateName'};
% get plate path from pMWT
[~,n] = cellfun(@fileparts,Import.MWTSet.pMWTchorpass,'UniformOutput',0);
% check if MWTfn are unique
if numel(unique(Import.MWTSet.Raw.MWTfn)) ~= numel(Import.MWTSet.Raw.MWTfn);
    error('duplicate MWTfn');
end
% get paths for MWTSet.Raw.MWTfn
i = ismember(n,Import.MWTSet.Raw.MWTfn);
% get original path
pMWT = Import.MWTSet.pMWT(i);
% get plate name
[pGroup,plateName] = cellfun(@fileparts,pMWT,'UniformOutput',0);
% get group names
[pExp,groupName] = cellfun(@fileparts,pGroup,'UniformOutput',0);
% get exp names 
[pH,expName] = cellfun(@fileparts,pExp,'UniformOutput',0);


%% get unique combinations of expName and groupName separate by /
% create / separator
a = cellfunexpr(expName,'/');
% combine expName and groupName
n = strcat(expName,a,groupName);
% find unique combo
comboName = unique(n);


% check if pH has only one unique value
if numel(unique(pH)) ~= 1; 
    error('can not process because found more than one Database path'); 
end


% replace exp/group name to path
uniqueGroupPath = strcat(...
        cellfunexpr(comboName(:,1),char(unique(pH))),...
        cellfunexpr(comboName(:,1),'/'),...
        comboName(:,1)...
        );


    
%% create index to plates for each group
% search pGroup to see find plate index
% some group will not have data, don't know why
plateInd = cell(size(uniqueGroupPath));
expPlateN = nan(size(uniqueGroupPath));
n = 0;
for x = 1:numel(uniqueGroupPath);
    % get index
    i = ismember(pGroup,uniqueGroupPath{x});
    plateInd{x} = find(i);
    % get plate N per group
    expPlateN(x) = sum(i);

%     % display progress
%     j = sum(i);
%     n = n+sum(i);
%     display(sprintf('[%d] %d found, total %d/%d plates',...
%         x,j,n,numel(pMWT)));
end

% get rid of experiment with 1 plate or less 
i = expPlateN <= 1;
uniqueGroupPath(i) = [];
plateInd(i) = [];
expPlateN(i) = [];


%% get only exp that has both groups
% exp names exists in both groups
% find unique exp name name
expNameU = unique(expName);
% find unique group name
groupNameU = unique(groupName);

% find number of group name under each unique experiment name
a = zeros(size(expNameU));
for e = 1:numel(expNameU)
    a(e) = numel(unique(groupName(ismember(expName,expNameU(e)))));
end

% find experiment name that has all group names
% find number of unique group names
validExpi = ismember(expName,expNameU(a == numel(groupNameU)));
valExpName = unique((expName(validExpi)));

% get exp name from uniqueGroupPath
[pExp,~] = cellfun(@fileparts,uniqueGroupPath,'UniformOutput',0);
[~,name] = cellfun(@fileparts,pExp,'UniformOutput',0);

% find exp that matches valid exp
i = ~ismember(name,valExpName);
% remove from file
uniqueGroupPath(i) = [];
plateInd(i) = [];
expPlateN(i) = [];



%% calculate descriptive statistics for each Exp/Group
% get data field names
clear fnames;
fnames = fieldnames(Import.MWTSet.Raw.Y);

% declare output array
clear A;
A = [];

% get expList and groupList
A.Path = uniqueGroupPath;

% get group and plate name form path
% get plate name
[pGroup,a] = cellfun(@fileparts,A.Path,'UniformOutput',0);
A.groupName = a;
% get group names
[pExp,a] = cellfun(@fileparts,pGroup,'UniformOutput',0);
 A.expName = a;
% get exp names

% calculate stats
typeName = 'DataByExp';
for f = 1:numel(fnames)
    % repeat for each field names
    for x = 1:numel(plateInd)
        % get data
        d = Import.MWTSet.Raw.Y.(fnames{f})(:,plateInd{x});
        
        % calculate N
        if expPlateN(x) <=1
            A.(typeName).(fnames{f}).N(:,x) = ~isnan(d);
        else
            A.(typeName).(fnames{f}).N(:,x) = sum(~isnan(d'))';
        end
        % calculate mean
        A.(typeName).(fnames{f}).Mean(:,x) = nanmean(d,2);
        
        % calculate SD
         A.(typeName).(fnames{f}).SD(:,x) = nanstd(d')';
         
        % calculate SE
        A.(typeName).(fnames{f}).SE(:,x) =  ...
            A.(typeName).(fnames{f}).SD(:,x)./...
            sqrt(A.(typeName).(fnames{f}).N(:,x));
    end
end


% get group names
u = unique(A.groupName);
plateInd_Ugroup = cell(size(u));
for x = 1:numel(u)
    plateInd_Ugroup{x} = find(ismember(A.groupName,u{x,1}));
end
A.GroupNameU = u; 



%% rearrange by group and export as .txt

sourceTypeName = 'DataByExp';
for g = 1:numel(A.GroupNameU)
    fname = fieldnames(A.(sourceTypeName));
    
    for f = 1:numel(fname)

        d = struct2cell(A.(sourceTypeName).(fname{f}));
        b = cell(size(d));
        for x = 1:numel(d)
            b{x,1} = d{x}(:,plateInd_Ugroup{g,1});
        end

        b = cell2mat(b');

        cd(pO);
        dlmwrite([fname{f},'_',A.GroupNameU{g},'_',...
            sourceTypeName,'.txt'],...
            b,'\t')
    end
    
    % make legend
    L = cell2table(A.expName(plateInd_Ugroup{g,1}));
   
    writetable(L,...
        ['ExpName_',A.GroupNameU{g},'_',sourceTypeName,'.txt'], ...
        'Delimiter','\t')
end




%% END
return



%% calculate statistics as N = experiment
% calcualtion
typeName = 'DataByGroupByExp';
sourceTypeName = 'DataByExp';
fname = fieldnames(A.(sourceTypeName));

% record group name
for f = 1:numel(fnames)
    for g = 1:numel(u)
        % get data
        d = A.(sourceTypeName).(fname{f}).Mean(:,plateInd_Ugroup{g});
        % get N
        A.(typeName).(fname{f}).N(:,g) = sum(~isnan(d'))';
        % get mean
        A.(typeName).(fname{f}).Mean(:,g) = nanmean(d')';
        % get SD
        A.(typeName).(fname{f}).SD(:,g) = nanstd(d')';
        % get E
        A.(typeName).(fname{f}).SE(:,g) = ...
            A.(typeName).(fname{f}).SD(:,g)./...
            sqrt(A.(typeName).(fname{f}).N(:,g));
        
    end
end



%% organize data to Output structural array
Graph  = [];
sourceTypeName = 'DataByGroupByExp';
Graph.GroupName = A.GroupNameU;
Graph.DataType = sourceTypeName;
fname = fieldnames(A.(sourceTypeName));
Graph.Data = A.(sourceTypeName);


%% export to excel
for f = 1:numel(fname)

    
    % count group
    gn = numel(Graph.GroupName);
    gname = Graph.GroupName;
    snames = fieldnames(Graph.Data.(fname{f}));
    
    % create legend
    legend = {};
    for s = 1:numel(snames)
        for g = 1:numel(gname)
            legend = [legend,strcat(snames(s),{'_'},gname(g))];
        end
    end
    
    % create table
    d = cell2mat(struct2cell(Graph.Data.(fname{f}))');
    T = array2table(d,'VariableNames',legend);
    % export table
    cd(pO);
    writetable(T,[(fname{f}),'.txt'],'Delimiter','\t')
end

%% create eror bar graph

% errorbar([T.Mean_N2,T.Mean_N2_400mM],[T.SE_N2,T.SE_N2_400mM])














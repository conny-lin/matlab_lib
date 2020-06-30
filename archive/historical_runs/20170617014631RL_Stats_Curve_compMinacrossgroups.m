%% OBJECTIVES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stats for this statement:
% Of the control groups, the 3 days old 0mM group?s body curve ranged 
% between 21-26 degrees, the 4 days old control group?s curve ranged
% between 28-31 degrees, and the 5 days old control group?s curve ranged between 25-29 degrees. 

% calculation of mean curve: 
% take data from every 5 mins from 5-60min, excluding 1st min
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% universal settings
pData = '/Users/connylin/Dropbox/RL/RL Pub PhD Dissertation/Chapters/2-Wildtype/3-Results/1-Figures & Data/Fig2-1 Body Curve 60m 3 4 5 do/AssayAge/Dance_DrunkMoves'; % paths
pSaveMat = fullfile(pM,'data.mat');
varname = 'curve'; % variable name



%% get data 
datafilename = 'Dance_DrunkMoves.mat'; % get data file name
fname = fullfile(pData,datafilename); % get path to file
load(fname); % load all data

v = {'groupname','mwtname','timeind','mean'}; % define table variable of interest
Data = MWTSet.Data_Plate.(varname)(:,v); %% get curve data per plate with variable of interest
% translate groupname from numeric to text
g = MWTSet.Info.VarIndex.groupname; % get groupname reference
Data.groupname = g(Data.groupname); % replace numeric index to reference

%% get data of interest
compGroup = {'N2_400mM_3d','N2_400mM','N2_400mM_5d'};
compTime = [15 45 55];
val = false(size(Data,1),1);
for ci =1:numel(compGroup)
    i = ismember(Data.groupname,compGroup(ci)) & Data.timeind == compTime(ci);
    val(i) = true;
end
Data(~val,:) = []; % get only time of interest

%% anova
[txt,anovastats,multstats] = anova1_std_v2(Data.mean,Data.groupname, 'data points','ns',0);
fid = fopen(fullfile(pM,'anova.txt'),'w');
fprintf(fid,'%s',txt);
fclose(fid);

%% get descriptive stats
[gn,n,m,s] = grpstats(Data.mean, Data.groupname,{'gname','numel','mean','sem'}); % take min curve per plate

% process group names
% get concentration
conc = regexpcellout(gn,'\d{1,}(?=mM)','match');
conc(cellfun(@isempty,conc)) = {'0'};
conc = cellfun(@str2num,conc);
% get age
age = regexpcellout(gn,'\d{1,}(?=d)','match');
age(cellfun(@isempty,age)) = {'4'};
age = cellfun(@str2num,age);

% put all info in table
T = table;
T.groupname = gn;
T.mM = conc;
T.age = age;
T.N = n;
T.mean = m;
T.se = s;
T = sortrows(T,{'age','mM'});
% write table
filename = fullfile(pM,sprintf('%s descriptive.csv',varname));
writetable(T,filename);


%% sort the descriptive table


%% close
save(pSaveMat,'Data'); % save data
fprintf(' *** done ***\n\n');


















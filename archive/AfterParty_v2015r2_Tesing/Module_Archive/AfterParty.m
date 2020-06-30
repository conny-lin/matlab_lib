%% AFTER PARTY: COLLECTION OF POST ANALYSIS OF DANCE
%% last updated: 20141121

%% collection of after party analysis

AfterParty_CombineMultipleMat
AfterParty_ShaneSpark_initialhablevelsum

return


%% set p to cd
% drag folder 
p = cd;

%% ADD FUNCTION PATH
addpath('/Users/connylin/OneDrive/MATLAB/Functions_Developer');

%% load MWTSEt
load('matlab.mat','MWTSet');

%% change graphs
load('matlab.mat','MWTSet');
MWTSet.pSaveA = p;

[MWTSet] = MWTAnalysisSetUpMaster_Graphing(MWTSet); 
cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');

[MWTSet] = Dance_Graph_Subplot(MWTSet);


%% get N
% get N
gnames = fieldnames(MWTSet.MWTfG);
A = nan(numel(gnames),1);

for g = 1:numel(gnames)
    A(g) = size(MWTSet.MWTfG.(gnames{g}),1);
end

T = table;
T.GroupName = gnames;
T.N = A;


%% SMALL ERROR BAR PROBLEM 
%% Organize raw data by groups
measures = fieldnames(MWTSet.Raw.Y);
gnames = fieldnames(MWTSet.MWTfG); % get group names
% declare structural array
A = [];

for m = 1:numel(measures); % repeat by measure
Measure = measures{m};


for g = 1:numel(gnames); % repeat by group
% check plate name for duplication
gname = gnames{g};
platenames = MWTSet.MWTfG.(gname)(:,1); % get plate name
matchPindex = ismember(MWTSet.Raw.MWTfn,platenames); % match plate name

% see if duplicated plate names
platenamesU = unique(platenames);
if numel(platenames) ~= numel(platenamesU)
   a = tabulate(platenames);
   a = a(cell2mat(a(:,2))>1,1:2);
    warning('duplicated plate names');
    disp(a)
   % mark (not remove)
   for p = 1:size(a,1) % for each duplicated plates
       dupindex = find(ismember(platenames,a(p)));
       matchPindex(dupindex) = false; % erase all index
       matchPindex(dupindex(1)) = true; % mark only the first one
   end
   % validate
   if sum(matchPindex) ~= numel(platenamesU)
       error('still duplicated plate index');
   end
end
% display
display(sprintf('N(%s) = %d',gname,sum(matchPindex)));

% match plate name
A.(Measure).(gname) = MWTSet.Raw.Y.(Measure)(:,matchPindex);
end
end

MWTSet.RawByGroup = A;

cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');


%%  recalculate
D = MWTSet.RawByGroup;
B = [];
measures = fieldnames(D);
for m = 1:numel(measures); % for each measures
    M = measures{m};

    gnames = fieldnames(D.(M));
    for g = 1:numel(gnames); % for each group

        G = gnames{g}; % get group names
        
        a = struct; % declare array
        
        % calculate stats
        d = D.(M).(G); % data
        a.n = sum(~isnan(d),2); % get N
        a.y = nanmean(d,2); % mean
        a.sd = nanstd(d')'; % SE
        a.e = sd./sqrt(n-1);
        B
    end
end


%% create initial and hab level output
p = cd;
% ShaneSpark_export2txt(p)
filename = 'Initial_HabLevel_Summary.txt';


load('matlab.mat','MWTSet');
Data = MWTSet.Graph;
GroupNames = MWTSet.GraphGroup;
measures = fieldnames(Data);


% set up table
T= table;
T.groupname = GroupNames;
% T.time = Data.(measures{1}).X(1,:)';

ynames = {'InitialResponse','HabLevel'};
for y = 1:numel(ynames)
    % initial response
    yname = 'InitialResponse';
    for m = 1:numel(measures)
        Measure = measures{m};
        T.(['InitialResponse','_',Measure]) = Data.(Measure).Y(1,:)';
        T.(['HabLevel','_',Measure]) = nanmean(Data.(Measure).Y(28:30,:))';
    end
    for m = 1:numel(measures)
        Measure = measures{m};
        T.(['InitialResponse','_',Measure,'_SE']) = Data.(Measure).E(1,:)';
        T.(['HabLevel','_',Measure,'_SE']) = nanmean(Data.(Measure).E(28:30,:))';
    end
end

% transpose
a = table2array(T(:,2:end))';
n = numel(T.Properties.VariableNames(2:end)')/2;
type = repmat({'InitialResponse';'HabLevel'},n,1);
mm = {};
for m = 1:numel(measures)
   mm = [mm;repmat(measures(m),2,1)];
end
mm = repmat(mm,2,1);
aa = [mm,type];
s = repmat({'mean'},n,1);
s = [s;repmat({'SE'},n,1)];
aa = [mm,s,type];

% get N
gnames = fieldnames(MWTSet.MWTfG);
A = nan(numel(gnames),1);

for g = 1:numel(gnames)
    A(g) = size(MWTSet.MWTfG.(gnames{g}),1);
end
a = [a;A'];
aa = [aa;{'N','',''}];
aa = cell2table(aa,'VariableNames',{'Measure';'Cal';'stats'});


% make final table
varnames = T.groupname;
a = array2table(a,'VariableNames',varnames);
T = [aa,a];


cd(p);
writetable(T,filename,'Delimiter','\t');

%% create initial and hab level graph
%% manually define data source folder names
% DataSources = {'ShaneSpark_20141117025708_slo1 10sISI'};
% pDataHome = '/Users/connylin/OneDrive/Dance_Output/';
% pData = [pDataHome,char(DataSources)];
% p = cd;
% define path for source data
addpath('/Users/connylin/OneDrive/MATLAB/Functions_Developer');
% group settings
groupset = ...
{...
'N2',[0 0 0];
% 'BZ142',[1 0 0];
'NM1968',[0.847058832645416 0.160784319043159 0];
'NM1630',[1 0.600000023841858 0.200000002980232];
% 'CX3940',[0 0.400000005960464 1];...
};

AfterParty_ShaneSpark_initialhablevelsum(pData,groupset)






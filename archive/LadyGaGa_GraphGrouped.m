function LadyGaGa_GraphGrouped(pExp,pFun,xticklable,ti,int,tf)

%% import sumimport file
cd(pExp);
[~,expname] = fileparts(pExp);
% validate experiment name
load(strcat('LadyGaGa_sumimport_',expname,'.mat'));

%% group data
[MWTfsn,~] = draftMWTfname3('*set',pExp);
%[remove user input] [GA,MWTfgcode] = assigngroupnameswitchboard2(MWTfsn,pFun,pExp,0);
[~,~,~,~,trackergroup] = parseMWTfnbyunder(MWTfsn(:,2));
gcode = char(trackergroup);
gcode = cellstr(gcode(:,end-1));
MWTfgcode = [MWTfsn(:,2),gcode];
cd(pExp);
load('Groups_1Set.mat','Groups');
GAA = [num2cell(1:size(Groups,1))',Groups];
% display(' ');
% [GAA] = groupseq(GA);
% GroupNameMaster
% [Gps] = GroupNameMaster(pExp,pSet,Version)

%% group import
%% group data
sumimportgrouped = {};
groupcode = unique(MWTfgcode(:,2));
for g = 1:numel(groupcode); % for every group  
i = logical(celltakeout(regexp(MWTfgcode(:,2),groupcode{g}),'singlenumber'));
for p = 1:numel(sumimport); % every plate
sumimportgrouped.(groupcode{g}){p,1} = sumimport{p}(i,:);
end
end

%% loop for each group
[Summaryheader] = LadyGaGasummaryheader;
% run analysis
ASelect = {'revIncident';'meanRevDist';'meanRevDur';'revSN'};
for x = 1:numel(ASelect); 
Mean = [];
N = [];
SE = [];
for gc = 1:numel(GAA(:,1));
    [~,n,mean,se,~] = decriptstats2...
        (sumimportgrouped.(GAA{gc,2}),Summaryheader,ASelect{x,1},pExp);
    N = cat(2,N,n);
    Mean = cat(2,Mean,mean);
    SE = cat(2,SE,se);   

end
    makefiggroups(Mean,SE,ASelect{x,1},'Time',GAA,xticklable);
    savefig(strcat(ASelect{x,1},'[',num2str(ti),':',num2str(int),':',num2str(tf),']'),pExp);
end
end
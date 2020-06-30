function AFR = AfterParty_IndividualPlates(AFR)
% AfterParty_IndividualPlates(AFR) generate a graph of individual plates
% per group

%% get data
pR = AFR.PATHS.pDanceResult;
load([pR,'/matlab.mat'],'MWTSet');

%% get var
Data = MWTSet.Data.ByPlates;
Legend = MWTSet.chor.choroutputLegend;
pMWT = MWTSet.Data.Import(:,1);
pSave = AFR.PATHS.pSaveA;
timepoints = MWTSet.Data.Timepoints;


%% get data per group
% get group names
[Gn,mwtn] = mwtpath_parse(Data.pMWT,{'gname','MWTname'});
GU = unique(Gn);
msr = fieldnames(Data.Y);
A = struct;
for g = 1:numel(GU)
    i = ismember(Gn,GU{g});
    pM = Data.pMWT(i); 
    
    for f = 1:numel(msr)
        A.(GU{g}).(msr{f}).pMWT = pM;
        A.(GU{g}).(msr{f}).N_TimeRow = Data.N.Ndatapoints(:,i);
        A.(GU{g}).(msr{f}).N_Worms = Data.N.NsumNVal(:,i);
        A.(GU{g}).(msr{f}).N_Total = Data.N.NsumN(:,i);
        A.(GU{g}).(msr{f}).time = repmat(Data.X,1,sum(i));
        A.(GU{g}).(msr{f}).mean = Data.Y.(msr{f})(:,i);
        A.(GU{g}).(msr{f}).SE = Data.E.(msr{f})(:,i);
    end
end
DataG = A;



%% make graph for each plate per measure
for gi = 1:numel(GU)
for msri = 1:numel(msr)

x = DataG.(GU{gi}).(msr{msri}).time;
y = DataG.(GU{gi}).(msr{msri}).mean;
e = DataG.(GU{gi}).(msr{msri}).SE;
% plot means
X = x(:,1);
Y = nanmean(y,2);
et = nanstd(y')'./sqrt(size(y,2)-1);
E1 = Y+et;
E2 = Y-et;
fig1 = figure('Visible','off');
area(X,E1,'FaceColor',[0 0 0])
hold on
area(X,E2,'FaceColor',[1 1 1])
x = DataG.(GU{gi}).(msr{msri}).time;
y = DataG.(GU{gi}).(msr{msri}).mean;
e = DataG.(GU{gi}).(msr{msri}).SE;
plot(x,y,'Color',[0 0 0]);
xlabel('time','FontSize',16);
ylabel(msr{msri},'FontSize',16);
title(regexprep(GU{gi},'_',''),'FontSize',16);
savefigepsOnly150(sprintf('Individual plates %s %s',msr{msri}, ...
    GU{gi}),pSave);
end
end





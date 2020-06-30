function AFR = AfterParty_IndividualPlatesTrimOutlier_v2015r0(AFR)
% AfterParty_IndividualPlates(AFR) generate a graph of individual plates
% per group
% v2015r2 - adding identification of outliers

%% get data
pR = AFR.PATHS.pDanceResult;
load([pR,'/matlab.mat'],'MWTSet');

%% get var
pMWT = MWTSet.Data.Import(:,1);
pSave = AFR.PATHS.pSaveA;

if isempty(strfind(MWTSet.AnalysisCode,'DrunkPosture')) == 0
    Legend = MWTSet.chor.choroutputLegend;
    Data = MWTSet.Data.ByPlates;
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
    
    
elseif isempty(strfind(MWTSet.AnalysisCode,'ShaneSpark2')) == 0
    Data = MWTSet.Data.ByGroupPerPlate;
    GU = fieldnames(Data);
    msr = {'RevFreq'; 'RevDur';'RevSpeed'};
    
    for gi = 1:numel(GU)
    for msri = 1:numel(msr)   
    DataG.(GU{gi}).(msr{msri}).pMWT = Data.(GU{gi}).MWTplateID;
    DataG.(GU{gi}).(msr{msri}).time = Data.(GU{gi}).time;   
    DataG.(GU{gi}).(msr{msri}).mean = Data.(GU{gi}).([msr{msri},'_Mean']);
    DataG.(GU{gi}).(msr{msri}).SE = Data.(GU{gi}).([msr{msri},'_SE']);
    end
    end
    
end


%% make graph for each plate per measure
for gi = 1%:numel(GU)
for msri = 1%:numel(msr)

x = DataG.(GU{gi}).(msr{msri}).time;
y = DataG.(GU{gi}).(msr{msri}).mean;
e = DataG.(GU{gi}).(msr{msri}).SE;
% plot means
X = x(:,1);
Y = nanmean(y,2);
et = nanstd(y')'./sqrt(size(y,2)-1);
E1 = Y+et;
E2 = Y-et;

% individual data
x = DataG.(GU{gi}).(msr{msri}).time;
y = DataG.(GU{gi}).(msr{msri}).mean;
e = DataG.(GU{gi}).(msr{msri}).SE;

%% get outliers
yy = y(1,:);
ival = true(size(yy));
median(yy)
mean(yy)
yy75 = quantile(yy,0.75)
yy25 = quantile(yy,0.25)
yyout75 = find(yy >= yy75)
yyout25 = find(yy <= yy25)
% ival(yyout75) = false;
ival(yyout25) = false;

pM_out = DataG.(GU{gi}).(msr{msri}).pMWT(~ival);
[mwtn] = mwtpath_parse(pM_out,{'MWTname'})
%% parse date
a = regexpcellout(mwtn,'_','split');
b = tabulate(a(:,1))

%%


return
fig1 = figure('Visible','off');
area(X,E1,'FaceColor',[0 0 0])
hold on
area(X,E2,'FaceColor',[1 1 1])

plot(x,y,'Color',[0 0 0]);
xlabel('time','FontSize',16);
ylabel(msr{msri},'FontSize',16);
title(regexprep(GU{gi},'_',' '),'FontSize',16);
savefigepsOnly150(sprintf('Individual plates %s %s',msr{msri}, ...
    GU{gi}),pSave);
end
end





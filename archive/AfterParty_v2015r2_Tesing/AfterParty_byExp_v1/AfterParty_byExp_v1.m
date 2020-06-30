% function MWTSet = AfterParty_byExp_v1(MWTSet)
% AfterParty_IndividualPlates(AFR) generate a graph of individual plates
% per group

%% process inputs
% MWTSetAP = MWTSet;
% pR = MWTSetAP.PATHS.pDanceResult;
% pSave = MWTSetAP.PATHS.pSaveA;

%% load data
load([pR,'/matlab.mat'],'MWTSet');

%% get var
% sometimes could be just plate name, need to write a code to address that
pMWT = MWTSet.MWTInfo.pMWT;
pMWTD = MWTSet.Data.Import(:,1); 
[i,j] = ismember(pMWTD,pMWT);
if sum(i) ~= numel(i) && issorted(j) == 0
   error('data import pMWT path not matching MWTInfo'); 
end
pMWTD = MWTSet.Data.ByPlates.pMWT;
[i,j] = ismember(pMWTD,pMWT);
if sum(i) ~= numel(i) && issorted(j) == 0
   error('data analysis pMWT path not matching MWTInfo'); 
end

%% organize by exp
% join structure arrays
A = MWTSet.Data.ByPlates.N;
B = MWTSet.Data.ByPlates.Y;
n = fieldnames(A);
for ni = 1:numel(n)
    B.(n{ni}) = A.(n{ni});
end
Data = B;

% organize by exp
A = struct;
msr = fieldnames(Data);
en = mwtpath_parse(pMWT,{'expname'});
enu = unique(en);
d = struct;
d.time = MWTSet.Data.ByPlates.X;
% creat exp name for structural array
a = char(enu);
enuNameList = cellstr(strcat('e',a(:,1:12)));
% make sure struc name is unique
if numel(unique(enuNameList)) ~= numel(enuNameList)
    error('exp name not unique');
end
for enui = 1:numel(enu)
% create exp name for structural array
en1 = enu{enui};
enName = enuNameList{enui};
A.(enName) = [];
i = ismember(en,en1);
pm = pMWT(i);
d.pMWT.(enName) = pm;
gn = mwtpath_parse(pm,{'gname'});
d.pMWT.(enName)(:,2) = gn;
gnu = unique(gn);
j = find(i);
for msri = 1:numel(msr)
for gnui = 1:numel(gnu)
k = j(ismember(gn,gnu{gnui}));
d.Mean.(msr{msri}).(enName).(gnu{gnui}) = Data.(msr{msri})(:,k);
end
end
end
DataByExp = d;

%% stats within exp .csv output
D = DataByExp;
A = []; B = {};
nRow = 1;
msr = fieldnames(D.Mean);
for msri = 1:numel(msr)
en = fieldnames(D.Mean.(msr{msri}));
for eni = 1:numel(en)
gn = fieldnames(D.Mean.(msr{msri}).(en{eni}));
for gni = 1:numel(gn)
d = D.Mean.(msr{msri}).(en{eni}).(gn{gni});
nCol = size(d,1);
B{nRow,1} = msr{msri};
B{nRow,2} = en{eni};
B{nRow,3} = gn{gni};
A(nRow,1) = size(d,2);
A(nRow,2:nCol+1) = nanmean(d,2)';
A(nRow,nCol+2:nCol+nCol+1) = nanstd(d');
nRow = nRow +1;
end
end
end

cd(pSave)
dlmwrite('byExpStats.csv',A,',');
writetable(cell2table(B),'byExpStatsLegend.csv','Delimiter',',')



%% plot
D = DataByExp;
A = []; 
nRow = 1;
msr = fieldnames(D.Mean);
for msri = 1:numel(msr)
en = fieldnames(D.Mean.(msr{msri}));
for eni = 1:numel(en)
gn = fieldnames(D.Mean.(msr{msri}).(en{eni}));
%% sort N2 as first
i = ~cellfun(@isempty,strfind(gn,'N2'));
gn = [gn(i);gn(~i)];

for gni = 1:numel(gn)
d = D.Mean.(msr{msri}).(en{eni}).(gn{gni});
m = nanmean(d,2);
sd = nanstd(d')';
n = sum(~isnan(d),2);
se = sd./sqrt(n-1);
time = D.time;

% create summary
A.(msr{msri}).(en{eni}).gname{gni} = gn{gni};
A.(msr{msri}).(en{eni}).mean(:,gni) = m;
A.(msr{msri}).(en{eni}).sd(:,gni) = sd;
A.(msr{msri}).(en{eni}).n(:,gni) = n;
A.(msr{msri}).(en{eni}).se(:,gni) = se;
A.(msr{msri}).(en{eni}).time(:,gni) = time;

end
end
end

StatsByExp = A;

%
D = StatsByExp;
msri= fieldnames(D);
for msri = 1:numel(msri)
en = fieldnames(D.(msr{msri}));
for eni = 1:numel(en)
x = D.(msr{msri}).(en{eni}).time;
y = D.(msr{msri}).(en{eni}).mean;
e = D.(msr{msri}).(en{eni}).se;
g = regexprep(D.(msr{msri}).(en{eni}).gname,'_',' ');
figure1 = figure('Visible','off');
axes1 = axes('Parent',figure1);
box(axes1,'on');
hold(axes1,'all');
errorbar1 = errorbar(x,y,e);
set(errorbar1(1),'LineWidth',3,'Color',[0 0 0]);
for xi = 1:size(x,2)
    set(errorbar1(xi),'DisplayName',g{xi});
end
title(regexprep(en{eni},'_',' '));
ylabel(msr{msri},'FontSize',16)
xlabel('time','FontSize',16)
legend1 = legend(axes1,'show');
set(legend1,'EdgeColor',[1 1 1],'Location','EastOutside','YColor',[1 1 1],...
    'XColor',[1 1 1]);
pSaveA = [pSave,'/',msr{msri}];
if isdir(pSaveA) == 0; mkdir(pSaveA); end
savefigepsOnly150(sprintf('%s %s',msr{msri},en{eni}),pSaveA);
end
end


return

%% plot within exp set 
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
for gi = 1:numel(GU)
for msri = 1:numel(msr)

x = DataG.(GU{gi}).(msr{msri}).time;
if isempty(x) == 1; 
    fprintf('** no data for [%s]%s\n', GU{gi},msr{msri});
else
y = DataG.(GU{gi}).(msr{msri}).mean;
e = DataG.(GU{gi}).(msr{msri}).SE;
% plot means
X = x(:,1);
Y = nanmean(y,2);
et = nanstd(y')'./sqrt(size(y,2)-1);
E1 = Y+et;
E2 = Y-et;
fig1 = figure('Visible','off');
area(X,E1,'FaceColor',[0 0 0]);
hold on
area(X,E2,'FaceColor',[1 1 1])
x = DataG.(GU{gi}).(msr{msri}).time;
y = DataG.(GU{gi}).(msr{msri}).mean;
e = DataG.(GU{gi}).(msr{msri}).SE;
plot(x,y,'Color',[0 0 0]);
xlabel('time','FontSize',16);
ylabel(msr{msri},'FontSize',16);
title(regexprep(GU{gi},'_',' '),'FontSize',16);
savefigepsOnly150(sprintf('Individual plates %s %s',msr{msri}, ...
    GU{gi}),pSave);
end
end
end

%% organize by group name
[f,p] = dircontent(pSave);
a = regexpcellout(f,' ','split');
a = a(:,4);
% a = regexpcellout(a,'_','split');
a = regexprep(a,'.eps','');
gu = unique(a);

cd(pSave);
for gui = 1:numel(gu)
    gt = gu{gui};
    i = ismember(a,gt);
    mkdir(gt);
    cellfun(@movefile,f(i),cellfunexpr(f(i),[pSave,'/',gt]));
end





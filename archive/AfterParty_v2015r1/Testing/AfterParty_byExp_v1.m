function AFR = AfterParty_byExp_v1(AFR)
% AfterParty_IndividualPlates(AFR) generate a graph of individual plates
% per group

%% get data
pR = AFR.PATHS.pDanceResult;
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
pSave = AFR.PATHS.pSaveA;

%% organize by exp
% join structure arrays
A = MWTSet.Data.ByPlates.N;
B = MWTSet.Data.ByPlates.Y;
n = fieldnames(A);
for ni = 1:numel(n)
    B.(n{ni}) = A.(n{ni});
end
Data = B;


%% organize by exp
A = struct;
msr = fieldnames(Data);
en = mwtpath_parse(pMWT,{'expname'});
enu = unique(en);
d = struct;

for enui = 1:numel(enu)
en1 = enu{enui};
enName = ['e',en1];
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

%% stats within exp
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
return


%% START WRITING HERE
%% plot
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




%%
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





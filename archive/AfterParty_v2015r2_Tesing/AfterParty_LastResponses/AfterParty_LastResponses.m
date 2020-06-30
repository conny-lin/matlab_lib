function AFR = AfterParty_LastResponses(AFR)
%% 
%% AfterParty_ExpReport(DanceOutputPath) generate a report of experiments analyzed in a matlab.mat output from Dance program
%    

%% get data
pR = AFR.PATHS.pDanceResult;
load([pR,'/matlab.mat'],'MWTSet');

%% get data
Data = MWTSet.Data.Import(:,2);
Legend = MWTSet.chor.choroutputLegend;
pMWT = MWTSet.Data.Import(:,1);
pSave = AFR.PATHS.pSaveA;
timepoints = MWTSet.Data.Timepoints;

%% get last response time
timeMin = timepoints(1,end);
timeMax = timepoints(2,end);
str = 'Last time points: %d-%ds';
disp(sprintf(str,timeMin,timeMax));

%% get last time data
dd = nan(numel(pMWT),numel(Legend));
for p = 1:numel(Data)
    time = Data{p}(:,1);
    k = time >= timeMin & time < timeMax;
    d = Data{p}(k,:);
    dd(p,:) = nanmean(d);
end
DataSample = dd;

%% get group names
Gn = mwtpath_parse(pMWT,{'gname'});
GU = unique(Gn);
GT = chooseoption(GU,2,'Choose groups to analyze');


%% get data
A = struct;
for g = 1:numel(GT)
    A.(GT{g}) = DataSample(ismember(Gn,GT{g}),:); 
end
DataG = A;


%% save group legned
cd(pSave); writetable(cell2table(GT),'groupname.dat')


%% get pMWT index
A = struct;
for g = 1:numel(GT)
    A.(GT{g}) = pMWT(ismember(Gn,GT{g}),:); 
end
pMWTind = A;


%% choose measure
display 'choose measures';
mName = chooseoption(Legend,2);
[~,mInd] = ismember(mName,Legend);



%% calculate

for m = 1:numel(mInd)
    
    D = []; GName = {}; 
    mNameNow = Legend(mInd(m));
    for g = 1:numel(GT)
        gname = GT{g};
        d = DataG.(gname)(:,mInd(m));
        nd = numel(d);
        glist = repmat({gname},nd,1);
        GName = [GName;glist];
        D = [D;d];
    end
    
    %% create output table
    [gn,n,mn,se,s] = grpstats(D,GName,{'gname','numel','mean','sem','std'});
    T = table;
    T.gname = gn;
    T.mean = mn;
    T.SE = se;
    T.SD = s;
    T.N = n;
    cd(pSave); 
    writetable(T,[char(mNameNow),'.txt'],'Delimiter','\t');
    
    %% anvoa
    [~,t,stats] = anova1(D,GName,'off');
    [c,~,~,gnames] = multcompare(stats,'display','off');
    
    result = anova_textresult(t);
    disp(result)
    ANOVASTATS(m,1) = strcat(mNameNow,{': '},result);
   
    % posthoc
    postanalysis = posthoc_result(c,gnames);
    T = cell2table(postanalysis);
    cd(pSave); writetable(T,[char(mNameNow),'_posthocSignPairs.dat'],'Delimiter','\t')
end
% write anova stats to dat

T2 = cell2table(ANOVASTATS);
cd(pSave);
writetable(T2,'ANOVA_results.dat')

return



















% %% anova report
% GName = {}; D = [];
% T2 = {};
% for m = 1:numel(mInd)
%     mNameNow = Legend(mInd(m));
%     disp(char(mNameNow));
%     
%     for g = 1:numel(GT)
%         gname = GT{g};
%         d = DataG.(gname)(:,mInd(m));
%         nd = numel(d);
%         glist = repmat({gname},nd,1);
%         GName = [GName;glist];
%         D = [D;d];
%     end
%     [~,t,stats] = anova1(D,GName,'off');
%     [c,~,~,gnames] = multcompare(stats,'display','off');
%     
%     result = anova_textresult(t);
%     disp(result)
%     ANOVASTATS(m,1) = strcat(mNameNow,{': '},result);
%    
%     postanalysis = posthoc_result(c,gnames);
%     T = cell2table(postanalysis);
%     cd(pSave); writetable(T,[char(mNameNow),'_posthocSignPairs.dat'],'Delimiter','\t')
% 
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %% get control data
% ctrl_Name = 'N2_0mM_0mM';
% Gn = mwtpath_parse(pMWT,{'gname'});
% d = DataSample(ismember(Gn,ctrl_Name),:);
% Control.N = size(d,1);
% Control.mean = mean(d);
% Control.SE = std(d)./sqrt(size(d,1)-1);
% 
% 
% %% find percentage difference from control data
% % generate index
% [~,mInd] = ismember({'Curve','Bias','Speed'},Legend);
% c = Control.mean(:,mInd);
% G = struct;
% G.Measure = Legend(mInd)';
% for g = 1:numel(GT)
%     d = DataG.(GT{g})(:,mInd);
%     nd = size(d,1);
%     cmat = repmat(c,nd,1); 
%     dd = ((d - cmat)./cmat)*100;
%     G.gname(g,1) = GT(g);
%     G.Y(g,:) = mean(dd);
%     G.E(g,:) = std(dd)./sqrt(nd-1);
% end
% 
% % plot percent diff
% % Create figure
% figure1 = figure('Color',[1 1 1]);
%     
% 
% X = repmat(1:numel(G.gname),size(G.Measure,2),1)';
% Y = G.Y;
% E = G.E;
% xlabel = cellstr(num2str((1:numel(G.gname))'));
% % Create axes
% axes1 = axes('Parent',figure1);
% hold(axes1,'all');
% 
% errorbar1 = errorbar(X,Y,E);
% for m = 1:numel(G.Measure)
%     set(errorbar1(m),'DisplayName',G.Measure{m},...
%         'Marker','o',...
%         'LineStyle','none',...
%         'LineWidth',3);
% end
% % Create legend
% legend1 = legend(axes1,'show');
% set(legend1,'EdgeColor',[1 1 1],'Location','EastOutside','YColor',[1 1 1],...
%     'XColor',[1 1 1]);
% 
% savefigepsOnly150('percent',pSave);
% 
% 
% %% plot scatter
% % generate index
% mName = {'Curve','Bias','Speed'};
% [~,mInd] = ismember(mName,Legend);
% c = Control.mean(:,mInd);
% G = struct;
% G.Measure = Legend(mInd)';
% X = []; Y = [];
% for g = 1:numel(GT)
%     d = DataG.(GT{g})(:,mInd);
%     nd = size(d,1);
%     cmat = repmat(c,nd,1); 
%     yy = ((d - cmat)./cmat)*100;
%     xx = repmat(g,size(yy));
%     X = [X;xx];
%     Y = [Y;yy];
%         
% end
% 
% 
% 
% figure1 = figure('Color',[1 1 1]);
% axes1 = axes('Parent',figure1);
% xlim(axes1,[0.5 numel(GT)+0.5]);
% hold(axes1,'all');
% 
% colorset = [0 0 0; .5 .5 .5; 1 0 1];
% for m = 1:size(Y,2)
%     cl = colorset(m,:);
%     scatter(X(:,m),Y(:,m),...
%         'MarkerFaceColor',cl,'MarkerEdgeColor',cl,'Parent',axes1,...
%         'DisplayName',mName{m});
%     hold on;
% end
% % Create legend
% legend1 = legend(axes1,'show');
% set(legend1,'EdgeColor',[1 1 1],'Location','EastOutside','YColor',[1 1 1],...
%     'XColor',[1 1 1]);
% 
% savefigepsOnly150('scatter',pSave);
% 
% 
% return
% %%





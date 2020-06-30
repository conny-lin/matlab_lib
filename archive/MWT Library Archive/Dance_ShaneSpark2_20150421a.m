function [varargout] = Dance_ShaneSpark2(MWTSet, varargin)
%% INFORMATION
% statistics = per group by plates 
% organize output by groups


%% VARAGOUT
varargout{1} = {};

%% SETTINGS
choreversion = 'Chore_1.3.0.r1035.jar';

%% INPUT validation
% check if chor is inside
pFun = MWTSet.PATHS.pFun;
[~,p] = dircontent(MWTSet.PATHS.pFun);
if ismember([pFun,'/',choreversion],p) == true
    pJava = pFun;
else
    error('no %s found in function folder',choreversion);
end

%% CHOR:
% GENERATE SCRIPTS
% GENERAL CHOR JAVA SETTINGS
javapath = pJava;
chor = ['''',javapath,'/',choreversion,'''']; % call chor 
b = blanks(1); % blank
javacall = 'java -jar'; javaRAM = '-Xmx7G'; javaRAM7G = '-Xmx7G';
beethoven = ['''',javapath,'/Beethoven_v2.jar','''']; % call beethoven 
map = '--map';
pixelsize = '-p 0.027'; speed = '-s 0.1'; 
mintime = '-t 20'; minmove = '-M 2'; shape = '--shadowless -S';
preoutline = '--plugin Reoutline::exp';  prespine = '--plugin Respine';

% ANALYSIS SPECIFIC SCRIPTS
oshanespark = '-O shanespark -o nNss*b12M'; % standard for Beethoven
revbeethoven_trv = '--plugin MeasureReversal::tap::dt=1::collect=0.5::postfix=trv';

% CREATE CHOR JAVA SCRIPTS
chorscript = {};
chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
    mintime,b,minmove,b,shape,b,oshanespark,b,preoutline,b,...
    prespine,b,revbeethoven_trv,b]; 
fval = {'*.trv';'*shanespark.dat'};
MWTSet.chor.chorscript = chorscript;
MWTSet.chor.chor_fileoutputnames = fval;


% RUN CHOR
display 'running choreography';
chorscript = MWTSet.chor.chorscript;
pMWTA = MWTSet.MWTInfo.pMWTf_Results;
pMWTS = MWTSet.MWTInfo.pMWT;
fval = MWTSet.chor.chor_fileoutputnames;
chorstatus = MWTSet.chor.chorstatus;
chormaster2(pMWTA,pMWTS,fval,chorscript,chorstatus)

%% IMPORT .TRV % revised 20150412
A = MWTSet.MWTInfo.MWTfn_Results;
pMWTf = MWTSet.MWTInfo.pMWTf_Results;
MWTfn = MWTSet.MWTInfo.MWTfn_Results;
for m = 1:size(pMWTf,1);
%     display(sprintf('processing[%d/%d]: %s',m,numel(pMWTf),MWTfn{m}));
    [~,p] = dircontent(pMWTf{m},'*.trv'); 
    % if there is no .trv
    if isempty(p) == 1
        A{m,2} = {};     
    else       
        % validate trv output format
        pt = p{1};
        fileID = fopen(pt,'r');
        d = textscan(fileID, '%s', 2-1, 'Delimiter', '', 'WhiteSpace', '');
        fclose(fileID);
        % read trv
        if strcmp(d{1}{1}(1),'#') ==1 % if trv file is made by Beethoven
            a = dlmread(pt,' ',5,0); 
        else % if trv file is made by Dance
            a = dlmread(pt,' ',0,0);

        end
        A{m,2} = a(:,[1,3:5,8:10,12:16,19:21,23:27]); % index to none zeros
    end
end
MWTfnImport = A;
MWTSet.Data.Import = MWTfnImport;

% legend
% L = {'time','N?','N_NoResponse','N_Reversed','?','RevDist'    };

%% CHECK TAP CONSISTENCY
[r,c] = cellfun(@size,MWTfnImport(:,2),'UniformOutput',0);
rn = celltakeout(r,'singlenumber');
rfreq = tabulate(rn);
rcommon = rfreq(rfreq(:,2) == max(rfreq(:,2)),1);
str = 'Most common tap number = %d';
display(sprintf(str,rcommon));
rproblem = rn ~= rcommon;

if sum(rproblem)~=0;
    MWTfnP = MWTfn(rproblem); 
    pMWTfP = pMWTf(rproblem);

    str = 'The following MWT did not have the same tap(=%d)';
    display(sprintf(str,rcommon)); disp(MWTfnP);
    display 'Removing from analysis...'; 
    MWTSet.RawBad = MWTfnImport(rproblem,:);
    MWTfnImport = MWTfnImport(~rproblem,:);
    MWTfnOK = MWTfn(~rproblem);
    pMWTfOK = pMWTf(~rproblem);    
    
    % reconstruct
%     [MWTSet.MWTfG] = reconstructMWTfG(pMWTf);
    MWTSet.MWTInfo.pMWT = pMWTfOK;
    MWTSet.MWTInfo.MWTfn = MWTfnOK;
    MWTSet.MWTInfo.pMWTBadTap = pMWTf(rproblem); 
    [~,g] = cellfun(@fileparts,...
        cellfun(@fileparts,pMWTfOK,'UniformOutput',0),...
        'UniformOutput',0);
    MWTSet.MWTInfo.GroupName = g;
        
end
%

%% MAKING SENSE OF TRV 
% .TRV OUTPUT LEGENDS
% output legends
% time
% # worms already moving backwards (can't score) 
% # worms that didn't reverse in response 
% # worms that did reverse in response 
% mean reversal distance (among those that reversed) 
% standard deviation of reversal distances 
% standard error of the mean 
% minimum 
% 25th percentile 
% median 
% 75th percentile 
% maximum 
% mean duration of reversal (also among those that reversed 
% standard deviation of duration 
% standard error of the mean 
% minimum 
% 25th percentile 
% median 
% 75th percentile 
% maximum

% get data
A = MWTSet.Data.Import(~rproblem,:);
B.MWTfn = MWTSet.MWTInfo.MWTfn;
pMWTf = MWTSet.MWTInfo.pMWT;
% indexes of .trv
ind.RevDur = 13;
ind.RevDist = 5;
% calculation
B = [];
for m = 1:size(pMWTf,1);
    % X = tap time
    % B.X.TapTime(:,m) = A{m,2}(:,1);
    B.X(:,m) = A{m,2}(:,1);   
    % basic caluations
    B.N.NoResponse(:,m) = A{m,2}(:,3);
    B.N.Reversed(:,m) = A{m,2}(:,4);  
    B.N.TotalN(:,m) = B.N.Reversed(:,m)+B.N.NoResponse(:,m);
    
    %% N
    n = B.N.TotalN(:,m);
    N = B.N.TotalN(:,m);
    N(n < 1) = NaN;
   
    %% Frequency
    B.Y.RevFreq(:,m) = B.N.Reversed(:,m)./N;
    % variance can not be calculated at this point
    B.E.RevFreq(:,m) = NaN(size(B.N.Reversed(:,m))); %  can only be zero
    B.SD.RevFreq(:,m) = NaN(size(B.N.Reversed(:,m)));
    % B.Y.RevFreq(:,m) = B.N.Reversed(:,m)./B.N.TotalN(:,m);
    % B.Y.RevFreqStd(:,m) = B.Y.RevFreq(:,m)/B.Y.RevFreq(1,m);
    
    %% Reversal Duration
    B.Y.RevDur(:,m) = A{m,2}(:,ind.RevDur);
    B.E.RevDur(:,m) = A{m,2}(:,ind.RevDur+1)./B.N.Reversed(:,m);
    B.SD.RevDur(:,m) = A{m,2}(:,ind.RevDur+1)./B.N.Reversed(:,m);

    %% Reversal Speed = RevDist/RevDur
    % Distance [disabled]
    RevDist(:,m) = A{m,2}(:,ind.RevDist); 
%     B.SD.RevDist(:,m) = A{m,2}(:,ind.RevDist+1);
%     B.E.RevDist(:,m) = A{m,2}(:,ind.RevDist+1)./B.N.Reversed(:,m);
    % B.Y.RevDistStd(:,m) = B.Y.RevDist(:,m)/B.Y.RevDist(1,m);
    % B.Y.SumRevDist(:,m) = B.Y.RevDist(:,m).*B.N.Reversed(:,m);    
    B.Y.RevSpeed(:,m) = RevDist(:,m)./B.Y.RevDur(:,m); 
    B.E.RevSpeed(:,m) = NaN(size(B.Y.RevSpeed(:,m))); 
    B.SD.RevSpeed(:,m) = NaN(size(B.Y.RevSpeed(:,m)));
end
Raw = B;
MWTSet.Data.Raw = Raw;

%% ORGANIZE OUTPUT BY GROUP
GroupName = MWTSet.MWTInfo.GroupName;
GroupSeq = MWTSet.GraphSetting.GroupSeq;
D = MWTSet.Data.Raw;
A = struct;
for g = 1:size(GroupSeq,1)
    B = struct;
    gname = GroupSeq{g,2};
    i = ismember(GroupName,GroupSeq(g,2));
    B.MWTplateID = MWTSet.MWTInfo.MWTfn(i);
    B.time = D.X(:,i);
    B.N_NoResponse = D.N.NoResponse(:,i);
    B.N_Reversed = D.N.Reversed(:,i);
    B.N_TotalN = D.N.TotalN(:,i);
    B.RevFreq_Mean = D.Y.RevFreq(:,i);
    B.RevFreq_SE = D.E.RevFreq(:,i);
    B.RevDur_Mean = D.Y.RevDur(:,i);
    B.RevDur_SE = D.E.RevDur(:,i);
    B.RevSpeed_Mean = D.Y.RevSpeed(:,i);
    B.RevSpeed_SE = D.E.RevSpeed(:,i);
    A.(gname) = B;
end
MWTSet.Data.ByGroupPerPlate = A;

%% STATISTICS FOR GRAPHS (by group by plate)
D = MWTSet.Data.ByGroupPerPlate;
gnames = fieldnames(D);
B = struct;
B.GroupNames = gnames;
for g = 1:numel(gnames)
    gname = gnames{g};
    
    D1 = D.(gname);
    
    plateN = numel(D1.MWTplateID);
    X = (1:size(D1.N_TotalN,1))';
    
    B.PlateN(g,1) = plateN;
    
    B.TotalN.X(:,g) = X;
    B.TotalN.Y(:,g) = nanmean(D1.N_TotalN,2);
    B.TotalN.E(:,g) = nanstd(D1.N_TotalN')';
    
    B.N_Reversed.X(:,g) = X;
    B.N_Reversed.Y(:,g) = nanmean(D1.N_Reversed,2);
    B.N_Reversed.E(:,g) = nanmean(D1.N_Reversed,2);
    
    B.N_NoResponse.X(:,g) = X;
    B.N_NoResponse.Y(:,g) = nanmean(D1.N_NoResponse,2);
    B.N_NoResponse.E(:,g) = nanstd(D1.N_NoResponse')';
    
    B.RevFreq.X(:,g) = X;
    B.RevFreq.Y(:,g) = nanmean(D1.RevFreq_Mean,2);
    B.RevFreq.SD(:,g) = nanstd(D1.RevFreq_Mean')';
    B.RevFreq.E(:,g) = B.RevFreq.SD(:,g)./...
        sqrt(repmat(plateN,size(B.RevFreq.SD(:,g),1),1));

    B.RevDur.X(:,g) = X;
    B.RevDur.Y(:,g) = nanmean(D1.RevDur_Mean,2);
    B.RevDur.SD(:,g) = nanstd(D1.RevDur_Mean')';
    B.RevDur.E(:,g) = B.RevDur.SD(:,g)./...
        sqrt(repmat(plateN,size(B.RevDur.SD(:,g),1),1));
    
    B.RevSpeed.X(:,g) = X;
    B.RevSpeed.Y(:,g) = nanmean(D1.RevSpeed_Mean,2);
    B.RevSpeed.SD(:,g) = nanstd(D1.RevSpeed_Mean')';
    B.RevSpeed.E(:,g) = B.RevSpeed.SD(:,g)./...
        sqrt(repmat(plateN,size(B.RevSpeed.SD(:,g),1),1));
    
end

MWTSet.Graph.HabCurve = B;

%% GRAPHING: HABITUATION CURVES
M = fieldnames(MWTSet.Graph);
M = {'TotalN'
    'N_Reversed'
    'N_NoResponse'
    'RevFreq'
    'RevDur'
    'RevSpeed'};

Graph = MWTSet.Graph.HabCurve;
GroupName = regexprep(Graph.GroupNames,'_',' ');
pSaveA = [MWTSet.PATHS.pSaveA,'/','Graph Habituation curves'];
if isdir(pSaveA) == 0; mkdir(pSaveA); end
timestamp = MWTSet.timestamp;
for m = 1:numel(M);% for each measure
    
    % get coordinates
    X = Graph.(M{m}).X;
    Y = Graph.(M{m}).Y;
    E = Graph.(M{m}).E;
    
    % Create figure
    figure1 = figure('Color',[1 1 1]);
    axes1 = axes('Parent',figure1,'FontSize',18);
    box(axes1,'off');
    xlim(axes1,[0 size(Y,1)+1]);
    ylim(axes1,[min(min(Y-E))*.9 max(max(Y+E))*1.1]);
    hold(axes1,'all');
    errorbar1 = errorbar(X,Y,E,'LineWidth',5);
    
    color = [0 0 0; 1 0 0; [0.5 0.5 0.5]; [0.04 0.52 0.78]]; 
    n = min([size(color,1) size(Y,2)]);
    for x = 1:n
        set(errorbar1(x),'Color',color(x,1:3))
    end
    
    for x = 1:size(Y,2)
        set(errorbar1(x),'DisplayName',GroupName{x})
    end
    titlestr = timestamp;
    title(titlestr,'FontSize',12);
    
    xlabel('Tap','FontSize',18);
    ylabel(regexprep(M{m},'_',' '),'FontSize',18);
    legend1 = legend(axes1,'show');
    set(legend1,'EdgeColor',[1 1 1],...
        'Location','NorthEastOutside',...
        'YColor',[1 1 1],...
        'XColor',[1 1 1],'FontSize',12);
    
    % text strings
    a = Graph.PlateN;
    b = '';
    for x = 1:numel(a)
        b = [b,num2str(a(x)),', '];
    end
    
    str1 = ['N(plate) = ',b(:,1:end-2)];
    textboxstr = [str1];
    annotation(figure1,'textbox',...
    [0.70 0.015 0.256 0.05],...
    'String',textboxstr,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);
    
    figname = [M{m}];
    savefigeps(figname,pSaveA);
end

%% GRAPHING: INITIAL & LAST 3 TAPS
M = fieldnames(MWTSet.Graph);
M = {'RevFreq', 'RevDur', 'RevSpeed'};

% calculate data - hab level
D = MWTSet.Data.ByGroupPerPlate;
gnames = fieldnames(D);
A = struct;
for m = 1:numel(M);% for each measure
    B = []; G = {};
    for g = 1:numel(gnames)
        d = D.(gnames{g}).([M{m},'_Mean'])(end-2:end,:);
        % calculate last 3 taps average per plate
        d1 = nanmean(d);
        % get data
        B = [B;d1'];
        n = numel(d1);
        G = [G; repmat(gnames(g), n,1)];
    end
    % stats
    [p,t,stats] = anova1(B,G,'off');
    [c,m1,h,gnames] = multcompare(stats,'ctype','bonferroni','display','off');
    A.(M{m}).GroupName = stats.gnames;
    A.(M{m}).N = stats.n;
    A.(M{m}).Y = stats.means;
    A.(M{m}).E = m1(:,2); 
    A.(M{m}).ANOVA = t;
    i = ((c(:,2) >0 & c(:,4) >0) + (c(:,2) <0 & c(:,4) <0)) >0;
    a = [gnames(c(:,1)), gnames(c(:,2))];
    a(i,3) = {'< 0.05'};
    a(~i,3) = {'not significant'};
    A.(M{m}).posthoc = a;
end
MWTSet.Graph.HabLevel = A;


% calculate data - initial
D = MWTSet.Data.ByGroupPerPlate;
gnames = fieldnames(D);
A = struct;
for m = 1:numel(M);% for each measure
    B = []; G = {};
    for g = 1:numel(gnames)
        d1 = D.(gnames{g}).([M{m},'_Mean'])(1,:);
        % get data
        B = [B;d1'];
        n = numel(d1);
        G = [G; repmat(gnames(g), n,1)];

    end

    % stats
    [p,t,stats] = anova1(B,G,'off');
    [c,m1,h,gnames] = multcompare(stats,'ctype','bonferroni','display','off');
    A.(M{m}).GroupName = stats.gnames;
    A.(M{m}).N = stats.n;
    A.(M{m}).Y = stats.means;
    A.(M{m}).E = m1(:,2); 
    A.(M{m}).ANOVA = t;
    i = ((c(:,2) >0 & c(:,4) >0) + (c(:,2) <0 & c(:,4) <0)) >0;
    a = [gnames(c(:,1)), gnames(c(:,2))];
    a(i,3) = {'< 0.05'};
    a(~i,3) = {'not significant'};
    A.(M{m}).posthoc = a;
end
MWTSet.Graph.Initial = A;

% GRAPH: INITIAL HAB LEVEL
gcategory = {'Initial','HabLevel'};
pSaveA = [MWTSet.PATHS.pSaveA,'/','Graph Initial HabLevel bar'];
if isdir(pSaveA) == 0; mkdir(pSaveA); end

G = []; 
for m = 1:numel(M);% for each measure
    GroupName = {}; Y = []; E = []; X = [];
    for c = 1:numel(gcategory)
        GroupName(:,c) = MWTSet.Graph.(gcategory{c}).(M{m}).GroupName;
        X(:,c) = (1:numel(MWTSet.Graph.(gcategory{c}).(M{m}).Y))';
        Y(:,c) = MWTSet.Graph.(gcategory{c}).(M{m}).Y;
        E(:,c) = MWTSet.Graph.(gcategory{c}).(M{m}).E;
    end
    
    titlename = MWTSet.timestamp;
    figname  = M{m};
    
    figure1 = figure('Color',[1 1 1]);
    axes1 = axes('Parent',figure1,...
        'XTickLabel',regexprep(GroupName(:,1),'_',' '),...
        'XTick',[1 2 3 4],...
        'FontSize',14);
    xlim(axes1,[0.5 4.5]);
    hold(axes1,'all');
    % create bar
    bar1 = bar(X,Y,'BarWidth',1,'Parent',axes1); 
    colorSet = [[0.043 0.52 0.78];[0.85 0.16 0]];
    for c = 1:size(colorSet,1)
        set(bar1(c),'FaceColor',colorSet(c,:),'DisplayName',gcategory{c});
    end
    % create errorbar
    errorbar1 = errorbar([X(:,1)-0.145 X(:,2)+0.145],Y,E);
    for c = 1:size(colorSet,1)
        set(errorbar1(c),...
            'LineStyle','none','Color',[0 0 0],'DisplayName',' ');
    end
    
%     s = D.ANOVA;
%     if s{2,6} < 0.0001; 
%         k = '<';
%     else
%         k = '=';
%     end
%     j = sprintf('F(%d,%d) = %.3f, p %s %.3f',...
%         s{2,3}, s{3,3}, s{2,5}, k, s{2,6});
%     titlestr = [timestamp, '  ', j];
%     title(titlestr);
    
    title(titlename);
    ylabel(M{m},'FontSize',16);
    legend1 = legend(axes1,'show');
    set(legend1,'EdgeColor',[1 1 1],...
        'Location','EastOutside','YColor',[1 1 1],...
        'XColor',[1 1 1]);
    savefigeps(figname,pSaveA);    
end

%% EXCEL OUTPUT
pSaveA = [MWTSet.PATHS.pSaveA,'/','Tables'];
if isdir(pSaveA) == 0; mkdir(pSaveA); end
gcategory = {'Initial','HabLevel'};
groupname = {};
rtype = {};
ctype = {};
N = []; Y = []; E = [];
for c = 1:numel(gcategory)
    for m = 1:numel(M)
        D = MWTSet.Graph.(gcategory{c}).(M{m});
        groupname = [groupname; D.GroupName];
        rtype = [rtype; repmat(M(m), numel(D.GroupName), 1)];
        ctype = [ctype; repmat(gcategory(c), numel(D.GroupName), 1)];
        N = [N; D.N'];
        Y = [Y; D.Y'];
        E = [E; D.E];       
    end
end
T = table;
T.group = groupname;
T.response_type = rtype;
T.msr = ctype;
T.N_plates = N;
T.Mean = Y;
T.SE = E;

cd(pSaveA);
writetable(T,'initial hab level summary.txt','Delimiter','\t');


% export anova 
for m = 1:numel(M)
    for c = 1:numel(gcategory)
        D = MWTSet.Graph.(gcategory{c}).(M{m}).ANOVA;
        D(1,6) = {'p'};
        T = cell2table(D(2:end,:),'VariableNames',D(1,:));
        tname = sprintf('ANOVA %s %s.txt',gcategory{c},M{m});
        cd(pSaveA); 
        writetable(T, tname,'Delimiter','\t');
    end   
end


% export posthoc
for m = 1:numel(M)
    for c = 1:numel(gcategory)
        D = MWTSet.Graph.(gcategory{c}).(M{m}).posthoc;
        T = cell2table(D,'VariableNames',{'group1','group2','p'});
        tname = sprintf('ANOVA %s %s posthoc bonferroni.txt',...
            gcategory{c},M{m});
        cd(pSaveA); 
        writetable(T, tname,'Delimiter','\t');
    end   
end


%% CODE RETURN
varargout{1} = MWTSet;
return




























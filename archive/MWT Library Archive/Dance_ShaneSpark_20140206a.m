function [varargout] = Dance_ShaneSpark_20140206(varargin)

%% input output
varargout = {};

MWTfG = varargin{1};
fnvalidate = varargin{2};
pSaveA = varargin{3};

%% STEP4: STATS AND GRAPHING
%% STEP3E: EXCLUDE CHOR PROBLEM MWT FILES FROM ANALYSIS
% RE-CHECK CHOR OUTPUTS
display ' '; display 'Double checking chor outputs...'
% prepare pMWTf input for validation
A = celltakeout(struct2cell(MWTfG),'multirow');
pMWTfT = A(:,2); MWTfnT = A(:,1);
pMWTf = pMWTfT; MWTfn = MWTfnT;
% check chor ouptputs
pMWTfC = {}; MWTfnC = {}; 
for v = 1:size(fnvalidate,1);
    [valname] = cellfunexpr(pMWTf,fnvalidate{v});
    [fn,path] = cellfun(@dircontentext,pMWTf,valname,'UniformOutput',0);
    novalfn = cellfun(@isempty,fn);
    if sum(novalfn)~=0;
        pMWTfnoval = pMWTf(novalfn); MWTfnoval = MWTfn(novalfn);
        pMWTfC = [pMWTfC;pMWTfnoval]; MWTfnC = [MWTfnC;MWTfnoval];
    end
end
pMWTfC = unique(pMWTfC); MWTfnC = unique(MWTfnC);
% reporting
if isempty(pMWTfC)==1; display 'All files have required Chor outputs';
elseif isempty(pMWTfC)==0;
    str = 'Chore unsuccessful in %d MWT files';
    display(sprintf(str,numel(pMWTfC)));disp(MWTfnC);
    % STEP3F: EXCLUDE PROBLEM MWT FILES
    display 'Excluding problem MWT from analysis';
    gname = fieldnames(MWTfG);
    for x = 1:numel(MWTfnC) % each problem folders
        for g = 1:numel(gname)
            A = MWTfG.(gname{g})(:,1);
            i = logical(celltakeout(regexp(A,MWTfnC{x}),'singlenumber'));
            if sum(i)>0; 
                str = '>removing [%s]';
                display(sprintf(str,MWTfnC{x}));
                MWTfG.(gname{g})(i,:)=[]; % remove that from analysis
            end
        end
    end
end
%% STEP4A: IMPORT .TRV 
% get MWT list
A = celltakeout(struct2cell(MWTfG),'multirow');
pMWTfT = A(:,2); MWTfnT = A(:,1);
pMWTf = pMWTfT; MWTfn = MWTfnT;
% creating MWTftrv legend
% ALegend = {1,'MWTfile name';3,'RawData'};
% trvL = {1,'time';2,'N?';3,'Noresponse';4,'NReversed';5,'RevDist'};
% import 
A = MWTfn;
for m = 1:size(pMWTf,1);
    [fn,~] = dircontentext(pMWTf{m},'*.trv'); 
    a = dlmread(fn{1},' ',0,0);
    i = [1,3:5,8:10,12:16,19:21,23:27]; % index to none zeros
    A{m,2} = a(:,i); % remove zeros
end
MWTfnImport = A;
%% STEP4X: CHECK TAP CONSISTENCY
[r,c] = cellfun(@size,MWTfnImport(:,2),'UniformOutput',0);
rn = celltakeout(r,'singlenumber');
rfreq = tabulate(rn);
rcommon = rfreq(rfreq(:,2) == max(rfreq(:,2)),1);
str = 'Most common tap number = %d';
display(sprintf(str,rcommon));
rproblem = rn ~= rcommon;
if sum(rproblem)~=0;
    MWTfnP = MWTfn(rproblem); 
    str = 'The following MWT did not have the same tap(=%d)';
    display(sprintf(str,rcommon)); disp(MWTfnP);
    display 'Removing from analysis...'; gname = fieldnames(MWTfG);
    for x = 1:numel(MWTfnP) % each problem folders
        for g = 1:numel(gname)
            A = MWTfG.(gname{g})(:,1);
            i = logical(celltakeout(regexp(A,MWTfnP{x}),'singlenumber'));
            if sum(i)>0; 
                %str = '>removing [%s] from group file';
                %display(sprintf(str,MWTfnP{x}));
                MWTfG.(gname{g})(i,:)=[]; % remove that from analysis
            end
            k = logical(celltakeout(regexp(MWTfnImport(:,1),MWTfnP{x}),'singlenumber'));
            if sum(k)>0; 
                %str = '>removing [%s] from imported file';
                %display(sprintf(str,MWTfnP{x}));
                MWTfnImport(k,:)=[]; % remove that from analysis
            end
        end
    end
end
%% STEP4B: MAKING SENSE OF TRV 
% reload MWT files
A = celltakeout(struct2cell(MWTfG),'multirow');
pMWTf = A(:,2); MWTfn = A(:,1);
% calculate
B = [];
B.MWTfn = MWTfn;
A = MWTfnImport;
for m = 1:size(pMWTf,1);
    B.X.TapTime(:,m) = A{m,2}(:,1); 
    B.N.NoResponse(:,m) = A{m,2}(:,3);
    B.N.Reversed(:,m) = A{m,2}(:,4); 
    B.N.TotalN(:,m) = B.N.Reversed(:,m)+B.N.NoResponse(:,m);
    B.Y.RevFreq(:,m) = B.N.Reversed(:,m)./B.N.TotalN(:,m);
    B.Y.RevDist(:,m) = A{m,2}(:,5); 
%     B.Y.SumRevDist(:,m) = B.Y.RevDist(:,m).*B.N.Reversed(:,m); 
    B.Y.RevDistStd(:,m) = B.Y.RevDist(:,m)/B.Y.RevDist(1,m);
    B.Y.RevFreqStd(:,m) = B.Y.RevFreq(:,m)/B.Y.RevFreq(1,m); % freqStd
end
Stats = B;
O.Stats = Stats;
%% STEP4B: PREPARE GRAPH SUMMARY FOR SUBPLOTS
Graph = [];
MWTfnimport = Stats.MWTfn;
M = fieldnames(Stats.Y);
gnameL = fieldnames(MWTfG);
for m = 1:numel(M);% for each measure
    Y = []; X = []; E = [];
    for g = 1:numel(gnameL); % for each group
        gname = gnameL{g};
        %pMWTf = MWTfG.(gname)(:,2); 
        MWTfn = MWTfG.(gname)(:,1);
        N = size(MWTfG.(gname),1);
        [~,i,~] = intersect(MWTfnimport,MWTfn);
        %Graph.Y.(M{m})(:,g) = mean(Stats.Y.(M{m})(:,i),2);
        %Graph.E.(M{m})(:,g) = std(Stats.Y.(M{m})(:,i)')'./sqrt(N);
        Graph.Raw.(M{m}).(gname) = Stats.Y.(M{m})(:,i);
        Graph.Y.(M{m})(:,g) = nanmean(Stats.Y.(M{m})(:,i),2);
        Graph.E.(M{m})(:,g) = nanstd(Stats.Y.(M{m})(:,i)')'./sqrt(N);
        Graph.X.(M{m})(:,g) = (1:size(Stats.X.TapTime,1));
    end
end 
O.Graph = Graph;
%% STEP4C.SUBPLOTS
% source code: LadyGaGaSubPlot(MWTftrvG,pExp,SavePrefix)
% define universal settings
% switch graphing sequence
i = [2,3,1,4];
k = fieldnames(Stats.Y)';
M = k(i);
groupname = fieldnames(MWTfG)';
groupsize = numel(fieldnames(MWTfG));
gnshow = regexprep(groupname,'_',' ');
xmax = size(Graph.X.(M{m}),1)+1;
subplotposition(1,1:4) = [0.065 0.55 0.4 0.4];
subplotposition(2,1:4) = [0.55 0.55 0.4 0.4];
subplotposition(3,1:4) = [0.065 0.11 0.4 0.4];
subplotposition(4,1:4) = [0.55 0.11 0.4 0.4];
legendposition = 2;
% preset color codes
color(1,:) = [0,0,0];
color(2,:) = [0.30 0.50 0.92]; %[0.04 0.14 0.42];
color(3,:) = [0.168 0.505 0.337];
color(4,:) = [0.847 0.16 0];
% Create figure
figure1 = figure('Color',[1 1 1]); 
for m = 1:numel(M);
    axes1 = axes('Parent',figure1,'FontName','Arial',...
        'Position',subplotposition(m,1:4));
    % 'XTickLabel','', (remove setting it off
    ylim(axes1,[0 1.1]); xlim(axes1,[0 xmax]); hold(axes1,'all');
    errorbar1 = errorbar(Graph.X.(M{m}),Graph.Y.(M{m}),...
        Graph.E.(M{m}),...
        'Marker','.','LineWidth',2);
    ylabel(M{m},'FontName','Arial'); % Create ylabel
    if numel(groupname) <=4
        for g = 1:numel(groupname);
            set(errorbar1(g),'DisplayName',gnshow{g},...
                    'LineWidth',2,'Color',color(g,1:3),...
                    'MarkerSize',20,'Marker','.'); 
        end
    elseif numel(groupname) >=5
        for g = 1:4;
            set(errorbar1(g),'DisplayName',gnshow{g},...
                    'LineWidth',2,'Color',color(g,1:3),...
                    'MarkerSize',20,'Marker','.'); 
        end
        for g = 5:numel(groupname);
            set(errorbar1(g),'DisplayName',gnshow{g},...
                    'LineWidth',2,...
                    'MarkerSize',20,'Marker','.'); 
        end  
    end


    if m ==legendposition; % if making righttop cornor
        for g = 1:numel(groupname);
            %set(errorbar1(g),'DisplayName',gnshow{g},...
                %'LineWidth',2);

            legend1 = legend(axes1,'show');
            set(legend1,'EdgeColor',[1 1 1],'YColor',[1 1 1],...
                'XColor',[1 1 1],'TickDir','in',...
                'LineWidth',1);
        end
    end
end

% create textbox for N
for g = 1:numel(groupname); gN(g) = size(MWTfG.(groupname{g}),1); end
n = num2str(gN'); b = cellfunexpr(groupname',' ');
a = char(cell2mat(cellstr([n,char(b)])'));
v = a(1,1:end); 
t = 'N = '; 
N = [t,v];
annotation(figure1,'textbox',[0.003 0.02 0.20 0.05],'String',{N},...
    'FontName','Arial','FitBoxToText','off','EdgeColor','none');

% save figure 
%         h = (gcf);
titlename = ['ShaneSpark_CombineGraph']; % set name of the figure
savefigjpeg(titlename,pSaveA);
%         set(h,'PaperPositionMode','auto'); % set to save as appeared on screen
%         cd(pSaveA);
%         print (h,'-dtiff', '-r0', titlename); saveas(h,titlename,'fig');
% finish up
%         display 'Graph done.';
%         close;
%% STEP6C: SAVE MATLAB
cd(pSaveA); save('matlab.mat');  
O.pSaveA = pSaveA;
function [varargout] = Dance_ShaneSpark_20141120(GlobalVar)


%% VARAGOUT
varargout{1} = {};


%% VARARGIN
MWTSet = varargin{1};

%% PRESET UP
%% ANALYSIS SET UP
clear MWTSet;
[MWTSet] = MWTAnalysisSetUpMaster(GlobalVar);
cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');
% [MWTfG] = MWTDataBaseMaster(GlobalVar.pData,'search');

























%% CHOR 
[MWTSet] = chormaster(MWTSet);
cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');

%% ANALYSIS SWITCH BOARD
[MWTSet] = Dance_AnalysisMaster(MWTSet);
% [MWTSet] = chormaster_legend(MWTSet); % supsend - 20140528 for ShaneSpark

%% STATS SWITCH BOARD
[MWTSet] = Dance_StatsMaster(MWTSet);
cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');

%% GET REQUIRED INPUT
pMWTchorpass = MWTSet.pMWTchorpass;
pMWTf = MWTSet.pMWT;


        
%% GET MWT FILE PATH
% pMWTf = MWTSet.pMWTchorpass;
[~,MWTfn] = cellfun(@fileparts,pMWTf,'UniformOutput',0);


%% STEP4A: IMPORT .TRV 
% revised 20140419
A = MWTfn;
for m = 1:size(pMWTf,1);
    display(sprintf('processing[%d/%d]: %s',m,numel(pMWTf),MWTfn{m}));
    [~,p] = dircontentext(pMWTf{m},'*.trv'); 
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
MWTSet.Import = MWTfnImport;

%% legend
% L = {'time','N?','N_NoResponse','N_Reversed','?','RevDist'    };
    

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
    pMWTfP = pMWTf(rproblem);

    str = 'The following MWT did not have the same tap(=%d)';
    display(sprintf(str,rcommon)); disp(MWTfnP);
    display 'Removing from analysis...'; 
    MWTSet.RawBad = MWTfnImport(rproblem,:);
    MWTfnImport = MWTfnImport(~rproblem,:);
    MWTfn = MWTfn(~rproblem);
    pMWTf = pMWTf(~rproblem);    
    
    % reconstruct
    [MWTSet.MWTfG] = reconstructMWTfG(pMWTf);

end

%% .TRV OUTPUT LEGENDS
%% output legends
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

%% STEP4B: MAKING SENSE OF TRV 


% indexes of .trv
ind.RevDur = 13;
ind.RevDist = 5;

% calculation
B = [];
B.MWTfn = MWTfn;
A = MWTfnImport;
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
    N(n < 3) = NaN;
    
    %% Frequency
    B.Y.RevFreq(:,m) = B.N.Reversed(:,m)./N;
    % variance can not be calculated at this point
    B.E.RevFreq(:,m) = NaN(size(B.N.Reversed(:,m))); %  can only be zero
    B.SD.RevFreq(:,m) = NaN(size(B.N.Reversed(:,m)));
    % B.Y.RevFreq(:,m) = B.N.Reversed(:,m)./B.N.TotalN(:,m);
    % B.Y.RevFreqStd(:,m) = B.Y.RevFreq(:,m)/B.Y.RevFreq(1,m);
    
    %% Distance
    B.Y.RevDist(:,m) = A{m,2}(:,ind.RevDist); 
    B.SD.RevDist(:,m) = A{m,2}(:,ind.RevDist+1);
    B.E.RevDist(:,m) = A{m,2}(:,ind.RevDist+1)./B.N.Reversed(:,m);
    % B.Y.RevDistStd(:,m) = B.Y.RevDist(:,m)/B.Y.RevDist(1,m);
    % B.Y.SumRevDist(:,m) = B.Y.RevDist(:,m).*B.N.Reversed(:,m);     
    
    %% Reversal Duration
    B.Y.RevDur(:,m) = A{m,2}(:,ind.RevDur);
    B.E.RevDur(:,m) = A{m,2}(:,ind.RevDur+1)./B.N.Reversed(:,m);
    B.SD.RevDur(:,m) = A{m,2}(:,ind.RevDur+1)./B.N.Reversed(:,m);

    
    %% Reversal Speed = RevDist/RevDur
    B.Y.RevSpeed(:,m) = B.Y.RevDist(:,m)./B.Y.RevDur(:,m); 
    % variance can not be calculated at this point
    B.E.RevSpeed(:,m) = NaN(size(B.Y.RevSpeed(:,m))); 
    B.SD.RevSpeed(:,m) = NaN(size(B.Y.RevSpeed(:,m)));
end


Raw = B;


%% VARARGOUT
MWTSet.Raw = Raw;
varargout{1} = MWTSet;




%% [moved] STEP4C.SUBPLOTS
% 
% % source code: LadyGaGaSubPlot(MWTftrvG,pExp,SavePrefix)
% % define universal settings
% % switch graphing sequence
% i = [2,3,1,4];
% k = fieldnames(Stats.Y)';
% M = k(i);
% groupname = fieldnames(MWTfG)';
% groupsize = numel(fieldnames(MWTfG));
% gnshow = regexprep(groupname,'_',' ');
% xmax = size(Graph.X.(M{m}),1)+1;
% subplotposition(1,1:4) = [0.065 0.55 0.4 0.4];
% subplotposition(2,1:4) = [0.55 0.55 0.4 0.4];
% subplotposition(3,1:4) = [0.065 0.11 0.4 0.4];
% subplotposition(4,1:4) = [0.55 0.11 0.4 0.4];
% legendposition = 2;
% % preset color codes
% color(1,:) = [0,0,0];
% color(2,:) = [0.30 0.50 0.92]; %[0.04 0.14 0.42];
% color(3,:) = [0.168 0.505 0.337];
% color(4,:) = [0.847 0.16 0];
% % Create figure
% figure1 = figure('Color',[1 1 1]); 
% for m = 1:numel(M);
%     axes1 = axes('Parent',figure1,'FontName','Arial',...
%         'Position',subplotposition(m,1:4));
%     % 'XTickLabel','', (remove setting it off
%     ylim(axes1,[0 1.1]); xlim(axes1,[0 xmax]); hold(axes1,'all');
%     errorbar1 = errorbar(Graph.X.(M{m}),Graph.Y.(M{m}),...
%         Graph.E.(M{m}),...
%         'Marker','.','LineWidth',2);
%     ylabel(M{m},'FontName','Arial'); % Create ylabel
%     if numel(groupname) <=4
%         for g = 1:numel(groupname);
%             set(errorbar1(g),'DisplayName',gnshow{g},...
%                     'LineWidth',2,'Color',color(g,1:3),...
%                     'MarkerSize',20,'Marker','.'); 
%         end
%     elseif numel(groupname) >=5
%         for g = 1:4;
%             set(errorbar1(g),'DisplayName',gnshow{g},...
%                     'LineWidth',2,'Color',color(g,1:3),...
%                     'MarkerSize',20,'Marker','.'); 
%         end
%         for g = 5:numel(groupname);
%             set(errorbar1(g),'DisplayName',gnshow{g},...
%                     'LineWidth',2,...
%                     'MarkerSize',20,'Marker','.'); 
%         end  
%     end
% 
% 
%     if m ==legendposition; % if making righttop cornor
%         for g = 1:numel(groupname);
%             %set(errorbar1(g),'DisplayName',gnshow{g},...
%                 %'LineWidth',2);
% 
%             legend1 = legend(axes1,'show');
%             set(legend1,'EdgeColor',[1 1 1],'YColor',[1 1 1],...
%                 'XColor',[1 1 1],'TickDir','in',...
%                 'LineWidth',1);
%         end
%     end
% end
% 
% % create textbox for N
% for g = 1:numel(groupname); gN(g) = size(MWTfG.(groupname{g}),1); end
% n = num2str(gN'); b = cellfunexpr(groupname',' ');
% a = char(cell2mat(cellstr([n,char(b)])'));
% v = a(1,1:end); 
% t = 'N = '; 
% N = [t,v];
% annotation(figure1,'textbox',[0.003 0.02 0.20 0.05],'String',{N},...
%     'FontName','Arial','FitBoxToText','off','EdgeColor','none');
% 
% % save figure 
% %         h = (gcf);
% titlename = ['ShaneSpark_CombineGraph']; % set name of the figure
% savefigjpeg(titlename,pSaveA);
% %         set(h,'PaperPositionMode','auto'); % set to save as appeared on screen
% %         cd(pSaveA);
% %         print (h,'-dtiff', '-r0', titlename); saveas(h,titlename,'fig');
% % finish up
% %         display 'Graph done.';
% %         close;


%% STEP6C: SAVE MATLAB
% cd(pSaveA); save('matlab.mat');  
% O.pSaveA = pSaveA;


%% POST SET UP ********************
%% GRAPH SETTING
[MWTSet] = MWTAnalysisSetUpMaster_Graphing(MWTSet);
cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');


%% GRAPHING SWITCH BOARD
GraphNames = MWTSet.GraphNames;
GraphN = numel(GraphNames);

for x = 1:GraphN
    display ' '; 
    display(sprintf('Running graphing package [%s]',GraphNames{x}));
    addpath(MWTSet.pFunGP{x}); % add path to analysis packs
    switch GraphNames{x}
        
        case 'Individual graphs'
            [MWTSet] = Dance_Graph_Individual(MWTSet);
        
        case 'subplot all in one'
            [MWTSet] = Dance_Graph_Subplot(MWTSet);
        
        case 'subplot SD'
            [MWTSet] = Dance_Graph_Subplot_SD(MWTSet);
    
        otherwise
        error('Graph packs not installed');
    end
end

cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');


%% CREATE REPORT OF INFO OF THIS ANALYSIS
% REPORT
% GET pMWT from MWTfG
MWTfG = MWTSet.MWTfG;
if isstruct(MWTfG) ==1
    A = celltakeout(struct2cell(MWTfG),'multirow');
    pMWT = A(:,2); 
end
[p,mwtfn] = cellfun(@fileparts,pMWT,'UniformOutput',0);
[pExp,gfn] = cellfun(@fileparts,p,'UniformOutput',0);
groupnames = unique(gfn);
pExpU = unique(pExp);
[~,ExpfnU] = cellfun(@fileparts,pExpU,'UniformOutput',0);
Report = nan(numel(pExpU),numel(groupnames));
expstr = 'Experiments = ';
for e = 1:numel(pExpU)
    [fn,p] = dircontent(pExpU{e});
    a = regexpcellout(ExpfnU{e},'_','split');
    a = [a{1,1},'_',a{2,1}];
    expstr = [expstr,a,', ']; 
    for g = 1:numel(groupnames)
        i = ismember(fn,groupnames{g});
        if sum(i) == 0;
            n = 0;
        else
            p1 = p{i};
            fn1 = dircontent(p1);
            n = numel(fn1);
        end
        Report(e,g) = n;
    end
end
expstr = [expstr(1:end-2),'; '];

% sample size string
names = fieldnames(MWTSet.MWTfG);
a = structfun(@size,MWTSet.MWTfG,'UniformOutput',0);
s = [];
str = '';
for x = 1:numel(names)

    str = [str,names{x},' N=',num2str(a.(names{x})(1,1)),'; '];
end
Nstr = str;

% by experiment number
str = '';
for g = 1:numel(groupnames)
    str = [str,groupnames{g},'='];
    a = Report(:,g);
    
    for x = 1:numel(a)
        str = [str,num2str(a(x,1)),','];
    end
    str = [str(1:end-1),'; '];
end
expNstr = str(1:end-2);

% compose
expreport = [Nstr,' ',expstr,expNstr];

MWTSet.expreport = expreport;
[~,fn] = fileparts(MWTSet.pSaveA);
display([fn,' (', char(MWTSet.StatsOption),') ',MWTSet.expreport]);

cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');




display 'Analysis completed';
end
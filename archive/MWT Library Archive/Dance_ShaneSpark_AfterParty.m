function [varargout] = Dance_ShaneSpark_AfterParty(varargin)


%% VARAGOUT
varargout{1} = {}; varargout{2} = {};

%% VARARGIN
if nargin == 1
    a = inputname(1);
    if strcmp(a,'MWTSet') == 1
        MWTSet = varargin{1};
        OPT = 1;
    elseif strcmp(a,'MWTInfo') == 1
        MWTInfo = varargin{1};
        OPT = 2;
    end
end

%% GET REQUIRED INPUT
switch OPT 
    case 1
%         pMWTchorpass = MWTSet.pMWTchorpass;
        pMWTf = MWTSet.pMWT;
    case 2
        pMWTf = MWTInfo.path;
end

%% GET MWT FILE PATH
switch OPT 
    case  1
        % pMWTf = MWTSet.pMWTchorpass;
        [~,MWTfn] = cellfun(@fileparts,pMWTf,'UniformOutput',0);
    case 2
        MWTfn = MWTInfo.MWTfn;
end

%% STEP4A: IMPORT .TRV (revised 20140419, 20150220)
if OPT == 1
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
end

% legend
% L = {'time','N?','N_NoResponse','N_Reversed','?','RevDist'    };
    

%% STEP4X: CHECK TAP CONSISTENCY
% get trv raw data
switch OPT
    case 1
        [r,c] = cellfun(@size,MWTfnImport(:,2),'UniformOutput',0);
    case 2
        [r,c] = cellfun(@size,MWTInfo.datImport,'UniformOutput',0);
end

% check tap consistency
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
    switch OPT
        case 1
            MWTSet.RawBad = MWTfnImport(rproblem,:);
            MWTfnImport = MWTfnImport(~rproblem,:);
            MWTfn = MWTfn(~rproblem);
            pMWTf = pMWTf(~rproblem);    
            % reconstruct
            [MWTSet.MWTfG] = reconstructMWTfG(pMWTf);
        case 2
            % mark problems
            MWTInfo.BadTap = rproblem;
    end
end


%% STEP4B: MAKING SENSE OF TRV 
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
% indexes of .trv
ind.RevDur = 13;
ind.RevDist = 5;

% calculation
B = [];
switch OPT
    case 1
        B.MWTfn = MWTfn;
        A = MWTfnImport(:,2);
    case 2
        B.MWTfn = MWTInfo.MWTfn;
        A = MWTInfo.datImport;
end
        
for m = 1:size(B.MWTfn,1);
    
    % X = tap time
    % B.X.TapTime(:,m) = A{m}(:,1);
    B.X(:,m) = A{m}(:,1);
    
    % basic caluations
    B.N.NoResponse(:,m) = A{m}(:,3);
    B.N.Reversed(:,m) = A{m}(:,4); 
    
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
    B.Y.RevDist(:,m) = A{m}(:,ind.RevDist); 
    B.SD.RevDist(:,m) = A{m}(:,ind.RevDist+1);
    B.E.RevDist(:,m) = A{m}(:,ind.RevDist+1)./B.N.Reversed(:,m);
    % B.Y.RevDistStd(:,m) = B.Y.RevDist(:,m)/B.Y.RevDist(1,m);
    % B.Y.SumRevDist(:,m) = B.Y.RevDist(:,m).*B.N.Reversed(:,m);     
    
    %% Reversal Duration
    B.Y.RevDur(:,m) = A{m}(:,ind.RevDur);
    B.E.RevDur(:,m) = A{m}(:,ind.RevDur+1)./B.N.Reversed(:,m);
    B.SD.RevDur(:,m) = A{m}(:,ind.RevDur+1)./B.N.Reversed(:,m);

    
    %% Reversal Speed = RevDist/RevDur
    B.Y.RevSpeed(:,m) = B.Y.RevDist(:,m)./B.Y.RevDur(:,m); 
    % variance can not be calculated at this point
    B.E.RevSpeed(:,m) = NaN(size(B.Y.RevSpeed(:,m))); 
    B.SD.RevSpeed(:,m) = NaN(size(B.Y.RevSpeed(:,m)));
end
Raw = B;


%% STEP4B: MAKING SENSE OF TRV (AFTERPARTY, MWTINFO)
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

% indexes of .trv
ind.RevDur = 13;
ind.RevDist = 5;

% calculation

if OPT == 2      
    A = MWTInfo.datImport;
    for m = 1:size(MWTInfo,1);
        MWTInfo.time{m} = A{m}(:,1);
        MWTInfo.NForward{m} = A{m}(:,2);
        MWTInfo.NNoResponse{m} = A{m}(:,3);
        MWTInfo.NReversed{m} = A{m}(:,4); 
        MWTInfo.NValid{m} = A{m}(:,4)+A{m}(:,3);
        MWTInfo.NTotal{m} = A{m}(:,4)+A{m}(:,3)+A{m}(:,2);  
        MWTInfo.RevFreq{m} = MWTInfo.NReversed{m}./MWTInfo.NValid{m};   
        MWTInfo.RevDist{m} = A{m}(:,ind.RevDist);  
        MWTInfo.RevDur{m} = A{m}(:,ind.RevDur);    
        MWTInfo.RevSpeed{m} =  MWTInfo.RevDist{m}./MWTInfo.RevDur{m}; 
        
    end

        % check for low Total N
        MWTInfo.lowTotalNIndex = false(size(MWTInfo,1),1);
        MWTInfo.lowTotalNIndex(sum(cell2mat(MWTInfo.NTotal') <3) > 0) = true; % less than 3 total worms 
        disp(' '); disp('Plates with less than 3 worms tracked at any taps: ');
        tabulate(MWTInfo.groupNames(MWTInfo.lowTotalNIndex))
        % check for low Rev N at any taps
        MWTInfo.lowRevNIndex = false(size(MWTInfo,1),1);
        MWTInfo.lowRevNIndex(sum(cell2mat(MWTInfo.NReversed') <3) > 0) = true; % less than 3 total worms 
        disp(' '); disp('Plates with less than 3 worms reversed at any taps: ');
        tabulate(MWTInfo.groupNames(MWTInfo.lowRevNIndex))

        % check for low Rev N at first 3 taps
        MWTInfo.lowRevN3Index = false(size(MWTInfo,1),1);
        a = cell2mat(MWTInfo.NReversed');
        MWTInfo.lowRevN3Index(sum(a(1:3,:) <3) >0) = true; % less than 3 total worms 
        % flag low N plates
        disp(' '); disp('Plates with less than 3 worms reversed at first 3 taps: ');
        tabulate(MWTInfo.groupNames(MWTInfo.lowRevN3Index))
        
end


%% STATS
if OPT == 2
   disp(' '); disp('choose statistics option: ');
   choice = chooseoption({'by plates, excluding low N';...
       'by plates, including low N';...
       'by exp [under construction]'});
end

%% by plates, excluding low N'
MWTStats = table;
a = tabulate(MWTInfo.groupNames);
MWTStats.groupNames = a(:,1);
MWTStats.statsName = repmat(choice,size(MWTStats,1),1);
MWTStats.NPlateAll = a(:,2);
if OPT ==2 && strcmp(choice,'by plates, excluding low N') == 1
    analysisNames = {'RevFreq','RevDur','RevSpeed'};
    
    
    % excluding low first 3 taps reversals
    gname = MWTInfo.groupNames(~MWTInfo.lowRevN3Index);
    a = tabulate(gname);
    [~,i] = ismember(MWTStats.groupNames,a(:,1));
    MWTStats.NPlateValid = a(i,2);

    
    for x = 1:numel(analysisNames)
      
        D = cell2mat(MWTInfo.(analysisNames{x})(~MWTInfo.lowRevN3Index)');
        [m,se,n,gn] = grpstats(D',gname,{'mean','sem','numel','gname'});
        
        [~,i] = ismember(MWTStats.groupNames,gn);
        if isequal(gn(i),MWTStats.groupNames) ~=1
            error('group name matching issue')
        end
        MWTStats.([analysisNames{x},'_Mean']) = num2cell(m(i,:)',1)';
        MWTStats.([analysisNames{x},'_SE']) = num2cell(se(i,:)',1)';
        MWTStats.([analysisNames{x},'_N']) = num2cell(n(i,:)',1)';
    end
end

%% by plates, including low N'
MWTStats = table;
a = tabulate(MWTInfo.groupNames);
MWTStats.groupNames = a(:,1);
MWTStats.statsName = repmat(choice,size(MWTStats,1),1);
MWTStats.NPlateAll = a(:,2);

if OPT ==2 && strcmp(choice,'by plates, including low N') == 1
    analysisNames = {'RevFreq','RevDur','RevSpeed'};
    % excluding low first 3 taps reversals
    gname = MWTInfo.groupNames;
    a = tabulate(gname);
    [~,i] = ismember(MWTStats.groupNames,a(:,1));
    
    for x = 1:numel(analysisNames)
        D = cell2mat(MWTInfo.(analysisNames{x})');
        [m,se,n,gn] = grpstats(D',gname,{'mean','sem','numel','gname'});        
        [~,i] = ismember(MWTStats.groupNames,gn);
        if isequal(gn(i),MWTStats.groupNames) ~=1
            error('group name matching issue')
        end
        MWTStats.([analysisNames{x},'_Mean']) = num2cell(m(i,:)',1)';
        MWTStats.([analysisNames{x},'_SE']) = num2cell(se(i,:)',1)';
        MWTStats.([analysisNames{x},'_N']) = num2cell(n(i,:)',1)';
    end
end


%% VARARGOUT
switch OPT
    case 1
        MWTSet.Raw = Raw;
        varargout{1} = MWTSet;
    case 2
        varargout{1} = MWTInfo;
        varargout{2} = MWTStats;
end



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
end
%% Script name: RL201411201225
%% OBJECTIVE: create initial and hab level graph


%% manually define data source folder names
DataSources = {'ShaneSpark_20141117025708_slo1 10sISI'};
pDataHome = '/Users/connylin/OneDrive/Dance_Output/';
pData = [pDataHome,char(DataSources)];

%% define path for source data
pFun = '/Users/connylin/OneDrive/MATLAB/Functions_Developer';
addpath(pFun);
pScript = '/Users/connylin/OneDrive/RL_Scripts';
% create output folder
% pSave = mfilename('fullpath'); % get script name
% if isdir(pSave) == 0; mkdir(pSave); end % create output directory

%% Organize raw data by groups
cd(pData); load('matlab.mat','MWTData','MWTSet');
measures = fieldnames(MWTSet.Raw.Y);
gnames = fieldnames(MWTSet.MWTfG); % get group names
% declare structural array
A = [];

for m = 1:numel(measures); % repeat by measure
    Measure = measures{m};
    for g = 1:numel(gnames); % repeat by group
    % check plate name for duplication
    gname = gnames{g};
    platenames = MWTSet.MWTfG.(gname)(:,1); % get plate name
    matchPindex = ismember(MWTSet.Raw.MWTfn,platenames); % match plate name

    % see if duplicated plate names
    platenamesU = unique(platenames);
    if numel(platenames) ~= numel(platenamesU)
       a = tabulate(platenames);
       a = a(cell2mat(a(:,2))>1,1:2);
        warning('duplicated plate names');
        disp(a)
       % mark (not remove)
       for p = 1:size(a,1) % for each duplicated plates
           dupindex = find(ismember(platenames,a(p)));
           matchPindex(dupindex) = false; % erase all index
           matchPindex(dupindex(1)) = true; % mark only the first one
       end
       % validate
       if sum(matchPindex) ~= numel(platenamesU)
           error('still duplicated plate index');
       end
    end
    % display
    display(sprintf('N(%s) = %d',gname,sum(matchPindex)));

    % match plate name
    A.(Measure).(gname) = MWTSet.Raw.Y.(Measure)(:,matchPindex);
    end
end

MWTData.RawByGroup = A;

cd(pData); save('matlab.mat','MWTData','-append');


%% create initial and hab level graph

% group settings
groupset = ...
{...
'N2',[0 0 0];
'BZ142',[1 0 0];
'NM1968',[0.847058832645416 0.160784319043159 0];
'NM1630',[1 0.600000023841858 0.200000002980232];
'CX3940',[0 0.400000005960464 1];...
};

% load data
load('matlab.mat','MWTData','MWTSet');
Data = MWTData.RawByGroup;
GroupNames = MWTSet.GraphGroup;
measures = fieldnames(Data);

for m = 1%:numel(measures);
    M = measures{m};
    groups = fieldnames(Data.(M));
    clearvars n y e
    n = nan(numel(groups),2);
    y = n;
    e = n;
    for g = 1:numel(groups);
        G = groups{g};
        % get data
        D = Data.(M).(G);
        % get initial mean
        d = D(1,:);
        y(g,1) = nanmean(d);
        n = sum(~isnan(d));
        N(g,1) = n;
        e(g,1) = nanstd(d)/sqrt(n-1);
        % get hab level mean
        d = nanmean(D(28:30,:));% mean of last 3 taps per plate
        y(g,2) = nanmean(d);
        n = sum(~isnan(d));
        N(g,2) = n;
        e(g,2) = nanstd(d)/sqrt(n-1);

    end

    % reorg by groupset
    [~,i] = ismember(groupset(:,1),groups);
    y = y(i,:);
    e = e(i,:);

    % Create figure
    figure1 = figure('Color',[1 1 1]);
    axes1 = axes('Parent',figure1,...
        'XTickLabel',{'initial','hab level'},...
        'XTick',[1 2],...
        'Position',[0.13 0.134 0.34 0.8],...
        'FontSize',24);
    xlim(axes1,[0.5 2.2]);
    hold(axes1,'all');
    errorbar1 = errorbar(y',e');
    for g = 1:size(groupset,1)
        set(errorbar1(g),'MarkerSize',25,...
            'DisplayName',groupset{g,1},'Color',groupset{g,2},...
            'MarkerSize',10,'MarkerFaceColor',groupset{g,2},...
            'MarkerEdgeColor',groupset{g,2},...
            'Marker','o',...
            'LineWidth',6);
    end
    ylabel(M,'FontSize',24);
    legend1 = legend(axes1,'show');
    set(legend1,'EdgeColor',[1 1 1],'Location',...
        'EastOutside','YColor',[1 1 1],...
        'XColor',[1 1 1],...
        'Position',[0.50 0.25 0.3 0.5]);

    savefigjpeg([M,'_initial_hablevel'],pData);
end

return


%% CODE RETURN
display '*** CODE RETURN ***';
return
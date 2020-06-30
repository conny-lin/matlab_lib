function [varargout] = Dance_Graph_Subplot_SD(MWTSet)

%% INSTRUCTION
% REVISION RECORD: 20140419003


%% VARARGOUT
varargout{1} = {};

%% OBTAIN VARIABLE FROM MWTSET
% get field out
names = fieldnames(MWTSet);
for x = 1:numel(names)
   eval([names{x},'= MWTSet.',names{x},';']);
end

% See if graph has settings
if isempty(MWTSet.GraphSetting) ==0
    Colorchoice = MWTSet.GraphSetting.color;
    Linechoice = MWTSet.GraphSetting.linestyle;
else
    Colorchoice = [];
    Linechoice = [];
end


%% get subplot number and arrangement
n = numel(fieldnames(Graph));
y = floor(sqrt(n));
x = ceil(sqrt(n));
subplotcol = x;
subplotrow = y;

%% set linewidth and marker size
if y <= 2
    linewithset = 1;
    markersizeset = 5;
elseif y > 2
    linewithset = 1;
    markersizeset = 2;
end

%% get group names
% groupname = MWTSet.GraphGroup';
groupname = GraphGroup';
gnshow = regexprep(groupname,'_',' ');


%% MAKE LEGEND 
M = fieldnames(Graph);
figure1 = figure('Color',[1 1 1]);
for m = 1:1%numel(M);
    
    % get variables
    X = Graph.(M{m}).X;
    Y = Graph.(M{m}).Y;
    E = Graph.(M{m}).SD;
    axes1 = axes('Parent',figure1,'FontName','Arial','FontSize',20);
    hold on;    
    errorbar1 = errorbar(X,Y,E,'LineWidth',5);
    box(axes1,'off');
    
    % create legend        
    for g = 1:numel(gnshow)
        set(errorbar1(g),'DisplayName',gnshow{g});
    end

    % set color and line spec
    for g = 1:size(Colorchoice,1);
    set(errorbar1(g),...
        'LineWidth',5,'Color',Colorchoice(g,1:3),...
        'MarkerSize',20,'Marker','.',...
        'LineStyle',Linechoice{g}); 
    end

    legend1 = legend(axes1,'show');
    set(legend1,'EdgeColor',[1 1 1],'YColor',[1 1 1],...
        'XColor',[1 1 1],'TickDir','in',...
        'LineWidth',1)
end
% save figure 
titlename = ['SubplotSD_legend_',char(MWTSet.StatsOption),'_',generatetimestamp]; % set name of the figure
savefigjpeg(titlename,pSaveA);



%% MAKE SUBPLOT
figure1 = figure('Color',[1 1 1]);
for m = 1:numel(M);
    
    % get variables
    X = Graph.(M{m}).X;
    Y = Graph.(M{m}).Y;
    E = Graph.(M{m}).SD;
    
    % plot
    subplot1 = subplot(subplotcol,subplotrow,m,'Parent',figure1);
    errorbar1 = errorbar(X,Y,E);
    box(subplot1,'off');
    ylabel(M{m},'FontName','Arial');%,'FontSize',16); % Create ylabel
    
    maxy = (max(max(Y))+max(max(E)))*1.1;
    if isnan(maxy) ==0
        ylim([0 maxy]); 
    end
    xlim([min(min(X))*0.9 max(max(X))]); 
    

    for g = 1:numel(gnshow)
        set(errorbar1(g),'DisplayName',gnshow{g});
    end

    % set color and line spec
    for g = 1:size(Colorchoice,1);
    set(errorbar1(g),...
        'LineWidth',linewithset,'Color',Colorchoice(g,1:3),...
        'MarkerSize',markersizeset,'Marker','.',...
        'LineStyle',Linechoice{g}); 
    end

end


% save figure 
titlename = ['Subplot_SD_',char(MWTSet.StatsOption),'_',generatetimestamp]; % set name of the figure
savefigtiff(titlename,pSaveA);


%% 
varargout{1} = MWTSet;
end

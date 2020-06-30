function [varargout] = Dance_Graph_Individual(MWTSet)

varargout = {};

display 'Making individual graphs...';


%% INPUT       
% get field out
names = fieldnames(MWTSet);
for x = 1:numel(names)
   eval([names{x},'= MWTSet.',names{x},';']);
end
pSaveA = MWTSet.pSaveA;


% See if graph has settings
if isempty(MWTSet.GraphSetting) ==0
    Colorchoice = MWTSet.GraphSetting.color;
    Linechoice = MWTSet.GraphSetting.linestyle;
else
    Colorchoice = [];
    Linechoice = [];
end

%% MWTSet input validation
% name = fieldnames(MWTSet);
% reqname = {'pSaveA','MWTfG'};
% nameN = numel(reqname);
% i = ismember(name,reqname);
% if sum(i) == nameN
% %     MWTfG = MWTSet.MWTfG;
%     pSaveA = MWTSet.pSaveA;
%     Colorchoice = MWTSet.GraphSetting.color;
%     Linechoice = MWTSet.GraphSetting.linestyle;
% else
%     error('missing required inputs');
% end


%% get variables

gnameL = MWTSet.GraphGroup;  
Graph = MWTSet.Graph;
M = fieldnames(Graph);

%% make legend graph
for m = 1:1%numel(M);% for each measure
    
    %% get coordinates
    X = Graph.(M{m}).X;
    Y = Graph.(M{m}).Y;
    E = Graph.(M{m}).E;
    
    %% Create figure
    figure1 = figure('Color',[1 1 1]);
    axes1 = axes('Parent',figure1,'FontSize',18);
    box(axes1,'off');
    hold(axes1,'all');
    errorbar1 = errorbar(X,Y,E,'LineWidth',5);
    
    %% create legend        
    gnshow = regexprep(gnameL,'_',' ');
    for g = 1:numel(gnameL)
        set(errorbar1(g),'DisplayName',gnshow{g});
    end
    
    %% set color   
    for g = 1:size(Colorchoice,1)
        set(errorbar1(g),'Color',Colorchoice(g,1:3),...
            'LineStyle',Linechoice{g,1});
    end
    
    %% set legend
    legend1 = legend(axes1,'show');
    set(legend1,'Location','NorthEastOutside',...
        'EdgeColor',[1 1 1],...
        'YColor',[1 1 1],...
        'XColor',[1 1 1]);
    
    ylabel('Legend','FontName','Arial','FontSize',30); % Create ylabel
    figname = ['Legend_',char(MWTSet.StatsOption),'_',generatetimestamp];
    
    
    savefigtiff(figname,pSaveA);
    

end 


%% make graphs for each measure
for m = 1:numel(M);% for each measure
    
    % get coordinates
    X = Graph.(M{m}).X;
    Y = Graph.(M{m}).Y;
    E = Graph.(M{m}).E;
    
    % Create figure
    figure1 = figure('Color',[1 1 1]);
    axes1 = axes('Parent',figure1,'FontSize',18);
    box(axes1,'off');
    hold(axes1,'all');
    errorbar1 = errorbar(X,Y,E,'LineWidth',5);
    
    maxy = (max(max(Y))+max(max(E)))*1.1;
    if isnan(maxy) == 0
        ylim([0 maxy]);
    end
    xlim([min(min(X))*0.9 max(max(X))*1.1]);
    
    % create legend        
    gnshow = regexprep(gnameL,'_',' ');
    for g = 1:numel(gnameL)
        set(errorbar1(g),'DisplayName',gnshow{g});
    end
    
    %% set color   
%     Colorchoice = [];
%     Colorchoice(1,1:3) = [0 0 0]; % block
%     Colorchoice(2,1:3) = [1 0 0]; % red
    
    for g = 1:size(Colorchoice,1)
        set(errorbar1(g),'Color',Colorchoice(g,1:3),...
            'LineStyle',Linechoice{g,1});
    end
    
    % set legend
%     legend1 = legend(axes1,'show');
%     set(legend1,'Location','NorthEastOutside',...
%         'EdgeColor',[1 1 1],...
%         'YColor',[1 1 1],...
%         'XColor',[1 1 1]);
    
    ylabel(M{m},'FontName','Arial','FontSize',30); % Create ylabel
    figname = [M{m},'_',char(MWTSet.StatsOption),'_',generatetimestamp];
%     ,'[',num2str(ti,'%.0f'),':',...
%         num2str(int,'%.0f'),...
%         ':',num2str(tf,'%.0f'),']'];
    savefigtiff(figname,pSaveA);
    

end  

%% VARARGOUT
varargout{1} = MWTSet;
end


function [varargout] = Dance_Graph_Subplot(MWTSet)

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
n = numel(fieldnames(MWTSet.Graph));
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
    E = Graph.(M{m}).E;
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
titlename = ['Subplot_legend_',char(MWTSet.StatsOption),'_',generatetimestamp]; % set name of the figure
savefigjpeg(titlename,pSaveA);



%% MAKE SUBPLOT
figure1 = figure('Color',[1 1 1]);
for m = 1:numel(M);
    
    % get variables
    X = Graph.(M{m}).X;
    Y = Graph.(M{m}).Y;
    E = Graph.(M{m}).E;
    
    % plot
    subplot1 = subplot(subplotcol,subplotrow,m,'Parent',figure1);
    errorbar1 = errorbar(X,Y,E);
    box(subplot1,'off');
    ylabel(M{m},'FontName','Arial');%,'FontSize',16); % Create ylabel
    
%     maxy = (max(max(Y))+max(max(E)))*1.1;
%     if isnan(maxy) ==0
%         ylim([0 maxy]); 
%     end
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
titlename = ['Subplot_',char(MWTSet.StatsOption),'_',generatetimestamp]; % set name of the figure
savefigtiff(titlename,pSaveA);


%% 
varargout{1} = MWTSet;
end

% 
% %%
% 
% %% STEP4C.SUBPLOTS
% % source code: LadyGaGaSubPlot(MWTftrvG,pExp,SavePrefix)
% % source code: Dance_ShaneSpark+20140227a(varargin)
% % define universal settings
% % switch graphing sequence
% i = [2,3,1,4];
% % k = fieldnames(Stats.Y)';
% k = fieldnames(Graph)';
% 
% M = k(i);
% groupname = fieldnames(MWTfG)';
% groupsize = numel(fieldnames(MWTfG));
% gnshow = regexprep(groupname,'_',' ');
% xmax = size(Graph.(M{m}).X,1)+1;
% 
% subplotposition(1,1:4) = [0.065 0.55 0.4 0.4];
% subplotposition(2,1:4) = [0.55 0.55 0.4 0.4];
% subplotposition(3,1:4) = [0.065 0.11 0.4 0.4];
% subplotposition(4,1:4) = [0.55 0.11 0.4 0.4];
% 
% legendposition = 2;
% % preset color codes
% % color(1,:) = [0,0,0];
% % color(2,:) = [0.30 0.50 0.92]; %[0.04 0.14 0.42];
% % color(3,:) = [0.168 0.505 0.337];
% % color(4,:) = [0.847 0.16 0];
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
%     if numel(groupname) <= size(Colorchoice,1)
%         for g = 1:size(Colorchoice,1);
%             set(errorbar1(g),'DisplayName',gnshow{g},...
%                     'LineWidth',2,'Color',Colorchoice(g,1:3),...
%                     'MarkerSize',20,'Marker','.',...
%                     'LineStyle',Linechoice{g}); 
%         end
%     elseif numel(groupname) > size(Colorchoice,1)
%         for g = 1:size(Colorchoice,1);
%             set(errorbar1(g),'DisplayName',gnshow{g},...
%                     'LineWidth',2,'Color',Colorchoice(g,1:3),...
%                     'MarkerSize',20,'Marker','.',...
%                     'LineStyle',Linechoice{g}); 
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
% %% create textbox for N
% for g = 1:numel(groupname); gN(g) = size(MWTfG.(groupname{g}),1); end
% n = num2str(gN'); b = cellfunexpr(groupname',' ');
% a = char(cell2mat(cellstr([n,char(b)])'));
% v = a(1,1:end); 
% t = 'N = '; 
% N = [t,v];
% annotation(figure1,'textbox',[0.003 0.02 0.20 0.05],'String',{N},...
%     'FontName','Arial','FitBoxToText','off','EdgeColor','none');
% 
% %% save figure 
% %         h = (gcf);
% titlename = ['Subplot']; % set name of the figure
% savefigjpeg(titlename,pSaveA);
% 
% %         set(h,'PaperPositionMode','auto'); % set to save as appeared on screen
% %         cd(pSaveA);
% %         print (h,'-dtiff', '-r0', titlename); saveas(h,titlename,'fig');
% % finish up
% %         display 'Graph done.';
% %         close;
% 
% 
% 
% 
% end

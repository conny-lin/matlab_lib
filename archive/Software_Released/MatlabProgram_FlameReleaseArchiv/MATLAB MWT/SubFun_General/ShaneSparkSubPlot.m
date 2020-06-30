function ShaneSparkSubPlot(MWTftrvG,pExp)
% source code: Analysis_Subplot
% create subplots 
clearvars Graph;
% Set up graphing variables
LabelY = {'Dist'  'Freq'  'DistStd'  'FreqStd'};
VDIndex = [10,8,12,13];
groupname = MWTftrvG(:,1)';
groupsize = numel(groupname);

% make stats by groups
for m = 1:numel(LabelY);
    VD = LabelY{m};
    Graph.(VD).Mean = [];
    Graph.(VD).SE = [];
    for g = 1:groupsize;
        gn = groupname{g};
        k = strmatch(gn, char(groupname), 'exact'); % locate group name in MWTftrvG
        % evaluate equality for size
        data = cell2mat(MWTftrvG{k,2}(:,VDIndex(m))');
        Graph.(VD).Mean(:,g) = mean(data,2);
        Graph.(VD).SE(:,g) = std(data',1)'./sqrt(size(data,2));
    end
end

%% CREATEFIGURE

% Create figure
figure1 = figure('Color',[1 1 1]);

% define current graph
x = 1;
VD = LabelY{x};
% Create axes for Dist
xmax = size(Graph.(VD).Mean,1)+1; % define xlim as last stim+1
axes1 = axes('Parent',figure1,'XTickLabel','',...
    'Position',[0.065 0.55 0.4 0.4],...
    'FontName','Arial');
ylim(axes1,[0 1.1]);
xlim(axes1,[0 xmax]);
hold(axes1,'all');
% Create multiple error bars using matrix input to errorbar
errorbar1 = errorbar(Graph.(VD).Mean,Graph.(VD).SE,'Marker','.','LineWidth',1);
set(errorbar1(1),'Color',[0 0 0]); 
ylabel(VD,'FontName','Arial'); % Create ylabel

% Create axes for DistStd
axes2 = axes('Parent',figure1,'XTickLabel','',...
    'Position',[0.55 0.55 0.4 0.4],'FontName','Arial');
ylim(axes2,[0 1.1]);
xlim(axes2,[0 xmax]);
hold(axes2,'all');

% Create multiple error bars using matrix input to errorbar
VD = LabelY{3};
errorbar2 = errorbar(Graph.(VD).Mean,Graph.(VD).SE,'Marker','.','LineWidth',1);
ylabel(VD,'FontName','Arial'); % Create ylabel
% create legend

for g = 1:numel(groupname);
    name = groupname{g};
    if g==1;
        set(errorbar2(1),'DisplayName',name,'Color',[0 0 0]); 
    else
        set(errorbar2(g),'DisplayName',name);
    end
end



% Create axes for Freq
VD = LabelY{2};
axes3 = axes('Parent',figure1,'Position',[0.065 0.11 0.4 0.4],...
    'FontName','Arial');
ylim(axes3,[0 1.1]);
xlim(axes3,[0 xmax]);
hold(axes3,'all');
errorbar3 = errorbar(Graph.(VD).Mean,Graph.(VD).SE,'Marker','.','LineWidth',1);
set(errorbar3(1),'Color',[0 0 0]); 
xlabel('Stim'); % Create xlabel
ylabel(VD,'FontName','Arial'); % Create ylabel

% Create axes for FreqStd
VD = LabelY{4};
axes4 = axes('Parent',figure1,'Position',[0.55 0.11 0.4 0.4],...
    'FontName','Arial');
ylim(axes4,[0 1.1]);
xlim(axes4,[0 xmax]);
hold(axes4,'all');

% Create multiple error bars using matrix input to errorbar
errorbar4 = errorbar(Graph.(VD).Mean,Graph.(VD).SE,'Marker','.','LineWidth',1);
set(errorbar4(1),'Color',[0 0 0]); 
xlabel('Stim'); % Create xlabel
ylabel(VD,'FontName','Arial'); % Create ylabel

% Create legend
legend1 = legend(axes2,'show');
set(legend1,'EdgeColor',[1 1 1],'YColor',[1 1 1],'XColor',[1 1 1],...
    'TickDir','in',...
    'Position',[0.85 0.85 0.15 0.1],...
    'LineWidth',1,...
    'ColorOrder',[0 0 0;1 0 0;0 0 1;0.2 0.6 0.4;0.75 0 0.75;1 1 0;1 0.4 0;0.5 0 0.5]);

%% Create textbox for stats significance
% % Text Distance ----------
% % Depth
% if Stats.ANOVA.pValue(2,1)==0
% elseif Stats.ANOVA.pValue(2,1)<0.05 
%         annotation(figure1,'textbox',[0.19 0.9 0.1 0.07],...
%             'String',{'Depth*'},...
%             'FontName','Arial',...
%             'FitBoxToText','off',...
%             'EdgeColor','none');
% else
% end
% 
% 
% % Rate
% if Stats.ANOVA.pValue(3,1)==0
% elseif Stats.ANOVA.pValue(3,1)<0.05 
%     annotation(figure1,'textbox',[0.14 0.9 0.1 0.07],...
%         'String',{'Rate*'},...
%         'FontName','Arial',...
%         'FitBoxToText','off',...
%         'EdgeColor','none');
% else
% end
% 
% % Initial
% if Stats.ANOVA.pValue(1,1)==0
% elseif Stats.ANOVA.pValue(1,1)<0.05 
%     annotation(figure1,'textbox',[0.08 0.9 0.1 0.07],...
%         'String',{'Initial*'},...
%         'FontName','Arial',...
%         'FitBoxToText','off',...
%         'EdgeColor','none');
% else
% end
% 
% % Create textbox(DistStd)--------------
% % Depth
% if Stats.ANOVA.pValue(2,3)==0
% elseif Stats.ANOVA.pValue(2,3)<0.05 
%     annotation(figure1,'textbox',[0.68 0.9 0.1 0.07],...
%         'String',{'Depth*'},...
%         'FontName','Arial',...
%         'FitBoxToText','off',...
%         'EdgeColor','none');
% else
% end
% 
% % Rate
% if Stats.ANOVA.pValue(3,3)==0
% elseif Stats.ANOVA.pValue(3,3)<0.05 
%     annotation(figure1,'textbox',[0.63 0.9 0.1 0.07],...
%         'String',{'Rate*'},...
%         'FontName','Arial',...
%         'FitBoxToText','off',...
%         'EdgeColor','none');
% else
% end
% % Initial
% if Stats.ANOVA.pValue(1,3)==0
% elseif Stats.ANOVA.pValue(1,3)<0.05 
% annotation(figure1,'textbox',[0.57 0.9 0.1 0.07],...
%     'String',{'Initial*'},...
%     'FontName','Arial',...
%     'FitBoxToText','off',...
%     'EdgeColor','none');
% else
% end
% 
% %% Create textbox (Freq)----------------
% % Depth
% if Stats.ANOVA.pValue(2,2)==0
% elseif Stats.ANOVA.pValue(2,2)<0.05 
%     annotation(figure1,'textbox',[0.19 0.44 0.1 0.07],...
%         'String',{'Depth*'},...
%         'FontName','Arial',...
%         'FitBoxToText','off',...
%         'EdgeColor','none');
% else
% end
% % Rate
% if Stats.ANOVA.pValue(3,2)==0
% elseif Stats.ANOVA.pValue(3,2)<0.05 
%     annotation(figure1,'textbox',[0.14 0.44 0.1 0.07],...
%     'String',{'Rate*'},...
%     'FontName','Arial',...
%     'FitBoxToText','off',...
%     'EdgeColor','none');
% else
% end
% % Initial
% if Stats.ANOVA.pValue(1,2)==0
% elseif Stats.ANOVA.pValue(1,2)<0.05 
%     annotation(figure1,'textbox',[0.08 0.44 0.1 0.07],...
%         'String',{'Initial*'},...
%         'FontName','Arial',...
%         'FitBoxToText','off',...
%         'EdgeColor','none');
% else
% end
% 
% %% Create textbox(FreqStd)------------
% % Depth
% if Stats.ANOVA.pValue(2,4)==0
% elseif Stats.ANOVA.pValue(2,4)<0.05 
%     annotation(figure1,'textbox',[0.68 0.45 0.1 0.07],...
%     'String',{'Depth*'},...
%     'FontName','Arial',...
%     'FitBoxToText','off',...
%     'EdgeColor','none');
% else
% end
% 
% % Rate
% if Stats.ANOVA.pValue(3,4)==0
% elseif Stats.ANOVA.pValue(3,4)<0.05 
%     annotation(figure1,'textbox',[0.63 0.45 0.1 0.07],...
%     'String',{'Rate*'},...
%     'FontName','Arial',...
%     'FitBoxToText','off',...
%     'EdgeColor','none');
% else
% end
% 
% %% create p value for curves
% s = size(Stats.ANOVA.pValue,1); % assess if only > 2 groups comparison
% 
% if s==5; % if only 2 groups
%     anovap = 5; % set pvalue index
% elseif s==7; % if more than 2 groups
%     anovap = 7; % set pvalue index
% else % indication that ANOVArm have not been run
%     display('ANOVArm have not been run');
%     return
% end
% 
% % Create textbox
% if Stats.ANOVA.pValue(anovap,1)<0.05
%     annotation(figure1,'textbox',[0.25 0.9 0.1 0.07],...
%         'String',{'Curve*'},...
%         'FontName','Arial',...
%         'FitBoxToText','off',...
%         'EdgeColor','none');
% else
% end
% 
% % Create textbox
% if Stats.ANOVA.pValue(anovap,2)<0.05
%     annotation(figure1,'textbox',[0.74 0.9 0.1 0.07],...
%         'String',{'Curve*'},...
%         'FontName','Arial',...
%         'FitBoxToText','off',...
%         'EdgeColor','none');
% else 
% end
% 
% % Create textbox
% if Stats.ANOVA.pValue(anovap,3)<0.05
%     annotation(figure1,'textbox',[0.25 0.44 0.1 0.07],...
%         'String',{'Curve*'},...
%         'FontName','Arial',...
%         'FitBoxToText','off',...
%         'EdgeColor','none');
% else
% end
% 
% % Create textbox
% if Stats.ANOVA.pValue(anovap,4)<0.05
%     annotation(figure1,'textbox',[0.74 0.45 0.1 0.07],...
%         'String',{'Curve*'},...
%         'FontName','Arial',...
%         'FitBoxToText','off',...
%         'EdgeColor','none');
% else
% end


%% create textbox for N
t = 'N = ';
N=[];
v=[];
VI.Plate = cellfun(@size,MWTftrvG(:,2),cellfunexpr(MWTftrvG,[1]))';
v = num2str(VI.Plate);
% for g =1:numel(groupname);
%     a = '%d,';
%     a1 = VI.Plate(1,g);
%     v=strcat(v,sprintf(a,a1));
% end
N = [t,v];
% Create textbox
% Create textbox
annotation(figure1,'textbox',[0.003 0.02 0.08 0.05],'String',{N},...
    'FontName','Arial','FitBoxToText','off','EdgeColor','none');

%% Create textbox for source folder
[~,expname] = fileparts(pExp);
annotation(figure1,'textbox',[0.001 0.01 0.999999999999 0.02],...
    'String',{expname},'FontSize',8,'FontName','Arial',...
    'FitBoxToText','off','EdgeColor','none');

% save work
h = (gcf);
titlename ='GraphCombine_ShaneSpark'; % set name of the figure

% save figure   
set(h,'PaperPositionMode','auto'); % set to save as appeared on screen
cd(pExp);
print (h,'-dtiff', '-r0', titlename); % save as tiff
saveas(h,titlename,'fig'); % save as matlab figure 

% % move variables
% Temp = Graph;
% clearvars Graph;
% Graph.Curve = Temp;

% finish up
display 'Graph done.';
close;

                                 


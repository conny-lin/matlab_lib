function linegender(X,Y,E)

%% PLOT, 
display 'processing graphs';


% Create figure
figure1 = figure('Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1,'FontSize',16,'FontName','Calibri');
xlim(axes1,[0 25.5]);
hold(axes1,'all');

% Create multiple error bars using matrix input to errorbar
errorbar1 = errorbar(X,Y,E,'LineWidth',3);
set(errorbar1(1),'DisplayName','Female','Color',[1 0 0]);
%set(errorbar1(2),'DisplayName','Male',...
   % 'Color',[0.87058824300766 0.490196079015732 0]);
% set(errorbar1(3),'DisplayName','40s','Color',[1 1 0]);
% set(errorbar1(4),'DisplayName','50s','Color',[0 0.50 0]);
set(errorbar1(2),'DisplayName','Male','Color',[0 0 1]);
% set(errorbar1(6),'DisplayName','70s',...
%     'Color',[0.48 0.06 0.89]);


% Create legend
legend1 = legend(axes1,'show');
set(legend1,'EdgeColor',[1 1 1],'Location','EastOutside','YColor',[1 1 1],...
    'XColor',[1 1 1]);



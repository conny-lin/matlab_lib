function bargenderallgame(ymatrix1)
%CREATEFIGURE(YMATRIX1)
%  YMATRIX1:  bar matrix data

%  Auto-generated by MATLAB on 04-Dec-2013 17:44:06

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,...
    'XTickLabel',{'1','7','11','2','8','3','6','4','10','5','9','12'},...
    'XTick',[1 2 3 4 5 6 7 8 9 10 11 12],...
    'Position',[0.13 0.11 0.775 0.717586206896552],...
    'FontSize',14);
xlim(axes1,[0 13]);
box(axes1,'on');
hold(axes1,'all');

% Create multiple lines using matrix input to bar
bar1 = bar(ymatrix1,'BarWidth',1,'Parent',axes1);
set(bar1(1),'FaceColor',[1 0 0],'DisplayName','Female');
set(bar1(2),'FaceColor',[0 0 1],'DisplayName','Male');

xlabel('Game ID','FontSize',18,'FontName','Calibri');


% Create legend
legend1 = legend(axes1,'show');
set(legend1,'EdgeColor',[1 1 1],'YColor',[1 1 1],'XColor',[1 1 1],...
    'Position',[0.841020076920363 0.867014483302084 0.138855368547334 0.104688537190371]);

% Create textbox
annotation(figure1,'textbox',...
    [0.192 0.811 0.0947 0.0714],...
    'String',{'Logic'},...
    'HorizontalAlignment','center',...
    'FontSize',14,...
    'EdgeColor','none');

% Create line
annotation(figure1,'line',[0.338805970149254 0.338805970149254],...
    [0.827586206896552 0.110837438423645],'LineStyle','--','LineWidth',1);

% Create line
annotation(figure1,'line',[0.458805970149254 0.458805970149254],...
    [0.824827586206897 0.10807881773399],'LineStyle','--','LineWidth',1);

% Create line
annotation(figure1,'line',[0.578208955223881 0.578208955223881],...
    [0.829753694581281 0.113004926108374],'LineStyle','--','LineWidth',1);

% Create line
annotation(figure1,'line',[0.694626865671642 0.694626865671643],...
    [0.827290640394089 0.110541871921182],'LineStyle','--','LineWidth',1);

% Create textbox
annotation(figure1,'textbox',...
    [0.343 0.813 0.121 0.0714],...
    'String',{'Memory'},...
    'HorizontalAlignment','center',...
    'FontSize',14,...
    'EdgeColor','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.454 0.813 0.128 0.0714],...
    'String',{'Attention'},...
    'HorizontalAlignment','center',...
    'FontSize',14,...
    'EdgeColor','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.584 0.813 0.100 0.0714],...
    'String',{'Visual'},...
    'HorizontalAlignment','center',...
    'FontSize',14,...
    'EdgeColor','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.729 0.813 0.105 0.0714],...
    'String',{'Speed'},...
    'HorizontalAlignment','center',...
    'FontSize',14,...
    'EdgeColor','none');

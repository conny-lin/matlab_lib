function [varargout] = Swanlake_Graph(paths,MWTindex,Stats,...
                        Analysis,GroupBy,varargin)

varargout{1} = {};

%% INPUT 
pSaveA = paths.MWT.pSaveA;



%% VARARGIN
% [optional] control
i = strcmp(varargin,'control');
if isempty(i) ==0 && sum(i) ==1 && iscell(varargin{find(i)+1}) ==1
    controlname = varargin{find(i)+1};
end


% [optional] OPTION
i = cellfun(@isstruct,varargin);
if sum(i) ==1;
    % get OPTION CONTENT
    OPTION = varargin{i};
    varnames = fieldnames(OPTION);
    
    % find control name
    n = 'Control';
    k = strcmp(varnames,n);
    if sum(k) ==1;
        controlname = OPTION.(n){1};
    end

    % find color
    n = 'Color';
    k = strcmp(varnames,n);
    if sum(k) ==1;
        color = OPTION.(n);
    else
        % set colors
        cd(paths.MWT.pSet); load('color.mat','c');
        OPTION.Color = [c.black;c.red;c.gray;c.pink];
        clear c;
    end

    % find sample time
    n = 'SampleTime';
    k = strcmp(varnames,n);
    if sum(k) ==1;
        SampleTime = OPTION.(n).all;
    else
    end
end



%% POSTURE GRAPH - BY GROUP WITH CONTROLS IN BACKGROUND
% a = 'Control';
% varnames = fieldnames(OPTION);
% i = strcmp(varnames,a);
%GroupBy = 'group';
g = MWTindex.(GroupBy).legend;
groupname = cellfun(@strrep,g,cellfunexpr(g,'_'),cellfunexpr(g,' '),...
        'UniformOutput',0);
%%
StatType = 'Descriptive';

% load data
D = Stats.(Analysis).(GroupBy).(StatType);

% load control stats
cd(paths.MWT.pSet); 
A = load([controlname,'.mat'],'Stats'); 
Control = A.Stats;
C = Control.(Analysis).(GroupBy).(StatType);




%% graph_posturebygroup(D,gname,SampleTime,C,pSaveA,OPTION.Color)
%CREATEFIGURE(XMATRIX1,YMATRIX1,EMATRIX1)
%  XMATRIX1:  errorbar x matrix
%  YMATRIX1:  errorbar y matrix
%  EMATRIX1:  errorbar e matrix


% subplot position
plotposition(1,:) = [0.09 0.75 0.40 0.20];
plotposition(2,:) = [0.56 0.75 0.40 0.20];
plotposition(3,:) = [0.09 0.45 0.40 0.20];
plotposition(4,:) = [0.56 0.45 0.40 0.20];
plotposition(5,:) = [0.09 0.15 0.40 0.20];
plotposition(6,:) = [0.56 0.15 0.40 0.20];

measure = {'aspect';'kink';'width';'curve';'length'};

% Create figure
figure1 = figure('Color',[1 1 1],'Visible','off');



for m = 1:numel(measure)
    
axes1 = axes('Parent',figure1,'XLim',[0 max(SampleTime)+10],...
    'Position',plotposition(m,:));
% set ylim
Y = D.(measure{m}).Y;
E = D.(measure{m}).E;
XC = C.(measure{m}).t;
YC = C.(measure{m}).Y;
EC = (C.(measure{m}).E).*sqrt(C.(measure{m}).N);

ymin = min(min([Y,YC]-[E,EC])); ymin = ymin-(ymin*.1);
ymax = max(max([Y,YC]+[E,EC])); ymax = ymax+(ymax*.1);
ylim(axes1,[ymin ymax]);

xlim(axes1,[0 420]); 
hold(axes1,'all');

% plot control
area(XC,YC+EC,'FaceColor',[0.94 0.94 0.94],...
    'BaseValue',ymin+(ymin*0.05),'EdgeColor','w');
hold on;
area(XC,YC-EC,'FaceColor',[1 1 1],'EdgeColor','w',...
    'BaseValue',ymin+(ymin*0.05));


X = D.(measure{m}).t;
Y = D.(measure{m}).Y;
E = D.(measure{m}).E;
errorbar1 = errorbar(X,Y,E,'Marker','.');
if size(X,2) <= size(color,1)
    for g = 1:size(X,2)
       set(errorbar1(g),'DisplayName',groupname{g},...
            'LineWidth',0.5,'Color',color(g,1:3),...
            'MarkerSize',6,'Marker','.'); 
    end
end

ylabel((measure{m})); % Create ylabel

end

% create legend
m = 6;
axes1 = axes('Parent',figure1,...
    'Position',plotposition(m,:),'Box','off',...
    'YColor',[1 1 1],'XColor',[1 1 1]);
errorbar1 = errorbar(X,Y,E,'Marker','.');
hold(axes1,'all');
if size(X,2) <= size(color,1)
    for g = 1:size(X,2)
       set(errorbar1(g),'DisplayName',groupname{g},...
            'LineWidth',3,'Color',color(g,1:3),...
            'MarkerSize',6,'Marker','none'); 
    end
end
legend1 = legend('show');
set(legend1,'FontSize',20);

% SAVE FIGURE
savefigpdf(['Posture_',GroupBy],pSaveA);
%savefigjpeg('Posture_ByGroup',pSaveA);
%display 'Posture_ByGroup graphing done';


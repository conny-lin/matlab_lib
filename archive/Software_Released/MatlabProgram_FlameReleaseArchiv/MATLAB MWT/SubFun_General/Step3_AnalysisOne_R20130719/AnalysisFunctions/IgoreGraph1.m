function IgoreGraph1(pExp,pFun)
[~,~,~] = igoreGraphing2(pFun,pExp,'time','import*.mat'); 
end


%% [subfunctions] ---------------------------------------------------------

%% [SF] graphing
function [Time,Graph,Stats] = igoreGraphing2(pFun,pExp,Yn,rawfilename)
%% set paths and load .mat set files
addpath(genpath(pFun)); 
cd(pFun);
cd(pExp);
a = dir(rawfilename);
a = {a.name};
load(char(a));
%% analysis
[titlename,~,m,intmin,int,intmax,Xn] = selectmeasure2(pFun,'analysisetting.mat',0);
[Data,Time,Xaxis] = getmeanresponse(MWTfdatG,intmin,int,intmax,m);
%% [OBJECTIVES]
%% descriptive and graph
[Stats.curve] = statcurve2(Data,2); 
[Stats.curvestd] = statstdcurve2(Data,2); 
[Graph] = figvprep3(Stats.curve,'MWTfdata',GAA,Xn,Yn,...
            pFun,pExp,'GraphSetting.mat');
makefig2(Graph);
savefig(titlename,pExp);
cd(pExp);
[savename] = creatematsavename(pExp,'statscurve_','');
save(savename);
%% combineed speed graphs of 6 groups 
% day4 - 0mM, 400mM
% day5 - 0mM, 400mM, 0mM(repeated), 400mM(repeated)

%% [code later] create analysis dat reference
%% individual and combined graphs of any parameters
% [code later] create analysis dat reference
%% flexibility in selecting X axis
%% bar graphs to compare selected time points

end
    function [titlename,set,m,intmin,int,intmax,Yn] = selectmeasure2(pFun,setfn,id)
%% userinput interface
cd(pFun);
load(setfn);
load('javasetting.mat'); % load matlab settings
while id ==0;
    id = input('set analysis use preset(1), quick entry (2), user prompt(3):\n');
end

switch id
    case 1 % preset
        display(setid);
        x = input('select analysis: ');
        set = preset(x,:);
        m = set(1);
        Yn = MWTfdatGraphcode{m,2};
        intmin = set(2);
        int = set(3);
        intmax = set(4);
        
    case 2 % quick entry
        disp(MWTfdatGraphcode(:,1:2));
        set = input('enter [m intmin int intmax] separated by space:\n ','s');
        set = str2num(set);
        m = set(1);
        intmin = set(2);
        int = set(3);
        intmax = set(4);
        Yn = MWTfdatGraphcode{m,2};
    case 3 % user prompt
        disp(MWTfdatGraphcode(:,1:2));
        mi = input('select measure code: ');
        m = MWTfdatGraphcode{mi,3};
        Yn = MWTfdatGraphcode{m,2};
        set(1) = m;
        intmin = input('starting time: ');
        set(2) = intmin;
        int = input('interval: ');
        set(3) = int;
        intmax = input('end time: ');
        set(4) = intmax;
        
        %% [future coding] - ask to store setting
        
end
% make graph title name
titlename = regexprep(mat2str(set),' ','x');
titlename = strcat(Yn,'_',titlename);
    end
    function [Data,Time,Xaxis] = getmeanresponse(A,intmin,int,intmax,m)
    %% get speed is at column 6
    %m = 6; % select speed (at column 6)
    % set up time intervals
    %intmin = 0; % starting time
    %int = 10; % at 10 second intervals
    %intmax = 410; % until max time

    Time = A(:,1:2); % get group name
    Xaxis = (intmin:int:intmax)';
    for g = 1:size(A,1); % loop groups
        for p = 1:size(A{g,2},1); % loop plates  
            % import time
            ri = [];
            T = A{g,2}{p,2}(:,1); % get time data
            for xt = intmin:int:intmax; % loop for time intervals
                [frame,~]= find(T>xt); % find a time
                tf = frame(1); % row to the beginning of next interval
                ri(end+1,1) = tf; % record row index
                ri(end,2) = xt; % record interval number
            end
            Time{g,2}{p,2} = ri;

            % get mean of measure per interval
            D = A{g,2}{p,2}(:,m); % get speed data
            for x = 2:size(ri,1)-1; % for each time interval
                A{g,3}(x,p) = mean(D(ri(x):ri(x+1)-1)); % mean of all data during this time
            end

        end

    end
    Data = A;
    end   
    function [A] = statcurve2(D,id)
% id - Expdata=1, MWTdata=2
switch id
    case 1 % D = Expfdat   
        for f = 1:size(D,1); % for every import
            for g = 1:size(D{f,3},1); % for every group  
                A = {};
                A{f,3}{g,1} = D{f,3}{g,1}; 
                A{f,3}{g,2} = D{f,3}{g,2}; % get data
                A{f,3}{g,3} = mean(D{f,3}{g,2},2);
                A{f,3}{g,4} = SE(D{f,3}{g,2});
            end
            A{f,4} = cell2mat(D{f,3}(:,3)'); % combine get group mean 
            A{f,5} = cell2mat(D{f,3}(:,4)'); % combine get group se 
        end
        
        
    case 2 % MWTfdat/MWTftrv
        for g = 1:size(D,1); % for every group  
            A(g,1) = D(g,1); % get group code
            A(g,2) = D(g,3); % get plate data
            A{g,3}= mean(D{g,3},2); % plate mean
            A{g,4}= SE(D{g,3}); % plate SE
        end
end
    end
    function [B] = statstdcurve2(D,id)
% id - Expdata=1, MWTdata=2
%% Standardized Curve
switch id
    case 1 % D = Expfdat 
        for f = 1:size(D,1); % for every import
            for g = 1:size(D{f,3},1); % for every group  
                A = {};
                A = D{f,3}{g,2}; % get data
                I = repmat(A(1,:),size(A,1),1); % get initial array
                A = A./I; % standardize to initial
                D{f,3}{g,3}= mean(A,2); % calculate mean
                D{f,3}{g,4}= SE(A); % calculate SE
            end
            D{f,4} = cell2mat(D{f,3}(:,3)'); % combine get group mean 
            D{f,5} = cell2mat(D{f,3}(:,4)'); % combine get group se 
            B = D;
        end
    case 2 % MWTfdat/MWTftrv
        %%
        for g = 1:size(D,1); % for every group  
            A = D{g,3};
            %% [BUG] initial zero... what to do then?
            I = repmat(A(1,:),size(A,1),1); % get initial array
            A = A./I; % standardize to initial
            D{g,3}= mean(A,2); % calculate mean
            D{g,4}= SE(A); % calculate SE
        end
        B = D;
        
    otherwise
        error('invalid analysis id for statstdcurve2');
        
end
    end
    function [Graph] = figvprep3(D,fn,GAA,Yn,Xn,pFun,pExp,setfilename)
%% Graphing: individual
% [Graph] = figvprep3(D,fn,GAA,Yn,Xn,pFun,pExp,setfilename)% D-stats data (produced by stats* function 
%   with graph means at D{f,3} and SE at D{f,4}
% pFun - path to funciton
% pExp - path to experiment
% setfilename - name of the graph settings
% Groups - .mat files containing group name and index
% fn -name of the imported file (i.e. *.dat), 
%   type in 'MWTfdata' for MWTfdat and MWTftrv analysis
% Yn - Y axis name
% Xn - X axis name
% GAA - group sorting files
% Example:
%setfilename = 'GraphSetting.mat';

%% load graph settings
cd(pFun);
Graph = load(setfilename);
Graph.legend = GAA(:,3);
Graph.Ylabel = Yn;
Graph.Xlabel = Xn;

%% load graph data source
% if filename is a variable, or imported Expfdata
if (isequal(fn,'MWTfdata')==1)||ismember(fn,D(:,1))==1; 
    Graph.Y = cell2mat(D(:,3)');
    Graph.E = cell2mat(D(:,4)');
else
    error('imported data %s does not exist...',fn);
    
end

%% see if group needs to be resorted
Graph.gs = cell2mat((GAA(:,1))');
YA = Graph.Y;
EA = Graph.E;
for x = 1:size(Graph.gs,2);
    YA(:,x) = Graph.Y(:,Graph.gs(1,x));
    EA(:,x) = Graph.E(:,Graph.gs(1,x));
end
Graph.Y = YA;
Graph.E = EA;

%% fix names
[~,Graph.expname] = fileparts(pExp);
Graph.expname = strrep(Graph.expname,'_','-');
for x = 1:size(Graph.legend);
    Graph.legend{x,1} = strrep(Graph.legend{x,1},'_','-');
end

    end
    function makefig2(G)
%% create figure 
figure1 = figure('Color',[1 1 1]); % Create figure with white background

x = 1;
axes1 = axes('Parent',figure1,...
    'XTickLabel','',...
    'FontName',G.FontName);
%
hold(axes1,'all');
errorbar1 = errorbar(G.Y,G.E,...
    'Marker','.',...
    'LineWidth',1);
for i = 1:size(G.Y,2);
    set(errorbar1(i),...
        'DisplayName', G.legend{i,1},...
        'Color',G.Color(i,:)); 
end
%ylim(axes1,[G.Ymin(x) G.Ymax(x)]);
%xlim(axes1,[G.Xmin(x) G.Xmax(x)]);
ylabel(G.Ylabel,'FontName',G.FontName);
xlabel(G.Xlabel,'FontName',G.FontName);


legend(axes1,'show');
set(legend,...
    'Location','NorthEast',...
    'EdgeColor',[1 1 1],...
    'YColor',[1 1 1],...
    'XColor',[1 1 1],...
    'TickDir','in',...
    'LineWidth',1);


%% annotation: N
N = size(G.Y,2);
s = 'N=%d';
text = sprintf(s,N);
annotation(figure1,...
    'textbox',G.Gp(6,1:4),...
    'String',{text},...
    'FontSize',10,...
    'FontName',G.FontName,...
    'FitBoxToText','on',...
    'EdgeColor','none');

%% annotation: experiment name
annotation(figure1,...
    'textbox',G.Gp(7,1:4),...
    'String',{G.expname},...
    'FontSize',10,...
    'FontName',G.FontName,...
    'FitBoxToText','on',...
    'EdgeColor','none');
    end
function savefig(titlename,pSave)
% save figures 
% titlename = 'CombinedGraph';
cd(pSave);
h = (gcf);
set(h,'PaperPositionMode','auto'); % set to save as appeared on screen
print (h,'-dtiff', '-r0', titlename); % save as tiff
saveas(h,titlename,'fig'); % save as matlab figure 
close;
end

%% Shared functions
function [savename] = creatematsavename(pExp,prefix,suffix)
    % add experiment code after a prefix i.e. 'import_';
    [~,expn] = fileparts(pExp);
    i = strfind(expn,'_');
    if size(i,2)>2;
        expn = expn(1:i(3)-1);
    else
        ...
    end
    savename = strcat(prefix,expn,suffix);
    end
function [a] = SE(A)
    a = std(A,1,2)/sqrt(size(A,2));
end



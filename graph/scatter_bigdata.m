function f = scatter_bigdata(D,varargin)
%% plot scatter for big data
% use circle size to show data point size
% input must be two columns of data, rows = observations


%% defaults
tname = '';
logscale = false;
yname = ''; 
xname = '';
visible = true;
reducefactor = 1000;
dotstepsize=100;
%% process varargin
vararginProcessor
% D = table2array(FBTscore_getIVDV(Data,'dv',varpair(dvi,:),'gameid',gn,'keepIV',false));
%% evaluate unique numbers
u1 =unique(D(:,1));
nu1 = numel(u1);
u2 = unique(D(:,2));
nu2 = numel(u2);
% make x = smaller number of variables
if nu1 < nu2 || nu1 == nu2
    ux = u1; uy = u2;
    xi = 1; yi = 2;
    ynameplot = yname; 
    xnameplot = xname;
    seq=1;
elseif nu1 > nu2
    ux = u2; uy = u1;
    xi = 2; yi = 1;
    ynameplot = xname; 
    xnameplot = yname;
    seq=2;
end

DU = unique(D,'rows');
npair = size(DU,1);
n = nan(size(DU,1),1);
clear DU;
x = nan(npair,1);
y = x;
nrow = 1;
for xui = 1:numel(ux)
    i = D(:,xi)==ux(xui);
    a = tabulate(D(i,yi));
    if ~isempty(a)
        a(a(:,2)==0,:) = [];
        yvar = a(:,1);
        yvarN = numel(yvar);
        yvarcount = a(:,2);
        nrow2 = nrow+yvarN-1;
        x(nrow:nrow2) = repmat(ux(xui),yvarN,1);
        y(nrow:nrow2) = yvar;
        n(nrow:nrow2) = yvarcount;
        nrow = nrow2+1;
    end
end

%% round N and set dot size
s = n./reducefactor;
% s(s<dotstepsize)=1;
% s = round(s./dotstepsize).*dotstepsize;
% round less than .01 percent of data to point =1
% onefactor = round(size(D,1)./10000); 
% s(s<reducefactor)=1;

% set color
color = [0.3 0.3 0.3];
c = repmat(color,numel(x),1);


% make figure
close
f = figure('Visible','off','Color','w');
if visible
   set(f,'Visible','on'); 
end
a = axes('Parent',f,'FontSize',10);  hold on;
if logscale
    if max(D(:,yi)) > 10000; set(a,'YScale','log'); end
    if max(D(:,xi)) > 10000; set(a,'XScale','log'); end
end
switch seq
    case 1
        scatter(x,y,s,c,'MarkerFaceColor',color)
    case 2
        scatter(y,x,s,c,'MarkerFaceColor',color)
end
ylabel(yname,'FontSize',10);
xlabel(xname,'FontSize',10);
title(tname);





function [f,n,xvalues,nu] = histogram_line(d,varargin)
%% create histogram displayed as line graph
% - each bin is a unique value found in d

%% defaults
xname = 'bin';
yname = 'N';
tname = 'histogram';
% displayopt = true;
visible = true;
logscaleon = false;
xloglim = 10000;
yloglim = 10000;
fontsize = 10;
xlog = false;
ylog = false;

%% process varargin
vararginProcessor

%% CODE
% take out infinity
i = isinf(d);
infN = sum(i);
d(i) = [];

% unique variables
nu = numel(unique(d));
% set unique number as x values
xvalues = unique(d);
% find n
[n,centers] = hist(d,xvalues);
% if there are infinity values, add the number at the end
if infN > 0
  n = [n infN];
  centers(end+1) = centers(end)+(centers(end-1)-centers(end-2));
end

% create figure
f = figure('Visible','off','Color','w');
if visible
    set(f,'Visible','on');
end
a = axes('Parent',f,'FontSize',fontsize,'XColor',[0.5 0.5 0.5],...
   'YColor',[0.5 0.5 0.5]);
hold on;
% set log scale
if (max(n) > xloglim && logscaleon) || ylog
    set(a,'YScale','log');    
end
if (max(centers) > yloglim && logscaleon) || xlog
    set(a,'XScale','log');
    yname = 'N log';
end

% labels
xlim([min(centers) max(centers)]);
plot(centers,n,'Color','k')
ylabel(yname,'FontSize',fontsize);
xlabel(xname,'FontSize',fontsize);
if infN > 0
    text(centers(end),n(end)*2,sprintf('Inf N=%d',infN))
end
title(tname);










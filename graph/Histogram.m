function fig1 = Histogram(data,bin,varargin)
%% setting
yname = '';
titlename = '';
facecolor = [0 0 0];
edgecolor = [1 1 1];
vararginProcessor

%% graph
fig1 = figure;
hist(data,bin)
h = findobj(gca,'Type','patch');
set(h,'FaceColor',facecolor,'EdgeColor',edgecolor)
ylabel(yname)
title(regexprep(titlename,'_',' '));
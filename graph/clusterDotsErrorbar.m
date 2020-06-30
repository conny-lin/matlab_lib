function fig1 = clusterDotsErrorbar(D,gname,varargin)


%% input variables
visible = 'on';
scatterdotcolor = [0.8 0.8 0.8];
errorbarLineWidth = 3;
errobarColor = [0 0 0];
yname = 'Y';
xname = 'X';
errorbartype = 'sd';
fontsize = 14;
markersize=1;
groupseq = {};

vararginProcessor

if size(scatterdotcolor,1)== numel(D)
    plotvarcolor = true;
else
    plotvarcolor = false;
end

%% make graph
clear G
[G.gn,G.m,G.sd,G.se] = grpstats(D,gname,{'gname','mean','std','sem'});
if isnumeric(gname)
   gnameu = cellfun(@str2num,G.gn);
   G.gn = gnameu;
end
if ~isempty(groupseq)
    [i,j] = ismember(groupseq,G.gn);
    f = fieldnames(G);
    for fi = 1:numel(f)
       G.(f{fi}) = G.(f{fi})(j);
    end
end

%% figure
close all
fig1 = figure('Visible',visible);
axes('XTickLabel',G.gn,'XTick',1:numel(G.gn));
hold on


%% plot scatter


for gi = 1:numel(G.gn)
    if isnumeric(gname)
        i = gname==gnameu(gi); 
    else
        i = ismember(gname,G.gn{gi});
    end
    y = D(i);
    n = numel(y);
    x = ones(n,1);
    % randomly shift dots
    shift = rand(n,1);
    shift(shift > 0.5) = 0.25;
    shift(shift < 0.5 & shift ~=0.25) = -0.25;
    x = (rand(n,1)) .*shift;
    x = x+gi;
    % plot
    if ~plotvarcolor
        plot(x,y,'MarkerFaceColor',scatterdotcolor,...
            'MarkerEdgeColor',scatterdotcolor,'Marker','o',...
            'LineStyle','none','MarkerSize',markersize);
        
    elseif plotvarcolor
        markercolorP = scatterdotcolor(i,:);
        markersizeP = repmat(markersize,numel(x),1);
        scatter(x,y,markersizeP,markercolorP,'o','filled');
    end
end

%% graph errorbar
errorbar(G.m, G.(errorbartype),'LineStyle','none','Color',errobarColor,...
    'LineWidth',errorbarLineWidth,'MarkerFaceColor',errobarColor,...
    'MarkerEdgeColor',errobarColor,'Marker','o')
ylabel(yname,'FontSize',fontsize);
xlabel(xname,'FontSize',fontsize);






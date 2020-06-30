function gp = graphsetpack(name,varargin)

%% default

vararginProcessor;

%% color names
black = [0 0 0];
red = [1 0 0];
purple = [0.494117647409439 0.184313729405403 0.556862771511078];
softblue = [0 0.447058826684952 0.74117648601532];
hookgreen = [0 0.498039215803146 0];
duckyellow = [0.749019622802734 0.749019622802734 0];
orange = [0.87058824300766 0.490196079015732 0];
%% graph setting

switch name
    case 'brnf'
        gp.Color = [{[0 0 0]}; {[1 0 0]}; {[0 0 0]}; {[1 0 0]}];
        gp.LineStyle = {'none','none','-','-'};
        gp.MarkerFaceColor = {'none','none',gp.Color{3}, gp.Color{4}};

    case 'brnfsc'
        gp.Color = [{[0 0 0]}; {[1 0 0]}; {[0 0 0]}; {[1 0 0]}];
        gp.LineStyle = {'none','none','-','-'};
        gp.MarkerFaceColor = {'none','none',gp.Color{3}, gp.Color{4}};
        gp.Marker = {'s','s','o','o'};

    case 'cathy' % wildtype black, mutant red, 0mM hallow, 400mM solid
        gp.Color = {[0 0 0]; [0 0 0]; [1 0 0]; [1 0 0]};
        gp.LineStyle = {'none','none','none','none'};
        gp.MarkerFaceColor = {'none',gp.Color{2},'none', gp.Color{4}};
        gp.Marker = {'o','o','o','o'};
    case 'cathyline' % wildtype black, mutant red, 0mM hallow, 400mM solid
        gp.Color = {[0 0 0]; [0 0 0]; [1 0 0]; [1 0 0]};
        gp.LineStyle = {'-','-','-','-'};
        gp.MarkerFaceColor = {'none',gp.Color{2},'none', gp.Color{4}};
        gp.Marker = {'o','o','o','o'};
    case 'cathyline_purple'
        gp.Color = {black; black; purple; purple};
        gp.LineStyle = {'-','-','-','-'};
        gp.MarkerFaceColor = {'none',gp.Color{2},'none', gp.Color{4}};
        gp.Marker = {'o','o','o','o'};
     case 'bkrainbowline'
        gp.Color = {black; red; orange; duckyellow;hookgreen;softblue;purple};
        gp.LineStyle = repmat({'-'},size(gp.Color));
        gp.MarkerFaceColor = gp.Color;
        gp.MarkerEdgeColor = gp.Color;
        gp.Marker = repmat({'o'},size(gp.Color));
        
end

end
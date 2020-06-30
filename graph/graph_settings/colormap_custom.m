function map = colormap_custom(varargin)

%% defaults
grad1 = 0;
gradmax = 0.3;
step = 40;
maxcolor = [1 1 1]; % white
color_reference = {'y',[1 1 0];'m',[1 0 1];'c',[0 1 1];'r',[1 0 0];'g',[0 1 0];'b',[0 0 1];'w',[1 1 1];'k',[0 0 0]};
color = 'r';
vararginProcessor
%% calculate variables
colorselect = color_reference{ismember(color_reference(:,1),color),2};
onecol = find(colorselect == 1);

  
cl = (grad1:gradmax/(step-1):gradmax)';
map = repmat(cl,1,3);
map(:,onecol) = 1;
map(end,1:3) = maxcolor;
% SpeedF_colorindex = map;
function [varargout] = MWTAnalysisSetUpMaster_Graphing(varargin)

%% varargin

MWTSet = varargin{1};

%% reporting
display ' ';
display 'Setting up graphing parameters..';


%% determine group number
groups = MWTSet.GraphGroup;
groupsN = numel(groups); 
display(sprintf('%d groups(s)',groupsN));
a = regexpcellout(groups,'_','split');


%% color list
colorlist = {'black',[0 0 0];
    'red',[1 0 0];
    'gray',[0.8 0.8 0.8];
    'blue',[0 0 1];
    'light blue',[0.729411780834198 0.831372559070587 0.95686274766922];
    'orange',[0.87058824300766 0.490196079015732 0];
    'pink',[0.749019622802734 0 0.749019622802734];
    'purple',[0.47843137383461 0.062745101749897 0.894117653369904];
    'green',[0 0.498039215803146 0];
    'yellow',[1 1 0];
    };

%% line list
linelist = {'solid line','-';
    'dotted',':';
    'dash','--';
    'no line','none';
    'dash-dot','-.'};


%% DEFAULT SETTING
% in the format of {N group,N strains}{N conditions}
% N conditions are differentiated by line style
defaultset = {}; 
% 1 group
c(1,1:3) = colorlist{1,2};
l(1,1) = linelist(1,2);
defaultset{1}.black = struct('color',c,'linestyle',{l});

% 2 groups, different strains
c(1,1:3) = colorlist{1,2};
c(2,1:3) = colorlist{2,2};
l(1,1) = linelist(1,2);
l(2,1) = linelist(1,2);
defaultset{2}.blackred = struct('color',c,'linestyle',{l});


% 2 groups, same strains, 2 conditions
c(1,1:3) = colorlist{1,2};
c(2,1:3) = colorlist{1,2};
l(1,1) = linelist(1,2);
l(2,1) = linelist(2,2);
defaultset{2}.black_soliddash = struct('color',c,'linestyle',{l});

% blackred_soliddash - 2 groups, 2 strains, 2 conditions
c(1,1:3) = colorlist{1,2};
c(2,1:3) = colorlist{1,2};
c(3,1:3) = colorlist{2,2};
c(4,1:3) = colorlist{2,2};
l(1,1) = linelist(1,2);
l(2,1) = linelist(2,2);
l(3,1) = linelist(1,2);
l(4,1) = linelist(2,2);
defaultset{4}.blackred_soliddash = struct('color',c,'linestyle',{l});

% blkgrayredpink = 2 groups, 2 strains, 2 conditions
c(1,1:3) = colorlist{1,2};
c(2,1:3) = colorlist{3,2};
c(3,1:3) = colorlist{2,2};
% c(4,1:3) = [0.8 0 0]; % dark red
c(4,1:3) = [1 0.6 0.6]; % light red
l(1,1) = linelist(1,2);
l(2,1) = linelist(1,2);
l(3,1) = linelist(1,2);
l(4,1) = linelist(1,2);
defaultset{4}.blkgrayredpink = struct('color',c,'linestyle',{l});


%% determine if groups situation is coded in default
groupMax = numel(defaultset);
if groupsN > groupMax
    inputoption = {'Auto'; 'Manual'};
else
    inputoption = {'Default'; 'Auto'; 'Manual'};
%     a = input('Use default setting? (y/n): ','s');
end
display 'Assign color and line style to groups';

display(makedisplay(inputoption));
a = inputoption{input('Choice: ')}; 

%% assign
switch a        
    case 'Default'
        % select default        
        [GraphSetting] = defaultsetselect(MWTSet.MWTfG,defaultset);
    case 'Auto'
        % do nothing
        GraphSetting = [];
    case 'Manual'
        [GraphSetting] = manual(groups,colorlist,linelist);
    otherwise
end


%% VARARGOUT

varargout{1} = GraphSetting;
end


%% subfunctions
function [GraphSetting] = manual(groups,colorlist,linelist)
    color = nan(numel(groups),3);
    linestyle = cell(numel(groups),1);
    display ' ';
    display 'Color choices:';
    disp(makedisplay(colorlist(:,1)));
    display ' ';
    display 'Line choices:';
    disp(makedisplay(linelist(:,1)));
    display ' ';
    for x = 1:numel(groups)
        % assign color and line style

        i = input(sprintf('group [%s] [color linestyle]: ',groups{x}),'s');
        i = str2num(i)';
        
        color(x,1:3) = colorlist{i(1),2};
        linestyle(x,1) = linelist(i(2),2);

    end
    % construct output struc array
    GraphSetting.color = color;
    GraphSetting.linestyle = linestyle;
end



%% default set selection
function [GraphSetting] = defaultsetselect(MWTfG,defaultset)

%% select default set
groupN = numel(fieldnames(MWTfG)); % get number of groups
choice = fieldnames(defaultset{groupN});
disp(makedisplay(choice));
i = input('select: ');
%% generate GraphSetting
GraphSetting = defaultset{groupN}.(choice{i});


end





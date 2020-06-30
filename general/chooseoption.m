function [option,i] = chooseoption(optionlist,varargin)

%% [option,i] = chooseoption(optionlist,selection)
% selection:
% 1 - choose only one option
% 2 - choose multiple options
% string = display string questions. i.e. chooseoption(optionlist, 'choose volume')
% then 'choose volume' would be displayed before option displays
% "choose volume:"
% option list...

display ' ';
%% get how many varargin there are [added: 20150510]
varInN = 0;
if nargin > 1
    varInN = nargin-1;
end

%% process selection number setting
selection = 1; % default is only one choice
% if first varargin is a number, code for a differen selection
% and code next varargin start to 2
if varInN >= 1 
    if isnumeric(varargin{1}) == 1
        selection = varargin{1};
    elseif ischar(varargin{1}) == 1
        disp(sprintf(varargin{1}));
    end
end


%% process text option varargin
% deault settings:
outputsetting = 'option name';

% change default:
if nargin >=2
    % see how many varargin inputs pairs
    varinputList = varargin(2:end);
    for v = 1:numel(varinputList)
        switch varinputList{v}
            case 'index'
                outputsetting = 'index';     
        end
    end
end



%% see size of input
if size(optionlist,2) == 2
    optionname = optionlist(:,1);
    optionfunction = optionlist(:,2);
elseif size(optionlist,2) == 1
    optionname = optionlist;
    optionfunction = optionlist;
end

display(makedisplay(optionname));

switch selection
    case 1    % only choose one option
        displaystring = 'Enter option: ';
        i = input(displaystring);
        option = optionfunction{i};
    case 2 % enable choosing multiple options
        disp('Enter options separated by [SPACE],enter ''all'' to choose all listed options');
        k = input(': ','s');
        if strcmp(k,'all') == 1
            i = 1:size(optionname);
        else
            i = str2num(k);
        end
        option = optionfunction(i);
end

%% organize output
switch outputsetting
    case 'index'
        option = i;
    otherwise
end

end





function [show] = makedisplay(list, varargin)
% option = 'bracket', 1) list
% option = string, i.e. '-', then 1-list; 2-list
%%
% A = varargin{1}; 
% A
% varargin 2 = 1 = show 


switch nargin
    case 1
        sepoption = 'none';
        showoption = 0;
    case 2
        if isnumeric(varargin{1}) ==1
            showoption = varargin{1};
            sepoption = 'none';

        elseif isstr(varargin{1}) ==1
            sepoption = varargin{1};
            showoption = 0;
        end
    case 3
        i = cellfun(@isnumeric,varargin);
        if sum(i) ==1
            showoption  = varargin{i};
        else
            showoption = 0;
        end
        i = cellfun(@isstr,varargin);
        if sum(i) ==1
            sepoption = varargin{i};
        else
            sepoption = 'none';

        end
        
end

if numel(varargin) >=2
    sepoption = varargin{2};
else
    sepoption = 'none';    
end


switch sepoption
    case 'bracket'
        numb = num2str((1:numel(list))');
        [b] = cellfunexpr(list,')');
        show = [numb,char(b),char(list)];
    case 'none'
        numb = num2str((1:numel(list))');
        [b] = cellfunexpr(list,')');
        show = [numb,char(b),char(list)];
end

switch showoption
    case 1
        disp(show);
    case 0
end

    
end

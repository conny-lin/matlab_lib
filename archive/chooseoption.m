function [option,i] = chooseoption(optionlist,varargin)

if nargin >1
   selection = varargin{1};
else
    selection = 1;
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
    case 1    
        i = input('enter option: ');
        option = optionfunction{i};
    case 2
        k = input('enter options separated by [SPACE]\n: ','s');
        i = str2num(k);
        option = optionfunction(i);
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

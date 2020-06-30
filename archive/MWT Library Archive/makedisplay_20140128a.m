function [show] = makedisplay(varargin)
% option = 'bracket', 1) list
% option = string, i.e. '-', then 1-list; 2-list
%%
% A = varargin{1}; 
% A

list = varargin{1};

if numel(varargin) >=2
    A = varargin{2};
else
    A = 'none';    
end

switch A
    case 'bracket'
        numb = num2str((1:numel(list))');
        [b] = cellfunexpr(list,')');
        show = [numb,char(b),char(list)];
    case 'none'
        numb = num2str((1:numel(list))');
        [b] = cellfunexpr(list,')');
        show = [numb,char(b),char(list)];
end
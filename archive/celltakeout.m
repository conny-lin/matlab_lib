function [A] = celltakeout(cell,option)

switch option
    case 'split'
        A = {};
        for x = 1:numel(cell); col = size(cell{x},2); 
            A(x,1:col) = cell{x}; end
    case 'multirow'
        A = {}; for x = 1:numel(cell); A = [A;cell{x}]; end
    case 'singlerow'
        A = {};
        for x = 1:numel(cell);
            if isempty(cell{x})==0; A(x,1) = cell{x,1};
            else A(x,1) = {''}; end
        end
    case'match'
        A = {};
        for x = 1:numel(cell);
            if isempty(cell{x})==0; A(x,1) = cell{x,1};
            else A(x,1) = {''}; end
        end
    case 'singlenumber'
        A = [];
        for x = 1:numel(cell)
            if isempty(cell{x})==0; A(x,1) = cell{x,1};
            else A(x,1) = 0; end
        end
    case 'logical'
         A = [];
        for x = 1:numel(cell)
            if isempty(cell{x})==0; A(x,1) = cell{x,1};
            else A(x,1) = 0; end
        end
        A = logical(A);
        
    otherwise
end

%


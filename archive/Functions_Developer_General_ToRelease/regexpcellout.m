function [A] = regexpcellout(C,searchterm,varargin)
% function [A] = regexpcellout(C,searchterm,option)
% updated 20140204

optionlist = {'logical'};
reglist = {'split','match'};

nargin
% make sense of inputs
switch nargin
    case 2
        option = 'logical';
        % validate first input as cell
        %if iscell(varargin{1}), C = varargin{1}; end
        %if ischar(varargin{2}), searchterm = varargin{2}; end
        B = regexp(C,searchterm);
    
    case 3
        %if iscell(varargin{1}), C = varargin{1}; end
        %if ischar(varargin{2}), searchterm = varargin{2}; end
        a = varargin{1};
        if ischar(a); option = a; end
        i = strcmp(reglist,option);
        if sum(i)==1
            B = regexp(C,searchterm,option);
        else
            B = regexp(C,searchterm);
        end
        
    otherwise
        error 'incorect number of inputs';
end

  
switch option
    case 'split'
        A = {};
        for x = 1:numel(B); col = size(B{x},2); 
            A(x,1:col) = B{x}; end
    case'match'
        col = cell2mat(cellfun(@size,B,'UniformOutput',0));
        A = cell(numel(B),max(col(:,2)));
        for x = 1:numel(B);
            if isempty(B{x})==0; 
                col = size(B{x,1},2);
                A(x,1:col) = B{x};
            else
                A(x,1) = {''}; 
            end
        end
    case 'logical'
         A = [];
        for x = 1:numel(B)
            if isempty(B{x})==0; A(x,1) = B{x,1};
            else A(x,1) = 0; end
        end
        A = logical(A); 
%     case 'multirow'
%         A = {}; for x = 1:numel(B); A = [A;B{x}]; end
%     case 'singlerow'
%         A = {};
%         for x = 1:numel(B);
%             if isempty(B{x})==0; A(x,1) = B{x,1};
%             else A(x,1) = {''}; end
%         end
%     case 'singlenumber'
%         A = [];
%         for x = 1:numel(B)
%             if isempty(B{x})==0; A(x,1) = B{x,1};
%             else A(x,1) = 0; end
%         end       
    otherwise
end

end
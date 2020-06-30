%% VARARGIN PROCESSOR
VARARGIN = varargin;
%%
if numel(VARARGIN) > 1
    if isinteger(numel(VARARGIN)/2) == 1
        error('variable entries incorrect')
    end
    callName = VARARGIN(1:2:numel(VARARGIN));
    % check if call names are strings
%     for callnamei = 1:numel(callName)
%        if ischar(callName{callnamei}) == 0
%            error('some var names not strings');
%        end
%     end
    setValue = VARARGIN(2:2:numel(VARARGIN)); % get input values
    
    % assign input to var by input type
    for callnamei = 1:numel(callName)
        setValue1 = setValue{callnamei};
        callName1 = callName{callnamei};
        eval(sprintf('%s = setValue1;',callName1));
    end
end

clear VARARGIN callName callnamei setValue aTEMP callName1 setValue1 
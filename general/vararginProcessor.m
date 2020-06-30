%% VARARGIN PROCESSOR
VARARGIN = varargin;
%%
if numel(VARARGIN) > 1
    if isinteger(numel(VARARGIN)/2) == 1
        error('variable entries incorrect')
    end
    callName = VARARGIN(1:2:numel(VARARGIN));
    % check if call names are strings
    for callnamei = 1:numel(callName)
       if ischar(callName{callnamei}) == 0
           error('some var names not strings');
       end
    end
    setValue = VARARGIN(2:2:numel(VARARGIN)); % get input values
    
    % assign input to var by input type
    for callnamei = 1:numel(callName)
        setValue1 = setValue{callnamei};
        callName1 = callName{callnamei};
        % if is char
        if eval(sprintf('ischar(%s)',callName1)) == true
            eval(sprintf('%s = ''%s'';',callName1,setValue1));
        % if is numeric value
        elseif eval(sprintf('isnumeric(%s)',callName1)) == true || ...
            eval(sprintf('islogical(%s)',callName1)) == true
%             aTEMP = cell2mat(setValue1);
            if numel(setValue1)==1
                eval(sprintf('%s = %d;',callName1,setValue1));
            else
                 eval(sprintf('%s = setValue1;',callName1));
            end
        % if is table or cell
        elseif eval(sprintf('iscell(%s)',callName1)) == true ||...
               eval(sprintf('istable(%s)',callName1)) == true
                eval(sprintf('%s = setValue1;',callName1));
        % other types not coded here
        else
            error('need coding for %s',callName1);
        end
    end
end

clear VARARGIN callName callnamei setValue aTEMP callName1 setValue1 
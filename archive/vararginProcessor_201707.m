%% VARARGIN PROCESSOR
A = varargin;
%%
if numel(A) > 1
    if isinteger(numel(A)/2) == 1
        error('variable entries incorrect')
    end
    callName = A(1:2:numel(A));
    % check if call names are strings
    for x = 1:numel(callName)
       if ischar(callName{x}) == 0
           error('some var names not strings');
       end
    end
    setValue = A(2:2:numel(A)); % get input values
    % assign input to var by input type
    for x = 1:numel(callName)
        % if is char
        if eval(sprintf('ischar(%s)',callName{x})) == true
            eval(sprintf('%s = ''%s'';',callName{x},setValue{x}));
        % if is numeric value
        elseif eval(sprintf('isnumeric(%s)',callName{x})) == true || ...
            eval(sprintf('islogical(%s)',callName{x})) == true
            a = cell2mat(setValue(x));
            if numel(a)==1
                eval(sprintf('%s = %d;',callName{x},a));
            else
                 eval(sprintf('%s = a;',callName{x}));
            end
        % if is table or cell
        elseif eval(sprintf('iscell(%s)',callName{x})) == true ||...
               eval(sprintf('istable(%s)',callName{x})) == true
            a = setValue{x};
            eval(sprintf('%s = a;',callName{x}));
        % other types not coded here
        else
            error('need coding for %s',callName{x});
        end
    end
end

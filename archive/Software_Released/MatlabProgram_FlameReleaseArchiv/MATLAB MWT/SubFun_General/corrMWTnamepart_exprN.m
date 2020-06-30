function [new] = corrMWTnamepart_exprN(MWTfn,part,checkname,...
    expr,exprN,cond)
% check if string defined in expr occurs a specific number of times (exprN)
% in cell array (part) and report result of name check as checkname

%% switchboard
equation = char(regexp(cond,'(equal)|(lessthan)','match'));
correction = char(regexp(cond,'(auto)|(manual)','match'));
if isempty(correction) ==1;
    correction = 'manual';
end

%% identify error
[i] = validate(equation,exprN,expr,part);

%% correction
new = part;
while sum(i) ~=0;
    display(sprintf('Name Check [%s]:FAIL',checkname));
    % [suspend] Problem = i; % record problem
switch correction
    case 'manual'
        [new] = manualcorrection(i,part,new,expr,MWTfn);
    case 'auto'
        display 'Auto correct [h_] to [h]...';
        [new] = regexprep(part,'h_','h'); % replace h_ with h
end           

%% validate correction
[i] = validate(equation,exprN,expr,new);
end

% report success
display(sprintf('Name Check [%s]:PASS',checkname));
end



%% subfun
function [i] = validate(equation,exprN,expr,part)
switch equation
    case 'equal'
        i = cellfun(@numel,regexp(part,expr)) ~= exprN;
    case 'lessthan'
        i = cellfun(@numel,regexp(part,expr)) > exprN;
end
end


function [new] = manualcorrection(i,part,new,expr,MWTfn)
i = find(i);
for x = 1:numel(i);
    display(sprintf('In MWTfile[%s]:',MWTfn{i(x,1),1})); % display tracker name    
    display(sprintf('run name has incorrect number of [%s]:',expr));
    display(part{i(x,1),1});
    new{i(x,1),1} = input('Enter correct name: ','s');
end
end
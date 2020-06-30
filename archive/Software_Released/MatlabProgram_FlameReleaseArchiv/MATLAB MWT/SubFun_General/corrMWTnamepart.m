function [new] = corrMWTnamepart(MWTfn,part,checkname,...
    expr,exprN,cond)
%% correct parts
% check if string defined in expr occurs a specific number of times (exprN)
% in cell array (part) and report result of name check as checkname

% switchboard
equation = char(regexp(cond,'(equal)|(lessthan)','match'));
correction = char(regexp(cond,'(auto)|(manual)|(nofix)','match'));
if isempty(correction) ==1;
    correction = 'manual';
end

[i] = validate(equation,exprN,expr,part); % identify error

% correction
new = part;
while sum(i) ~=0;
    display(sprintf('Name Check [%s]:FAIL',checkname));
    % [suspend] Problem = i; % record problem
switch correction
    case 'manual'
        [new] = manualcorrection(i,part,new,expr,MWTfn);
        [i] = validate(equation,exprN,expr,new); % validate correction
    case 'auto'
        [new] = autocorrhunder(part);
        while sum(i) ~=0;
        [i] = validate(equation,exprN,expr,new); % validate correction
        [new] = manualcorrection(i,part,new,expr,MWTfn);
        [i] = validate(equation,exprN,expr,new); % validate correction
        end
    case 'nofix'
        display('Detected incorrect file name');
        display 'correction turned off, no files corrected';
        i = 0;
end           
end
display(sprintf('Name Check [%s]:PASS',checkname)); % report success
end


function [i] = validate(equation,exprN,expr,part)
switch equation
    case 'equal'
        i = cellfun(@numel,regexp(part,expr,'match')) ~= exprN;
    case 'lessthan'
        i = cellfun(@numel,regexp(part,expr,'match')) > exprN;
end
end



function [new] = manualcorrection(i,part,new,expr,MWTfn)
%% manual correction
i = find(i);
for x = 1:numel(i);
    display(sprintf('In MWTfile[%s]:',MWTfn{i(x,1),1})); % display tracker name    
    display(sprintf('run name has incorrect number of [%s]:',expr));
    display(part{i(x,1),1});
    new{i(x,1),1} = input('Enter correct name: ','s');
end
end


function [new] = autocorrhunder(part)
%% Auto correct [h_] to [h]...
display 'Auto correct [h_] to [h]...';
[new] = regexprep(part,'h_','h'); % replace h_ with h
% detect how many files different
diff = setdiff(part,new);
display(sprintf('%d files autocorrected',numel(diff)));
disp(diff);
end
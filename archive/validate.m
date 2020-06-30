

function [i] = validate(equation,exprN,expr,part)
switch equation
    case 'equal'
        i = cellfun(@numel,regexp(part,expr,'match')) ~=exprN;
    case 'lessthan'
        i = cellfun(@numel,regexp(part,expr,'match')) > exprN;
end
end

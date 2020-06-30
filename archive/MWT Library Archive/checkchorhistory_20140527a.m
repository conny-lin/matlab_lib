function [pMWTpass,pMWTfail] = checkchorhistory(pMWT,chorfile)



%% CHECK IF CHOR HAD BEEN DONE
% DEFINE CHOROUTPUTS AND CHOR CODE
% display ' '; 
% display 'Checking for existing chor outputs...'

%% check chor ouptputs
% assume all true  = pass
fail = false(size(pMWT)); 

% mark failed ones as false
for v = 1:size(chorfile,1)
    [fn,~] = cellfun(@dircontentext,pMWT,cellfunexpr(pMWT,chorfile{v})...
        ,'UniformOutput',0); % search for files
    i = cellfun(@isempty,fn); % empty = fail
    fail(i) = true;
end


if isempty(i) == 0; 
    pMWTpass = unique(pMWT(~fail)); % pass
    pMWTfail = unique(pMWT(fail)); % fail
else
    pMWTfail = pMWT; % all fail
    pMWTpass = [];
end


end

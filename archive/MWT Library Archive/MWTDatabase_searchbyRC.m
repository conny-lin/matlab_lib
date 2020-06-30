function [pExpfT,ExpfnT] = MWTDatabase_searchbyRC(ExpfnD,pExpfD)
% SELECT RUN CONDITION
% get run condition
display 'Run conditions:';
a = celltakeout(regexp(ExpfnD,'_','split'),'split');
RC = a(:,3); 
r = unique(RC);
[show] = makedisplay(r,'bracket'); disp(show);
display 'Enter run condition number,press [ENTER] to abort'; 
a = input(': ');
if isempty(a) ==1; 
    return; 
else
    RCT = r(a);
    i = ismember(r{a},RC);
end
% refine exp folder list
i = ismember(RC,RCT); % index to RC
ExpfnT = ExpfnD(i); pExpfT = pExpfD(i);
display(sprintf('selected RC: %s',RCT{1}));
display(sprintf('[%d] experiment found',numel(ExpfnT)));
disp(ExpfnT);
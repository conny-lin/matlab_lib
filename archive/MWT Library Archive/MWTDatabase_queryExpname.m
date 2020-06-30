function [pExpfT,ExpfnT] = MWTDatabase_queryExpname(pExpfT,ExpfnT)
% [release only by experiment search] search for target paths
% display ' ';
% display 'Search Experiment folders';
pExpfS = pExpfT;
ExpfnS = ExpfnT;
% moresearch = input('Narrow down search (y=1,n=0)?: ');
% 
% while moresearch==1;
    display 'Enter search term:';
    searchterm = input(': ','s');
    % find matches
    k = regexp(ExpfnS,searchterm,'once');
    searchindex = logical(celltakeout(k,'singlenumber'));
    pExpfS = pExpfS(searchindex);
    ExpfnS = ExpfnS(searchindex);
    disp(ExpfnS);
%     moresearch = input('Narrow down search (y=1,n=0)?: ');
% end
pExpfT = pExpfS;
ExpfnT = ExpfnS;
display 'Target experiments:';
disp(ExpfnT); 
% O.ExpfnT = ExpfnT; % export
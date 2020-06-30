function ShaneSparkChorAfterADate(Home)
[~,pMWTf,MWTfn] = getunzipMWT(Home);
display 'enter the oldest year/date you want the analysis [20120304] or [2013]:';
datemin = input(': ');
searchterm = ['^' num2str(datemin)];
searchstart = min(find(not(cellfun(@isempty,regexp(MWTfn,searchterm))))); % find minimum
pMWTtarget = pMWTf(searchstart:end); % get all MWT from search start
% run chore
for x = 1:size(pMWTtarget,1);
    ptrv = pMWTtarget{x,1};
    Shanesparkchoretapreversal(ptrv);
end
display 'done.';
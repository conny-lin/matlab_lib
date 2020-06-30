function T = statsTable_multvar(n,m,s,v)

%% table output for descriptive data
% m = MEAN;
% s = SEM;
% n = NVAL;
% v = responseTypes;
%%

vcorr = regexprep(v,' ','_');

nvar = numel(vcorr);
if size(nvar,2) >1
    nvar = nvar';
end
nData = size(n);
ncoli = ismember(nData,nvar);
arraysetuporientation = find(ncoli);
if arraysetuporientation==1 % flip data
    m = transpose(m);
    s = transpose(s);
    n = transpose(n);
    nRow = nData(2);
end


%%
% create colnames
nstr = strjoinrows([repmat({'N'},nvar,1) vcorr],'_');
mstr = strjoinrows([repmat({'mean'},nvar,1) vcorr],'_');
sstr = strjoinrows([repmat({'SE'},nvar,1) vcorr],'_');
varnames =[nstr' mstr' sstr'];

T = array2table([n m s],'VariableNames',varnames);

%%


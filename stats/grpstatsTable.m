function T = grpstatsTable(y,grp,varargin)
%% standard grpstats table output

%% default
% group name unique list, sorted alphabetically
gnameu = unique(grp);
gnameutitle = 'gnameu';
meantitle = 'mean';
%header for the table, input must be a table
grpheader =table;
if ~iscell(gnameu) && isnumeric(gnameu)
    gnameu = cellfun(@num2str,num2cell(gnameu),'UniformOutput',0);
end    
if isnumeric(gnameu)
    grpheader = array2table(gnameu);
else
    grpheader = cell2table(gnameu);
end

% process varargin
vararginProcessor


%% make stats
[n,mn,sd,se,gn] = grpstats(y, grp,{'numel','mean','std','sem','gname'});
if isnumeric(gnameu)
   gn= cellfun(@str2num,gn) ;
end
[i,j] = ismember(gnameu,gn);
a = [mn se sd n];
b = nan(numel(gnameu),size(a,2));
b(i,:)= a(j(i),:);
b = array2table(b,'VariableNames',{meantitle,'se','sd','n'});

%% make table group name header
T = table;
T.(gnameutitle) = gnameu;
T = [T b];




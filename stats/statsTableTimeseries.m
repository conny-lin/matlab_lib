function T = statsTableTimeseries(D,groupname,varargin)


%% default
stats = {'mean','se'};
timename = 'time';
timeprefix = 't';
vararginProcessor

%% export data

tu = unique(D.(timename));

time = cellfun(@num2str,num2cell(tu),'UniformOutput',0);
colname = strjoinrows([cellfunexpr(time,timeprefix) time],'');
gnu = unique(D.(groupname));
A = nan(numel(gnu)*2,numel(colname));

T = table;
T.stats = cell(numel(stats)*numel(gnu),1);
T.(groupname) = repmat(gnu,numel(stats),1);
r1 = 1;
for stati = 1:numel(stats)
    r2 = r1+numel(gnu)-1;
    T.stats(r1:r2) = repmat(stats(stati),numel(gnu),1);
    B = nan(numel(gnu),numel(tu));
    for gi = 1:numel(gnu)
        D2 = D(ismember(D.(groupname),gnu(gi)),:);
        [i,j] = ismember(D2.(timename),tu);
        a = nan(1,numel(tu));
        B(gi,i) = D2.(stats{stati})(j(i));
    end
    A(r1:r2,:) = B;
    r1 = r2+1;
end
T = [T array2table(A,'VariableNames',colname)];


function [d,leg] = statsBasic(D,varargin)
%% statsBasic
% return N all, N valid, mean, SD, SE
% must be a column or columns of different variables
% (discontinued) if multiple then row = per group Col = per datapoint

%% setting
outputtype = 'array';
leg = {'N','n','mean','sd','se','min','max','median'};
report = 0;

%% varargin process
vararginProcessor


%% calculation
if istable(D)
   vname = D.Properties.VariableNames; 
   D =table2array(D);
   recordvname = true;
else
    recordvname = false;
end

nRow = size(D,1);
nCol = size(D,2);
nall = repmat(nRow,1,nCol);
if nRow==1
    n = repmat(nRow,1,nCol);
    m = nanmean(D,1);
    sd=nan(nRow,nCol);
    m1 = min(D,1);
    m2 = max(D,1);
    md = median(D,1);
else
    n = sum(~isnan(D));
    m = nanmean(D);
    sd =nanstd(D);
    m1 = min(D);
    m2 = max(D);
    md = median(D);
end
se = sd./sqrt(n-1);


%%
switch outputtype
    case 'table'
        d = table;
        if recordvname
            d.vname = vname';
        end
        d.N = nall';
        d.n = n';
        d.mean = m';
        d.sd = sd';
        d.se = se';
        d.min = m1';
        d.max = m2';
        d.median = md';
    case 'array'
        d = [nall',n', m',sd',se',m1',m2',md'];
    case 'struct'
        d = struct;
        if recordvname
            d.vname = vname';
        end
        d.N = nall';
        d.n = n';
        d.mean = m';
        d.sd = sd';
        d.se = se';
        d.min = m1';
        d.max = m2';
        d.median = md';
end


%% reporting

if report
   fprintf('N: %d/%d\n',n,nall);
   fprintf('mean: %.2f sd: %.2f se: %.2f\n',m,sd,se);
end
    

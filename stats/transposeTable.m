function [T1, A,colnamesVar]= transposeTable(T,dvname, tspname, ivnames)


%% get variables
% DV-----------------------------------------------------------------------
rm = T.(tspname);
rmu = unique(rm); % get unique repeated measures 
if isnumeric(rmu)
    a = repmat({tspname},numel(rmu),1);
    b = num2cellstr(rmu);
    colnamesVar = strjoinrows([a b],'_');
end
dv = T.(dvname);
%--------------------------------------------------------------------------

%% IV

iv = T(:,ivnames); % get IV
IV = cell(size(iv));
numInd = false(numel(ivnames));
for ivi =1:numel(ivnames)
    a = T.(ivnames{ivi});
    if isnumeric(a)
       a = num2cellstr(a);
       numInd(ivi) = true;
    end
    IV(:,ivi) = a;
end
IVID = strjoinrows(IV,'@');
ividu = unique(IVID);


%%

% get row identifiers
% id = T.(idname);
% ivgu = unique(id); % get unique I

% match row
[i,j] = ismember(IVID,ividu);
rowid = j(i);
% match column
[i,j] = ismember(rm,rmu);
colid = j(i);
% create array
A = nan(numel(ividu),numel(rmu)); % create matrix
i = sub2ind(size(A),rowid,colid);
A(i) = dv;
inan = any(isnan(A),2);
if sum(inan)==size(A,1); warning('no data valid'); end

A1 = array2table(A,'VariableNames',colnamesVar);

% IV ----------------------------------------------------------------------
%%
IVS = regexpcellout(ividu,'@','split');
TIV = table;
for ivi =1:numel(ivnames)
    a = IVS(:,ivi);
    if isnumeric(T.(ivnames{ivi}))
        a = cellfun(@str2num,a);
    end
    TIV.(ivnames{ivi}) = a;
end

%%
T1 = [TIV A1];


%--------------------------------------------------------------------------

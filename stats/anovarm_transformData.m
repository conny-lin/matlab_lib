function S = anovarm_transformData(Data,rmName,ivnames,repName,dvName, varargin)

%%
% rmName = repeated measures name i.e. tap
% ivnames = comparison IV factor names, i.e. group, response types, ethanol
% repName = individual subject identifier i.e. mwtid
% dvName = DV measure name i.e. probability, mean

%%
% ivnames = {'group','response_type'};
% rmName = 'tap';
% repName = 'mwtid';
% dvName = 'probability';

S = struct;
%% get variables
% repeated measures variable ----------------------------------------------
rm = Data.(rmName);
if ~isnumeric(rm); error('Repeated measures variable must be numeric'); end
rmu = unique(rm); % get unique repeated measures 
S.rmu = rmu;
S.rmtable = array2table(rmu,'VariableNames',{rmName}); % get unique repeated measures table
%--------------------------------------------------------------------------

% DV-----------------------------------------------------------------------
dv = Data.(dvName);
if ~isnumeric(dv); error('DV must be numeric'); end
%--------------------------------------------------------------------------

% IV ----------------------------------------------------------------------
iv = Data(:,ivnames); % get IV
% iv = table2cell(iv);
% ivg = strjoinrows(table2cell(iv),'@'); % make unique iv g
% conver numeric to cell str
ivc = cell(size(iv)); 
for i = 1:numel(ivnames)
    d = Data.(ivnames{i});
    if isnumeric(d)
        ivc = num2cellstr(d);
    else
        ivc(:,i) = d;
    end
end

% get multiple factors comparison
if numel(ivnames)>1
    S.factors = char(strjoin(ivnames,'*'));
    g1 = strjoinrows(ivc,'*');
else
    S.factors = char(ivnames);
    g1 = ivc;
end
ivcu = unique(g1);
S.gpairs = strjoinrows(pairwisecomp_getpairs(ivcu),' x ');
%--------------------------------------------------------------------------

% repeat id ---------------------------------------------------------------
id = Data.(repName);
if isnumeric(id); idc = num2cellstr(id); else; idc = id; end % conver numeric to cell str
% --------------------------------------------------------------------------
% get row identifiers
rowinfo = [ivc idc];
ivg = strjoinrows(rowinfo,'@'); % make unique iv g
ivgu = unique(ivg); % get unique ID

%% TRANSFORM --------------------------------------------------------------
% match row
[i,j] = ismember(ivg,ivgu);
rowid = j(i);
% match column
[i,j] = ismember(rm,rmu);
colid = j(i);
% create array
A = nan(numel(ivgu),numel(rmu)); % create matrix
i = sub2ind(size(A),rowid,colid);
A(i) = dv;
I = isnan(A) | isinf(A); % find nan or inf 20170816
inan = any(I,2); % find any data with inf/nan 20170816
if sum(inan)==size(A,1)
    warning('no data valid'); 
end
% -------------------------------------------------------------------------
%% MAKE TABLE -------------------------------------------------------------
% groups
G = regexpcellout(ivgu,'@','split');
T = cell2table(G,'VariableNames',[ivnames,{repName}]);
T.id = ivgu;
T.factors = strjoinrows(T(:,ivnames),'*');

% dv
a = repmat({rmName},numel(rmu),1);
b = num2cellstr(rmu);
c = strjoinrows([a b],'');
T2 = array2table(A,'VariableNames',c);
% combine
Data2 = [T T2];
S.Data_all = Data2;
% -------------------------------------------------------------------------

%% clean up nan 
Data3 = Data2(~inan,:);
S.Data = Data3;



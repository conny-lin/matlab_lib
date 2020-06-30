function [T,a1,TC,TCn] = multcompare_pairinterpretation(c,gnames,varargin)
%% multcompare_pairinterpretation
% Input
%     nsshow = 1; % use 0 to exclude n.s. output
% Output:
%     TC = cross tab table
%     TCn = cross table table in numeric array



%% default values & varargin processer
nInput = 2;
pvalue = 0.05;
nsshow = 1; % use 0 to exclude n.s. output

vararginProcessor;


%% calculate significant pairs
i = sum((c(:,3:5) > 0),2) == 3 | sum((c(:,3:5) < 0),2) == 3;
isig = i;
a = [gnames(c(:,1)), gnames(c(:,2))];
% find pvalue digit
str = sprintf('<%%.%df',numel(num2str(pvalue))-2);
a(i,3) = {sprintf(str,pvalue')};




%% create table output
% create table
T = table;
T.group1 = a(:,1);
T.group2 = a(:,2);
T.pvalue = nan(size(a,1),1);
if nsshow == 1
    a(~i,3) = {'n.s.'};
    T.pvalue(i) = pvalue;
elseif nsshow == 0
    a(~i,:) = [];
    T(~i,:) = [];
    T.pvalue(:) = pvalue;
end


%% produce text output
a1 = cell(size(a,1),1);
for x = 1:size(a,1)
    if strcmp(a{x,3},'n.s.')
       sgn = '=';
    else
        sgn = '';
    end
    a1{x} = sprintf('%s vs. %s %s %s',a{x,1},a{x,2},sgn,a{x,3});  
%     a1{x} = sprintf('%s vs. %s %s',a{x,1},a{x,2},a{x,3});  

end



%% creat cross tab output (r201512051256)
% make sure names are valid names
gnameL = regexprep(gnames,' ','_');
% create entry matrix
b = cell(numel(gnameL),numel(gnameL));
for x = 1:numel(gnameL)
    b(x,x:end) = {'--'};
end
icol = c(:,1);
irow = c(:,2);
for x = 1:numel(icol)
    if isig(x) == true
        b{irow(x),icol(x)} = num2str(pvalue);
    else 
        b{irow(x),icol(x)} = 'n.s.';
    end
end
% add gname col
b = [gnameL b];
% fix number as start of the name
i = regexpcellout(gnameL,'\<\d');
if sum(i) > 0
    gnameL = strjoinrows([cellfunexpr(gnameL,'x') gnameL],'');
end
% create table
TC = cell2table(b,'VariableNames',[{'gname'} gnameL']);

%% translate to numeric array
b = table2array(TC(1:end,2:end));
a = nan(size(b));
a(ismember(b,{'n.s.'})) = Inf;
i = ~ismember(b,{'n.s.','--'});
a(i) = cellfun(@str2num,b(i));
TCn = a;

end
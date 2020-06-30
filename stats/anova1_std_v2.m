function [txt,anovastats,multstats,T,ST,ST2] = anova1_std_v2(data,group, Nname,varargin)

%% varargin
% input
if nargin<3
    Nname = '';
end
ns = 1; % include p=n.s.
psig = 0.05; % 
digit = 2;

pSave = '';
vararginProcessor



%% check input
if numel(data) ~= numel(group); error('x and g different size'); end


%% anova
[anovatext,DesStat,p,anovastats,t,ST] = anova1_autoresults(data,group);
[multstats,gnames] = multcompare_convt22016v(anovastats);
% remove n.s.
if ~ns
    multstats(multstats.pValue > psig,:) = [];
end
% generate text results
result = multcompare_text2016b(multstats); 


%% create N output
% group names
groupnames = char(strjoinrows(DesStat.gnames',', '));
groupnames = regexprep(groupnames,'_',' ');
% N
n = strjoin(num2cellstr(DesStat.N')',', ');
if ~isempty(Nname)
    nstr = sprintf('N(%s) = %s',Nname,n);
else
    nstr = sprintf('N = %s',n);
end
% mean
m = strjoin(correct_digitstr(DesStat.mean,digit)',', ');
% se
s = strjoin(correct_digitstr(DesStat.SE,digit)',', ');

dstr = sprintf('*** Descriptive ***\ngroupnames: %s\n%s\nmean: %s\nSE: %s',groupnames,nstr,m,s);
txt = sprintf('%s\n\n*** ANOVA ***\n%s\n\n*** MultCompare ***\n%s',dstr,anovatext,result);

%% group descriptive
T = statsBasicG(data,group,'group');

%% structural output
ST2 = struct;
ST2.descriptive = anovastats;
ST2.anovatable = ST;
ST2.anovatext = txt;
ST2.multcompare = multstats;
ST2.table = T;

%% save
if ~isempty(pSave)
   fid = fopen(pSave,'w');
   fprintf(fid,'%s\n',txt);
   fclose(fid);
end

end


















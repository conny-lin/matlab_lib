function [pstr,pvt,tv] = pvaluestring(rtime,pv,alpha,pvlimit,varargin)

space = false;
zerob4 = true;
vararginProcessor

%% combine
Data = table;
Data.t = rtime;
Data.p = pv;

%% delete n.s.
Data(Data.p > alpha,:) = [];
tv = Data.t;
pvt = Data.p;


%%
if all(Data.p <= pvlimit)
   str = 'all, p<%.3f';
   pstr = sprintf(str,pvlimit);
   
elseif isempty(Data)
    pstr = 'p=n.s.';
    
else
    asig_pvlimit = Data(Data.p<=pvlimit,:);
    asig_lower = Data(Data.p>pvlimit,:);
    if ~isempty(asig_pvlimit)
        nn = table;
        nn.t = asig_pvlimit.t;        
        nn.d1 = [diff(nn.t);5];
        nn.d2 = [1;diff(nn.d1)];
        nn.sep = repmat({', '},size(nn,1),1);
        nn2 = nn(nn.d2~=0,:);
        nn2.sep(nn2.d1==1) = {'-'};
        nn2.ttxt = num2cellstr(nn2.t);
        nn2.ttxt_sep = strjoinrows([nn2.ttxt,nn2.sep],'');
        a = strjoin(nn2.ttxt_sep','');
        a = sprintf('t%sp=%.3f',a,pvlimit);
        p1000 = a;
    else
        p1000 = '';
    end
    
    a = num2cellstr(asig_lower.t);
    a = strjoinrows([cellfunexpr(a,'t'),a],'');
    b = num2cellstr(asig_lower.p);
    c = cellfunexpr(a,'p=');
    d = strjoinrows([c b],'');
    e = strjoinrows([a d],', ');
    s2 = strjoin(e',', ');
    if isempty(p1000)
        pstr = s2;

    else
        pstr = sprintf('%s, %s',p1000,s2);
    end


end

%% correct format
if space
    a = pstr;
    a = regexprep(a,'=',' = ');
    pstr = a;
end

%%
if ~zerob4
    a = pstr;
    a = regexprep(a,'0[.]','.');
    pstr = a;
end




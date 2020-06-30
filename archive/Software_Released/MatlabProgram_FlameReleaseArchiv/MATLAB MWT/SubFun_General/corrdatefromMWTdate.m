function [MWTrunameCorr] = corrdatefromMWTdate(MWTfn,MWTfsn)
[strain,seedcolony,colonygrowcond,runcond,trackergroup] = ...
        parseMWTfnbyunder(MWTfsn);
    
a = char(MWTfn); % get MWT folder date
MWTMM = str2num(a(:,5:6));
MWTYY = str2num(a(:,1:4)); % get year
MWTDD = str2num(a(:,7:8));
t = datenum([MWTYY MWTMM MWTDD]); % convert to number format
% get age of worm
a = char(colonygrowcond);
a = regexp(colonygrowcond,'[a-z]','split');
b = [];
for x = 1:numel(a)
    b(x) = str2num(a{x}{2});
end
c = b./24;
c = round(c);
date2 = [];
for x = 1:numel(t)
date2(x)= addtodate(t(x),-c(x),'day');
end
expdate = num2cell(date2)';
[format] = cellfunexpr(expdate,'mmdd');
expdate = cellfun(@datestr,expdate,format,'UniformOutput',0);
% replace it with original names
a = char(trackergroup);
method = cellstr(a(:,1)); % get months
gp = cellstr(a(:,6:7));
new = cellfun(@strcat,method,expdate,gp,'UniformOutput',0);
A = MWTfsn;
[u] = cellfunexpr(MWTfsn,'_');
B = cellfun(@strcat,strain,u,seedcolony,u,colonygrowcond,u,runcond,u,new,'UniformOutput',0)
MWTrunameCorr = B;

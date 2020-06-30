function [pExptarget,Expntarget] = getExpntargetAfteraDate(Home)
[pExp,Expfn,~,~,~,~,MWTfsn] = getMWTpathsNname(Home,'noshow');
display 'enter the oldest year/date you want the analysis [20120304] or [2013]:';
datemin = input(': ');
searchterm = ['^' num2str(datemin)];
expname =Expfn;
searchstart = min(find(not(cellfun(@isempty,regexp(expname,searchterm))))); % find minimum
pExptarget = pExp(searchstart:end); % get all MWT from search start
Expntarget = Expfn(searchstart:end); 
display 'Experiments set as targets:';
disp(Expntarget);
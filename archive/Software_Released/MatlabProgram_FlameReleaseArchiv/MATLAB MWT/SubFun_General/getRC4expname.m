function [MWTfname, RC] = getRC4expname(pMWTfset)
[fn,~,~,~] = dircontent(pMWTfset{1,1}); 
MWTfname = fn(1,1); 
under = strfind(MWTfname{1,1},'_'); % find underline
RC = MWTfname{1,1}(under(3)+1:under(4)-1); % run condition
end

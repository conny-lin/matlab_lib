function [groupcodemwt,mwtnogcode,groupcodeU,P] = findNvalidategroupcodes(MWTfsn)
%% unerline must be correct
gc(1:size(MWTfsn(:,2)),1) = {'[a-z][a-z]'};
[~,~,~,match,~,~,split] = cellfun(@regexp,MWTfsn(:,2),gc,'UniformOutput',0);
% take match data out of cell
groupcodemwt = {};
for x = 1:size(match,1);
    groupcodemwt(x,1) = match{x,1};   
end
% take split out of cell
mwtnogcode = {};
for x = 1:size(match,1);
    mwtnogcode(x,1) = split{x,1}(1);   
end
 
%%
groupcodeU = unique(groupcodemwt);
% compare redundancy;
gcsize = size(groupcodeU,1);
mwtfsize = size(MWTfsn,1);
if gcsize ~= mwtfsize;
    display('redundency foudn in group-plate codes');
    P = 0;
else 
    P = 1;
end

end
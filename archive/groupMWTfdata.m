function [A] = groupMWTfdata(MWTfdat,MWTfGi)
% [Expfdat] = groupexpimport(Expfdat,MWTGind);
%% organize import via groups: Expfdat
% process raw import to get plate mean via MWTGind
% D = Expfdat;
A = MWTfGi(:,1);
groupsize = size(MWTfGi,1);
for xg = 1:groupsize; % for each group
    groupindex = MWTfGi{xg,3}; % get MWTf index
    for xx = 1:size(groupindex,2);
        i = groupindex(1,xx); % get index to MWTf
        A{xg,2}{xx,1} = MWTfdat{i,1}; % get raw data MWTf name 
        A{xg,2}(xx,2) = MWTfdat(i,3);% get MWTfdat raw data
    end
end
end
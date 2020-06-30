function [A] = groupMWTfdata2(MWTfdat,MWTfgcode)
% [Expfdat] = groupexpimport(Expfdat,MWTGind);
%% organize import via groups: Expfdat
% process raw import to get plate mean via MWTGind
% D = Expfdat;
display(' ');
display('Orgnizing data into preset groups...');
A = MWTfgcode(:,1);
groupsize = size(MWTfgcode,1);
for xg = 1:groupsize; % for each group
    groupindex = MWTfgcode{xg,3}; % get MWTf index
    for xx = 1:size(groupindex,2);
        i = groupindex(1,xx); % get index to MWTf
        A{xg,2}(xx,:) = MWTfdat(i,:); % get raw data MWTf name 
    end
end
display('done');
end
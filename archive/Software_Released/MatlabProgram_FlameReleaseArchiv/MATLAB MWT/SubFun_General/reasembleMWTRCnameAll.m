function [name] = reasembleMWTRCnameAll(RCpart)
%%
n = RCpart;
underline(1:size(n,1),1) = {'_'};
cross(1:size(n,1),1) = {'x'};
second(1:size(n,1),1) = {'s'};
temp(1:size(n,1),1) = {'C_'};
hr(1:size(n,1),1) = {'h'};

name = cellfun(@strcat,n(:,2),underline,n(:,3),cross,n(:,4),underline,n(:,5),...
    n(:,6),hr, n(:,7),temp, n(:,8),second,n(:,9),cross,n(:,10),...
                    second,n(:,11),underline,n(:,12),n(:,13),n(:,14),n(:,15),'UniformOutput',0);

end
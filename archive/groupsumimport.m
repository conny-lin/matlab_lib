function [sumimportgrouped] = groupsumimport(sumimport,MWTfgcode)
%% group sumiport into groups
%%
sumimportgrouped = {};
%%
for gn = 1:numel(MWTfgcode(:,1)); % for every group   
    for x = 1:numel(sumimport); % for the number of sprevs imported
        sumimportgrouped.(char(MWTfgcode{gn,1})){x,1} = ...
            sumimport{x}(MWTfgcode{gn,3},:);
    end
end

end
function [A] = displayallMWTfrunname2(MWTfsn)
%%
b1(1:size(MWTfsn,1),1) = {'['};
b2(1:size(MWTfsn,1),1) = {'] '};
A = char(cellfun(@strcat,b1,cellstr(num2str((1:size(MWTfsn,1))')),b2,MWTfsn(:,1),...
    b1,MWTfsn(:,2),b2,'UniformOutput',0));
display('Found the following MWT run names:');
disp(A);
end
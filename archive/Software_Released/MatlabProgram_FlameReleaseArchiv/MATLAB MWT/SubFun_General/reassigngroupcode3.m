function [GRA] = reassigngroupcode3(RCpart)
%% manually assign group code
GRA = cellfun(@strcat,RCpart(:,14),RCpart(:,15),'UniformOutput',0);
disp(GRA);
disp('type in correct group-plate code (i.e. aa)...');
q1 = 'correct group code of %s[%s]: ';
i = {};
for x = 1:size(RCpart,1);
     GRA(x,2) = {input(sprintf(q1,RCpart{x,1},GRA{x,1}),'s')};
end
end
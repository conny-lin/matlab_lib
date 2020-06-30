function [GRA] = reassigngroupcode2(RCpart)
%% manually assign group code
%% NOT DONE
% works with parseMWTRCnameall
Strain = RCpart(:,2);
%%
GRA = cellfun(@strcat,RCpart(:,14),RCpart(:,15),'UniformOutput',0);
equal(1:size(MWTfsn,1),1) = {' strain= '};
GRAS = cellfun(@strcat,RCpart(:,14),RCpart(:,15),equal,RCpart(:,2),'UniformOutput',0);
disp(GRA);
if size(unique(GRA),1) ~= size(GRA,1);
    warning('duplicate goupe-plate code found');
    T = tabulate(GRA);
    disp(T(:,1:2));
end
%%
disp('type in correct group-plate code (i.e. aa)...');
q1 = 'correct group code of %s[%s]: ';
i = {};
for x = 1:size(RCpart,1);
     GRA(x,2) = {input(sprintf(q1,RCpart{x,1},GRA{x,1}),'s')};
end
end
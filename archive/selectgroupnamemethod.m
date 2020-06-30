function [GA] = selectgroupnamemethod(gcode,RCpart,pFun,pExp,id)
%% get group index
%MWTGname = MWTfdat;
if id==0;
q1 = input('Manually assign (1), select variable (0), or use Groups*.mat(2)?\n ');
else
q1 =id;
end

switch q1;
case 1 % manually assign
    GA = gcode;
    disp(gcode);
    disp('type in the name of each group as prompted...');
    q1 = 'name of group %s: ';
    i = {};
    for x = 1:size(gcode,1);
         GA(x,2) = {input(sprintf(q1,gcode{x,1}),'s')};
    end
case 0 % select assign (by continueing)
    [~,~,GA] = assigngroupname(RCpart,4,3,pFun)
case 2 % use group files
    cd(pExp);
    fn = dir('Groups*.mat'); % get filename for Group identifier
    fn = fn.name; % get group file name
    load(fn); % load group files
    GA = Groups;
otherwise
    error('please enter 0 or 1');
end
end
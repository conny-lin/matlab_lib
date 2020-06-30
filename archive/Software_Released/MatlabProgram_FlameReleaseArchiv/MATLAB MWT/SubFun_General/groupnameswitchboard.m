function [GA] = groupnameswitchboard(gcode,RCpart,pFun,pExp,id)
        % assign group names
        % id: 0- select method, 1- select pre-defined variable, 
        % 2-manually assign, 3-use premade Groups*.mat file
        %MWTGname = MWTfdat; 
        if id==0;
            disp(' ');
            method = char('[0] Select pre-defined variable',...
            '[1] Manually assign','[2] Use Groups*.mat file');
            disp(method);
            q1 = input('Enter method to name your group: ');
        else
            q1 =id;
        end
        switch q1;
        case 2 % manually assign
            GA = gcode;
            disp(gcode);
            disp('type in the name of each group as prompted...');
            q1 = 'name of group %s: ';
            i = {};
            for x = 1:size(gcode,1);
                 GA(x,2) = {input(sprintf(q1,gcode{x,1}),'s')};
            end
        case 1 % select assign (by continueing)
            [~,~,GA] = assigngroupname(RCpart,4,3,pFun)
        case 3 % use group files
            cd(pExp);
            fn = dir('Groups*.mat'); % get filename for Group identifier
            fn = fn.name; % get group file name
            load(fn); % load group files
            GA = Groups;
        otherwise
            error('please enter 0 or 1');
        end
        end
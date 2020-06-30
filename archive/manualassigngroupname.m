function [GA] = manualassigngroupname(MWTfgcode)
        %% manually assign group code
            GA = MWTfgcode(:,1);
            disp(MWTfgcode);
            disp('type in the name of each group as prompted...');
            q1 = 'name of group %s: ';
            i = {};
            for x = 1:size(MWTfgcode,1);
                 GA(x,2) = {input(sprintf(q1,MWTfgcode{x,1}),'s')};
            end
        end
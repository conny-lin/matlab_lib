function [P] = validatetaps(MWTftrvG)
%% validate data
psize = [];
for g = 1:size(MWTftrvG,1);
    for p = 1:size(MWTftrvG{g,2},1);
        psize(g,p) = size(MWTftrvG{g,2}{p,10},1);
        rown = unique(psize(g,:));
        if isequal(size(rown,2))==0;
            display(sprintf('data in group[%s] plate [%d] is not good',MWTftrvG{g,1},p));
            P = 0;% record the unique number
        else
            P = 1;
        end
    end
end
end


    function developing 
test = {};
for g = 1:size(psize,2)
    rown = unique(psize(g,:));
    if isequal(size(rown,2))==0;
        display(sprintf('data in group[%s] plate [%d] is not good',MWTftrvG{g,1},p));
        P = 0;% record the unique number
    else
        P = 1;
    end
end 
    end


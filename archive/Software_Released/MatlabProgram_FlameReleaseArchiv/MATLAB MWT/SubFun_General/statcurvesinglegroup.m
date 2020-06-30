function [A] = statcurvesinglegroup(D,id)
% id - Expdata=1, MWTdata=2
switch id
    case 1 % D = Expfdat   
        for f = 1:size(D,1); % for every import
            for g = 1:size(D{f,3},1); % for every group  
                A = {};
                A{f,3}{g,1} = D{f,3}{g,1}; 
                A{f,3}{g,2} = D{f,3}{g,2}; % get data
                A{f,3}{g,3} = mean(D{f,3}{g,2},2);
                A{f,3}{g,4} = SE(D{f,3}{g,2});
            end
            A{f,4} = cell2mat(D{f,3}(:,3)'); % combine get group mean 
            A{f,5} = cell2mat(D{f,3}(:,4)'); % combine get group se 
        end
        
        
    case 2 % MWTfdat/MWTftrv
        for g = 1:size(D,1); % for every group  
            A(g,1) = D(g,1); % get group code
            A(g,2) = D(g,3); % get plate data
            A{g,3}= mean(D{g,3},2); % plate mean
            A{g,4}= SE(D{g,3}); % plate SE
        end
end
end

%% SUBFUNCTION
function [a] = SE(A)
    a = std(A,1,2)/sqrt(size(A,2));
end
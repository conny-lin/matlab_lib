function [B] = statstdcurve2(D,id)
% id - Expdata=1, MWTdata=2
%% Standardized Curve
switch id
    case 1 % D = Expfdat 
        for f = 1:size(D,1); % for every import
            for g = 1:size(D{f,3},1); % for every group  
                A = {};
                A = D{f,3}{g,2}; % get data
                I = repmat(A(1,:),size(A,1),1); % get initial array
                A = A./I; % standardize to initial
                D{f,3}{g,3}= mean(A,2); % calculate mean
                D{f,3}{g,4}= SE(A); % calculate SE
            end
            D{f,4} = cell2mat(D{f,3}(:,3)'); % combine get group mean 
            D{f,5} = cell2mat(D{f,3}(:,4)'); % combine get group se 
            B = D;
        end
    case 2 % MWTfdat/MWTftrv
        %%
        for g = 1:size(D,1); % for every group  
            A = D{g,3};
            %% [BUG] initial zero... what to do then?
            I = repmat(A(1,:),size(A,1),1); % get initial array
            A = A./I; % standardize to initial
            D{g,3}= mean(A,2); % calculate mean
            D{g,4}= SE(A); % calculate SE
        end
        B = D;
        
    otherwise
        error('invalid analysis id for statstdcurve2');
        
end
end


%% SUBFUNCTION
function [a] = SE(A)
    a = std(A,1,2)/sqrt(size(A,2));
end


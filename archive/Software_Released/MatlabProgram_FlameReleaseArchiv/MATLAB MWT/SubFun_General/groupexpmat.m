function [A] = groupexpmat(D,MWTGind)
% [Expfdat] = groupexpimport(Expfdat,MWTGind);
%% organize import via groups: Expfdat
% process raw import to get plate mean via MWTGind
% D = Expfdat;
A = {};
for f = 1:(size(D,1)); % loop for all imports
    c1 = 3; % get rid of time and mean
    c2 = size(D{f,2},2)-1; % get rid of SD
    A{f,1} = D{f,2}(:,c1:c2); % get only plate mean
    A{f,2} = MWTGind; % copy group index into each file import
    for g = 1:size(A{f,2},1);% for each group
        p = A{f,2}{g,2}; % get plate number

        for px = 1:p; % for each plate
           i = A{f,2}{g,3}(1,px); % get column number
           A{f,2}{g,4}(:,px) = A{f,1}(:,i); % get data 
        end
        
    end
    A{f,2}(:,2)= []; % remove count
    A{f,2}(:,2)= []; % remove column index
end
A = cat(2,D(:,1),A);
end
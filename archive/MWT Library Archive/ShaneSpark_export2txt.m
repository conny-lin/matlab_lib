%% export ShaneSpark output to excel sheet
function [A,GroupNames] = ShaneSpark_export2txt(p)
% load matlab.mat
cd(p);
load('matlab.mat','MWTSet');
Data = MWTSet.Graph;
GroupNames = MWTSet.GraphGroup;
measures = fieldnames(Data);

for m = 1:numel(measures)
    % get first data
   
colNames = strcat(GroupNames,cellfunexpr(GroupNames,'_Time'));
    x = array2table(Data.(measures{m}).X,...
        'VariableNames',colNames);
colNames = strcat(GroupNames,cellfunexpr(GroupNames,'_Mean'));
    y = array2table(Data.(measures{m}).Y,...
        'VariableNames',colNames);
 colNames = strcat(GroupNames,cellfunexpr(GroupNames,'_SE'));
    e = array2table(Data.(measures{m}).E,...
        'VariableNames',colNames);  
    
    a = [x,y,e];
    A.(measures{m}) = a;
    filename = [measures{m},'.txt'];
    cd(p);
    writetable(a,filename,'Delimiter','\t');
end
end


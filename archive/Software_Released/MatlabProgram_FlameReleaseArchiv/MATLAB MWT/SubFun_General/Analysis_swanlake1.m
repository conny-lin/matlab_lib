function [Stats] = Analysis_swanlake1(Analysis,MWTindex,Stats,...
    GroupBy,SourceBy,SampleTime)
%function Analysis_taptime(Analysis,
% Analysis = 'Posture';
% pSet = paths.pMWTSet;

%% GROUP MEAN
%GroupBy = 'group'; SourceBy = 'plate';
B = Stats.(Analysis).(SourceBy).Descriptive; 
measure = fieldnames(B);
%Time = SampleTime';
platei = MWTindex.(SourceBy).code;
groupi = MWTindex.(GroupBy).code; 
gu = unique(groupi);
for m = 1:numel(measure)
    A = B.(measure{m}); % get data
    StatType = 'Descriptive';
    D = [];
    for g = 1:numel(gu)
        i = ismember(A(:,1), platei(groupi == gu(g)));
        [n,ms,se,gn] = grpstats(A(i,4),A(i,2),...
            {'numel','mean','sem','gname'}); 
            time = cellfun(@str2num,gn);
        % put data according to time
        tval = ismember(time,SampleTime');
        D.t(tval,g) = time;
        D.N(tval,g) = n;
        D.Y(tval,g) = ms;
        se(se==0) = NaN;
        D.E(tval,g) = se;
    end    
    Stats.(Analysis).(GroupBy).(StatType).(measure{m}) = D;
    
    % prep rm anova input
    if numel(gu)>1;
        StatType = 'rmANOVA';
        [~,table] = anova_rm(D.Y','off');
        Stats.(Analysis).(GroupBy).(StatType).(measure{m}) = table;
    end
end





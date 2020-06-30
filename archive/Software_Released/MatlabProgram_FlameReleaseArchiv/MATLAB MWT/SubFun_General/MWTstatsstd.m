function [D] = MWTstatsstd(i,S,GroupBy,pSaveA)
%GroupBy = 'groupbyexp'; SourceBy = 'exp_group';
% STATS WORM SHAPE BY GROUP AND EXP
%i = MWTindex.(GroupBy).code;
u = unique(i);
%StatType = 'Descriptive';
%S = Stats.(Analysis).(SourceBy).(StatType);
measure = fieldnames(S);
D = [];
% descriptives
for m = 1:numel(measure);

    StatType = 'Descriptive';
    if iscell(S.(measure{m}))
        b = S.(measure{m})
    else
        b = S.(measure{m})(:,2);
    end

    a = [];
    for x = 1:numel(u);
       a(x,1:3) = [numel(b(i==u(x),1)),nanmean(b(i==u(x),1)),...
           nanstd(b(i==u(x),1))];
    end
    D.(StatType).(measure{m}) = a;
end

% anova stats
StatType = 'ANOVA';
for m = 1:numel(measure);
    [p,t,st] = anova1(b,i,'off');
    D.(StatType).(measure{m}) = t;
end

% posthoc
StatType = 'Posthoc';
if numel(u)>2;
    for m = 1:numel(measure);

        c = multcompare(st,'display','off');
        D.(StatType).(measure{m}) = c;
        % pick posthoc significance
        c = c(c(:,5)>0 & (c(:,3)<0 | c(:,4)<0),1:2);
        cd(pSaveA); dlmwrite([GroupBy,'_',StatType,'_',measure{m},'.dat'],c);   
    end
end
%Stats.(Analysis).(GroupBy) = D;
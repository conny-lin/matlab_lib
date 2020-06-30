function [D] = MWTstatsMaster(Code,S,Analysis,GroupBy,pSaveA)
%GroupBy = 'groupbyexp'; SourceBy = 'exp_group';
% STATS WORM SHAPE BY GROUP AND EXP
%i = MWTindex.(GroupBy).code;
u = unique(Code);
%StatType = 'Descriptive';
%S = Stats.(Analysis).(SourceBy).(StatType);
measure = fieldnames(S);
D = [];

for m = 1:numel(measure);
% descriptives
    StatType = 'Descriptive';
    switch GroupBy
        case 'plate'
            P = S.(measure{m});
            r = 1; group = []; n = []; A = [];
            for mwt = 1:numel(P)
                % get mean of median body area of individual worms
                n = numel(P{mwt}(:,2));
                B(mwt,:) = [n,nanmean(P{mwt}(:,2)),nanstd(P{mwt}(:,2))];
                Code(r:r+n-1,1) = repmat(mwt,n,1);
                A(r:r+n-1,1) = P{mwt}(:,2);
                r = r+n;
            end
            D.(StatType).(measure{m}) = B;
        otherwise
            A = S.(measure{m})(:,2);
            a = [];
            for x = 1:numel(u);
               a(x,1:3) = [numel(A(Code==u(x),1)),nanmean(A(Code==u(x),1)),...
                   nanstd(A(Code==u(x),1))];
            end
            D.(StatType).(measure{m}) = a;
    end
            % anova stats
            StatType = 'ANOVA';
            [p,t,st] = anova1(A,Code,'off');
            D.(StatType).(measure{m}) = t;

            % posthoc
            StatType = 'Posthoc';
            if numel(u)>2;
                c = multcompare(st,'display','off');
                D.(StatType).(measure{m}) = c;
                % pick posthoc significance
                c = c(c(:,5)>0 & (c(:,3)<0 | c(:,4)<0),1:2);
                cd(pSaveA); dlmwrite([GroupBy,'_',StatType,'_',measure{m},'.dat'],c);   
            end
    
end
%Stats.(Analysis).(GroupBy) = D;
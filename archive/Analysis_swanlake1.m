function [Stats] = Analysis_swanlake1(Analysis,MWTindex,Stats,...
    GroupBy,SourceBy,SampleTime)
%function Analysis_taptime(Analysis,
% Analysis = 'Posture';
% pSet = paths.pMWTSet;

switch GroupBy

    case 'group'
    %% GROUP MEAN
    %GroupBy = 'group'; SourceBy = 'plate';
    B = Stats.(Analysis).(SourceBy).Descriptive; 
    measure = fieldnames(B);
    %Time = SampleTime';
    %platei = MWTindex.(SourceBy).code;
%% 
a = MWTindex.platepath.text;
a = regexpcellout(a,'/','split');
groupnamelist = a(:,end-1);
groupname = unique(groupnamelist);
groupnumber = numel(groupname);

%%
    groupi = MWTindex.(GroupBy).legendindex; 
    groupnumber = numel(MWTindex.(GroupBy).legend);
    
    for m = 1:numel(measure)
        A = B.(measure{m}); % get data
        StatType = 'Descriptive';
        D = [];
        for g = 1:groupnumber
            %i = ismember(A(:,1), platei(groupi == gu(g)));
            i = strcmp(groupnamelist,groupname{g});
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
        if numel(gn)>1;
            StatType = 'rmANOVA';
            [~,table] = anova_rm(D.Y','off');
            Stats.(Analysis).(GroupBy).(StatType).(measure{m}) = table;
        end
    end

end



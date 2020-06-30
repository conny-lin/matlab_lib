function AFR = AfterParty_ExpReport(AFR)
%% 
%% AfterParty_ExpReport(DanceOutputPath) generate a report of experiments analyzed in a matlab.mat output from Dance program
%    

%% get data
pR = AFR.PATHS.pDanceResult;
M = load([pR,'/matlab.mat']);
M = M.MWTSet;


%% find  MWT plates in results report
MWTfnReport = mwtpath_parse(M.MWTInfo.pMWT,{'MWTname'});
nReport = numel(MWTfnReport);


%% check if any missing plates
D = M.MWTInfo;
names = fieldnames(D);
names(~regexpcellout(names,'\<pMWT')) = [];
D1 = struct;
nFiles = zeros(size(names));
for x =1:numel(names)
    nFiles(x) = size(D.(names{x}),1);
end


%% create bad MWT file report
i = nFiles > nReport;
if sum(i) == 0
    disp('no plates excluded in this analysis');

else
    nMWTRefnotSameAsnReport = names(i);
    disp('The following MWTInfo field has more MWT files than reporting MWT number:')
    disp(char(nMWTRefnotSameAsnReport));
    
    % find plates excluded and their info
   A = MWTfnReport;
   pMWTmissing = {};
    for x = 1:numel(nMWTRefnotSameAsnReport)
        p = D.(nMWTRefnotSameAsnReport{x});
        B = mwtpath_parse(p,{'MWTname'});
        [C,~,ib] = setxor(A,B);
        fnMWTmissing = C;
        iMWTmissing = ib;
        pMWTmissing = [pMWTmissing;p(ib)];
    end
    
    % find unique paths
    m = mwtpath_parse(pMWTmissing,{'MWTname'});
    [~,i] = unique(m);
    pMWTmissing = pMWTmissing(i);
    
    % create report
    createxpreport(pMWTmissing,AFR.PATHS.pSaveA,'ExperimentReport_badMWTfiles.txt');
    
    

end


%% create data analysis report
i = nFiles == max(nFiles);
a = names(i);
p = D.(a{1});
mn = mwtpath_parse(p,{'MWTname'});
p(~ismember(mn,MWTfnReport)) = [];
createxpreport(p,AFR.PATHS.pSaveA,'ExperimentReport_gooddata.txt');

%% create by group counts

createexpreport_groupcount(p,AFR.PATHS.pSaveA,'ExperimentReport_plateNbyGroup.txt');

end

%% SUBFUN
%% create experiment report
function R = createxpreport(pMWT,pSave,fname)
     R = cell(1,5);
    [expname,Gn,mn,s,gc] = mwtpath_parse(pMWT,...
        {'expname','gname','MWTname','strain','groupcond'});
    R = [R;[expname,mn,Gn,s,gc]];
    R(1,:) = [];
    varnames = {'Experiment_Names','MWT_name','Group','strain','condition'};
    T = cell2table(R,'VariableNames',varnames);
    cd(pSave);
    writetable(T,fname,'Delimiter','\t');
end


%% create by group counts
function createexpreport_groupcount(pMWT,pSave,fname)
    [gn,s] = mwtpath_parse(pMWT,{'gname','strain'});
    a = tabulate(gn);
    snamelable = a(:,1);
    % put N2 first
    i = regexpcellout(s,'(N2)');
    N2U = unique(gn(i));
    i = ismember(snamelable,N2U);
    a = a([find(i);find(~i)],1:2);
    gname = a(:,1);
    gcount = a(:,2);
    
    b = regexpcellout(gname,'(_)','split');
    condition = cell2table(b);
    t = condition;
    
    T = table;
    T.groupname = gname;
    T = [T,t];
    
    t = table;
    t.platecount = gcount;
    T = [T,t];
    cd(pSave);
    writetable(T,fname,'Delimiter','\t');
    
end


function a = getgroupcondition(GroupName)
    b = regexpcellout(GroupName,'(_)','split');
    b = b(:,2:end);

    for x = 1:size(b,1)
        d = b(x,:);
        e = '';
        for y = 1:numel(d)
           e = strcat(e,d{y});
        end
        a{x,1} = e;
    end
    
end

function a = getstrainname(GroupName)
    b = regexpcellout(GroupName,'(_)','split');
    a = b(:,1);
    
end



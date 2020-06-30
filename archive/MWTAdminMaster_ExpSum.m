function [Report] = MWTAdminMaster_ExpSum(MWTfG,pSaveA)
%% Requires extension pack:
    % writetable

%% CREATE TABLE
colheading = {
    'expname';
    'run_cond';
    'strain_name';
    'exposure_type';
    'groupname';
    'MWT_platename'};

%% GET PLATE NAME
names = fieldnames(MWTfG);
D = {};
for x = 1:numel(names)
    platenames = MWTfG.(names{x})(:,1);
    n = numel(platenames);
    groupname = names{x};
    a = regexp(groupname,'_','split');
    strainame = repmat(a(1,1),n,1);
    if size(a,2) >1
        exptype = repmat({regexprep(groupname,strcat(a(1,1),'_'),'')},n,1);
    else
        exptype = repmat({''},n,1);
    end
    groupname = repmat({groupname},n,1);
    
    %%
    a = MWTfG.(names{x})(:,2);
    a = cellfun(@fileparts,a,'UniformOutput',0);
    a = cellfun(@fileparts,a,'UniformOutput',0);
    [~,a] = cellfun(@fileparts,a,'UniformOutput',0);
    expname = a(:,1);
    a = regexpcellout(expname,'_','split');
    runcond = a(:,3);
    B = [expname,runcond,strainame,exptype,groupname,platenames];
    D = [D;B];
end

%% make table
C = cell2table(D,'VariableNames',colheading');
names = colheading;
for x = 1:numel(names)
    C.(names{x}) = char(C.(names{x}));
end
cd(pSaveA);
writetable(C,'ExpSum.dat','Delimiter','\t');


%% OUTPUT
Report = C;


%%
end
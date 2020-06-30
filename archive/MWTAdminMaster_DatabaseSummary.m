function [T] = MWTAdminMaster_DatabaseSummary(pList)
%% give output

%% validate input
i = isfield(pList,{'pData','pSave'});
if sum(i) == 2
    pData = pList.pData;
    pSave = pList.pSave;
elseif i(1) == 0
    display('Cut and paste data path here')
    pData = input(': ','s');
elseif i(2) == 0
    display('Cut and paste save path here')
    pSave = input(': ','s');  
end

%% search database
[A] = MWTDataBase_searchAll(pData);
%%

%%
groupnames = unique(A.foldername(regexpcellout(A.type,'Group'),:));
expnames = unique(A.foldername(regexpcellout(A.type,'Exp'),:));
mwtnames = unique(A.foldername(regexpcellout(A.type,'MWT'),:));
mwtnamesval = unique(A.foldername(regexpcellout(A.type,'MWT\>'),:));
analysisnames = unique(A.foldername(regexpcellout(A.type,'Matlab'),:));

%% get only mwt folders
B = A(regexpcellout(A.type,'MWT'),:);
display(sprintf('%d MWT folders found',size(B,1)));


%% make summary
T = table;
T.Experiment = B.expfolder;
    expn = char(T.Experiment);
T.ExpDate = expn(:,1:8);
T.Tracker = expn(:,9:9);
T.Expter = expn(:,11:12);
T.ExpDescription = cell(size(T.Experiment));
  a = celltakeout(regexp(T.Experiment,'_'),'multirow');
  c = zeros(size(a));
  for x = 1:size(a,1)
    b = a{x,1};
    if numel(b) >2 
        c(x) = b(3);
        T.ExpDescription{x,1} = expn(x,b(3)+1:end);
    end
  end

a = regexpcellout(T.Experiment,'_','split');    
T.runcond = char(a(:,3));
T.MWTfolder = B.foldername;
T.Group = B.groupfolder;
    a = regexpcellout(T.Group,'_','split');
T.strain = a(:,1);
T.ExpCond = char(cellfun(@regexprep,T.Group,T.strain,...
    cellfunexpr(T.Group,''),'UniformOutput',0));


% write table
tablename = ['MWTDatabaseSummary_',generatetimestamp,'.csv'];
cd(pSave); writetable(T,...
    tablename,'Delimiter','\t');
display(sprintf('saving %s to pSave:',tablename));
disp(pSave);



















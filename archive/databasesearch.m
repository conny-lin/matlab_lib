function [MWTDatabase,A] = databasesearch(Home)
%% create database
% Group Data base require to run Stage option NameGroups
%% get info
[pExpV,Expfn,pGp,Gpn,pMWTf,MWTfn,MWTfsn] = getMWTpathsNname(Home,'noshow');
[allpaths] = getalldir(Home);
[ph,fn] = cellfun(@fileparts,allpaths,'UniformOutput',0); % get filename of all paths

%% [suspend] define Group folders [might be too personal] 
% % format defined as 'a_N2_400mM'
% nonexpfolder = setdiff(fn,Expfn); % not experiment foldres
% notMWTfolder = setdiff(nonexpfolder,MWTfn); % not MWT folders
% [~,hn] = fileparts(Home); 
% noHome = setdiff(notMWTfolder,hn); % not input folder
% nodatefolder = noHome(cellfun(@isempty,regexp(noHome,'(\d{8})'))); %not a date folder
% noempty = nodatefolder(not(cellfun(@isempty,nodatefolder))); % not empty folder
% 
% % parse group code
% groupfolder = noempty;
% s = regexp(noempty,'_','split');
% a = celltakeout(s,'split');
% groupcode = a(:,1);
% s = regexp(noempty,'^[a-z]_','split');
% a = celltakeout(s,'split');
% groupname = a(:,2);
% groupinfo = [groupcode groupname];
% % reporting
% unique(groupname)

%% create database 
% Group database: using premade Groups_.mat files
% import group folders
groupfilename = {}; groupfilepath = {}; gfn = {}; gfp = {};
[ph,fn] = cellfun(@fileparts,allpaths,'UniformOutput',0); 

for x = 1:numel(pExpV);
    pLook = [pExpV{x},'/','MatlabAnalysis'];
    [gn,pg] = dircontentext(pExpV{x},'Groups_1Set*');
    if isempty(gn) ==1; gn = {''}; pg = {''}; end
    gfn = [gfn;gn(1)]; gfp = [gfp;pg(1)];
end
gfn'
%%
for x = 1:numel(pExpV);
    load(gfp{x},'Groups'); [expname] = cellfunexpr(Groups,Expfn{x});
    info = [expname Groups]; GroupDataBase = [GroupDataBase;info]; 
end
MWTDatabase.GroupDataBase = GroupDataBase;

%% create exp database
expnamelist = Expfn;
a = celltakeout(regexp(expnamelist,'_','split'),'split');
b = celltakeout(regexp(a(:,1),'(\d{8})','split'),'split');
tracker = b(:,2);
b = celltakeout(regexp(a(:,1),'[A-Z]','split'),'split');
expdate = b(:,1); expter = a(:,2);runcon = a(:,3);
expinfo = [expdate,tracker,expter,runcon];
MWTDatabase.Experiments = expinfo;
cd(Home); save('MWTDatabase.mat','MWTDatabase');

%% Database search --------------------
view = input('Do you want to view the database before searching (y=1,n=0,enter=abort)? ');
if view==0;
    display 'Group Names:'; disp(unique(GroupDataBase(:,3)));
    display 'Experiment run conditions: '; disp(unique(runcon));  
elseif isempty(view)==1; return; 
end
search = input('Enter search word: ','s');
% search in group name
groupname= GroupDataBase(:,3);
k = not(cellfun(@isempty,regexp(groupname,search)));
expqurey = unique(GroupDataBase(k,1));
str ='[%d] experiment has group name [%s]';
display(sprintf(str,numel(expqurey),search));
% create output
i = ismember(expqurey,Expfn); pExpM = pExpV(matchexp);
A.ExpinfoG = [pExpM,Expfn];

%% analyzing recovery taps
i = not(cellfun(@isempty,regexp(runcon,search)));
str = 'found [%d] experiments for runcondition [%s]';
display(sprintf(str,sum(i),search));
disp(expnamelist(i));
disp(pExpV(i));
A.pExpR = pExpV(i);
A.ExpfnR = expnamelist(i);

%% find MWT matches
[noshow] = cellfunexpr(pExpV(i),'noshow');
[~,~,~,~,pMWTf,MWTfn,MWTfsn] = cellfun(@getMWTpathsNname,pExpV(i),noshow,...
'UniformOutput',0);
[pMWT] = celltakeout(pMWTf,'multirow');
A.MWTinfoR = [pMWTf,MWTfn,MWTfsn];
A.ExpinfoR = [pExpV(i) Expfn(i)];


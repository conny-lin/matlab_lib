%% Embryonic exposure ET55 F1-3 data processing

%% SCRIPT DEFINITION
ProjectName = 'Embryonic Exposure';
Datafilename = 'ET55F1F3RawData';

%% PATH
pFunD = '/Users/connylin/Documents/MATLAB/Functions_Developer';
addpath(pFunD);
[p] = PathCommonList;

% project scripts path
pScpt = [p.pML,'/Projects_RankinLab/Embryonic Exposure'];

% data path
a = [p.RL.pProjA,'/Lab Project Embryonic Exposure'];
a = [a,'/EE Dose Titration 55 Physical/Data'];
pD = [a,'/DataRaw Summary'];

%% MANUAL PROCESSING
%1) cd(pD);
cd(pD);
%2) double click on excel file to import selected sheet
%3) import as table






%% PROCESS: expcode
ET55_import1;
% change varname
newname = 'expcode';
varname = 'ET55F1F3RawData';
if exist(varname,'var') ==1
    str = [newname,'=',varname,';'];
    eval(str); eval(['clearvars ',varname]);
end
% standardize groupcode varnames
tablename = 'expcode';
newname = 'groupcode';      
varnames = '\<ID\>'; % names to be changed from
eval(['D = ',tablename,';']);
v = D.Properties.VariableNames;
D.Properties.VariableNames = regexprep(v,varnames,newname);
eval([tablename,'=D;']);


% get groupcode list
tablename = 'expcode';
parname = 'group';
eval(['D = ',tablename,';']);
Parameter.(parname) = ...
    table(D.groupcode,D.groupname,...
    'VariableNames',{'groupcode','groupname'});


%% PROCESS: exprecord
% % change var name
% newname = 'exprecord';
% varname = 'ET55F1F3RawDataS1';
% if exist(varname,'var') ==1
%     str = [newname,'=',varname,';'];
%     eval(str); eval(['clearvars ',varname]);
% end
% 
% % get variable lists (measure, age, generation)
% types = exprecord(:,1);
% types(ismember(types,Parameter.group.groupname)) = [];
% types(ismember(types,{'groupname'})) = [];
% for x = 1:numel(types)
%     varnames = unique(exprecord(x,:));
%     varnames(ismember(varnames,{'',types{x}})) = [];
%     Parameter.(types{x}) = varnames;
% end
% Parameter.age(ismember(Parameter.age,{'65h+','d1+'})) = [];

% age parameter
Parameter.age  = {'d1','d2','d3','d4','d5','d6'};
Parameter.generation  = {'F1','F2','F3'};
Parameter.measures = {'HR','WS','RO','LS'};

%% make RO, HR, LS
a = Parameter.measures;
a(ismember(a,{'WS','HR'})) = [];
b = Parameter.generation;
c = repmat(b,1,numel(a));
A = [];
for x = 1:numel(a)
    d = repmat(a(x),1,numel(b));
    A = [A,d];
end
A = A';
c = c';
e = repmat({'_'},numel(A),1);
measure = strcat(A,e,c);

% make WS
str = {'WS'};
b = Parameter.generation;
c = sortrows(Parameter.age);
i = numel(b)*numel(c);
a = repmat(str,i,1);
e = repmat({'_'},i,1);
cc = repmat(c,1,i/numel(c))';
B = [];
for x = 1:numel(b)
    d = repmat(b(x),1,numel(c));
    B = [B,d];
end
% combine WS and RO,HR,LS
measure = [measure;strcat(a,e,B',e,cc)];

% make HR
str = {'HR'};
b = Parameter.generation;
c = sortrows(Parameter.age);
i = numel(b)*numel(c);
a = repmat(str,i,1);
e = repmat({'_'},i,1);
cc = repmat(c,1,i/numel(c))';
B = [];
for x = 1:numel(b)
    d = repmat(b(x),1,numel(c));
    B = [B,d];
end
measure = [measure;strcat(a,e,B',e,cc)];


Parameter.measurelist = measure';

% construct exprecord table
A = cell(numel(Parameter.group.groupname),numel(Parameter.measurelist)+1);
A = cell2table(A);
A.Properties.VariableNames = [{'groupname'},Parameter.measurelist];
A.groupname = char(Parameter.group.groupname);
exprecord = A;


%% PROCESS: WSF1d1
% change varname
newname = 'WSF1d1';
varname = 'ET55F1F3RawDataS4';
if exist(varname,'var') ==1
    str = [newname,'=',varname,';'];
    eval(str); eval(['clearvars ',varname]);
end
% standardize groupcode varnames
tablename = 'WSF1d1';
datavarname = 'WS_F1_d1';
newname = 'groupcode';      
varnames = '(\<ID\>)'; % names to be changed from
eval(['D = ',tablename,';']);
v = D.Properties.VariableNames;
D.Properties.VariableNames = regexprep(v,varnames,newname);
eval([tablename,'=D;']);
% record data source to exprecord
i = unique(D.groupcode);
a = cellstr(repmat(tablename,numel(i),1));
exprecord.(datavarname)(i) = a;


%% PROCESS: WSF1d2
% change varname
newname = 'WSF1d2';
varname = 'ET55F1F3RawDataS5';
if exist(varname,'var') ==1
    str = [newname,'=',varname,';'];
    eval(str); eval(['clearvars ',varname]);
end
% standardize groupcode varnames
tablename = newname;
datavarname = 'WS_F1_d2';
newname = 'groupcode';      
varnames = '(\<ID\>)'; % names to be changed from
eval(['D = ',tablename,';']);
v = D.Properties.VariableNames;
D.Properties.VariableNames = regexprep(v,varnames,newname);
eval([tablename,'=D;']);
% record data source to exprecord
i = unique(D.groupcode);
a = cellstr(repmat(tablename,numel(i),1));
exprecord.(datavarname)(i) = a;


%% PROCESS: WSF1d4
% custom inputs
newname = 'WSF1d4';
datavarname = 'WS_F1_d4';
varname = 'ET55F1F3RawDataS6';

% change varname
if exist(varname,'var') ==1
    str = [newname,'=',varname,';'];
    eval(str); eval(['clearvars ',varname]);
end
% standardize groupcode varnames
tablename = newname;
newname = 'groupcode';      
varnames = '(\<ID\>)'; % names to be changed from
eval(['D = ',tablename,';']);
v = D.Properties.VariableNames;
D.Properties.VariableNames = regexprep(v,varnames,newname);
eval([tablename,'=D;']);
% record data source to exprecord
i = unique(D.groupcode);
a = cellstr(repmat(tablename,numel(i),1));
exprecord.(datavarname)(i) = a;


%% PROCESS: WSF2d2
% custom inputs
newname = 'WSF2d2';
datavarname = 'WS_F2_d2';
varname = 'ET55F1F3RawDataS8';
% change varname
if exist(varname,'var') ==1
    str = [newname,'=',varname,';'];
    eval(str); eval(['clearvars ',varname]);
end
% standardize groupcode varnames
tablename = newname;
newname = 'groupcode';      
varnames = '(\<ID\>)'; % names to be changed from
eval(['D = ',tablename,';']);
v = D.Properties.VariableNames;
D.Properties.VariableNames = regexprep(v,varnames,newname);
eval([tablename,'=D;']);
% record data source to exprecord
i = unique(D.groupcode);
a = cellstr(repmat(tablename,numel(i),1));
exprecord.(datavarname)(i) = a;


%% PROCESS: WSF3d2
% custom inputs
newname = 'WSF3d2';
datavarname = 'WS_F3_d2';
varname = 'ET55F1F3RawDataS9';
% change varname
if exist(varname,'var') ==1
    str = [newname,'=',varname,';'];
    eval(str); eval(['clearvars ',varname]);
end
% standardize groupcode varnames
tablename = newname;
newname = 'groupcode';      
varnames = '(\<ID\>)'; % names to be changed from
eval(['D = ',tablename,';']);
v = D.Properties.VariableNames;
D.Properties.VariableNames = regexprep(v,varnames,newname);
eval([tablename,'=D;']);
% record data source to exprecord
i = unique(D.groupcode);
a = cellstr(repmat(tablename,numel(i),1));
exprecord.(datavarname)(i) = a;


%% PROCESS: HRF123
% custom inputs
tablename = 'HR';
varname = 'ET55F1F3RawDataS2';
% change varname
if exist(varname,'var') ==1
    str = [tablename,'=',varname,';'];
    eval(str); eval(['clearvars ',varname]);
end
% standardize groupcode varnames
newname = 'groupcode';      
varnames = '(\<ID\>)'; % names to be changed from
eval(['D = ',tablename,';']);
v = D.Properties.VariableNames;
D.Properties.VariableNames = regexprep(v,varnames,newname);
eval([tablename,'=D;']);


% correct varnames in table
D = HR;
a = HR.Properties.VariableNames;
b = Parameter.generation;
for x = 1:numel(b)
    a = regexprep(a',b{x},[b{x},'_']);
end
% remove non-measure variables
i = ~ismember(a,{'VarName5','groupcode','durationmins','timing',...
    'timingcode','expname'});
% a(i) = [];
% add HR in front of them
e = cellstr(repmat('_',numel(a(i)),1));
b = strcat(cellstr(repmat(tablename,numel(a(i)),1)),e);
c = strcat(b,a(i));
% replace varname in table
HR.Properties.VariableNames(i) = c;


varno = {'VarName5','groupcode','durationmins','timing',...
    'timingcode','expname'};
datanames = HR.Properties.VariableNames;
datanames = datanames(~ismember(datanames,varno));
HR.Properties.VariableNames{1} = 'groupcode';

% enter record to varname on list
measures = Parameter.measurelist;
i = find(ismember(datanames,measures));
gc = HR.groupcode;

for x = 1:numel(i)
    mn = (datanames{i(x)});
    d = HR.(mn);
    k = gc(find(~isnan(d)));
    exprecord.(mn)(k) = {tablename};
end


%% PROCESS: RO






























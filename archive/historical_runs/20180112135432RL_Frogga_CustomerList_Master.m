%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pData = '/Users/connylin/Dropbox/CA/FroggaBio/Customer/Customer List/Source data';
load(fullfile(pData,'CustomerList.mat'));

%% EXTRACT FROM EACH LIST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TM = table; % master table;

% master list
T = extract_info_from_list(MasterList,{'Leads','Model','Researchfocus','Notes'});
TM = [TM;T];

% Contacts1botanyzoology
A = Contacts1botanyzoology;
A.Institution = repmat({'UBC'},size(A,1),1);
A.Building = repmat({'Botany Zoology'},size(A,1),1);
A.Room = repmat({''},size(A,1),1);
A.Address = repmat({''},size(A,1),1);
A.City = repmat({'Vancouver'},size(A,1),1);
T = extract_info_from_list(A,{'Notes'});
TM = [TM;T];

% Contacts2Wes
A = Contacts2Wes;
T = table;
T.Institution = A.Institution;
T.Building = repmat({''},size(A,1),1);
T.Room = repmat({''},size(A,1),1);
T.PI = repmat({''},size(A,1),1);
T.Name = strjoinrows(A(:,{'FirstName','LastName'}),' ');
T.Email = A.Email;
T.Phone = A.Phone;
T.Address = A.Address;
T.City = A.PrimaryCity;
T.Notes = repmat({''},size(A,1),1);
TM = [TM;T];

% Contacts3James
A = Contacts3James;
T = table;
T.Institution = A.Institution;
T.Building = A.Building;
T.Room = A.Room;
T.PI = A.PI;
T.Name = A.Labcontact;
T.Email = A.Email;
T.Phone = A.Phone;
T.Address = A.Address;
T.City = A.City;
T.Notes = repmat({''},size(A,1),1);
TM = [TM;T];


% customersBC
A = customersBC;
T = table;
T.Institution = repmat({''},size(A,1),1);
T.Building = repmat({''},size(A,1),1);
T.Room = repmat({''},size(A,1),1);
T.PI = repmat({''},size(A,1),1);
a = A.Name;
a = regexprep(a,'Mr\s{1}|Ms\s{1}|Dr\s{1}','');
T.Name = a;
T.Email = A.Email;
T.Phone = repmat({''},size(A,1),1);
T.Address = repmat({''},size(A,1),1);
T.City = repmat({''},size(A,1),1);
T.Notes = repmat({''},size(A,1),1);
TM = [TM;T];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Make sure format consistent %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varnames = TM.Properties.VariableNames;
for vi = 1:numel(varnames)
    vn = varnames{vi};
    % blank cells
    i = cellfun(@isempty,TM.(vn));
    TM.(vn)(i) = {''};
    
    % no numeric
    a = TM.(vn);
    i =cellfun(@isnumeric,a);
    b = a(i);
    a(i) = cellfun(@num2str,b,'UniformOutput',0);
    TM.(vn) = a;
 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% adjust PI name %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = TM.PI;
% get rid of ones with comma
a(~cellfun(@isempty,regexp(a,','))) = {''};
% remove wasteful words
a = regexprep(a,'\s{1}Lab|\s{1}Labs|\s{1}lab|^Dr\s|^Dr[.]\s|^Mr|^Mr[.]|^Attn[:]\s{1}|^Lab[-]|Group|&','');
% remove initial characters
a = regexprep(a,'^[.]|^[.]\s|^[A-Z]{1}[.]{1}\s{1}|^\s{1}','');
% get rid of Van xxx
a(~cellfun(@isempty,regexp(a,'^Van\s{1}'))) = {''};
% replace teaching labs to teaching lab
a(~cellfun(@isempty,regexp(a,'^Teaching'))) = {'Teaching Lab'};
% remove T. 
a = regexprep(a,'T[.]','');
% remove brackets 
a = regexprep(a,'[(].{1,}[)]','');
% get rid of one word
b = regexpcellout(a,'\s|[-]','split');
n = sum(~cellfun(@isempty,b),2);
a(n==1) = {''};
% get last name
b = regexpcellout(a,'\s','split');
b = b(:,2);
i = ~cellfun(@isempty,b);
a(i) = b(i);
% get PI name
TM.PI = a;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clean - Institute  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = TM.Institute;
unique(a)

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clean - Building  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clean - Room  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clean - Name  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clean - Email  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clean - Phone  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% merge %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% selectively keep duplicate names
% make sure all names are cell arrays

varname = 'Name';
D = TM;
A = D.(varname);
B = tabulate(A);
dupnames = B(cell2mat(B(:,2))>1,1);
dupind = false(size(A,1),1);
for ai = 1:numel(dupnames)
   cn = dupnames(ai);
   i = ismember(D.(varname),cn);
   i = find(i);
   E = D(i,:);
   % merge information
   vn = E.Properties.VariableNames';
   for vi = 1:numel(vn)
      a = E.(vn{vi});
      a(cellfun(@isempty,a)) = [];
      a(cellfun(@isnumeric,a)) = [];
      a = unique(a);
      if numel(a) ==1
          E.(vn{vi}) = repmat(a,size(E,1),1);
      end
   end
   
   % see if still duplicated
   a = unique(E,'rows');
   if size(a,1)==1
       dupind(i(2:end)) = true;
       fprintf('delete merged duplicate\n');
   else
       % choose information
       n = (1:size(E,1))';
       E1 = table;
       E1.N = n;
       disp([E1 E])
       opt = input('choose #(s) to delete: ','s');
       a = regexp(opt,'\s','split')';
       opt = cellfun(@str2num,a);
       d = i(ismember(n,opt));
       sure =input('are you sure to delete: (1=y,2=keep all, 0=stop): ');
       if sure==0
           display('quit');
           return
       else
           % mark delete
           dupind(d) = true;
       end
   end
end
%%
TM(dupind,:)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% remove duplicates

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




















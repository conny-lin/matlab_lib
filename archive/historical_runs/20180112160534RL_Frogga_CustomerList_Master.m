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

%% Clean - Institute  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cross column fix or delete
a = TM.Institution;
TM(ismember(a,{'University of Lethbridge','University of Calgary','University of Alberta','Calgary Laboratory Services','Alberta Health Services'}),:) = []; 

i = ismember(a,{'University of British Columbia; Centre For Hip Health & Mobility'});
TM.Institution(i) = {'UBC'};
TM.Building(i) = {'Centre For Hip Health & Mobility'};

i = regexpcellout(a,'University of British Columbia, Life Sciences Centre');
TM.Institution(i) = {'UBC'};
TM.Building(i) = {'LSI'};

i = regexpcellout(a,'University of British Columbia, Faculty of Pharmaceutical Sciences');
TM.Institution(i) = {'UBC'};
TM.Building(i) = {'Pharmaceutical'};

i = ismember(a,{'University of British Columbia, CMMT','University of British Columbia, CFRI'});
TM.Institution(i) = {'UBC'};
TM.Building(i) = {'CMMT'};

i = ismember(a,{'UVic GBC Proteomics Centre'});
TM.Institution(i) = {'UVic'};
TM.Building(i) = {'Proteomics Centre'};

i = ismember(a,{'St.Paul''s HospitalBC'});
TM.Institution(i) = {'UBC'};
TM.Building(i) = {'St Paul'};

i = ismember(a,{'Simon Fraser University, Faculty of Health Sciences'});
TM.Institution(i) = {'SFU'};
TM.Building(i) = {'Health Sciences'};

i = ismember(a,{'Simon Fraser University, Department of Archaeology'});
TM.Institution(i) = {'SFU'};
TM.Building(i) = {'Archaeology'};

i = ismember(a,{'Jack Bell Res.Ctr'});
TM.Institution(i) = {'UBC'};
TM.Building(i) = {'Jack Bell'};

i = ismember(a,{'Health Canada, BC Food Laboratory'});
TM.Institution(i) = {'Health Canada'};
TM.Building(i) = {'BC Food Laboratory'};

i = ismember(a,{'Agriculture Canada (Summerland)','Agri Food Summerland'});
TM.Institution(i) = {'Agriculture and Agri-Food Canada'};
TM.Building(i) = {'Summerland'};

i = ismember(a,{'Agriculture Canada (Agassiz)'});
TM.Institution(i) = {'Agriculture and Agri-Food Canada'};
TM.Building(i) = {'Agassiz'};


% merge
a = TM.Institution;
a = regexprep(a,'^\s{1,}','');
a = regexprep(a,'4D Labs','SFU');
a = regexprep(a,'iProgen Biotech Inc.','iProgen');
a(regexpcellout(a,'@')) = {''};
a(ismember(a,{'University of Victoria','University of Victoria,','Univ. of Victoria BC'})) = {'UVic'};
a = regexprep(a,'Vancouver Island Univesity','VIU');
a = regexprep(a,'University of the Fraser Valley','UFV');
a = regexprep(a,'University of Northern BC|Uni Northern BC','UNBC');
a = regexprep(a,'University of British Columbia, Okanagan','UBCO');
a = regexprep(a,'Trinity Western University','TWU');
a = regexprep(a,'Vancouver Community College','VCC');
a = regexprep(a,'University of British Columbia','UBC');
a(ismember(a,{'Thomas Rivers Uni'})) = {'TRU'};
a(ismember(a,{'Sun Rype Products'})) = {'Sun Rype'};
a(ismember(a,{'StemCell Techn'})) = {'Stemcell Technologies'};
a(ismember(a,{'Simon Fraser University','Simon Fraser Univ.','Simon Fraser Lab'})) = {'SFU'};
a(ismember(a,{'Natural Resources Canada, Canadian Forest Service','Natural Res.'})) = {'Natural Resources Canada'};
a(ismember(a,{'Deeley Res. Ctr'})) = {'Deeley Research Centre'};
a(ismember(a,{'Child and Family Research Institute','Centre for Molecular Medicine and Therapeutics (CMMT)'})) = {'CMMT'};
a(ismember(a,{'Centre for Drug Research and Development'})) = {'CDRD'};
a(ismember(a,{'Canadian Blood Services ','Canadian Blood Serv'})) = {'Canadian Blood Services'};
a(ismember(a,{'BC Cancer Res.Centre','BC Cancer'})) = {'BC Cancer Research Centre'};
a(ismember(a,{'Augurex Life Sciences Corp. '})) = {'Augurex Life Sciences Corp.'};
a(ismember(a,{'Applied Biological M','App.Biol.Mat.'})) = {'Applied Biological Materials'};
a(ismember(a,{'Amgen BC'})) = {'Amgen'};
a(ismember(a,{'Agriculture & Agri Food canada','Agriculture & Agri Food Canada','AgriFood BC'})) = {'Agriculture and Agri-Food Canada'};

TM.Institution = a;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Clean - Building  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = TM.Building;

i = ismember(a,{'Vancouver Island Univesity'});
TM.Institution(i) = {'VIU'};
TM.Building(i) = {''};


a = TM.Building;
a(ismember(a,{'University of Victoria','University of Bristish Columbia-Okanagan Campus','University of Northern British Columbia','iProgen Biotech inc.'})) = {''};
a(ismember(a,{'Vancouver Prostate Centre'})) = {'Jack Bell'};
a(ismember(a,{'University of British Columbia-St Paul''s Hospital'})) = {'St Paul'};
a(ismember(a,{'University of British Columbia-Pharmaceutical Sciences'})) = {'Pharmaceutical'};
a(ismember(a,{'University of British Columbia-Dr. Brain Ellis Lab'})) = {'MSL'};
a(ismember(a,{'University of British COlumbia','University of British Colombia','University of British Columbia','University of British Colombia '})) = {''};
a(ismember(a,{'University of British Columbia-BCCRC'})) = {'BC Cancer'};
a(ismember(a,{'University of British Columbia US$'})) = {''};
a(ismember(a,{'Thompson Rivers University'})) = {''};
a(ismember(a,{'TASC II'})) = {'TASC2'};
a(ismember(a,{'St Pauls'})) = {'St Paul'};
a(ismember(a,{'Spinal Cord'})) = {'ICORD'};
a(ismember(a,{'Simon Fraser University, Faculty of Health Sciences'})) = {'Health Sciences'};
a(ismember(a,{'Simon Fraser University, Department of Archaeology'})) = {'Archaeology'};
a(ismember(a,{'Sci'})) = {'Science'};
a(ismember(a,{'Pharmacology','Pharmacy'})) = {'Pharmaceutical'};
a(ismember(a,{'Simon Fraser University'})) = {''};
a(ismember(a,{'Quest University Canada'})) = {''};
a(ismember(a,{'Protein centre'})) = {'Proteomics Centre'};
a(ismember(a,{'PHSA-Cancer Research Centre'})) = {'Cancer Research Centre'};
a(ismember(a,{'Natural Resources Canada, Canadian Forest Service'})) = {'Canadian Forest Service'};
a(ismember(a,{'McGavin'})) = {'MCML'};
a(ismember(a,{'Hospital','British Columbia Institute of Technology'})) = {''};
a(ismember(a,{'GIP account'})) = {''};
a(ismember(a,{'FIP'})) = {'FIPKE'};
a(ismember(a,{'FHN'})) = {'FNH'};
a(ismember(a,{'Children''s & Women''s Health Centre BC','CMMT-University of British COlumbia','CMMT-University of British Columbia'})) = {'CMMT'};
a(ismember(a,{'Cancer Research'})) = {'Cancer Research Centre'};
a(ismember(a,{'Botany Zoology'})) = {'Botany/Zoology'};
a(ismember(a,{'Biology'})) = {'Shrum Science Centre'};
a(ismember(a,{'Blusson Spinal Cord Centre'})) = {'ICORD'};
a(ismember(a,{'BCCDC Site-BC Centre for Disease Control'})) = {'BCCDC'};
a(ismember(a,{'BC Cancer Agency Research Centre','BC Cancer','BC Cancer Research Centre'})) = {'BCCRC'};
a(ismember(a,{'BC Geome Centre (Ash/7th)','BC Cancer Agency - Genome Research Centre'})) = {'BCGRC'};

TM.Building = a;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clean - Room  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = TM.Room;
TM.Room = regexprep(a,'^Room |^Rm|^Room: |^\s{1} |Room|Rm','');

% extract number
a = TM.Room;
n = regexpcellout(a,'[0-9]{1,}','match');
nblank = regexprep(a,'[0-9]{1,}','');
roomnum = n(:,1);
TM.Room = roomnum;

% add the rest to notes
TM.Notes = strjoinrows([TM.Notes nblank],' ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clean - PI name %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%% Clean - Name  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% delete irrelevant
TM.Name(ismember(TM.Name,{'prof office','prof','test test','undergrad office'})) = {''};
a = TM.Name;
% take care of ones with emails
i = regexpcellout(a,'@');
TM.Email(i) = TM.Name(i);
TM.Name(i) = {''};

a = TM.Name;
a = regexprep(a,'^Miss |^Mr |Dr[.] |^Dr ','');

TM.Name = a;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clean - Email  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clean - Phone  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = TM.Phone;
a = regexprep(a,'^\s{1}|#ERROR!','');
a(ismember(a,{'(knows Fred)'})) = {''};
a(cellfun(@isempty,regexp(a,'^[0-9]|[(]'))) = {''};
TM.Phone = a;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clean - notes  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = TM.Notes;
a = regexprep(a,'^\s{1,}','');
TM.Notes = a;
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
for ai = 33:numel(dupnames)
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
   
   
end

return
%%
% see if still duplicated

for ai = 33:numel(dupnames)
   cn = dupnames(ai);
   i = ismember(D.(varname),cn);
   i = find(i);
   E = D(i,:);
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
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dupind_record(dupind == true) = true;


% remove duplicates

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




















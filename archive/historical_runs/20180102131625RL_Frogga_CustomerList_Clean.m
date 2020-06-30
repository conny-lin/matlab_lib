%% CLEAN CUSTOMER LIST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SHARED VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pHome = '/Users/connylin/Dropbox/CA/FroggaBio/Customer List';
fnameData = 'Frogga_CustomerList_Convert2James';
pData = fullfile(pHome,fnameData);
% get customer list
[fcustomerlist,pcustomerlist] = dircontent(pData,'*csv');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLEAN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ci = 1:numel(fcustomerlist)
    filename = fcustomerlist{ci};
    fprintf('\n* evaluating file %s\n',filename);
    D = importfile_jamesconv(filename);
    % rid of dr and lab
    varname = 'PI';
    a = D.(varname);
    a = regexprep(a,'Dr[.]\s|Lab','');
    a = regexprep(a,'[A-Z]{1}[.]\s','');
    % exclude duplicates
    A = D(:,{'Labcontact','Email','Phone'});
    [C,ia] = unique(A,'rows');
    D = D(ia,:);
    DSave = D;
    % selectively keep duplicate names
    A = table2cell(D(:,{'Labcontact'}));
    B = tabulate(A);
    dupnames = B(cell2mat(B(:,2))>1,1);
    for ai = 1:numel(dupnames)
       cn = dupnames(ai);
       i = ismember(D.Labcontact,cn);
       i = find(i);
       E = D(i,:);
       % merge information
       vn = E.Properties.VariableNames';
       for vi = 1:numel(vn)
          a = E.(vn{vi});
          a = unique(a);
          a(cellfun(@isempty,a)) = [];
          if numel(a) ==1
              E.(vn{vi}) = repmat(a,size(E,1),1);
          end
       end
       %% see if still duplicated
       a = unique(E,'rows');
       if size(a,1)==1
           D(i(2:end),:) = []; % keep the first and delet the rest
       else
           % choose information
           n = (1:size(E,1))';
           E1 = table;
           E1.N = n;
           disp([E1 E])
           opt = input('choose option(s): ','s');
           a = regexp(opt,'\s','split')';
           opt = cellfun(@str2num,a);
           d = i(ismember(n,opt));
    %        disp(D(d,:))
           sure =input('are you sure to delete: (1=y,2=keep all, 0=stop): ');
           if sure==0
               display('quit');
               return
           else
               % delete
               D(d,:) = [];
           end
       end
    end
    
    savepath = fullfile(pM,filename);
    writetable(D,savepath);
    fprintf('\n* save file %s\n',filename);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function expter_add(pFunD,pFun,pPF)
%% create personal folders
addpath(genpath(pFunD));
load('expter.mat');
display(expter);        
%% user input
name = input('type in full name of new expter: ','s');
name = strrep(name,' ','_');
if sum(strncmp(name,expter(1:end-1,1),2))~=0; % check if this name already exits
    display('expter name already exists...');
    return
end
expter(end+1,1) = {name};
%% automatically assign name code
i = strfind(name,'_');
name3 = strcat(name(1),name(i+1)); % cat initials
while sum(strncmp(name3,expter(1:end-1,2),2))~=0;
    display(sprintf('Initials %s already taken...',name3));
    name3 = input('Enter manually assigned 2 capital letter initials (i.e. BM): ','s'); 
end
expter(end,2) = {name3};


%% create folder if there is none
cd(pPF);
p = strcat(pPF,'/',expter{end,1}); % create path pPF
if isdir(p) ==0; % check if is dir
    mkdir(expter{end,1});
end

%% update expter.mat
expter = sortrows(expter,1);
%%
cd(pFun);
save('expter.mat','expter');
cd(pFunD);
save('expter.mat','expter');


%% reporting
display(sprintf('experimenter code for %s is...',name));
disp(name3);


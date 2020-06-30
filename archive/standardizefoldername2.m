function [pExpStdSave,pExpStd,pRaw,pRawC,pRawCExp,expname] = standardizefoldername2(pFun,pExp)
display('Standardizing experiment folder name...');
[expname] = findstadexpfoldername(pExp,pFun);% standardize folder name: 20130528B_DH_100s30x10s10s
[pExpter,Expterfname] = fileparts(pExp); % find home path of pExp


%% create paths and folders
% create standardized exp name folder
if isequal(expname,Expterfname) ==0; % check if original pExp name is incorrect
    cd(pExpter);
    mkdir(expname); % make new folder
end

[pRaw,pRawC,~] = definepath4diffcomputers(pFun); % get standard paths
% path to Conny's folder
pRawCExp = strcat(pRawC,'/',expname);
cd(pRawC);
mkdir(expname);

% path to analysis name folder
[analysisnamedate] = creatematsavenamewdate('_ShaneSpark_','');
pExpStd = strcat(pExpter,'/',expname);

% [suspended] path to analysis folder
%pExpStdSave = strcat(pExpStd,'/',analysissavename);

%% save original names
cd(pExpStd);
mkdir(analysisnamedate);
str = Expterfname;                 %# A string
fName = strcat('OriginalExpName_',expname,'.txt');         %# A file name
fid = fopen(fName,'w');            %# Open the file
if fid ~= -1
  fprintf(fid,'%s\r\n',str);       %# Print the string
  fclose(fid);                     %# Close the file
end
cd(pRawCExp);
fid = fopen(fName,'w');            %# Open the file
if fid ~= -1
  fprintf(fid,'%s\r\n',str);       %# Print the string
  fclose(fid);                     %# Close the file
end
display('done');
end
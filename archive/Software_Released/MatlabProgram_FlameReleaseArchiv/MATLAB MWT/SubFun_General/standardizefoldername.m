function [pAExp,pExpS,pRaw,pRawC,pRawCExp,expname,analysissavename] = standardizefoldername(pFun,pExp)
display('Standardizing experiment folder name...');
[expname] = findstadexpfoldername(pExp,pFun);% standardize folder name: 20130528B_DH_100s30x10s10s
[pExpter,Expterfname] = fileparts(pExp); % find home path of pExp
%% create paths and folders
ID = 1; % suspend
switch ID
    case 0
        if isequal(expname,Expterfname) ==0; % check if original pExp name is incorrect
            cd(pExpter);
            mkdir(expname); % make new folder
        end
    case 1
end

[pRaw,pRawC,~] = definepath4diffcomputers(pFun);
pRawCExp = strcat(pRawC,'/',expname);
cd(pRawC);
mkdir(expname);
pExpS = strcat(pExpter,'/',expname);
[analysissavename] = creatematsavenamewdate('_Analysis_ShaneSpark_','');
pAExp = strcat(pExpter,'/',expname,analysissavename);
cd(pExpter);
mkdir(pAExp);
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
function MWTorgfiles2(pFun,pExp)
%%  MWTorgfiles(pFun,pExp)
% Transfer raw files from MWT computer and prepare for Beethoven analysis
% Conny Lin. start 2013 July 3. Completed: 20130709 9:46am
% zip files is ok...
%% [UPDATE REQUIRED: 
% Correct other parts of MWTname
% ASSIGN GROUP NAME AUTO

%% warning message
display('This program only works with ungrouped MWT files...');
display('Please enter(1) to stop the program if your data is grouped,');
t1 = input('otherwise, enter any key to continue: ');
if t1 ==1;
    return
end

%% generate path to set functions
addpath(pFun); % generate path for modules

%% check if zipped, if so, unzip all
[MWTf,pMWTf] = dircontentext(pExp,'*.zip');
if isempty(MWTf) ==0; % if there is zip files
    display('unzipping files, please wait...');
    for x = 1:size(MWTf,1);
        [pH,~] = fileparts(pMWTf{x,1}); % get home path
        unzip(MWTf{x,1},pH); % unzip them all
        delete(pMWTf{x,1}); % delete zip files
    end
end



%% standardize folder name
[expname] = findstadexpfoldername(pExp,pFun);% standardize folder name: 20130528B_DH_100s30x10s10s
[pExpter,Expterfname] = fileparts(pExp); % find home path of pExp
if isequal(expname,Expterfname) ==0; % check if original pExp name is incorrect
    % Transfer files
    cd(pExpter);
    mkdir(expname); % make new folder
end
% create paths
[pRaw,pRawC] = definepath4diffcomputers(pFun);
pRawExp = strcat(pRaw,'/',expname); 
cd(pRaw);
mkdir(expname);
% store original file name
pExpStd = strcat(pExpter,'/',expname);
cd(pExpStd); 
str = Expterfname;                 %# A string
fName = strcat('OriginalExpName_',expname,'.txt');         %# A file name
fid = fopen(fName,'w');            %# Open the file
if fid ~= -1
  fprintf(fid,'%s\r\n',str);       %# Print the string
  fclose(fid);                     %# Close the file
end
cd(pRawExp);
fid = fopen(fName,'w');            %# Open the file
if fid ~= -1
  fprintf(fid,'%s\r\n',str);       %# Print the string
  fclose(fid);                     %# Close the file
end
cd(pRawC);
fid = fopen(fName,'w');            %# Open the file
if fid ~= -1
  fprintf(fid,'%s\r\n',str);       %# Print the string
  fclose(fid);                     %# Close the file
end



%% report new raw to Conny's pRawC folder
cd(pRawC);
load('NewRaw.mat','NewRaw');
NewRaw(end+1,:) = {expname};
save('NewRaw.mat','NewRaw');

%% [coding....] exclude bad runs
% display MWTf
% enter reason for exclusion
% put file into "BadRun" folder
% save BadFile record

%% Make sure MWTrun naming are correct
%% [UPDATE REQUIRED: Correct other parts of MWTname]
[MWTfsn] = correctMWTnamingswitchboard3(pExp);

%% [UPDATE REQUIRED: ASSIGN GROUP NAME AUTO]
[GA,MWTfgcode] = setgroup3(MWTfsn,pFun,pExp,0);
display('preparing Group*.mat files...');
[savename] = creatematsavename(pRawExp,'Groups_','.mat');
cd(pRawExp);
save(savename,'GA','MWTfgcode');
cd(pRawC);
save(savename,'GA','MWTfgcode');
cd(pExpStd);
save(savename,'GA','MWTfgcode');
display('Group*.mat saved in all locations...');
%% move files
display('file organizing begins...');
[MWTf,pMWTf,P,T] = getungroupedMWTfolders2(pExp);
for x = 1:size(MWTf,1);
    pExpStdZip = strcat(pExpStd,'/',MWTf{x,1},'.zip');
    zip(pExpStdZip,MWTf{x,1},pExp); % zip to standardized Exp folder in expter
    rmdir(pMWTf{x,1},'s'); % delete MWTf
    % copyfile(pZipSave,pBetCExp); % copy to pBetCExp
    %copyfile(pZipSave,pExpterBet);
end
copyfile(pExpStd,strcat(pRaw,'/',expname)); % copy to pRaw
rmdir(pExp,'s'); % remove old file
display('File organization done, proceed to Beethoven analysis...');
end


 



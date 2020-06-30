function HabAnalysis2(pExp,pFun)
% habitution anaysis complete flow
addpath(genpath(pFun));
%% record diary
[savename] = creatematsavenamewdate('HabAnalysis2Report','');
diary on;
cd(pExp);
diary(savename);
%% organize raw data
% check if unzipped, if so, unzip all
[MWTf,pMWTf] = dircontentext(pExp,'*.zip');
if isempty(MWTf) ==0; % if there is zip files
    display('unzipping files, please wait...');
    for x = 1:size(MWTf,1);
        [pH,~] = fileparts(pMWTf{x,1}); % get home path
        unzip(MWTf{x,1},pH); % unzip them all
        delete(pMWTf{x,1}); % delete zip files
    end
end

%% Make sure MWTrun naming are correct
[MWTfsn,RCpart] = correctMWTnamingswitchboard3(pExp);
% show strain group. validate strains
% take out .set


%% Experiment error reporting
[MWTf,pMWTf,badfileset,P] = validateORmovetofolder(pExp,'MissingSetfiles','*.set');
[MWTf,pMWTf,badfilesum,P] = validateORmovetofolder(pExp,'MissingSummaryfiles','*.set');

%experrorusereport(pExp);


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
pRawExp = strcat(pRaw,'/',expname,'_Info'); 
cd(pRaw);
mkdir(strcat(expname,'_Info'));
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
cd(pRawC);
fid = fopen(fName,'w');            %# Open the file
if fid ~= -1
  fprintf(fid,'%s\r\n',str);       %# Print the string
  fclose(fid);                     %# Close the file
end


%% report new raw to Conny's pRawC folder
[savename] = creatematsavenamewdate('NewRaw_','.mat');
cd(pRawC);
load('NewRaw.mat','NewRaw');
NewRaw(end+1,:) = {expname};
save('NewRaw.mat','NewRaw');


%% [UPDATE REQUIRED: ASSIGN GROUP NAME AUTO]
[GA,MWTfgcode] = switchboard_assigngroupname(MWTfsn,pFun,pExp,1);
[GAA] = groupseq(GA);
display('saving Group*.mat files...');
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
% zip to pRaw/expname
[p,oriname] = fileparts(pExp);
pRawzip = strcat(pRaw,'/',expname,'.zip');
if exist(pRawzip,'file')~=2;% check if there is already a zipped file in Raw
   display('backup a zip copy to Raw_Data...');
    zip(pRawzip,oriname,p);
else
    dispaly('Raw_Data already has this file backed up, skip...');
end
% move all MWTf to new folder
[fn,p,~,~] = dircontent(pExp);
if isequal(pExp,pExpStd)==0;
    display('moving to standardized folder...');
    movefile(pExp,pExpStd);
    rmdir(pExp,'s'); % remove old file
    pExp = pExpStd; % update pExp path
    display('done');  
else
    display('folder already in standardized name');
end
display('File organization done, proceeding to Beethoven analysis...');

%% automate chore
% loop for all MWTf
% this needs unzipped files
[~,pMWTf,~,P] = dircontentmwt(pExp);
for x = 1:size(pMWTf,1);
ptrv = pMWTf{x,1};
choretapreversal(ptrv);
end
%%
[MWTftrv] = revtrvreversalcompile(pExp);
%% saving
[savename] = creatematsavename(pExp,'import_','.mat'); % create save name
cd(pExp);
save(savename);

%% group import

[MWTftrvG] = groupMWTfdata2(MWTftrv,MWTfgcode);
[savename] = creatematsavename(pExp,'stats_','.mat'); % create save name
cd(pExp);
save(savename);

%% [formula may be wrong]
%% [coding] check for plate consistency
%[P] = validatetaps(MWTftrvG); 
%if P ==0
 %   error('taps are not equal in all plates');
%end
[HabGraph] = statcurvehab1(MWTftrvG);
[HabGraphStd] = statstdcurvehab1(MWTftrvG)

%% Graphing
[G] = habgraphindividual2(HabGraph,HabGraphStd,'GraphSetting.mat',GAA,pFun,pExp,pExp);

end


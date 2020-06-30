function ShaneSparkbeta(pExp,pFun)
% from HabAnalysis3
% habitution anaysis complete flow

%% set up
addpath(genpath(pFun));
pExpO = pExp; % define pExp as original path name 
[dsavn] = diarysavename(pExp); % record diary set up paths

%% zip and unzip data
%% [DEVELOP] change original name file for it to start with run name
[~,~] = unziprawdata(pExpO); % Unzip raw data
if exist(strcat(pExpO,'.zip'),'file') ~=2; % if this file had not been zipped
    display('Zipping a copy of current file as backup, please wait...');
    zip(pExpO,pExpO); % create a zip back up in case of mistakes
end
display('done');

%% check names
[MWTfsn] = correctMWTnamingswitchboard3(pExpO); % Make sure MWTrun naming are correct
% show strain group. validate strains

%% validate MWTf folder contents
%% [DEVELOP] choice to get rid of bad files
validaterawfilecontents(pExpO); % Experiment error reporting

%% create standardize folder name
[pAExp,pExpS,pRaw,pRawC,pRawCExp,expname,analyzedname] = ...
    standardizefoldername(pFun,pExpO); % standardize folder name
cd(pAExp);
diary(dsavn);

%% [DEVELOP] change raw report to text file append
rawdatareport2Conny(pRawC,expname); % report raw to Conny
cd(pAExp);
diary(dsavn);

%% [DEVELOP] Assign group names and sequence appears on the graph
[GA,MWTfgcode] = assigngroupnameswitchboard2(MWTfsn,pFun,pExpO,0);
display(' ');
[GAA] = groupseq(GA);
[savename] = creatematsavename3(expname,'Groups_','.mat');
cd(pRawCExp);
save(savename,'GA','MWTfgcode');
cd(pAExp);
save(savename,'GA','MWTfgcode');
display('done');

%% organize MWT files and back up
organizemwtfiles(pExpO,pExpS,pRaw,expname); % move files

%% Choreography and importing generated data
STATUS = 'suspend until chor installed in lab MAC'
switch STATUS
    case 'suspend until chor installed in lab MAC'
    ...
    case 'release chor'
        ShaneSparkChor(pExpO); % chore
        cd(pExpO);
        diary(diarysavename);
end

%% Import trv and group data for graphing
%% [BUG] sometimes there are data points but no object valid
%% [BUG] trv size not consistent, fixes
%% [BUG] check for plate consistency
%% [BUG] trv size not consistent, fixes
[MWTftrv] = importtrvNsave(pExpO,pExpO); % import trv generated from Chore
diary(diarysavename);

%% Data analysis and graphing
%% [Check] statistic formula needs to be checked
ShaneSparkGraph3(pSave,pFun,pExpO,MWTfgcode,GAA,expname,dsavn);
cd(pAExp);
diary(dsavn);

%% back up and clean up
% remove blobs, summary png and set files
removeallexceptanalyzed(pExpO);
% move analyzed files to analyzed folder
moveanalyzedfiles2analyzedfolder(pExpO,pAExp);
% make a copy to Conny's folder
backup2Connyfolder(pFun,analyzedname,pAExp);


%% reporting
display(' ');
display('ShaneSpark analysis completed.');

end




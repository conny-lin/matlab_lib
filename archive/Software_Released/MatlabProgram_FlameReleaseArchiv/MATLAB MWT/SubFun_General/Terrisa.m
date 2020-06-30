function Terrisa(pExp)
% standardized data pararation for MWT analysis
%% DATA PAPARATION ---------------------------------------
%% [suspend] zip and unzip data
% % [DEVELOP] change original name file for it to start with expname
% % unzip MWTf if zipped, and zip one original file in student folder for
% % backup
% switch zipfile
%     case 'backup'; % zip file
%         [~,pMWTf] = unziprawdata(pExpO); % Unzip raw data
%         if exist(strcat(pExpO,'.zip'),'file') ~=2;
%             display('zipping a copy of current file as backup, please wait...');
%             zip(pExpO,pExpO); % create a zip back up in case of mistakes
%         end
%         display('done');
%     case 'nobackup'; % don't zip file
%         display('zip backup skipped.');
% end

%% [suspend] untested parts of the program
codingstatus = 'testing';
switch codingstatus
case 'tested'
% do nothing
case 'testing'
%% [UNTESTED] validate MWTf folder contents
% [DEVELOP] should have png, set, summary and blobs, can get report for how
% many blobs here
% source: validaterawfilecontents(pExpO); % Experiment error reporting
[mwtfn,pmwtf] = dircontentmwt(pExp);
[a,~] = dircontentext(pmwt{x},'*.set');
[b,~] = dircontentext(pmwt{x},'*.summary');
[c,~] = dircontentext(pmwt{x},'*.blobs');
if isempty(a)==1 || isempty(b)==1 || isempty(c)==1;
    str = 'MWTf %s is missing either .set, .summary or .blobs';
    display(sprintf(str,mwtfn{x}));
    display 'Moving files to a problem folder';
    cd(pExp);
    name = 'IncompleteMWTfiles';
    mkdir(name);
    movefile(pmwtf,[pExp,'/',name]);
end


%% check MWT run names
% make sure no duplications
[~,MWTsum] = MWTrunameMaster(pExp,'duplicate');
[MWTfsn] = correctMWTnamingswitchboard3(pExpO); % Make sure MWTrun naming are correct


%% create standardize folder name
[pAExp,pExpS,pRaw,pRawC,pRawCExp,expname,analyzedname] = ...
    standardizefoldername(pFun,pExpO); % standardize folder name


%% [DEVELOP] change raw report to text file append
        rawdatareport2Conny(pRawC,expname); % report raw to Conny

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
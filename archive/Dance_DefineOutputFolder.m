function [paths] = Dance_DefineOutputFolder(paths,OPTION,varargin)

%% STEP7: DEFINE OUTPUT FOLDER

pSave = paths.MWT.pSave;


name = fieldnames(OPTION);
if strcmp(OPTION.rerun,'latest');
    % get last analysis output folder
    [fn,p,~,p1] = dircontent(pSave);
    a = cellfun(@str2num,celltakeout(regexp(fn,'\d{12}','match'),...
        'multirow'));
    [~,i] = max(a);
    pSaveA = p{i};
    return
end


% set new output folder
display 'Name your analysis output folder';
a = clock;
if a(4) <10; hrs = ['0',num2str(a(4))]; 
else hrs = num2str(a(4)); end
if a(5) <10; mins = ['0',num2str(a(5))]; 
else mins = num2str(a(5)); end
name = [input(': ','s'),'_',OPTION.Program,'_',datestr(now,'yyyymmdd'),...
    hrs,mins];
mkdir(pSave,name);
   pSaveA = [pSave,'/',name];
   paths.MWT.pSaveA = pSaveA;

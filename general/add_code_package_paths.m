function add_code_package_paths(wrkgrpname)


% ADD FUNCTION PATH
pFH = '/Users/connylin/Dropbox/Code/Matlab';
pL = fullfile(pFH,'Library');
switch wrkgrpname
    case 'RL'
        pFW = fullfile(pFH,'Library RL');
        pFWM = fullfile(pFH,'Library RL/Modules');
        pFun = {pL;
                fullfile(pFW,'Modules');
                fullfile(pFW,'Dance');
                fullfile(pFWM,'Graphs');
                fullfile(pFW,'Ochestra')};
    case 'FB'
        pFun = {pL;
                fullfile(pFH,'Library FB','Modules')};
    case 'PP'
        pFun = {pL;
                fullfile(pFH,'Library PP')};
end
addpath_allsubfolders(pFun);
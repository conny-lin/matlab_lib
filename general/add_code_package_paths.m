function add_code_package_paths(wrkgrpname)


% ADD FUNCTION PATH
pFH = '/Users/connylin/Code';
pL = fullfile(pFH,'matlab_lib');
switch wrkgrpname
    case 'RL'
        pFW = fullfile(pFH, 'proj', 'rankin_lab');
        % pFWM = fullfile(pFH,'Library RL/Modules');
        pFun = {pL; pFW};
                % fullfile(pFW,'Modules');
                % fullfile(pFW,'Dance');
                % fullfile(pFWM,'Graphs');
                % fullfile(pFW,'Ochestra')};
    case 'FB'
        pFun = {pL;
                fullfile(pFH,'proj', 'fitbrains','Modules')};
    case 'PP'
        pFun = {pL;
                fullfile(pFH,'proj')};
end
addpath_allsubfolders(pFun);
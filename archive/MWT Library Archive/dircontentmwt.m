function [MWTf,pMWTf] = dircontentmwt(pExp)

%% main function
% You might like this function I made called 'dircontentmwt'! 
% [MWTf,pMWTf] = dircontentmwt(pExp)
% - pExp = character variable of the path of your experiment folder
% - MWTf = a cell array containing the name of MWT folders
% - pMWTf = a cell array containing the paths of MWT folders
% 
% It gets you only MWT folders name and path from a folder path 'pExp'. In the function file attached you can see how I validate the name of the dir..
% Use it like any regular function in Matlab, like [path,folder] = fileparts(x). fileparts is the function, and x, path,folder are all variables you can define.
% For example, if your experiment folder is in current path you can just use 'cd' like this:  [MWTf,pMWTf] = dircontentmwt(cd)
% If you don't want to have both output, for example, if you just want pMWTf you can go [~,pMWTf] =  dircontentmwt(cd)
% The '~' ignores the MWTf output.
% 
% 
% The pMWTf is useful for loop cd into each MWT folders, like this:
% 
% for x = 1:numl(pMWTf); % for each validated MWT folders
% 	cd(pMWTf{x});  % path to MWT folder on cell array row x
% end



[~,~,f,p] = dircontent(pExp);
if isempty(f)==1;
%    MWTf = []; pMWTf = [];
else
    % check if there is mwt under group folder
    for x = 1:numel(p)
        [~,~,f1,p1] = dircontent(p{x});
        k(1:numel(p1),x) = cellfun(@isdir,p1);    
    end
end
if sum(sum(k)) > 0;
    Status = 'group folder';
else
    Status = 'MWT folder'; 
end


MWTf = []; pMWTf = [];
switch Status
    case 'group folder';
        for x = 1:numel(p)
            [~,~,f1,p1] = dircontent(p{x});      
            filestruct = cellfunexpr(f1,'\<(\d{8})[_](\d{6})\>');
%             match = cellfunexpr(f1,'match');
            t = cellfun(@regexp,f1,filestruct,'UniformOutput',0);
            i = celltakeout(t,'logical'); 
            a = f1(i,1);
            b = p1(i,1); 
            MWTf = [MWTf;a];
            pMWTf = [pMWTf;b];

        end
        
    case 'MWT folder';
        % get mwt folders
        filestruct(1:size(f,1),1) = {'\<(\d{8})[_](\d{6})\>'};
        t = cellfun(@regexp,f,filestruct,'UniformOutput',0);
        i = find(cell2mat(t))';
        MWTf = f(i,1);
        pMWTf = p(i,1); 
end


end




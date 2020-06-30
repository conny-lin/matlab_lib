function [MWTfsn,MWTfail] = draftMWTfname3(ext,pExp)
[MWTf,pMWTf] = dircontentmwt(pExp); % get only MWTf  
MWTfsn = {};
MWTfsn = MWTf;
MWTfail = {};
for x = 1:size(pMWTf,1); % for each MWTf
    cd(pMWTf{x,1}); % go to folder
    a = dir(ext); % list content
    a = {a.name}'; % get just the name of the file
    if (isempty(a) == 0); 
        MWTfsn{x,2} = a{1}(1:end-4); % name of file imported         
    else % in other situations
        display('Nothing imported for %s from [%s]',ext,MWTf{x,1});
        display('Use other extensions');
        a = dir
        a = {a.name}
        MWTfsn{x,2} = a{1}(1:end-4);
        MWTfail(end+1,1) = MWTf(x,1);
    end
end

end  
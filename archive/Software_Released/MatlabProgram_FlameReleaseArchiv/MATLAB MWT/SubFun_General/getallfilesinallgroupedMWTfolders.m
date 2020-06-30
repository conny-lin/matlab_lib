    function [filenamelist,filepathlist] = getallfilesinallgroupedMWTfolders(pExp)
[~,~,~,pGroupf] = dircontent(pExp); % get all files under all folders
pMWTf = {};
for x = 1:size(pGroupf,1);
    [~,~,~,pf] = dircontent(pGroupf{x,1}); % get all files under all folders
    pMWTf = cat(1,pMWTf,pf);
end
filenamelist = {};
filepathlist = {};
for x = 1:size(pMWTf,1);
    [f,pf,~,~] = dircontent(pMWTf{x,1});
    filenamelist = cat(1,filenamelist,f);
    filepathlist = cat(1,filepathlist,pf); 
end
end

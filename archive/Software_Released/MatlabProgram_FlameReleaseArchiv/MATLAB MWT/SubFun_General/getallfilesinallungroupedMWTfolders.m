function [filenamelist,filepathlist] = getallfilesinallungroupedMWTfolders(pMWTf)
filenamelist = {};
filepathlist = {};
for x = 1:size(pMWTf,1);
    [f,pf,~,~] = dircontent(pMWTf{x,1});
    filenamelist = cat(1,filenamelist,f);
    filepathlist = cat(1,filepathlist,pf); 
end
end
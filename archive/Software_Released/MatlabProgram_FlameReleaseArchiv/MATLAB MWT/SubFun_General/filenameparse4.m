function [parsefilename,ffront,fext] = filenameparse4(filenames)
% function [c,header] = getMWTrunName_v20130705(cell, col))
% get run condition parts
 % declare output cell array
dot(1:size(filenames,1),1) = {'[.]'};
[ext,~,~,~,~,~,split] = cellfun(@regexp,filenames,dot,'UniformOutput',0);
fext = {};
for x = 1:size(filenames,1)
fext{x,1} = filenames{x,1}(ext{x,1}:end);
ffront(x,1) = split{x,1}(1,1);
end
%% find blobs
blob(1:size(filenames,1),1) = {'[_]\d\d\d\d\d[k][.][b][l][o][b][s]'};
[~,~,~,blobext,~,~,ffrontwblob] = cellfun(@regexp,filenames,blob,'UniformOutput',0);
for x = 1:size(filenames,1);
if isempty(blobext{x,1}) ==0;
    ffront(x,1) = ffrontwblob{x,1}(1);% replace ffront and fext
    fext(x,1) = blobext{x,1};
end
end
parsefilename = cat(2,ffront,fext);

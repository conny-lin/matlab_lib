

function [zipfnmwt,pzipmwt] = findzipIsMWTf(pzipf)
[a,b] = regexp(pzipf,'\d\d\d\d\d\d\d\d_\d\d\d\d\d\d.zip','match','split');
i = find(not(cellfun(@isempty,a))); % index to MWTfolders
zipfnmwt = {};
pzipmwt = {};
for x = 1:numel(i)
zipfnmwt(x,1) = a{i(x,1),1}(1); % get MWTfoldername
pzipmwt(x,1) = pzipf(i(x,1),1);% get path to MWT folders
end
end
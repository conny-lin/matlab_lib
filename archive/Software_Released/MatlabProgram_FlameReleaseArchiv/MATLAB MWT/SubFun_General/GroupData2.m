function [MWTftrvG] = GroupData2(MWTftrv,pExp)

[groupmatname,p] = dircontentext(pExp,'Groups_*');
if numel(groupmatname)>=1 && iscell(groupmatname)==1;
    cd(pExp);load(groupmatname{1},'Groups');
    if exist('Groups','var')==0; 
        error 'Missing MWTfgcode var from Groups_*.mat import';
    end
else error 'No Groups_*.mat imported';
end
groupcode = Groups(:,1);

a = char(MWTftrv(:,2)); MWTfsn = cellstr(a(:,1:end-4)); % trim

[~,~,~,~,trackergroup] = parseMWTfnbyunder(MWTfsn);
a = char(trackergroup);
mwtgcode = cellstr(a(:,end-1));
MWTfgcode = Groups;
for xg = 1:numel(groupcode); % for each group
    i = find(not(cellfun(@isempty,regexp(mwtgcode,groupcode{xg}))));
    MWTfgcode(xg,3) = {num2cell(i)'};
end


MWTftrvG = {}; 
MWTftrvG = MWTfgcode(:,1);
groupsize = numel(MWTftrvG);
for xg = 1:groupsize; % for each group
    i = cell2mat(MWTfgcode{xg,3}'); % get MWTf index
    MWTftrvG{xg,2} = MWTftrv(i,:);
end


end
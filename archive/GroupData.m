function [MWTftrvG] = GroupData(MWTftrv,pExp)

% [groupmatname,p] = dircontentext(pExp,'Groups_*');
% if numel(groupmatname)>=1 && iscell(groupmatname)==1;
%     cd(pExp);
%     load(groupmatname{1});
% else
%     Groups = [];
%     display 'No Groups_*.mat imported';
%    
% end
[groupmatname,p] = dircontentext(pExp,'Groups_*');
if numel(groupmatname)>=1 && iscell(groupmatname)==1;
    cd(pExp);
    load(groupmatname{1},'Groups');
    if exist('Groups','var')==0; 
        error 'Missing MWTfgcode var from Groups_*.mat import';
    end
else
    error 'No Groups_*.mat imported';
end
groupcode = Groups(:,1);
[MWTfn,pMWTf] = dircontentmwt(pExp);
[MWTfsn,MWTsum] = getMWTruname(pMWTf,MWTfn);
[~,~,~,~,trackergroup] = parseMWTfnbyunder(MWTfsn);
a = char(trackergroup);
mwtgcode = cellstr(a(:,end-1));
MWTfgcode = Groups;
for xg = 1:numel(groupcode); % for each group
    i = find(not(cellfun(@isempty,regexp(mwtgcode,groupcode{xg}))));
    MWTfgcode(xg,3) = {num2cell(i)'};
end
cd(pExp);
save(groupmatname{1});



MWTftrvG = {};
if exist('MWTftrv','var')==1 && exist('MWTfgcode','var')==1;  
    MWTftrvG = MWTfgcode(:,1);
    groupsize = numel(MWTftrvG);
    for xg = 1:groupsize; % for each group
        i = cell2mat(MWTfgcode{xg,3}'); % get MWTf index
        MWTftrvG{xg,2} = MWTftrv(i,:);
    end
    display('done');
else
    display 'Missing MWTftrv and MWTfgcode var';
    return
end

%% fix group name
GroupNameFixed = regexprep(Groups(:,2),'_',' ');
% replace MWTgcode with group name
for x = 1:size(MWTftrvG,1)
i = celltakeout(regexp(Groups(:,1),MWTftrvG{x,1}),'singlenumber');
i = logical(i);
MWTftrvG(x,1) = GroupNameFixed(i,1);
end
end
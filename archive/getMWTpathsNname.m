%% [CODING] validate group vs exp folders
function [pExpV,Expfn,pGp,Gpn,pMWTf,MWTfn,MWTfsn] = ...
    getMWTpathsNname(Home,DisplayOptoin)
%% interpret input variable
option = char(regexp(DisplayOptoin,'(show)|(noshow)','match'));

%% get exp name, group name
[pMWTf,MWTfn,MWTfsn,~,pMWTH] = getMWTrunamefromHomepath(Home);
uni = 'UniformOutput';
[~,fn] = cellfun(@fileparts,pMWTH,uni,0);
%% reporting action
% reporting
str = 'Validating identies of %d MWT home folders...';
display(sprintf(str,numel(pMWTH)));

%% validate exp folder (works only if exp foldername is standardized
% parse by / and search all for qualified exp folder
slash = regexp(pMWTH,'/','split');
f = celltakeout(slash,'split');
f = reshape(f,(numel(f)),1);
f = unique(f(not(cellfun(@isempty,f)))); % take out all unique part of the paths
expnameidentifider = '^\d{8}[A-Z][_]([A-Z]{2})[_](.){1,}';
i = not(cellfun(@isempty,regexp(f,expnameidentifider,'match')));
expname = f(i);
%% find experiment foler path
pExpV = {};
for x = 1:numel(expname)
    paths = pMWTH(not(cellfun(@isempty,regexp(pMWTH,expname{x}))));
    p = paths{1};
    k = [];
    while isempty(k) ==1;
        [p,h] = fileparts(p);
        k = regexp(h,expname{x});
    end
    pExpV(x,1) = {[p '/' h]};
end
[~,Expfn] = cellfun(@fileparts,pExpV,uni,0); % get Expname

% serach for qualified standard exp folder
a = not(cellfun(@isempty,regexp(fn,'^\d{8}')));
% pExpV = pMWTH(a); % select only qualified exp folder qulified
% [~,Expfn] = cellfun(@fileparts,pExpV,uni,0);
% the rest are not standardized
pGp = pMWTH(not(a)); % get group folders
[~,Gpn] = cellfun(@fileparts,pGp,uni,0);

%% search for [a-z] group folder
[gcm,gcs] = regexp(fn,'^[a-z]','match','split');
pGroupcode = pMWTH(not(cellfun(@isempty,gcm)));

%% reporting
str = '%d standardized experiment folders found:';
display(sprintf(str,numel(Expfn)));
switch option
    case 'show';
    disp(Expfn);
    case 'noshow'
end
str = '%d [%d code] group folders found:';
display(sprintf(str,numel(Gpn),numel(pGroupcode)));
switch option
    case 'show'
    disp(unique(Gpn)');
    case 'noshow'
end





